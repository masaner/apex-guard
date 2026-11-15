# Execution Contexts & Quiddity Architecture

Salesforce Apex runs across many heterogeneous runtimes within the same org: synchronous Apex services, Triggers, `@AuraEnabled` LWC controllers, Flows, Agentforce Invocable Actions, `@RestResource` endpoints, and Asynchronous jobs (`Queueable`, `Batchable`, `@future`, `Schedulable`). A single unhandled exception type cannot serve all of them cleanly.

`ApexGuard` centralizes runtime detection and failure dispatch inside [`GuardContext.cls`](../force-app/main/default/classes/context/GuardContext.cls).

---

## How `GuardContext` Resolves the Active Runtime

At failure time, `GuardContext` inspects two platform signals without executing SOQL or DML:

1. **`Trigger.isExecuting`** (checked via `GuardContext.isTriggerContext()`)
2. **`System.Request.getCurrent().getQuiddity()`** (checked via `GuardContext.getCurrentQuiddity()`)

| Runtime | Detected Signal | Default `Guard` Failure Behavior | Recommended Pattern |
| :--- | :--- | :--- | :--- |
| **Apex Services / Utilities** | `SYNCHRONOUS`, `ANONYMOUS` | Throws `GuardException` | `Guard.isNotNull(...)`, `Guard.isValidId(...)` |
| **Triggers** | `Trigger.isExecuting == true` (`TRIGGER`) | Throws `GuardException` for structural failures; attaches `addError()` via `Guard.onRecord()` | `Guard.isNotEmpty(Trigger.new, 'Trigger.new')` + `Guard.onRecord(rec)` |
| **LWC / Aura Controllers** | `Quiddity.AURA` or `Guard.forLwc()` | Throws `AuraHandledException` with `setMessage()` called | `Guard.forLwc().isNotBlank(...)` or automatic `Quiddity.AURA` detection |
| **Screen Flows / Autolaunched Flows / Agentforce** | `Quiddity.INVOCABLE_ACTION` | `GuardException` (triggers Fault path) or structured `Result` when `throwOnFailure = false` | `GuardFlowAction` (`@InvocableMethod`) |
| **Record-Triggered Flows** | `Quiddity.SYNCHRONOUS` / `Trigger.isExecuting` | Throws `GuardException` (Fault path) or `Result` via `GuardFlowAction` | `GuardFlowAction` (`throwOnFailure = false` for validation branching) |
| **REST APIs / Webhooks** | `Quiddity.REST` | Throws `GuardException` | Catch `GuardException`, serialize `ex.toMap()` as HTTP 400 JSON |
| **Async Apex (`Queueable`, `Batch`, `@future`, `Scheduled`)** | `QUEUEABLE`, `BATCH_APEX`, `FUTURE`, `SCHEDULED` | Throws `GuardException` | Log `ex.toMap()` in `TransactionFinalizer` / catch blocks |

---

## Platform Edge Cases Handled by `ApexGuard`

### 1. The `AuraHandledException.setMessage()` Trap
In Apex, calling `throw new AuraHandledException('Invalid input');` **does not** populate `ex.getMessage()` properly in all contexts—Apex tests and LWC error handlers frequently receive `"Script-thrown exception"` unless `auraEx.setMessage(message)` is explicitly invoked on the instance before throwing.

`GuardContext.createAuraHandledException(String message)` always executes both:

```apex
AuraHandledException auraEx = new AuraHandledException(safeMessage);
auraEx.setMessage(safeMessage);
return auraEx;
```

### 2. Record-Triggered Flows vs. Screen Flows (`Quiddity`)
- **Screen Flows, Autolaunched Flows, and Agentforce Actions** run under `System.Quiddity.INVOCABLE_ACTION`.
- **Record-Triggered Flows** that invoke Apex `@InvocableMethod` actions often run under `System.Quiddity.SYNCHRONOUS` (or alongside DML/trigger execution).

`GuardFlowAction` relies on `GuardContext.getExecutionContextName()`, which prioritizes `'TRIGGER'` whenever `Trigger.isExecuting` is `true` and otherwise records the active `System.Quiddity` name. Regardless of which Flow type calls `GuardFlowAction`, setting `throwOnFailure = false` safely captures `GuardException` and populates `Result.isValid = false`, `Result.errorMessage`, `Result.errorCode`, and `Result.executionContext`.

### 3. Apex Collection Covariance vs. Invariance (`Set<Id>`, `Set<String>`, `Map`)
In Apex:
- `List<T>` is **covariant**: `List<Account>` and `List<String>` implicitly convert to `List<Object>`.
- `Set<T>` is **invariant**: `Set<Id>` and `Set<String>` do **not** convert to `Set<Object>`.
- `Map<K, V>` is **invariant in its key type** (`Map<Id, Account>` does not convert to `Map<Object, Object>`) while `SObject` subtypes convert to `Object`/`SObject` values (`Map<String, Account>` resolves cleanly to `Map<String, Object>` without needing a separate `Map<String, SObject>` overload, which would otherwise collide ambiguously).

To provide seamless ergonomics without forcing callers to copy sets/maps, [`GuardCollectionValidator.cls`](../force-app/main/default/classes/validators/GuardCollectionValidator.cls) and [`Guard.cls`](../force-app/main/default/classes/core/Guard.cls) provide explicit overloads for `Set<Id>`, `Set<String>`, `Set<Integer>`, `Map<Id, SObject>`, `Map<String, Object>`, and `Map<String, String>`.

### 4. `SObject.isSet(Schema.SObjectField)` on Sparse SOQL Records
Reading an unqueried field from an `SObject` via `record.get(field)` throws `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field`. Both `Guard.hasPopulatedField(...)` and `Guard.onRecord(record)` check `record.isSet(field)` before calling `record.get(field)`.

---

## Building Custom Context Adapters with `IGuardFailureHandler`

Contributors and enterprise teams can hook into every guard failure in a transaction by implementing [`IGuardFailureHandler.cls`](../force-app/main/default/classes/context/IGuardFailureHandler.cls):

```apex
public class TelemetryFailureHandler implements IGuardFailureHandler {
    public void handleFailure(GuardContext.Failure failure) {
        // Option A: Log and allow ApexGuard to throw its normal context-aware exception
        System.debug(
            LoggingLevel.ERROR,
            JSON.serialize(failure.toGuardException().toMap())
        );

        // Option B: Translate into a custom domain exception (optional)
        // if (failure.executionContext == 'REST') {
        //     throw new MyApiBadRequestException(failure.errorCode, failure.message);
        // }
    }
}
```

Register your handler at the start of an entry point and reset in tests or `finally` blocks if needed:

```apex
Guard.setFailureHandler(new TelemetryFailureHandler());
```

## Testing Execution Contexts

`GuardContext` exposes `@TestVisible` overrides so `@IsTest` suites can deterministically verify any runtime without deploying Triggers or calling Lightning endpoints:

```apex
GuardContext.testQuiddityOverride = System.Quiddity.AURA;
// ... assert AuraHandledException ...
Guard.resetContext(); // Always clean up in a finally block
```
