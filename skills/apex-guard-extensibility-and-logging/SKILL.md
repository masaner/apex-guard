---
name: apex-guard-extensibility-and-logging
description: Use this skill when integrating ApexGuard with Nebula Logger, custom domain Exception classes, REST/Async logging telemetry, or global failure hooks via IGuardFailureHandler and GuardException.toMap().
---

# Extending ApexGuard: `IGuardFailureHandler`, Custom Exceptions & Nebula Logger

## Failure Dispatch Pipeline

Every exception-throwing guard failure routes through [`GuardContext.cls`](../../force-app/main/default/classes/context/GuardContext.cls) in this exact sequence:

1. Construct an immutable `GuardContext.Failure` payload (`message`, `paramName`, `errorCode`, `actualValue`, `quiddity`, `isTriggerExecuting`, `executionContext`, `customException`).
2. If an [`IGuardFailureHandler`](../../force-app/main/default/classes/context/IGuardFailureHandler.cls) is registered via `Guard.setFailureHandler(handler)`, invoke `handler.handleFailure(failure)`.
   * If `handleFailure` itself throws an exception (for example, translating failures into a team-wide domain exception), that exception propagates immediately.
   * If `handleFailure` returns normally (e.g., after logging), `GuardContext` continues to step 3.
3. If the caller supplied a custom `Exception` overload (`failure.customException != null`), throw `failure.customException`.
4. Else if LWC/Aura mode is active (`GuardContext.shouldThrowAuraException()`), throw `AuraHandledException` with `setMessage()` called.
5. Otherwise throw `failure.toGuardException()` (`GuardException`).

---

## Pattern 1: Integrating with **Nebula Logger** (`IGuardFailureHandler`)

`ApexGuard` core deliberately keeps **zero external dependencies**. You connect **Nebula Logger** with a thin transaction-scoped adapter implementing `IGuardFailureHandler`:

```apex
public with sharing class NebulaGuardFailureHandler implements IGuardFailureHandler {
    public void handleFailure(GuardContext.Failure failure) {
        GuardException guardEx = failure.toGuardException();

        Logger.error(
                'ApexGuard Failure [' +
                    failure.errorCode +
                    '] on param \'' +
                    failure.paramName +
                    '\': ' +
                    failure.message
            )
            .setExceptionDetails(guardEx)
            .addTag('ApexGuard')
            .addTag(failure.errorCode)
            .addTag('Context:' + failure.executionContext);

        // Nebula Logger's default EVENT_BUS save method uses PublishImmediately,
        // ensuring this entry persists even though Guard immediately throws below.
        Logger.saveLog();
    }
}
```

Register the handler once at the transaction entry point (Trigger Dispatcher, `@RestResource`, `Batchable.start` / `execute`, or `@AuraEnabled` controller):

```apex
Guard.setFailureHandler(new NebulaGuardFailureHandler());
```

> **Why `Logger.saveLog()` inside `handleFailure()` survives transaction rollback:**
> By default, Nebula Logger publishes `LogEntryEvent__e` on the Salesforce Event Bus (`PublishImmediately`). Even though `GuardContext` throws `GuardException` or `AuraHandledException` immediately after `handleFailure(failure)` returns—and Apex rolls back standard DML—the published `LogEntryEvent__e` commits asynchronously. Calling `saveLog()` inside `handleFailure()` is safe because precondition failures are exceptional, terminal transaction events (unlike tight loops).

### Resetting Handlers

* `Guard.resetFailureHandler()` clears only the registered `IGuardFailureHandler`.
* `Guard.resetContext()` clears the failure handler, explicit LWC mode flag, resets `autoDetectAuraQuiddity` to `true`, and clears all `@TestVisible` overrides. Always call `Guard.resetContext()` in test `finally` blocks.

---

## Pattern 2: Global Exception Translation

If your org standardizes on a single domain exception (e.g., `ApplicationException`), translate `GuardContext.Failure` inside `IGuardFailureHandler`:

```apex
public with sharing class ApplicationExceptionGuardHandler implements IGuardFailureHandler {
    public void handleFailure(GuardContext.Failure failure) {
        if (failure.customException != null) {
            return; // Respect explicit caller exception overrides
        }
        throw new ApplicationException(failure.errorCode + ': ' + failure.message);
    }
}
```

---

## Pattern 3: Per-Call Custom Messages & Custom Exceptions

Every parameter-named guard on `Guard` offers two override signatures:

```apex
// Custom diagnostic message — preserves GuardException paramName, errorCode & Quiddity
Guard.isNotBlank(externalKey, 'externalKey', 'External ERP key must be supplied.');

// Custom Exception instance — thrown instead of GuardException
public class InsufficientCreditException extends Exception {}

Guard.isGreaterThan(
    availableCredit,
    0,
    new InsufficientCreditException('Customer credit balance is exhausted.')
);
```

---

## Pattern 4: Structured Serialization (`GuardException.toMap()`)

Avoid parsing `ex.getMessage()` in telemetry frameworks, REST error wrappers, or `TransactionFinalizer` classes. Use `GuardException` getters or `toMap()`:

```apex
try {
    Guard.isIdOfType(recordId, Opportunity.SObjectType, 'opportunityId');
} catch (GuardException ex) {
    String param = ex.getParamName();          // 'opportunityId'
    String code = ex.getErrorCode();           // 'GUARD_ID_SOBJECT_TYPE'
    Object actual = ex.getActualValue();       // offending Id
    System.Quiddity q = ex.getQuiddity();      // e.g., Quiddity.REST
    String ctx = ex.getExecutionContext();     // e.g., 'REST' or 'TRIGGER'
    Map<String, Object> payload = ex.toMap();
    // Keys: 'message', 'paramName', 'errorCode', 'actualValue', 'quiddity', 'executionContext'
}
```

---

## Complete Standardized Error Code Catalog (30 Constants on `GuardException`)

| Constant | String Value | Constant | String Value |
| :--- | :--- | :--- | :--- |
| `ERR_NULL_VALUE` | `'GUARD_NULL_VALUE'` | `ERR_COLLECTION_SIZE` | `'GUARD_COLLECTION_SIZE'` |
| `ERR_NOT_NULL_VALUE` | `'GUARD_NOT_NULL_VALUE'` | `ERR_MISSING_KEY` | `'GUARD_MISSING_KEY'` |
| `ERR_TRUE_EXPECTED` | `'GUARD_TRUE_EXPECTED'` | `ERR_INVALID_ID` | `'GUARD_INVALID_ID'` |
| `ERR_FALSE_EXPECTED` | `'GUARD_FALSE_EXPECTED'` | `ERR_ID_SOBJECT_TYPE` | `'GUARD_ID_SOBJECT_TYPE'` |
| `ERR_EMPTY_STRING` | `'GUARD_EMPTY_STRING'` | `ERR_SOBJECT_TYPE` | `'GUARD_SOBJECT_TYPE'` |
| `ERR_BLANK_STRING` | `'GUARD_BLANK_STRING'` | `ERR_UNPOPULATED_FIELD` | `'GUARD_UNPOPULATED_FIELD'` |
| `ERR_STRING_LENGTH` | `'GUARD_STRING_LENGTH'` | `ERR_SOBJECT_NOT_ACCESSIBLE` | `'GUARD_SOBJECT_NOT_ACCESSIBLE'` |
| `ERR_MAX_LENGTH` | `'GUARD_MAX_LENGTH'` | `ERR_SOBJECT_NOT_CREATEABLE` | `'GUARD_SOBJECT_NOT_CREATEABLE'` |
| `ERR_REGEX_MISMATCH` | `'GUARD_REGEX_MISMATCH'` | `ERR_SOBJECT_NOT_UPDATEABLE` | `'GUARD_SOBJECT_NOT_UPDATEABLE'` |
| `ERR_GREATER_THAN` | `'GUARD_GREATER_THAN'` | `ERR_SOBJECT_NOT_DELETABLE` | `'GUARD_SOBJECT_NOT_DELETABLE'` |
| `ERR_GREATER_OR_EQUAL` | `'GUARD_GREATER_OR_EQUAL'` | `ERR_FIELD_NOT_ACCESSIBLE` | `'GUARD_FIELD_NOT_ACCESSIBLE'` |
| `ERR_LESS_THAN` | `'GUARD_LESS_THAN'` | `ERR_FIELD_NOT_CREATEABLE` | `'GUARD_FIELD_NOT_CREATEABLE'` |
| `ERR_LESS_OR_EQUAL` | `'GUARD_LESS_OR_EQUAL'` | `ERR_FIELD_NOT_UPDATEABLE` | `'GUARD_FIELD_NOT_UPDATEABLE'` |
| `ERR_OUT_OF_RANGE` | `'GUARD_OUT_OF_RANGE'` | `ERR_INVALID_GUARD_ARGUMENT` | `'GUARD_INVALID_ARGUMENT'` |
| `ERR_ZERO_VALUE` | `'GUARD_ZERO_VALUE'` | `ERR_EMPTY_COLLECTION` | `'GUARD_EMPTY_COLLECTION'` |

## Related Skills

* [apex-guard-usage](../apex-guard-usage/SKILL.md) — Core `Guard.*` facade signatures across Apex runtimes.
* [apex-guard-flows-and-agentforce](../apex-guard-flows-and-agentforce/SKILL.md) — How `GuardException` error codes map into `GuardFlowAction.Result`.
* [apex-guard-testing](../apex-guard-testing/SKILL.md) — Testing custom `IGuardFailureHandler` hooks safely with `Guard.resetContext()`.
