/**
 * @description Internal validator module for String preconditions (emptiness, whitespace, length, regex).
 *              Consumers should invoke these checks via the Guard facade.
 * @group Validators
 */
public inherited sharing class GuardStringValidator {
    /**
     * @description Ensures a string is neither null nor zero-length.
     * @param value String value to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated non-empty String.
     */
    public static String isNotEmpty(String value, String paramName) {
        return isNotEmpty(value, paramName, null);
    }

    /**
     * @description Ensures a string is neither null nor zero-length with an optional custom message.
     * @param value String value to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated non-empty String.
     */
    public static String isNotEmpty(String value, String paramName, String customMessage) {
        if (String.isEmpty(value)) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must not be null or empty.';
            GuardContext.fail(message, paramName, GuardException.ERR_EMPTY_STRING, value);
        }
        return value;
    }

    /**
     * @description Ensures a string is neither null nor zero-length, throwing a custom exception on failure.
     * @param value String value to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated non-empty String.
     */
    public static String isNotEmpty(String value, Exception customException) {
        if (String.isEmpty(value)) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_EMPTY_STRING,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures a string is not null, empty, or whitespace-only.
     * @param value String value to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated non-blank String.
     */
    public static String isNotBlank(String value, String paramName) {
        return isNotBlank(value, paramName, null);
    }

    /**
     * @description Ensures a string is not null, empty, or whitespace-only with an optional custom message.
     * @param value String value to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated non-blank String.
     */
    public static String isNotBlank(String value, String paramName, String customMessage) {
        if (String.isBlank(value)) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must not be null, empty, or whitespace.';
            GuardContext.fail(message, paramName, GuardException.ERR_BLANK_STRING, value);
        }
        return value;
    }

    /**
     * @description Ensures a string is not null, empty, or whitespace-only, throwing a custom exception on failure.
     * @param value String value to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated non-blank String.
     */
    public static String isNotBlank(String value, Exception customException) {
        if (String.isBlank(value)) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_BLANK_STRING,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures a non-null string has an exact character length.
     * @param value String value to validate.
     * @param expectedLength Exact required character count (must be >= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated String.
     */
    public static String hasLengthEqualTo(String value, Integer expectedLength, String paramName) {
        return hasLengthEqualTo(value, expectedLength, paramName, null);
    }

    /**
     * @description Ensures a non-null string has an exact character length with an optional custom message.
     * @param value String value to validate.
     * @param expectedLength Exact required character count (must be >= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated String.
     */
    public static String hasLengthEqualTo(
        String value,
        Integer expectedLength,
        String paramName,
        String customMessage
    ) {
        if (expectedLength == null || expectedLength < 0) {
            GuardContext.fail(
                'Expected length for parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must be zero or greater.',
                'expectedLength',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                expectedLength
            );
        }
        if (value == null || value.length() != expectedLength) {
            String actualDesc = value == null ? 'null' : String.valueOf(value.length());
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must have length ' +
                  expectedLength +
                  ', but was ' +
                  actualDesc +
                  '.';
            GuardContext.fail(message, paramName, GuardException.ERR_STRING_LENGTH, value);
        }
        return value;
    }

    /**
     * @description Ensures a non-null string has an exact character length, throwing a custom exception on failure.
     * @param value String value to validate.
     * @param expectedLength Exact required character count (must be >= 0).
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated String.
     */
    public static String hasLengthEqualTo(
        String value,
        Integer expectedLength,
        Exception customException
    ) {
        if (
            expectedLength == null ||
            expectedLength < 0 ||
            value == null ||
            value.length() != expectedLength
        ) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_STRING_LENGTH,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures a non-null string does not exceed the specified maximum character length.
     * @param value String value to validate.
     * @param maxLength Maximum allowed character count (must be >= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated String.
     */
    public static String hasMaxLength(String value, Integer maxLength, String paramName) {
        return hasMaxLength(value, maxLength, paramName, null);
    }

    /**
     * @description Ensures a non-null string does not exceed the specified maximum character length with an optional custom message.
     * @param value String value to validate.
     * @param maxLength Maximum allowed character count (must be >= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated String.
     */
    public static String hasMaxLength(
        String value,
        Integer maxLength,
        String paramName,
        String customMessage
    ) {
        if (maxLength == null || maxLength < 0) {
            GuardContext.fail(
                'Maximum length for parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must be zero or greater.',
                'maxLength',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                maxLength
            );
        }
        if (value == null || value.length() > maxLength) {
            String actualDesc = value == null ? 'null' : String.valueOf(value.length());
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must have length at most ' +
                  maxLength +
                  ', but was ' +
                  actualDesc +
                  '.';
            GuardContext.fail(message, paramName, GuardException.ERR_MAX_LENGTH, value);
        }
        return value;
    }

    /**
     * @description Ensures a non-null string does not exceed the specified maximum length, throwing a custom exception on failure.
     * @param value String value to validate.
     * @param maxLength Maximum allowed character count (must be >= 0).
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated String.
     */
    public static String hasMaxLength(String value, Integer maxLength, Exception customException) {
        if (maxLength == null || maxLength < 0 || value == null || value.length() > maxLength) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_MAX_LENGTH,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures a non-null string matches the full regular expression pattern.
     * @param value String value to validate.
     * @param regexPattern Apex regular expression pattern.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated String.
     */
    public static String matchesRegex(String value, String regexPattern, String paramName) {
        return matchesRegex(value, regexPattern, paramName, null);
    }

    /**
     * @description Ensures a non-null string matches the full regular expression pattern with an optional custom message.
     * @param value String value to validate.
     * @param regexPattern Apex regular expression pattern.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated String.
     */
    public static String matchesRegex(
        String value,
        String regexPattern,
        String paramName,
        String customMessage
    ) {
        if (String.isEmpty(regexPattern)) {
            GuardContext.fail(
                'Regex pattern for parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must not be null or empty.',
                'regexPattern',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                regexPattern
            );
        }
        if (value == null || !Pattern.compile(regexPattern).matcher(value).matches()) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' does not match required pattern \'' +
                  regexPattern +
                  '\'.';
            GuardContext.fail(message, paramName, GuardException.ERR_REGEX_MISMATCH, value);
        }
        return value;
    }

    /**
     * @description Ensures a non-null string matches the full regular expression pattern, throwing a custom exception on failure.
     * @param value String value to validate.
     * @param regexPattern Apex regular expression pattern.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated String.
     */
    public static String matchesRegex(
        String value,
        String regexPattern,
        Exception customException
    ) {
        if (
            String.isEmpty(regexPattern) ||
            value == null ||
            !Pattern.compile(regexPattern).matcher(value).matches()
        ) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_REGEX_MISMATCH,
                value
            );
        }
        return value;
    }
}
