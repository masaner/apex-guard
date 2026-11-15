# Custom Exceptions & Error Metadata

While `ApexGuard` provides descriptive messages and standardized error codes out of the box, enterprise applications frequently need custom domain messages, custom `Exception` classes, or structured JSON payloads for API consumers.

---

## 1. Custom Message Overloads

Every parameter-named guard on `Guard` accepts an optional `customMessage` argument:

```apex
Guard.isGreaterThan(
    discountPercent,
    0,
    'discountPercent',
    'Discount percentage must be positive before submitting approval.'
);
```

Even when `customMessage` is supplied, `GuardException` still retains `getParamName()` (`'discountPercent'`), `getErrorCode()` (`GuardException.ERR_GREATER_THAN`), and `getExecutionContext()`.

---

## 2. Custom `Exception` Overloads

Every core `Guard` check supports passing an explicit `Exception` instance. If the check fails, `ApexGuard` routes the failure through any active `IGuardFailureHandler` and then throws your exact exception instance:

```apex
public class InsufficientCreditException extends Exception {
}

public void authorizeCharge(Decimal availableCredit) {
    Guard.isGreaterThan(
        availableCredit,
        0,
        new InsufficientCreditException('Customer credit balance is exhausted.')
    );
}
```

---

## 3. Structured `GuardException` Metadata

When standard `GuardException` is thrown, callers and global error handlers can inspect structured fields without fragile string parsing:

```apex
try {
    Guard.isIdOfType(recordId, Opportunity.SObjectType, 'opportunityId');
} catch (GuardException ex) {
    String param = ex.getParamName();          // 'opportunityId'
    String code = ex.getErrorCode();           // 'GUARD_ID_SOBJECT_TYPE'
    Object actual = ex.getActualValue();       // offending Id
    System.Quiddity q = ex.getQuiddity();      // e.g., Quiddity.REST
    String ctx = ex.getExecutionContext();     // e.g., 'REST' or 'TRIGGER'
    Map<String, Object> payload = ex.toMap();  // Ready for JSON.serialize(payload)
}
```

### Standardized Error Code Constants (`GuardException`)

| Constant | Value |
| :--- | :--- |
| `GuardException.ERR_NULL_VALUE` | `'GUARD_NULL_VALUE'` |
| `GuardException.ERR_NOT_NULL_VALUE` | `'GUARD_NOT_NULL_VALUE'` |
| `GuardException.ERR_TRUE_EXPECTED` | `'GUARD_TRUE_EXPECTED'` |
| `GuardException.ERR_FALSE_EXPECTED` | `'GUARD_FALSE_EXPECTED'` |
| `GuardException.ERR_EMPTY_STRING` | `'GUARD_EMPTY_STRING'` |
| `GuardException.ERR_BLANK_STRING` | `'GUARD_BLANK_STRING'` |
| `GuardException.ERR_STRING_LENGTH` | `'GUARD_STRING_LENGTH'` |
| `GuardException.ERR_MAX_LENGTH` | `'GUARD_MAX_LENGTH'` |
| `GuardException.ERR_REGEX_MISMATCH` | `'GUARD_REGEX_MISMATCH'` |
| `GuardException.ERR_GREATER_THAN` | `'GUARD_GREATER_THAN'` |
| `GuardException.ERR_GREATER_OR_EQUAL` | `'GUARD_GREATER_OR_EQUAL'` |
| `GuardException.ERR_LESS_THAN` | `'GUARD_LESS_THAN'` |
| `GuardException.ERR_LESS_OR_EQUAL` | `'GUARD_LESS_OR_EQUAL'` |
| `GuardException.ERR_OUT_OF_RANGE` | `'GUARD_OUT_OF_RANGE'` |
| `GuardException.ERR_ZERO_VALUE` | `'GUARD_ZERO_VALUE'` |
| `GuardException.ERR_EMPTY_COLLECTION` | `'GUARD_EMPTY_COLLECTION'` |
| `GuardException.ERR_COLLECTION_SIZE` | `'GUARD_COLLECTION_SIZE'` |
| `GuardException.ERR_MISSING_KEY` | `'GUARD_MISSING_KEY'` |
| `GuardException.ERR_INVALID_ID` | `'GUARD_INVALID_ID'` |
| `GuardException.ERR_ID_SOBJECT_TYPE` | `'GUARD_ID_SOBJECT_TYPE'` |
| `GuardException.ERR_SOBJECT_TYPE` | `'GUARD_SOBJECT_TYPE'` |
| `GuardException.ERR_UNPOPULATED_FIELD` | `'GUARD_UNPOPULATED_FIELD'` |
| `GuardException.ERR_SOBJECT_NOT_ACCESSIBLE` | `'GUARD_SOBJECT_NOT_ACCESSIBLE'` |
| `GuardException.ERR_SOBJECT_NOT_CREATEABLE` | `'GUARD_SOBJECT_NOT_CREATEABLE'` |
| `GuardException.ERR_SOBJECT_NOT_UPDATEABLE` | `'GUARD_SOBJECT_NOT_UPDATEABLE'` |
| `GuardException.ERR_SOBJECT_NOT_DELETABLE` | `'GUARD_SOBJECT_NOT_DELETABLE'` |
| `GuardException.ERR_FIELD_NOT_ACCESSIBLE` | `'GUARD_FIELD_NOT_ACCESSIBLE'` |
| `GuardException.ERR_FIELD_NOT_CREATEABLE` | `'GUARD_FIELD_NOT_CREATEABLE'` |
| `GuardException.ERR_FIELD_NOT_UPDATEABLE` | `'GUARD_FIELD_NOT_UPDATEABLE'` |
| `GuardException.ERR_INVALID_GUARD_ARGUMENT` | `'GUARD_INVALID_ARGUMENT'` |

---

## 4. Global Exception Translation via `IGuardFailureHandler`

If your codebase standardizes on a single domain exception (e.g., `ApplicationException`) across all services, register an `IGuardFailureHandler` that translates every `GuardContext.Failure`:

```apex
public class ApplicationExceptionAdapter implements IGuardFailureHandler {
    public void handleFailure(GuardContext.Failure failure) {
        if (failure.customException != null) {
            return; // Respect explicit caller exception overrides
        }
        throw new ApplicationException(failure.errorCode + ': ' + failure.message);
    }
}
```
