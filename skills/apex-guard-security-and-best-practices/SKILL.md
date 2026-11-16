---
name: apex-guard-security-and-best-practices
description: Use this skill when reviewing, hardening, or standardizing ApexGuard usage across a Salesforce engineering team. Covers inherited sharing, SObject.isSet() safety after Security.stripInaccessible(), opt-in CRUD/FLS guards vs Trigger system mode, governor limits (0 SOQL/DML, no Schema.getGlobalDescribe), and when not to throw guard exceptions.
---

# ApexGuard Security, Sharing & Team Best Practices

## 1. `public inherited sharing class` Everywhere

Every class in `ApexGuard`—`Guard`, `GuardRecord`, `GuardContext`, `GuardException`, `GuardFlowAction`, and all six internal validators—is declared **`public inherited sharing class`**:

* When invoked from a `with sharing` LWC controller, REST endpoint, or service, sharing rules are respected.
* When invoked legitimately from a Trigger handler, Batch job, or `without sharing` system service, `ApexGuard` does not fail or unexpectedly restrict visibility.
* `ApexGuard` never uses `without sharing`, so it can never elevate privileges by accident.

---

## 2. Governor Limits & Describe Discipline (`0 SOQL | 0 DML`)

* **Zero SOQL Queries & Zero DML:** Core `Guard.*`, `Guard.onRecord()`, `Guard.forLwc()`, and `Guard.isAccessible()`..`Guard.isFieldUpdateable()` checks execute purely in memory using Apex primitives and `Schema.Describe*Result` metadata.
* **Zero `Schema.getGlobalDescribe()` Calls:** Calling `Schema.getGlobalDescribe()` in large orgs consumes significant CPU time and heap across thousands of custom objects. `ApexGuard` bans `getGlobalDescribe()`; when `GuardFlowAction` resolves a dynamic object name string, it calls targeted `Schema.describeSObjects(new List<String>{ apiName.trim() })` for that single object only.

---

## 3. Sparse SOQL & `Security.stripInaccessible()` Safety (`record.isSet()`)

Calling `record.get(field)` on an `SObject` whose field was not selected in SOQL—or was stripped out by `Security.stripInaccessible(AccessType.READABLE, records)`—throws an unhandled `System.SObjectException`.

Both `Guard.hasPopulatedField(record, field, paramName)` and `Guard.onRecord(record)` check **`record.isSet(field)`** before reading `record.get(field)`:

* `Guard.hasPopulatedField(...)` fails cleanly with `GuardException` (`ERR_UNPOPULATED_FIELD`) instead of `System.SObjectException`.
* `Guard.onRecord(...)` treats unset fields safely as `null` / unpopulated and attaches a clean `record.addError(field, message)`.

```apex
SObjectAccessDecision decision = Security.stripInaccessible(
    AccessType.READABLE,
    [SELECT Id, Name, AnnualRevenue FROM Account LIMIT 10]
);
for (Account acc : (List<Account>) decision.getRecords()) {
    // Even if AnnualRevenue was stripped by FLS, GuardRecord checks record.isSet()
    // and never throws System.SObjectException!
    Guard.onRecord(acc)
        .skipInaccessible()
        .isNotBlank(Account.Name)
        .isGreaterThan(Account.AnnualRevenue, 0);
}
```

---

## 4. Explicit, Opt-In Running-User CRUD & FLS Guards

### Why Triggers Do Not Auto-Enforce FLS by Default

Triggers run in **system mode**, whereas `Schema.DescribeSObjectResult` and `Schema.DescribeFieldResult` evaluate the **running user's** profile/permission sets. If `Guard.onRecord()` silently skipped or rejected Trigger validations based on running-user FLS by default, restricted or integration users could bypass critical domain invariants (`Opportunity.Amount > 0`).

Therefore, all CRUD & FLS checks in `ApexGuard` are **explicit and opt-in** for user-mode entry points (`@AuraEnabled` LWC controllers, REST endpoints, user-mode services):

* **Explicit SObject CRUD Guards (return `Schema.SObjectType`):**
  * `Guard.isAccessible(sObjectType)` (`ERR_SOBJECT_NOT_ACCESSIBLE`)
  * `Guard.isCreateable(sObjectType)` (`ERR_SOBJECT_NOT_CREATEABLE`)
  * `Guard.isUpdateable(sObjectType)` (`ERR_SOBJECT_NOT_UPDATEABLE`)
  * `Guard.isDeletable(sObjectType)` (`ERR_SOBJECT_NOT_DELETABLE`)
* **Explicit Field FLS Guards (return `Schema.SObjectField`):**
  * `Guard.isFieldAccessible(field)` (`ERR_FIELD_NOT_ACCESSIBLE`)
  * `Guard.isFieldCreateable(field)` (`ERR_FIELD_NOT_CREATEABLE`)
  * `Guard.isFieldUpdateable(field)` (`ERR_FIELD_NOT_UPDATEABLE`)
* **Fluent LWC Wrappers (`Guard.forLwc()`):** All 7 CRUD & FLS checks are exposed directly on `GuardContext.LwcScope` (`Guard.forLwc().isUpdateable(Account.SObjectType);`).
* **Opt-In `GuardRecord` FLS Controls:**
  * `.skipInaccessible()` / `.skipInaccessible(Boolean)` skips subsequent `Schema.SObjectField` value assertions when the running user lacks read FLS.
  * `.isFieldAccessible(field)`, `.isFieldCreateable(field)`, and `.isFieldUpdateable(field)` explicitly attach field-level `addError()` messages if FLS is denied.

Pair opt-in CRUD/FLS guards with Apex `WITH USER_MODE` SOQL or `as user` DML for defense-in-depth user-context endpoints.

---

## 5. When *Not* to Use Throw-Based `Guard.*` Calls

| Anti-Pattern | Use Instead | Why |
| :--- | :--- | :--- |
| Throwing `Guard.isNotBlank(...)` inside a Trigger `for (SObject rec : Trigger.new)` loop | `Guard.onRecord(rec).isNotBlank(Account.Name)` | Throwing aborts the whole DML batch and breaks `Database.insert(..., false)` partial success and multi-field UI errors. |
| Replacing Setup Validation Rules with Apex Guards for admin-owned UI policies | Declarative Salesforce Validation Rules | Admins cannot edit Apex code thresholds without a deployment; use `ApexGuard` for service contracts, REST/LWC inputs, and pre-DML domain logic. |
| Calling `Guard.forLwc();` statement mode without a `try { ... } finally { Guard.disableLwcMode(); }` | `Guard.forLwc().isNotBlank(...)` fluent scope (or `finally` reset) | Statement mode sets a static transaction-scoped flag (`forceLwcMode = true`). If a later helper in the same transaction expects `GuardException`, leaving LWC mode enabled would throw `AuraHandledException`. |
| Hardcoding profile names like `'Standard User'` in FLS `System.runAs` unit tests | Query `WHERE UserType = 'Standard' AND PermissionsModifyAllData = FALSE LIMIT 1` | English profile names fail in non-English Salesforce orgs. |

---

## 6. Pull Request & Code Review Checklist

* [ ] Do service/constructor/selector/LWC entry points use flat `Guard.*` pass-through assertions instead of nested `if/else` pyramids?
* [ ] Are internal Trigger loops using `Guard.onRecord(record)` (`GuardRecord`) instead of throwing `GuardException`?
* [ ] Are `Collection` assertions using direct `Set<Id>`, `Set<String>`, `Map<Id, SObject>`, `Map<String, Object>` overloads without redundant copies?
* [ ] Do user-mode `@AuraEnabled` controllers combine `WITH USER_MODE` / `as user` with explicit `Guard.forLwc().isAccessible(...)` / `isUpdateable(...)` / `isFieldUpdateable(...)` checks where appropriate?
* [ ] Do `@IsTest` classes that mutate `GuardContext` or `@TestVisible` overrides reset state in a `finally` block via `Guard.resetContext()`?

## Related Skills

* [apex-guard-usage](../apex-guard-usage/SKILL.md) — Pass-through API reference and LWC patterns.
* [apex-guard-triggers-and-bulk-dml](../apex-guard-triggers-and-bulk-dml/SKILL.md) — Fluent `Guard.onRecord()` patterns for Triggers.
* [apex-guard-testing](../apex-guard-testing/SKILL.md) — Locale-safe `System.runAs` and context override test patterns.
