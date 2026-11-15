/**
 * @description Internal validator module for numeric comparisons, ranges, and non-zero assertions
 *              supporting Decimal, Integer, Long, and Double (widened to Decimal).
 *              Consumers should invoke these checks via the Guard facade.
 * @group Validators
 */
public inherited sharing class GuardNumericValidator {
    // =========================================================================
    // isGreaterThan
    // =========================================================================

    /**
     * @description Ensures a Decimal value is strictly greater than minExclusive.
     * @param value Decimal value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Decimal value.
     */
    public static Decimal isGreaterThan(Decimal value, Decimal minExclusive, String paramName) {
        return isGreaterThan(value, minExclusive, paramName, null);
    }

    /**
     * @description Ensures a Decimal value is strictly greater than minExclusive with a custom message.
     * @param value Decimal value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Decimal value.
     */
    public static Decimal isGreaterThan(
        Decimal value,
        Decimal minExclusive,
        String paramName,
        String customMessage
    ) {
        requireNonNullBound(minExclusive, 'minExclusive');
        if (value == null) {
            failNullNumber(paramName, customMessage);
        }
        if (value <= minExclusive) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must be greater than ' +
                  minExclusive +
                  ', but was ' +
                  value +
                  '.';
            GuardContext.fail(message, paramName, GuardException.ERR_GREATER_THAN, value);
        }
        return value;
    }

    /**
     * @description Ensures a Decimal value is strictly greater than minExclusive, throwing a custom exception.
     * @param value Decimal value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Decimal value.
     */
    public static Decimal isGreaterThan(
        Decimal value,
        Decimal minExclusive,
        Exception customException
    ) {
        if (minExclusive == null || value == null || value <= minExclusive) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_GREATER_THAN,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures an Integer value is strictly greater than minExclusive.
     * @param value Integer value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Integer value.
     */
    public static Integer isGreaterThan(Integer value, Integer minExclusive, String paramName) {
        return isGreaterThan(value, minExclusive, paramName, null);
    }

    /**
     * @description Ensures an Integer value is strictly greater than minExclusive with a custom message.
     * @param value Integer value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Integer value.
     */
    public static Integer isGreaterThan(
        Integer value,
        Integer minExclusive,
        String paramName,
        String customMessage
    ) {
        isGreaterThan(
            value != null ? Decimal.valueOf(value) : null,
            minExclusive != null ? Decimal.valueOf(minExclusive) : null,
            paramName,
            customMessage
        );
        return value;
    }

    /**
     * @description Ensures an Integer value is strictly greater than minExclusive, throwing a custom exception.
     * @param value Integer value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Integer value.
     */
    public static Integer isGreaterThan(
        Integer value,
        Integer minExclusive,
        Exception customException
    ) {
        isGreaterThan(
            value != null ? Decimal.valueOf(value) : null,
            minExclusive != null ? Decimal.valueOf(minExclusive) : null,
            customException
        );
        return value;
    }

    /**
     * @description Ensures a Long value is strictly greater than minExclusive.
     * @param value Long value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Long value.
     */
    public static Long isGreaterThan(Long value, Long minExclusive, String paramName) {
        return isGreaterThan(value, minExclusive, paramName, null);
    }

    /**
     * @description Ensures a Long value is strictly greater than minExclusive with a custom message.
     * @param value Long value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Long value.
     */
    public static Long isGreaterThan(
        Long value,
        Long minExclusive,
        String paramName,
        String customMessage
    ) {
        isGreaterThan(
            value != null ? Decimal.valueOf(value) : null,
            minExclusive != null ? Decimal.valueOf(minExclusive) : null,
            paramName,
            customMessage
        );
        return value;
    }

    /**
     * @description Ensures a Long value is strictly greater than minExclusive, throwing a custom exception.
     * @param value Long value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Long value.
     */
    public static Long isGreaterThan(Long value, Long minExclusive, Exception customException) {
        isGreaterThan(
            value != null ? Decimal.valueOf(value) : null,
            minExclusive != null ? Decimal.valueOf(minExclusive) : null,
            customException
        );
        return value;
    }

    // =========================================================================
    // isGreaterThanOrEqualTo
    // =========================================================================

    /**
     * @description Ensures a Decimal value is >= minInclusive.
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Decimal value.
     */
    public static Decimal isGreaterThanOrEqualTo(
        Decimal value,
        Decimal minInclusive,
        String paramName
    ) {
        return isGreaterThanOrEqualTo(value, minInclusive, paramName, null);
    }

    /**
     * @description Ensures a Decimal value is >= minInclusive with a custom message.
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Decimal value.
     */
    public static Decimal isGreaterThanOrEqualTo(
        Decimal value,
        Decimal minInclusive,
        String paramName,
        String customMessage
    ) {
        requireNonNullBound(minInclusive, 'minInclusive');
        if (value == null) {
            failNullNumber(paramName, customMessage);
        }
        if (value < minInclusive) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must be greater than or equal to ' +
                  minInclusive +
                  ', but was ' +
                  value +
                  '.';
            GuardContext.fail(message, paramName, GuardException.ERR_GREATER_OR_EQUAL, value);
        }
        return value;
    }

    /**
     * @description Ensures a Decimal value is >= minInclusive, throwing a custom exception.
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Decimal value.
     */
    public static Decimal isGreaterThanOrEqualTo(
        Decimal value,
        Decimal minInclusive,
        Exception customException
    ) {
        if (minInclusive == null || value == null || value < minInclusive) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_GREATER_OR_EQUAL,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures an Integer value is >= minInclusive.
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Integer value.
     */
    public static Integer isGreaterThanOrEqualTo(
        Integer value,
        Integer minInclusive,
        String paramName
    ) {
        return isGreaterThanOrEqualTo(value, minInclusive, paramName, null);
    }

    /**
     * @description Ensures an Integer value is >= minInclusive with a custom message.
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Integer value.
     */
    public static Integer isGreaterThanOrEqualTo(
        Integer value,
        Integer minInclusive,
        String paramName,
        String customMessage
    ) {
        isGreaterThanOrEqualTo(
            value != null ? Decimal.valueOf(value) : null,
            minInclusive != null ? Decimal.valueOf(minInclusive) : null,
            paramName,
            customMessage
        );
        return value;
    }

    /**
     * @description Ensures an Integer value is >= minInclusive, throwing a custom exception.
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Integer value.
     */
    public static Integer isGreaterThanOrEqualTo(
        Integer value,
        Integer minInclusive,
        Exception customException
    ) {
        isGreaterThanOrEqualTo(
            value != null ? Decimal.valueOf(value) : null,
            minInclusive != null ? Decimal.valueOf(minInclusive) : null,
            customException
        );
        return value;
    }

    /**
     * @description Ensures a Long value is >= minInclusive.
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Long value.
     */
    public static Long isGreaterThanOrEqualTo(Long value, Long minInclusive, String paramName) {
        return isGreaterThanOrEqualTo(value, minInclusive, paramName, null);
    }

    /**
     * @description Ensures a Long value is >= minInclusive with a custom message.
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Long value.
     */
    public static Long isGreaterThanOrEqualTo(
        Long value,
        Long minInclusive,
        String paramName,
        String customMessage
    ) {
        isGreaterThanOrEqualTo(
            value != null ? Decimal.valueOf(value) : null,
            minInclusive != null ? Decimal.valueOf(minInclusive) : null,
            paramName,
            customMessage
        );
        return value;
    }

    /**
     * @description Ensures a Long value is >= minInclusive, throwing a custom exception.
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Long value.
     */
    public static Long isGreaterThanOrEqualTo(
        Long value,
        Long minInclusive,
        Exception customException
    ) {
        isGreaterThanOrEqualTo(
            value != null ? Decimal.valueOf(value) : null,
            minInclusive != null ? Decimal.valueOf(minInclusive) : null,
            customException
        );
        return value;
    }

    // =========================================================================
    // isLessThan
    // =========================================================================

    /**
     * @description Ensures a Decimal value is strictly less than maxExclusive.
     * @param value Decimal value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Decimal value.
     */
    public static Decimal isLessThan(Decimal value, Decimal maxExclusive, String paramName) {
        return isLessThan(value, maxExclusive, paramName, null);
    }

    /**
     * @description Ensures a Decimal value is strictly less than maxExclusive with a custom message.
     * @param value Decimal value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Decimal value.
     */
    public static Decimal isLessThan(
        Decimal value,
        Decimal maxExclusive,
        String paramName,
        String customMessage
    ) {
        requireNonNullBound(maxExclusive, 'maxExclusive');
        if (value == null) {
            failNullNumber(paramName, customMessage);
        }
        if (value >= maxExclusive) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must be less than ' +
                  maxExclusive +
                  ', but was ' +
                  value +
                  '.';
            GuardContext.fail(message, paramName, GuardException.ERR_LESS_THAN, value);
        }
        return value;
    }

    /**
     * @description Ensures a Decimal value is strictly less than maxExclusive, throwing a custom exception.
     * @param value Decimal value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Decimal value.
     */
    public static Decimal isLessThan(
        Decimal value,
        Decimal maxExclusive,
        Exception customException
    ) {
        if (maxExclusive == null || value == null || value >= maxExclusive) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_LESS_THAN,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures an Integer value is strictly less than maxExclusive.
     * @param value Integer value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Integer value.
     */
    public static Integer isLessThan(Integer value, Integer maxExclusive, String paramName) {
        return isLessThan(value, maxExclusive, paramName, null);
    }

    /**
     * @description Ensures an Integer value is strictly less than maxExclusive with a custom message.
     * @param value Integer value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Integer value.
     */
    public static Integer isLessThan(
        Integer value,
        Integer maxExclusive,
        String paramName,
        String customMessage
    ) {
        isLessThan(
            value != null ? Decimal.valueOf(value) : null,
            maxExclusive != null ? Decimal.valueOf(maxExclusive) : null,
            paramName,
            customMessage
        );
        return value;
    }

    /**
     * @description Ensures an Integer value is strictly less than maxExclusive, throwing a custom exception.
     * @param value Integer value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Integer value.
     */
    public static Integer isLessThan(
        Integer value,
        Integer maxExclusive,
        Exception customException
    ) {
        isLessThan(
            value != null ? Decimal.valueOf(value) : null,
            maxExclusive != null ? Decimal.valueOf(maxExclusive) : null,
            customException
        );
        return value;
    }

    /**
     * @description Ensures a Long value is strictly less than maxExclusive.
     * @param value Long value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Long value.
     */
    public static Long isLessThan(Long value, Long maxExclusive, String paramName) {
        return isLessThan(value, maxExclusive, paramName, null);
    }

    /**
     * @description Ensures a Long value is strictly less than maxExclusive with a custom message.
     * @param value Long value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Long value.
     */
    public static Long isLessThan(
        Long value,
        Long maxExclusive,
        String paramName,
        String customMessage
    ) {
        isLessThan(
            value != null ? Decimal.valueOf(value) : null,
            maxExclusive != null ? Decimal.valueOf(maxExclusive) : null,
            paramName,
            customMessage
        );
        return value;
    }

    /**
     * @description Ensures a Long value is strictly less than maxExclusive, throwing a custom exception.
     * @param value Long value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Long value.
     */
    public static Long isLessThan(Long value, Long maxExclusive, Exception customException) {
        isLessThan(
            value != null ? Decimal.valueOf(value) : null,
            maxExclusive != null ? Decimal.valueOf(maxExclusive) : null,
            customException
        );
        return value;
    }

    // =========================================================================
    // isLessThanOrEqualTo
    // =========================================================================

    /**
     * @description Ensures a Decimal value is <= maxInclusive.
     * @param value Decimal value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Decimal value.
     */
    public static Decimal isLessThanOrEqualTo(
        Decimal value,
        Decimal maxInclusive,
        String paramName
    ) {
        return isLessThanOrEqualTo(value, maxInclusive, paramName, null);
    }

    /**
     * @description Ensures a Decimal value is <= maxInclusive with a custom message.
     * @param value Decimal value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Decimal value.
     */
    public static Decimal isLessThanOrEqualTo(
        Decimal value,
        Decimal maxInclusive,
        String paramName,
        String customMessage
    ) {
        requireNonNullBound(maxInclusive, 'maxInclusive');
        if (value == null) {
            failNullNumber(paramName, customMessage);
        }
        if (value > maxInclusive) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must be less than or equal to ' +
                  maxInclusive +
                  ', but was ' +
                  value +
                  '.';
            GuardContext.fail(message, paramName, GuardException.ERR_LESS_OR_EQUAL, value);
        }
        return value;
    }

    /**
     * @description Ensures a Decimal value is <= maxInclusive, throwing a custom exception.
     * @param value Decimal value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Decimal value.
     */
    public static Decimal isLessThanOrEqualTo(
        Decimal value,
        Decimal maxInclusive,
        Exception customException
    ) {
        if (maxInclusive == null || value == null || value > maxInclusive) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_LESS_OR_EQUAL,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures an Integer value is <= maxInclusive.
     * @param value Integer value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Integer value.
     */
    public static Integer isLessThanOrEqualTo(
        Integer value,
        Integer maxInclusive,
        String paramName
    ) {
        return isLessThanOrEqualTo(value, maxInclusive, paramName, null);
    }

    /**
     * @description Ensures an Integer value is <= maxInclusive with a custom message.
     * @param value Integer value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Integer value.
     */
    public static Integer isLessThanOrEqualTo(
        Integer value,
        Integer maxInclusive,
        String paramName,
        String customMessage
    ) {
        isLessThanOrEqualTo(
            value != null ? Decimal.valueOf(value) : null,
            maxInclusive != null ? Decimal.valueOf(maxInclusive) : null,
            paramName,
            customMessage
        );
        return value;
    }

    /**
     * @description Ensures an Integer value is <= maxInclusive, throwing a custom exception.
     * @param value Integer value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Integer value.
     */
    public static Integer isLessThanOrEqualTo(
        Integer value,
        Integer maxInclusive,
        Exception customException
    ) {
        isLessThanOrEqualTo(
            value != null ? Decimal.valueOf(value) : null,
            maxInclusive != null ? Decimal.valueOf(maxInclusive) : null,
            customException
        );
        return value;
    }

    /**
     * @description Ensures a Long value is <= maxInclusive.
     * @param value Long value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Long value.
     */
    public static Long isLessThanOrEqualTo(Long value, Long maxInclusive, String paramName) {
        return isLessThanOrEqualTo(value, maxInclusive, paramName, null);
    }

    /**
     * @description Ensures a Long value is <= maxInclusive with a custom message.
     * @param value Long value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Long value.
     */
    public static Long isLessThanOrEqualTo(
        Long value,
        Long maxInclusive,
        String paramName,
        String customMessage
    ) {
        isLessThanOrEqualTo(
            value != null ? Decimal.valueOf(value) : null,
            maxInclusive != null ? Decimal.valueOf(maxInclusive) : null,
            paramName,
            customMessage
        );
        return value;
    }

    /**
     * @description Ensures a Long value is <= maxInclusive, throwing a custom exception.
     * @param value Long value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Long value.
     */
    public static Long isLessThanOrEqualTo(
        Long value,
        Long maxInclusive,
        Exception customException
    ) {
        isLessThanOrEqualTo(
            value != null ? Decimal.valueOf(value) : null,
            maxInclusive != null ? Decimal.valueOf(maxInclusive) : null,
            customException
        );
        return value;
    }

    // =========================================================================
    // isInRange
    // =========================================================================

    /**
     * @description Ensures a Decimal value falls within [minInclusive, maxInclusive].
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Decimal value.
     */
    public static Decimal isInRange(
        Decimal value,
        Decimal minInclusive,
        Decimal maxInclusive,
        String paramName
    ) {
        return isInRange(value, minInclusive, maxInclusive, paramName, null);
    }

    /**
     * @description Ensures a Decimal value falls within [minInclusive, maxInclusive] with a custom message.
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Decimal value.
     */
    public static Decimal isInRange(
        Decimal value,
        Decimal minInclusive,
        Decimal maxInclusive,
        String paramName,
        String customMessage
    ) {
        requireNonNullBound(minInclusive, 'minInclusive');
        requireNonNullBound(maxInclusive, 'maxInclusive');
        if (minInclusive > maxInclusive) {
            GuardContext.fail(
                'Minimum bound (' +
                    minInclusive +
                    ') must not exceed maximum bound (' +
                    maxInclusive +
                    ').',
                'minInclusive',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                minInclusive
            );
        }
        if (value == null) {
            failNullNumber(paramName, customMessage);
        }
        if (value < minInclusive || value > maxInclusive) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must be between ' +
                  minInclusive +
                  ' and ' +
                  maxInclusive +
                  ' (inclusive), but was ' +
                  value +
                  '.';
            GuardContext.fail(message, paramName, GuardException.ERR_OUT_OF_RANGE, value);
        }
        return value;
    }

    /**
     * @description Ensures a Decimal value falls within [minInclusive, maxInclusive], throwing a custom exception.
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Decimal value.
     */
    public static Decimal isInRange(
        Decimal value,
        Decimal minInclusive,
        Decimal maxInclusive,
        Exception customException
    ) {
        if (
            minInclusive == null ||
            maxInclusive == null ||
            minInclusive > maxInclusive ||
            value == null ||
            value < minInclusive ||
            value > maxInclusive
        ) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_OUT_OF_RANGE,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures an Integer value falls within [minInclusive, maxInclusive].
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Integer value.
     */
    public static Integer isInRange(
        Integer value,
        Integer minInclusive,
        Integer maxInclusive,
        String paramName
    ) {
        return isInRange(value, minInclusive, maxInclusive, paramName, null);
    }

    /**
     * @description Ensures an Integer value falls within [minInclusive, maxInclusive] with a custom message.
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Integer value.
     */
    public static Integer isInRange(
        Integer value,
        Integer minInclusive,
        Integer maxInclusive,
        String paramName,
        String customMessage
    ) {
        isInRange(
            value != null ? Decimal.valueOf(value) : null,
            minInclusive != null ? Decimal.valueOf(minInclusive) : null,
            maxInclusive != null ? Decimal.valueOf(maxInclusive) : null,
            paramName,
            customMessage
        );
        return value;
    }

    /**
     * @description Ensures an Integer value falls within [minInclusive, maxInclusive], throwing a custom exception.
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Integer value.
     */
    public static Integer isInRange(
        Integer value,
        Integer minInclusive,
        Integer maxInclusive,
        Exception customException
    ) {
        isInRange(
            value != null ? Decimal.valueOf(value) : null,
            minInclusive != null ? Decimal.valueOf(minInclusive) : null,
            maxInclusive != null ? Decimal.valueOf(maxInclusive) : null,
            customException
        );
        return value;
    }

    /**
     * @description Ensures a Long value falls within [minInclusive, maxInclusive].
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages.
     * @return The validated Long value.
     */
    public static Long isInRange(
        Long value,
        Long minInclusive,
        Long maxInclusive,
        String paramName
    ) {
        return isInRange(value, minInclusive, maxInclusive, paramName, null);
    }

    /**
     * @description Ensures a Long value falls within [minInclusive, maxInclusive] with a custom message.
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated Long value.
     */
    public static Long isInRange(
        Long value,
        Long minInclusive,
        Long maxInclusive,
        String paramName,
        String customMessage
    ) {
        isInRange(
            value != null ? Decimal.valueOf(value) : null,
            minInclusive != null ? Decimal.valueOf(minInclusive) : null,
            maxInclusive != null ? Decimal.valueOf(maxInclusive) : null,
            paramName,
            customMessage
        );
        return value;
    }

    /**
     * @description Ensures a Long value falls within [minInclusive, maxInclusive], throwing a custom exception.
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Long value.
     */
    public static Long isInRange(
        Long value,
        Long minInclusive,
        Long maxInclusive,
        Exception customException
    ) {
        isInRange(
            value != null ? Decimal.valueOf(value) : null,
            minInclusive != null ? Decimal.valueOf(minInclusive) : null,
            maxInclusive != null ? Decimal.valueOf(maxInclusive) : null,
            customException
        );
        return value;
    }

    // =========================================================================
    // isNotZero
    // =========================================================================

    /**
     * @description Ensures a Decimal value is non-null and not zero.
     * @param value Decimal value to validate.
     * @param paramName Parameter name included in error messages.
     * @return The validated non-zero Decimal value.
     */
    public static Decimal isNotZero(Decimal value, String paramName) {
        return isNotZero(value, paramName, null);
    }

    /**
     * @description Ensures a Decimal value is non-null and not zero with a custom message.
     * @param value Decimal value to validate.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated non-zero Decimal value.
     */
    public static Decimal isNotZero(Decimal value, String paramName, String customMessage) {
        if (value == null) {
            failNullNumber(paramName, customMessage);
        }
        if (value == 0) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must not be zero.';
            GuardContext.fail(message, paramName, GuardException.ERR_ZERO_VALUE, value);
        }
        return value;
    }

    /**
     * @description Ensures a Decimal value is non-null and not zero, throwing a custom exception.
     * @param value Decimal value to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated non-zero Decimal value.
     */
    public static Decimal isNotZero(Decimal value, Exception customException) {
        if (value == null || value == 0) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_ZERO_VALUE,
                value
            );
        }
        return value;
    }

    /**
     * @description Ensures an Integer value is non-null and not zero.
     * @param value Integer value to validate.
     * @param paramName Parameter name included in error messages.
     * @return The validated non-zero Integer value.
     */
    public static Integer isNotZero(Integer value, String paramName) {
        return isNotZero(value, paramName, null);
    }

    /**
     * @description Ensures an Integer value is non-null and not zero with a custom message.
     * @param value Integer value to validate.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated non-zero Integer value.
     */
    public static Integer isNotZero(Integer value, String paramName, String customMessage) {
        isNotZero(value != null ? Decimal.valueOf(value) : null, paramName, customMessage);
        return value;
    }

    /**
     * @description Ensures an Integer value is non-null and not zero, throwing a custom exception.
     * @param value Integer value to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated non-zero Integer value.
     */
    public static Integer isNotZero(Integer value, Exception customException) {
        isNotZero(value != null ? Decimal.valueOf(value) : null, customException);
        return value;
    }

    /**
     * @description Ensures a Long value is non-null and not zero.
     * @param value Long value to validate.
     * @param paramName Parameter name included in error messages.
     * @return The validated non-zero Long value.
     */
    public static Long isNotZero(Long value, String paramName) {
        return isNotZero(value, paramName, null);
    }

    /**
     * @description Ensures a Long value is non-null and not zero with a custom message.
     * @param value Long value to validate.
     * @param paramName Parameter name included in error metadata.
     * @param customMessage Optional override error message.
     * @return The validated non-zero Long value.
     */
    public static Long isNotZero(Long value, String paramName, String customMessage) {
        isNotZero(value != null ? Decimal.valueOf(value) : null, paramName, customMessage);
        return value;
    }

    /**
     * @description Ensures a Long value is non-null and not zero, throwing a custom exception.
     * @param value Long value to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated non-zero Long value.
     */
    public static Long isNotZero(Long value, Exception customException) {
        isNotZero(value != null ? Decimal.valueOf(value) : null, customException);
        return value;
    }

    // =========================================================================
    // Helpers
    // =========================================================================

    private static void requireNonNullBound(Decimal boundValue, String boundName) {
        if (boundValue == null) {
            GuardContext.fail(
                'Guard comparison bound \'' + boundName + '\' must not be null.',
                boundName,
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                null
            );
        }
    }

    private static void failNullNumber(String paramName, String customMessage) {
        String message = String.isNotBlank(customMessage)
            ? customMessage
            : 'Parameter \'' +
              GuardObjectValidator.safeParamName(paramName) +
              '\' must not be null.';
        GuardContext.fail(message, paramName, GuardException.ERR_NULL_VALUE, null);
    }
}
