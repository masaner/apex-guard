# Contributing to ApexGuard

Thank you for helping make defensive Apex programming cleaner, faster, and more reliable for the Salesforce ecosystem!

## Architecture & Directory Layout

```text
force-app/main/default/classes/
├── core/        # Public Guard.cls facade and GuardRecord.cls Trigger builder
├── context/     # GuardContext.cls runtime router and IGuardFailureHandler.cls interface
├── exceptions/  # GuardException.cls structured exception & error code constants
├── validators/  # Modular domain validators (Object, String, Numeric, Collection, SObject)
├── invocable/   # GuardFlowAction.cls for Flows and Agentforce
└── tests/       # @IsTest unit test suites
```

Separating validators by type keeps pull requests isolated and minimizes merge conflicts.

---

## Coding & Design Standards

1. **Positive Assertion Naming:** Name new methods after the **valid precondition required to pass** (e.g., `isPositive`, `isFutureDate`, `containsValue`) rather than `against...` or `throwIf...`.
2. **Pass-Through Return Values:** Whenever sensible, return the validated value so callers can write single-line assignment guards (`this.email = Guard.isEmail(email, 'email');`).
3. **Zero External Dependencies & Zero SOQL/DML:** Never introduce SOQL queries, DML statements, `Schema.getGlobalDescribe()` calls, or third-party package dependencies into core classes.
4. **Overload Safety:** Always provide standard `(value, paramName)`, `(value, paramName, customMessage)`, and `(value, customException)` overloads. Verify that literal `null` or subtype arguments do not introduce Apex compiler ambiguity.
5. **ApexDoc Requirement:** Every `public` class, method, and overload **must** include full ApexDoc tags (`@description`, `@param`, `@return`, `@throws`).
6. **Meta XML Companion:** Every `.cls` file must include a matching `.cls-meta.xml` with API version `62.0` and `<status>Active</status>`.

---

## Step-by-Step: Adding a New Guard Method

Let's walk through adding a hypothetical `Guard.isFutureDate(Date value, String paramName)`:

### Step 1: Add an Error Code Constant
Add a descriptive constant to [`GuardException.cls`](force-app/main/default/classes/exceptions/GuardException.cls):

```apex
public static final String ERR_FUTURE_DATE = 'GUARD_FUTURE_DATE';
```

### Step 2: Implement the Validator Logic
Add the implementation (with `paramName`, `customMessage`, and `Exception customException` overloads) to the appropriate validator in `force-app/main/default/classes/validators/`, routing failures through `GuardContext.fail(...)` or `GuardContext.failWithCustomException(...)`.

### Step 3: Expose the Method on `Guard.cls` (and `GuardRecord.cls` / `GuardContext.LwcScope` if applicable)
Delegate from [`Guard.cls`](force-app/main/default/classes/core/Guard.cls) with full ApexDoc comments. If the check applies to `SObject` fields (such as dates or strings), add matching field-level `addError` support in [`GuardRecord.cls`](force-app/main/default/classes/core/GuardRecord.cls).

### Step 4: Expose in `GuardFlowAction.cls` (Optional / Recommended for Scalar Checks)
If the guard accepts scalar Flow-compatible inputs (`String`, `Decimal`, `Boolean`, `SObject`), add the rule constant to `GuardFlowAction.executeRule(...)` and update the `@InvocableVariable` description on `GuardFlowAction.Request.rule`.

### Step 5: Write Comprehensive Unit Tests
Add `@IsTest` coverage in `force-app/main/default/classes/tests/` testing:
- Happy path and pass-through return value
- Boundary and null inputs
- Default error message and `GuardException.getErrorCode()`
- `customMessage` and `Exception customException` overloads
- `GuardRecord` field-level `addError()` (if added) and `GuardFlowAction` (`throwOnFailure = true` and `false`)

### Step 6: Update Documentation
Update the API Quick-Reference table in [README.md](README.md).

---

## Submitting a Pull Request

1. Format code with Prettier (`npm run prettier:verify` if installed locally).
2. Run all Apex tests in a scratch org or sandbox:
   ```bash
   sf apex run test --tests GuardTest GuardContextTest GuardRecordTest GuardFlowActionTest --code-coverage --result-format human --wait 10
   ```
3. Ensure >95% code coverage on every modified class and zero regressions.
4. Fill out the [Pull Request Template](.github/PULL_REQUEST_TEMPLATE.md).
