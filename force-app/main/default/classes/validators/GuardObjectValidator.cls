/**
 * @description Internal validator module for nullability and boolean state assertions.
 *              Consumers should invoke these checks via the Guard facade.
 * @group Validators
 */
public inherited sharing class GuardObjectValidator {
    /**
     * @description Ensures the specified object reference is not null.
     * @param value Value to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated non-null Object value.
     */
    public static Object isNotNull(Object value, String paramName) {
        return isNotNull(value, paramName, null);
    }

    /**
     * @description Ensures the specified object reference is not null with an optional custom message.
     * @param value Value to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated non-null Object value.
     */
    public static Object isNotNull(Object value, String paramName, String customMessage) {
        if (value == null) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' + safeParamName(paramName) + '\' must not be null.';
            GuardContext.fail(message, paramName, GuardException.ERR_NULL_VALUE, value);
        }
        return value;
    }

    /**
     * @description Ensures the specified object reference is not null, throwing a custom exception on failure.
     * @param value Value to validate.
     * @param customException Custom Exception instance to throw if value is null.
     * @return The validated non-null Object value.
     */
    public static Object isNotNull(Object value, Exception customException) {
        if (value == null) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_NULL_VALUE,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures the specified object reference is null.
     * @param value Value to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return Always returns null when validation succeeds.
     */
    public static Object isNull(Object value, String paramName) {
        return isNull(value, paramName, null);
    }

    /**
     * @description Ensures the specified object reference is null with an optional custom message.
     * @param value Value to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return Always returns null when validation succeeds.
     */
    public static Object isNull(Object value, String paramName, String customMessage) {
        if (value != null) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  safeParamName(paramName) +
                  '\' must be null, but was \'' +
                  String.valueOf(value) +
                  '\'.';
            GuardContext.fail(message, paramName, GuardException.ERR_NOT_NULL_VALUE, value);
        }
        return null;
    }

    /**
     * @description Ensures the specified object reference is null, throwing a custom exception on failure.
     * @param value Value to validate.
     * @param customException Custom Exception instance to throw if value is non-null.
     * @return Always returns null when validation succeeds.
     */
    public static Object isNull(Object value, Exception customException) {
        if (value != null) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_NOT_NULL_VALUE,
                value
            );
        }
        return null;
    }

    /**
     * @description Ensures the boolean condition evaluates to true.
     * @param condition Boolean condition to evaluate (null is treated as failure).
     * @param message Failure message used if the condition is not true.
     * @return Boolean true when validation succeeds.
     */
    public static Boolean isTrue(Boolean condition, String message) {
        if (condition != true) {
            String effectiveMessage = String.isNotBlank(message)
                ? message
                : 'Condition must evaluate to true.';
            GuardContext.fail(effectiveMessage, null, GuardException.ERR_TRUE_EXPECTED, condition);
        }
        return true;
    }

    /**
     * @description Ensures the boolean condition evaluates to true, throwing a custom exception on failure.
     * @param condition Boolean condition to evaluate (null is treated as failure).
     * @param customException Custom Exception instance to throw if condition is not true.
     * @return Boolean true when validation succeeds.
     */
    public static Boolean isTrue(Boolean condition, Exception customException) {
        if (condition != true) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_TRUE_EXPECTED,
                condition
            );
        }
        return true;
    }

    /**
     * @description Ensures the boolean condition evaluates to false.
     * @param condition Boolean condition to evaluate (null is treated as failure).
     * @param message Failure message used if the condition is not false.
     * @return Boolean false when validation succeeds.
     */
    public static Boolean isFalse(Boolean condition, String message) {
        if (condition != false) {
            String effectiveMessage = String.isNotBlank(message)
                ? message
                : 'Condition must evaluate to false.';
            GuardContext.fail(effectiveMessage, null, GuardException.ERR_FALSE_EXPECTED, condition);
        }
        return false;
    }

    /**
     * @description Ensures the boolean condition evaluates to false, throwing a custom exception on failure.
     * @param condition Boolean condition to evaluate (null is treated as failure).
     * @param customException Custom Exception instance to throw if condition is not false.
     * @return Boolean false when validation succeeds.
     */
    public static Boolean isFalse(Boolean condition, Exception customException) {
        if (condition != false) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_FALSE_EXPECTED,
                condition
            );
        }
        return false;
    }

    /**
     * @description Normalizes missing parameter names so error messages remain well-formed.
     * @param paramName Candidate parameter name.
     * @return Non-blank parameter label.
     */
    public static String safeParamName(String paramName) {
        return String.isBlank(paramName) ? 'value' : paramName;
    }
}
