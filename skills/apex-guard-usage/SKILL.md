---
name: apex-guard-usage
description: Use this skill when writing or refactoring Apex Services, Constructors, Selectors, @AuraEnabled LWC controllers, @RestResource endpoints, or Async Apex with ApexGuard (Guard.*). Covers positive-assertion pass-through calls, overloads, collection covariance vs invariance, LWC Quiddity.AURA and setMessage() handling, and REST/Async error serialization.
---

# Using ApexGuard Across Apex Services, LWC, REST & Async Apex

## Core Principles

1. **Always call `Guard.*` (Public Facade), not internal validators:** All consumer code calls static methods on `Guard` (or `Guard.forLwc()` / `Guard.onRecord(record)`). Internal `Guard*Validator` classes are modular implementation details.
2. **Positive Assertion Naming:** Methods describe the *valid state required to proceed* (`Guard.isNotBlank`, `Guard.isGreaterThan`, `Guard.isValidId`), replacing deeply nested `if/else` preconditions ("arrow anti-pattern").
3. **Pass-Through Return Values:** Most guards return the validated input value so validation and variable/field assignment happen in one expression:
   ```apex
   this.accountId = Guard.isIdOfType(
       Guard.isValidId(rawAccountId, 'rawAccountId'),
       Account.SObjectType,
       'rawAccountId'
   );
   ```
4. **Three Overload Shapes on Core Guards:** Every parameter-named guard on `Guard` provides:
   * `Guard.<method>(value, ..., paramName)` — throws `GuardException` (or `AuraHandledException` in Aura/LWC mode) with a clear diagnostic message naming `paramName` and `errorCode`.
   * `Guard.<method>(value, ..., paramName, customMessage)` — overrides the message string while keeping `paramName`, `errorCode`, `quiddity`, and `executionContext`.
   * `Guard.<method>(value, ..., customException)` — throws the caller's exact `Exception` instance after routing through any registered `IGuardFailureHandler`.
   *(Boolean assertions `isTrue` and `isFalse` omit `paramName` and accept `(condition, message)` or `(condition, customException)`.)*

---

## Complete `Guard` Facade API Reference

### 1. Nullability & Boolean State

| Method | Behavior & Return Type | Error Code |
| :--- | :--- | :--- |
| `Guard.isNotNull(value, paramName)` | Fails if `value == null`. Returns `Object`. | `GUARD_NULL_VALUE` |
| `Guard.isNull(value, paramName)` | Fails if `value != null`. Returns `null` (`Object`). | `GUARD_NOT_NULL_VALUE` |
| `Guard.isTrue(condition, message)` | Fails unless `condition == true` (`null` fails). Returns `Boolean` (`true`). | `GUARD_TRUE_EXPECTED` |
| `Guard.isFalse(condition, message)` | Fails unless `condition == false` (`null` fails). Returns `Boolean` (`false`). | `GUARD_FALSE_EXPECTED` |

### 2. Strings

| Method | Behavior & Return Type | Error Code |
| :--- | :--- | :--- |
| `Guard.isNotEmpty(value, paramName)` | Fails if `null` or `value.length() == 0`. Returns `String`. | `GUARD_EMPTY_STRING` |
| `Guard.isNotBlank(value, paramName)` | Fails if `null`, empty, or whitespace-only. Returns `String`. | `GUARD_BLANK_STRING` |
| `Guard.hasLengthEqualTo(value, expectedLength, paramName)` | Fails if `value == null` or `value.length() != expectedLength` (`expectedLength` must be `>= 0`). Returns `String`. | `GUARD_STRING_LENGTH` |
| `Guard.hasMaxLength(value, maxLength, paramName)` | Fails if `value == null` or `value.length() > maxLength` (`maxLength` must be `>= 0`). Returns `String`. | `GUARD_MAX_LENGTH` |
| `Guard.matchesRegex(value, regexPattern, paramName)` | Fails if `value == null` or full-string `Pattern.compile(regexPattern).matcher(value).matches()` is `false`. Returns `String`. | `GUARD_REGEX_MISMATCH` |

### 3. Numeric (`Decimal`, `Integer`, `Long`; `Double` Widens to `Decimal`)

| Method | Behavior & Return Type | Error Code |
| :--- | :--- | :--- |
| `Guard.isGreaterThan(value, minExclusive, paramName)` | Fails if `value == null` or `value <= minExclusive`. Returns matching type (`Decimal`/`Integer`/`Long`). | `GUARD_GREATER_THAN` |
| `Guard.isGreaterThanOrEqualTo(value, minInclusive, paramName)` | Fails if `value == null` or `value < minInclusive`. Returns matching type. | `GUARD_GREATER_OR_EQUAL` |
| `Guard.isLessThan(value, maxExclusive, paramName)` | Fails if `value == null` or `value >= maxExclusive`. Returns matching type. | `GUARD_LESS_THAN` |
| `Guard.isLessThanOrEqualTo(value, maxInclusive, paramName)` | Fails if `value == null` or `value > maxInclusive`. Returns matching type. | `GUARD_LESS_OR_EQUAL` |
| `Guard.isInRange(value, minInclusive, maxInclusive, paramName)` | Fails if `value == null` or outside `[minInclusive, maxInclusive]`. Returns matching type. | `GUARD_OUT_OF_RANGE` |
| `Guard.isNotZero(value, paramName)` | Fails if `value == null` or `value == 0`. Returns matching type. | `GUARD_ZERO_VALUE` |

### 4. Collections (`List`, `Set`, `Map` — Apex Covariance & Invariance Safe)

In Apex, `List<T>` is covariant (`List<Account>` converts to `List<Object>`), whereas **`Set<T>` is invariant** (`Set<Id>` does not convert to `Set<Object>`) and **`Map<K, V>` has invariant keys**. Do not convert collections to `Set<Object>` just to validate them—`Guard` provides explicit zero-copy overloads:

| Method | Supported Parameter & Return Types | Error Code |
| :--- | :--- | :--- |
| `Guard.isNotEmpty(collection, paramName)` | `List<Object>`, `Set<Object>`, `Set<Id>`, `Set<String>`, `Set<Integer>`, `Map<Object, Object>`, `Map<Id, SObject>`, `Map<String, Object>`, `Map<String, String>` | `GUARD_EMPTY_COLLECTION` |
| `Guard.hasSizeEqualTo(collection, expectedSize, paramName)` | `List<Object>`, `Set<Object>`, `Set<Id>`, `Set<String>`, `Map<Object, Object>`, `Map<Id, SObject>`, `Map<String, Object>` | `GUARD_COLLECTION_SIZE` |
| `Guard.containsKey(inputMap, key, paramName)` | `(Map<Object, Object>, Object)`, `(Map<Id, SObject>, Id)`, `(Map<String, Object>, String)`, `(Map<String, String>, String)` | `GUARD_MISSING_KEY` |

> **Compiler Ambiguity Note:** A `Map<String, Account>` converts cleanly to `Map<String, Object>`. A separate `Map<String, SObject>` overload is intentionally excluded because it causes Apex ambiguous method signature errors. Call `Guard.isNotEmpty(myStringAccountMap, 'myMap')` directly and it resolves to `Map<String, Object>`.

### 5. Salesforce-Native (`Id`, `SObject`, `Schema`)

| Method | Behavior & Return Type | Error Code |
| :--- | :--- | :--- |
| `Guard.isValidId(value, paramName)` | Verifies 15- or 18-character Salesforce Id syntax & checksum via `Id.valueOf()`. Returns `Id`. | `GUARD_INVALID_ID` |
| `Guard.isIdOfType(recordId, expectedType, paramName)` | Fails if `recordId == null` or `recordId.getSObjectType() != expectedType`. Returns `Id`. | `GUARD_ID_SOBJECT_TYPE` |
| `Guard.isSObjectType(record, expectedType, paramName)` | Fails if `record == null` or `record.getSObjectType() != expectedType`. Returns `SObject`. | `GUARD_SOBJECT_TYPE` |
| `Guard.hasPopulatedField(record, field, paramName)` | Checks `record != null`, **`record.isSet(field)`**, and `record.get(field) != null` (prevents `System.SObjectException` on unqueried fields). Returns `SObject`. | `GUARD_UNPOPULATED_FIELD` |

### 6. Opt-In Running-User Schema Permissions (CRUD & FLS)

* `Guard.isAccessible(sObjectType)` / `isCreateable` / `isUpdateable` / `isDeletable` -> returns `Schema.SObjectType`
* `Guard.isFieldAccessible(field)` / `isFieldCreateable` / `isFieldUpdateable` -> returns `Schema.SObjectField`

See [apex-guard-security-and-best-practices](../apex-guard-security-and-best-practices/SKILL.md) before applying CRUD/FLS checks so Trigger system-mode logic is not inadvertently restricted.

---

## Pattern 1: Refactoring Apex Services & Constructors

```apex
public with sharing class InvoiceCalculatorService {
    private final Id accountId;
    private final Decimal taxRate;
    private final String currencyCode;

    public InvoiceCalculatorService(
        String rawAccountId,
        Decimal taxRate,
        String currencyCode,
        Account billedAccount,
        Map<Id, Account> accountCache
    ) {
        this.accountId = Guard.isIdOfType(
            Guard.isValidId(rawAccountId, 'rawAccountId'),
            Account.SObjectType,
            'rawAccountId'
        );
        this.taxRate = Guard.isInRange(taxRate, 0, 1, 'taxRate');
        this.currencyCode = Guard.hasLengthEqualTo(
            Guard.isNotBlank(currencyCode, 'currencyCode'),
            3,
            'currencyCode'
        );
        Guard.hasPopulatedField(billedAccount, Account.BillingCountry, 'billedAccount');
        Guard.containsKey(accountCache, this.accountId, 'accountCache');
    }
}
```

---

## Pattern 2: LWC & Aura Controllers (`Quiddity.AURA` & `Guard.forLwc()`)

In Apex, calling `throw new AuraHandledException(msg);` without `ex.setMessage(msg);` frequently produces `"Script-thrown exception"` instead of your message. `ApexGuard` **always** invokes `auraEx.setMessage(safeMessage)` inside `GuardContext`.

* **Automatic Mode (Default):** When an `@AuraEnabled` method executes from Lightning Web Components or Aura, `System.Request.getCurrent().getQuiddity() == System.Quiddity.AURA`. `Guard.*` automatically throws `AuraHandledException` instead of `GuardException` (toggleable via `Guard.setAutoDetectAuraQuiddity(Boolean)`).
* **Explicit Fluent Scope (`Guard.forLwc().<method>(...)`):** Useful inside helper methods or `@IsTest` methods (where Quiddity defaults to `SYNCHRONOUS`). `LwcScope` sets LWC mode for that single call and restores the previous flag in `finally`:
  ```apex
  @AuraEnabled
  public static Account updateQuarterlyBudget(String accountIdStr, Decimal budget) {
      Id accountId = Guard.forLwc().isIdOfType(
          Guard.forLwc().isValidId(accountIdStr, 'accountIdStr'),
          Account.SObjectType,
          'accountIdStr'
      );
      Guard.forLwc().isUpdateable(Account.SObjectType);
      Guard.forLwc().isFieldUpdateable(Account.AnnualRevenue);
      Guard.forLwc().isGreaterThan(budget, 0, 'budget');

      Account acc = new Account(Id = accountId, AnnualRevenue = budget);
      update as user acc;
      return acc;
  }
  ```
* **Statement Mode (`Guard.forLwc();` / `Guard.disableLwcMode();`):** Activates LWC mode across multiple standard `Guard.*` calls (including custom messages, custom exceptions, `Long`, and `Map`/`hasSizeEqualTo`/`containsKey` overloads not wrapped directly on `LwcScope`):
  ```apex
  Guard.forLwc();
  try {
      Guard.hasSizeEqualTo(lineIds, 5, 'lineIds', 'Select exactly 5 lines.');
  } finally {
      Guard.disableLwcMode();
  }
  ```

---

## Pattern 3: REST APIs & Async Apex (`GuardException.toMap()`)

In `@RestResource` endpoints (`Quiddity.REST`) and Async Apex (`Queueable`, `Batchable`, `@future`, `Schedulable`, `TransactionFinalizer`), catch `GuardException` to access structured metadata without parsing message strings:

```apex
@RestResource(urlMapping='/v1/orders/*')
global with sharing class OrderRestResource {
    @HttpPost
    global static void createOrder(String accountId, Decimal amount) {
        RestResponse res = RestContext.response;
        try {
            Id validAccountId = Guard.isIdOfType(
                Guard.isValidId(accountId, 'accountId'),
                Account.SObjectType,
                'accountId'
            );
            Decimal validAmount = Guard.isGreaterThan(amount, 0, 'amount');
            res.statusCode = 201;
            res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, Object>{
                'accountId' => validAccountId,
                'amount' => validAmount
            }));
        } catch (GuardException ex) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(ex.toMap()));
            // toMap() contains: message, paramName, errorCode, actualValue, quiddity, executionContext
        }
    }
}
```

## Related Skills

* [apex-guard-triggers-and-bulk-dml](../apex-guard-triggers-and-bulk-dml/SKILL.md) — Use `Guard.onRecord()` instead of throwing inside record loops.
* [apex-guard-extensibility-and-logging](../apex-guard-extensibility-and-logging/SKILL.md) — Custom exceptions, `IGuardFailureHandler`, and Nebula Logger integration.
* [apex-guard-security-and-best-practices](../apex-guard-security-and-best-practices/SKILL.md) — Sharing rules, `isSet()`, CRUD/FLS guards, and when not to throw.
* [apex-guard-testing](../apex-guard-testing/SKILL.md) — Unit testing `GuardException` and `Quiddity.AURA`.
