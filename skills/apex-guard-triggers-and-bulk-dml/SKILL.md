---
name: apex-guard-triggers-and-bulk-dml
description: Use this skill when validating SObject records inside Apex Triggers or bulk DML operations with ApexGuard. Covers separating fail-fast structural checks (Guard.isNotEmpty) from non-throwing Guard.onRecord(SObject) validation, field-level SObject.addError(), partial DML (allOrNone = false), .skipInaccessible(), and SObject.isSet() safety.
---

# Triggers and Bulk DML Validation with `Guard.onRecord()`

## Two Validation Modes in Triggers

Never throw `GuardException` inside a `for (SObject rec : Trigger.new)` loop for per-record data validation errors. Throwing aborts the entire DML batch, defeats `Database.insert(records, false)` partial success, and hides pinpointed field errors in Lightning Experience.

Instead, combine both modes:

1. **Batch / Structural Preconditions (Fail-Fast):** Use static `Guard.*` methods *before* the loop (e.g., `Guard.isNotEmpty(Trigger.new, 'Trigger.new')`). If `Trigger.new` itself is null or empty, failing fast is appropriate.
2. **Per-Record & Field Validation (Non-Throwing):** Wrap each `SObject` in **`Guard.onRecord(SObject record)`** (`GuardRecord`). All failures attach directly to the underlying record via `record.addError(field, message)` or `record.addError(message)` without throwing.

> Note: `new GuardRecord(record)` (`Guard.onRecord(null)`) **does** throw `GuardException` (`GUARD_NULL_VALUE`) if `record` itself is `null`.

```apex
public with sharing class OpportunityTriggerHandler {
    public static void beforeSave(List<Opportunity> newList) {
        // 1. Structural precondition: fail fast if collection is null/empty
        Guard.isNotEmpty(newList, 'newList');

        // 2. Per-record validation: attach field errors without throwing
        for (Opportunity opp : newList) {
            Guard.onRecord(opp)
                .isNotBlank(Opportunity.Name)
                .hasMaxLength(Opportunity.NextStep, 255)
                .isGreaterThan(Opportunity.Amount, 0)
                .isInRange(Opportunity.Probability, 10, 90);
        }
    }
}
```

When multiple checks fail on the same record (e.g., invalid `Amount` *and* invalid `Probability`), **`GuardRecord` accumulates every error** on the respective fields simultaneously—both fields highlight in the Lightning UI.

---

## Complete `GuardRecord` API

Every mutating check returns `this` (`GuardRecord`) for fluent chaining and supports an optional trailing `String customMessage` parameter on all `Schema.SObjectField` overloads.

### Field-Level Methods (`record.addError(field, message)`)

| Category | Field Signatures (`Schema.SObjectField`) |
| :--- | :--- |
| **Nullability** | `isNotNull(field)`, `isNull(field)` |
| **Boolean + Field Target** | `isTrue(Boolean condition, field, String message)`, `isFalse(Boolean condition, field, String message)` |
| **Strings** | `isNotEmpty(field)`, `isNotBlank(field)`, `hasLengthEqualTo(field, Integer expectedLength)`, `hasMaxLength(field, Integer maxLength)`, `matchesRegex(field, String regexPattern)` |
| **Numeric** | `isGreaterThan(field, Decimal minExclusive)`, `isGreaterThanOrEqualTo(field, Decimal minInclusive)`, `isLessThan(field, Decimal maxExclusive)`, `isLessThanOrEqualTo(field, Decimal maxInclusive)`, `isInRange(field, Decimal minInclusive, Decimal maxInclusive)`, `isNotZero(field)` |
| **Populated Check** | `hasPopulatedField(field)` *(checks `record.isSet(field) && record.get(field) != null`)* |
| **Opt-In FLS** | `isFieldAccessible(field)`, `isFieldCreateable(field)`, `isFieldUpdateable(field)` |

### Record-Level Methods (`record.addError(message)`)

For computed values or cross-field invariants that do not map to a single `Schema.SObjectField`, call the value-based overloads on the same fluent chain:
* `isNotNull(Object value, String paramName)` / `isNull(Object value, String paramName)`
* `isTrue(Boolean condition, String message)` / `isFalse(Boolean condition, String message)`
* `isNotEmpty(String value, String paramName)` / `isNotBlank(String value, String paramName)` / `hasLengthEqualTo(String value, Integer expectedLength, String paramName)` / `hasMaxLength(String value, Integer maxLength, String paramName)` / `matchesRegex(String value, String regexPattern, String paramName)`
* `isGreaterThan(Decimal value, Decimal minExclusive, String paramName)` / `isGreaterThanOrEqualTo(...)` / `isLessThan(...)` / `isLessThanOrEqualTo(...)` / `isInRange(Decimal value, Decimal minInclusive, Decimal maxInclusive, String paramName)` / `isNotZero(Decimal value, String paramName)`

### Inspection Helpers

* `.hasErrors()` (`Boolean`) — `true` if any error was attached via `GuardRecord` *or* externally on `record.hasErrors()`.
* `.isValid()` (`Boolean`) — `!hasErrors()`.
* `.getErrorMessages()` (`List<String>`) — defensive copy of accumulated error messages attached via this `GuardRecord` instance.
* `.getRecord()` (`SObject`) — underlying validated `SObject`.

---

## Sparse SOQL (`isSet()`) & Trigger FLS Behavior

1. **Unqueried Fields Never Crash:** `GuardRecord` checks `this.record.isSet(field)` before reading `this.record.get(field)`. If an `SObject` came from a partial SOQL query (or `Security.stripInaccessible()`), unset fields are treated as `null` / unpopulated and converted into clean `addError()` validation messages instead of throwing `System.SObjectException`.
2. **System Context by Default:** Triggers run in system mode where business invariants (such as requiring `Opportunity.Amount > 0`) must still execute even if an integration or limited user lacks FLS visibility on a field. Therefore, `Guard.onRecord(record)` **does not automatically skip or enforce FLS** unless you opt in:
   ```apex
   // User-facing controller / service enforcing partial validation with FLS awareness:
   GuardRecord check = Guard.onRecord(accountFromUi)
       .skipInaccessible()                  // Silently skips field checks where !checkFieldAccessible(field)
       .isNotBlank(Account.Name)
       .isGreaterThan(Account.AnnualRevenue, 0)
       .isFieldUpdateable(Account.Industry); // Explicitly attaches field error if running user lacks update FLS
   ```
   *(Call `.skipInaccessible(false)` to re-enable validating all fields in the same chain.)*

---

## Partial DML Bulk Pattern (`Database.SaveResult`)

Because `GuardRecord` attaches standard Salesforce `SObject.addError()` errors rather than throwing, callers performing bulk DML can isolate failures cleanly:

```apex
Database.SaveResult[] results = Database.update(accountsToUpdate, false);
for (Database.SaveResult sr : results) {
    if (!sr.isSuccess()) {
        for (Database.Error err : sr.getErrors()) {
            System.debug(err.getFields() + ': ' + err.getMessage());
        }
    }
}
```

## Related Skills

* [apex-guard-usage](../apex-guard-usage/SKILL.md) — Static fail-fast `Guard.*` preconditions in Services and LWC.
* [apex-guard-security-and-best-practices](../apex-guard-security-and-best-practices/SKILL.md) — System-mode Triggers vs. opt-in FLS checks.
* [apex-guard-testing](../apex-guard-testing/SKILL.md) — Testing `GuardRecord` errors cleanly in `@IsTest`.
