---
name: apex-guard-testing
description: Use this skill when writing or updating Apex @IsTest classes that exercise code using ApexGuard. Covers testing GuardException metadata, simulating Quiddity.AURA and REST/Trigger contexts, testing GuardRecord in memory without DML, locale-safe System.runAs CRUD/FLS tests, and resetting Guard.resetContext() safely.
---

# Testing Code That Uses ApexGuard

## Core Testing Patterns

### 1. Always Reset `Guard.resetContext()` in a `finally` Block

`GuardContext` stores static transaction-scoped configuration (`failureHandler`, `forceLwcMode`, `autoDetectAuraQuiddity`) and `@TestVisible` overrides (`testQuiddityOverride`, `testTriggerExecutingOverride`, plus `GuardSchemaValidator.testForceDenyCrud` / `testForceDenyFls`). Whenever a test mutates any of these, wrap the test body in `try { ... } finally { Guard.resetContext(); }`:

```apex
@IsTest
static void myTest() {
    Guard.resetContext();
    try {
        GuardContext.testQuiddityOverride = System.Quiddity.REST;
        // ... assertions ...
    } finally {
        Guard.resetContext();
    }
}
```

### 2. Testing Standard `GuardException` Metadata

Assert structured fields rather than fragile full-sentence text alone:

```apex
@IsTest
static void shouldRejectNegativeAmount() {
    try {
        BillingService.applyDiscount(-5);
        System.Assert.fail('Expected GuardException for negative discount.');
    } catch (GuardException ex) {
        System.Assert.areEqual(GuardException.ERR_GREATER_THAN, ex.getErrorCode());
        System.Assert.areEqual('discountAmount', ex.getParamName());
        System.Assert.areEqual(-5, ex.getActualValue());
        System.Assert.areEqual('SYNCHRONOUS', ex.getExecutionContext());
    }
}
```

---

## Testing `@AuraEnabled` LWC Controllers in `@IsTest`

Apex `@IsTest` methods run with `System.Quiddity.SYNCHRONOUS` by default, so calling a controller that relies *only* on `Quiddity.AURA` auto-detection would throw `GuardException` during tests unless you simulate `AURA` or use `Guard.forLwc()`:

* **Controllers using `Guard.forLwc()`** already throw `AuraHandledException` directly in unit tests—and because `GuardContext.createAuraHandledException` always invokes `setMessage()`, `ex.getMessage()` returns the real validation text instead of `'Script-thrown exception'`:
  ```apex
  @IsTest
  static void shouldThrowReadableAuraHandledException() {
      try {
          BudgetController.updateQuarterlyBudget('', 100);
          System.Assert.fail('Expected AuraHandledException.');
      } catch (AuraHandledException ex) {
          System.Assert.isTrue(ex.getMessage().contains('accountIdStr'));
          System.Assert.areNotEqual('Script-thrown exception', ex.getMessage());
      }
  }
  ```
* **Controllers relying on automatic `Quiddity.AURA` detection** can be tested deterministically by setting the `@TestVisible` override:
  ```apex
  Guard.resetContext();
  try {
      GuardContext.testQuiddityOverride = System.Quiddity.AURA;
      // Call controller method using plain Guard.isNotBlank(...)
  } catch (AuraHandledException ex) {
      System.Assert.areNotEqual('Script-thrown exception', ex.getMessage());
  } finally {
      Guard.resetContext();
  }
  ```

---

## Testing `GuardRecord` Triggers Without DML Overhead

Because `Guard.onRecord(record)` calls `record.addError(...)` and accumulates error messages in memory, you can verify multi-field errors without executing a single DML statement:

```apex
@IsTest
static void shouldAttachFieldErrorsOnInvalidOpportunity() {
    Opportunity opp = new Opportunity(Name = '   ', Amount = -10, Probability = 120);

    GuardRecord result = Guard.onRecord(opp)
        .isNotBlank(Opportunity.Name)
        .isGreaterThan(Opportunity.Amount, 0)
        .isInRange(Opportunity.Probability, 10, 90);

    System.Assert.isTrue(result.hasErrors());
    System.Assert.isFalse(result.isValid());
    System.Assert.areEqual(3, result.getErrorMessages().size());
    System.Assert.isTrue(opp.hasErrors());
}
```

---

## Testing Opt-In CRUD & FLS Guards (Locale-Safe `System.runAs`)

Never hardcode English Profile names (`WHERE Name = 'Standard User'` or `'Minimum Access - Salesforce'`) in open-source or multi-language org test suites—non-English Salesforce orgs localize standard profile names.

Instead, follow the pattern used in `GuardTest`:

1. Query `SELECT Id FROM Profile WHERE UserType = 'Standard' AND PermissionsModifyAllData = FALSE LIMIT 1` with fallback to `UserInfo.getProfileId()`.
2. Build unique usernames with `System.now().getTime()`, `Crypto.getRandomInteger()`, and `UserInfo.getOrganizationId()`.
3. Remember that in some orgs the selected restricted profile may lack object CRUD (e.g., `Schema.SObjectType.Account.isAccessible() == false`). Guard calls to `Security.stripInaccessible(...)` conditionally or combine `System.runAs` with `@TestVisible GuardSchemaValidator.testForceDenyCrud` / `testForceDenyFls` inside `try { ... } finally { Guard.resetContext(); }` for deterministic permission-denial testing across any org configuration.

```apex
@IsTest
static void shouldDenyUpdateWhenCrudOrFlsBlocked() {
    User testUser = createLocaleSafeStandardUser();
    System.runAs(testUser) {
        Guard.resetContext();
        try {
            GuardSchemaValidator.testForceDenyFls = true;
            try {
                Guard.isFieldUpdateable(Account.AnnualRevenue);
                System.Assert.fail('Expected GuardException for denied FLS.');
            } catch (GuardException ex) {
                System.Assert.areEqual(GuardException.ERR_FIELD_NOT_UPDATEABLE, ex.getErrorCode());
            }
        } finally {
            Guard.resetContext();
        }
    }
}
```

---

## Testing Global `IGuardFailureHandler` Adapters

Implement a lightweight in-memory handler inside your `@IsTest` class to assert `GuardContext.Failure` fields (`errorCode`, `paramName`, `executionContext`, `quiddity`) or domain exception translation cleanly without touching live external loggers—and clear it via `Guard.resetContext()` in `finally`.

## Running the Built-In Test Suite

Execute all 4 ApexGuard test classes together using the included `ApexTestSuite`:

```bash
sf apex run test --suite-names ApexGuard --code-coverage --result-format human --wait 10
```

## Related Skills

* [apex-guard-usage](../apex-guard-usage/SKILL.md) — Core facade methods under test.
* [apex-guard-security-and-best-practices](../apex-guard-security-and-best-practices/SKILL.md) — CRUD/FLS design and `record.isSet()` rules.
* [apex-guard-extensibility-and-logging](../apex-guard-extensibility-and-logging/SKILL.md) — Testing `IGuardFailureHandler` and custom exceptions.
