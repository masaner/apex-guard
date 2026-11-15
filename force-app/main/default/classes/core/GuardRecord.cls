/**
 * @description Non-throwing fluent SObject validator designed for Apex Triggers and bulk record
 *              processing. Validation failures attach field-level errors via
 *              record.addError(field, message) or record.addError(message),
 *              preserving partial DML (allOrNone = false) and Lightning UI field highlighting.
 * @group Core
 */
public inherited sharing class GuardRecord {
    private final SObject record;
    private final List<String> errorMessages;

    /**
     * @description Constructs a GuardRecord validator wrapping a non-null SObject instance.
     * @param record SObject record under validation.
     * @throws GuardException if record is null.
     */
    public GuardRecord(SObject record) {
        GuardObjectValidator.isNotNull(record, 'record');
        this.record = record;
        this.errorMessages = new List<String>();
    }

    // =========================================================================
    // Nullability & State
    // =========================================================================

    /**
     * @description Attaches a field error if the specified field on the SObject is null or unset.
     * @param field Schema.SObjectField to inspect.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotNull(Schema.SObjectField field) {
        return isNotNull(field, null);
    }

    /**
     * @description Attaches a field error with a custom message if the field is null or unset.
     * @param field Schema.SObjectField to inspect.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotNull(Schema.SObjectField field, String customMessage) {
        Object value = readFieldValue(field);
        if (value == null) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' + fieldName(field) + '\' must not be null.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if an arbitrary value is null.
     * @param value Value to check.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotNull(Object value, String paramName) {
        if (value == null) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must not be null.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field error if the specified field on the SObject is non-null.
     * @param field Schema.SObjectField to inspect.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNull(Schema.SObjectField field) {
        return isNull(field, null);
    }

    /**
     * @description Attaches a field error with a custom message if the field is non-null.
     * @param field Schema.SObjectField to inspect.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNull(Schema.SObjectField field, String customMessage) {
        Object value = readFieldValue(field);
        if (value != null) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' +
                  fieldName(field) +
                  '\' must be null, but was \'' +
                  String.valueOf(value) +
                  '\'.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if an arbitrary value is non-null.
     * @param value Value to check.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNull(Object value, String paramName) {
        if (value != null) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must be null, but was \'' +
                    String.valueOf(value) +
                    '\'.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if condition does not evaluate to true.
     * @param condition Boolean condition to verify.
     * @param message Error message attached to the record on failure.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isTrue(Boolean condition, String message) {
        if (condition != true) {
            addRecordError(
                String.isNotBlank(message) ? message : 'Condition must evaluate to true.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field-level error if condition does not evaluate to true.
     * @param condition Boolean condition to verify.
     * @param field Schema.SObjectField to target with addError.
     * @param message Error message attached to the field on failure.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isTrue(Boolean condition, Schema.SObjectField field, String message) {
        if (condition != true) {
            addFieldError(
                field,
                String.isNotBlank(message) ? message : 'Condition must evaluate to true.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if condition does not evaluate to false.
     * @param condition Boolean condition to verify.
     * @param message Error message attached to the record on failure.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isFalse(Boolean condition, String message) {
        if (condition != false) {
            addRecordError(
                String.isNotBlank(message) ? message : 'Condition must evaluate to false.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field-level error if condition does not evaluate to false.
     * @param condition Boolean condition to verify.
     * @param field Schema.SObjectField to target with addError.
     * @param message Error message attached to the field on failure.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isFalse(Boolean condition, Schema.SObjectField field, String message) {
        if (condition != false) {
            addFieldError(
                field,
                String.isNotBlank(message) ? message : 'Condition must evaluate to false.'
            );
        }
        return this;
    }

    // =========================================================================
    // Strings
    // =========================================================================

    /**
     * @description Attaches a field error if the text field is null or empty.
     * @param field Schema.SObjectField to inspect.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotEmpty(Schema.SObjectField field) {
        return isNotEmpty(field, null);
    }

    /**
     * @description Attaches a field error with a custom message if the text field is null or empty.
     * @param field Schema.SObjectField to inspect.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotEmpty(Schema.SObjectField field, String customMessage) {
        String value = readStringValue(field);
        if (String.isEmpty(value)) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' + fieldName(field) + '\' must not be null or empty.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the supplied String value is null or empty.
     * @param value String value to inspect.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotEmpty(String value, String paramName) {
        if (String.isEmpty(value)) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must not be null or empty.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field error if the text field is null, empty, or whitespace-only.
     * @param field Schema.SObjectField to inspect.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotBlank(Schema.SObjectField field) {
        return isNotBlank(field, null);
    }

    /**
     * @description Attaches a field error with a custom message if the text field is blank.
     * @param field Schema.SObjectField to inspect.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotBlank(Schema.SObjectField field, String customMessage) {
        String value = readStringValue(field);
        if (String.isBlank(value)) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' + fieldName(field) + '\' must not be null, empty, or whitespace.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the supplied String value is blank.
     * @param value String value to inspect.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotBlank(String value, String paramName) {
        if (String.isBlank(value)) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must not be null, empty, or whitespace.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field error if the text field is null or does not match expectedLength.
     * @param field Schema.SObjectField to inspect.
     * @param expectedLength Exact required character count (>= 0).
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord hasLengthEqualTo(Schema.SObjectField field, Integer expectedLength) {
        return hasLengthEqualTo(field, expectedLength, null);
    }

    /**
     * @description Attaches a field error with a custom message if the text field length differs from expectedLength.
     * @param field Schema.SObjectField to inspect.
     * @param expectedLength Exact required character count (>= 0).
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord hasLengthEqualTo(
        Schema.SObjectField field,
        Integer expectedLength,
        String customMessage
    ) {
        requireNonNegativeLength(expectedLength, 'expectedLength');
        String value = readStringValue(field);
        if (value == null || value.length() != expectedLength) {
            String actualDesc = value == null ? 'null' : String.valueOf(value.length());
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' +
                  fieldName(field) +
                  '\' must have length ' +
                  expectedLength +
                  ', but was ' +
                  actualDesc +
                  '.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the String value is null or does not match expectedLength.
     * @param value String value to inspect.
     * @param expectedLength Exact required character count (>= 0).
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord hasLengthEqualTo(String value, Integer expectedLength, String paramName) {
        requireNonNegativeLength(expectedLength, 'expectedLength');
        if (value == null || value.length() != expectedLength) {
            String actualDesc = value == null ? 'null' : String.valueOf(value.length());
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must have length ' +
                    expectedLength +
                    ', but was ' +
                    actualDesc +
                    '.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field error if the text field is null or exceeds maxLength.
     * @param field Schema.SObjectField to inspect.
     * @param maxLength Maximum allowed character count (>= 0).
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord hasMaxLength(Schema.SObjectField field, Integer maxLength) {
        return hasMaxLength(field, maxLength, null);
    }

    /**
     * @description Attaches a field error with a custom message if the text field exceeds maxLength.
     * @param field Schema.SObjectField to inspect.
     * @param maxLength Maximum allowed character count (>= 0).
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord hasMaxLength(
        Schema.SObjectField field,
        Integer maxLength,
        String customMessage
    ) {
        requireNonNegativeLength(maxLength, 'maxLength');
        String value = readStringValue(field);
        if (value == null || value.length() > maxLength) {
            String actualDesc = value == null ? 'null' : String.valueOf(value.length());
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' +
                  fieldName(field) +
                  '\' must have length at most ' +
                  maxLength +
                  ', but was ' +
                  actualDesc +
                  '.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the String value is null or exceeds maxLength.
     * @param value String value to inspect.
     * @param maxLength Maximum allowed character count (>= 0).
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord hasMaxLength(String value, Integer maxLength, String paramName) {
        requireNonNegativeLength(maxLength, 'maxLength');
        if (value == null || value.length() > maxLength) {
            String actualDesc = value == null ? 'null' : String.valueOf(value.length());
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must have length at most ' +
                    maxLength +
                    ', but was ' +
                    actualDesc +
                    '.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field error if the text field is null or fails to match regexPattern.
     * @param field Schema.SObjectField to inspect.
     * @param regexPattern Apex regular expression pattern.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord matchesRegex(Schema.SObjectField field, String regexPattern) {
        return matchesRegex(field, regexPattern, null);
    }

    /**
     * @description Attaches a field error with a custom message if the text field does not match regexPattern.
     * @param field Schema.SObjectField to inspect.
     * @param regexPattern Apex regular expression pattern.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord matchesRegex(
        Schema.SObjectField field,
        String regexPattern,
        String customMessage
    ) {
        requireNonEmptyPattern(regexPattern);
        String value = readStringValue(field);
        if (value == null || !Pattern.compile(regexPattern).matcher(value).matches()) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' +
                  fieldName(field) +
                  '\' does not match required pattern \'' +
                  regexPattern +
                  '\'.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the String value is null or fails to match regexPattern.
     * @param value String value to inspect.
     * @param regexPattern Apex regular expression pattern.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord matchesRegex(String value, String regexPattern, String paramName) {
        requireNonEmptyPattern(regexPattern);
        if (value == null || !Pattern.compile(regexPattern).matcher(value).matches()) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' does not match required pattern \'' +
                    regexPattern +
                    '\'.'
            );
        }
        return this;
    }

    // =========================================================================
    // Numeric
    // =========================================================================

    /**
     * @description Attaches a field error if the numeric field is null or <= minExclusive.
     * @param field Schema.SObjectField to inspect.
     * @param minExclusive Exclusive lower bound.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isGreaterThan(Schema.SObjectField field, Decimal minExclusive) {
        return isGreaterThan(field, minExclusive, null);
    }

    /**
     * @description Attaches a field error with a custom message if the numeric field is null or <= minExclusive.
     * @param field Schema.SObjectField to inspect.
     * @param minExclusive Exclusive lower bound.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isGreaterThan(
        Schema.SObjectField field,
        Decimal minExclusive,
        String customMessage
    ) {
        requireNonNullBound(minExclusive, 'minExclusive');
        Decimal value = toDecimal(readFieldValue(field));
        if (value == null || value <= minExclusive) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' +
                  fieldName(field) +
                  '\' must be greater than ' +
                  minExclusive +
                  ', but was ' +
                  value +
                  '.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the numeric value is null or <= minExclusive.
     * @param value Decimal value to inspect.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isGreaterThan(Decimal value, Decimal minExclusive, String paramName) {
        requireNonNullBound(minExclusive, 'minExclusive');
        if (value == null || value <= minExclusive) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must be greater than ' +
                    minExclusive +
                    ', but was ' +
                    value +
                    '.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field error if the numeric field is null or < minInclusive.
     * @param field Schema.SObjectField to inspect.
     * @param minInclusive Inclusive lower bound.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isGreaterThanOrEqualTo(Schema.SObjectField field, Decimal minInclusive) {
        return isGreaterThanOrEqualTo(field, minInclusive, null);
    }

    /**
     * @description Attaches a field error with a custom message if the numeric field is null or < minInclusive.
     * @param field Schema.SObjectField to inspect.
     * @param minInclusive Inclusive lower bound.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isGreaterThanOrEqualTo(
        Schema.SObjectField field,
        Decimal minInclusive,
        String customMessage
    ) {
        requireNonNullBound(minInclusive, 'minInclusive');
        Decimal value = toDecimal(readFieldValue(field));
        if (value == null || value < minInclusive) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' +
                  fieldName(field) +
                  '\' must be greater than or equal to ' +
                  minInclusive +
                  ', but was ' +
                  value +
                  '.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the numeric value is null or < minInclusive.
     * @param value Decimal value to inspect.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isGreaterThanOrEqualTo(
        Decimal value,
        Decimal minInclusive,
        String paramName
    ) {
        requireNonNullBound(minInclusive, 'minInclusive');
        if (value == null || value < minInclusive) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must be greater than or equal to ' +
                    minInclusive +
                    ', but was ' +
                    value +
                    '.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field error if the numeric field is null or >= maxExclusive.
     * @param field Schema.SObjectField to inspect.
     * @param maxExclusive Exclusive upper bound.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isLessThan(Schema.SObjectField field, Decimal maxExclusive) {
        return isLessThan(field, maxExclusive, null);
    }

    /**
     * @description Attaches a field error with a custom message if the numeric field is null or >= maxExclusive.
     * @param field Schema.SObjectField to inspect.
     * @param maxExclusive Exclusive upper bound.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isLessThan(
        Schema.SObjectField field,
        Decimal maxExclusive,
        String customMessage
    ) {
        requireNonNullBound(maxExclusive, 'maxExclusive');
        Decimal value = toDecimal(readFieldValue(field));
        if (value == null || value >= maxExclusive) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' +
                  fieldName(field) +
                  '\' must be less than ' +
                  maxExclusive +
                  ', but was ' +
                  value +
                  '.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the numeric value is null or >= maxExclusive.
     * @param value Decimal value to inspect.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isLessThan(Decimal value, Decimal maxExclusive, String paramName) {
        requireNonNullBound(maxExclusive, 'maxExclusive');
        if (value == null || value >= maxExclusive) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must be less than ' +
                    maxExclusive +
                    ', but was ' +
                    value +
                    '.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field error if the numeric field is null or > maxInclusive.
     * @param field Schema.SObjectField to inspect.
     * @param maxInclusive Inclusive upper bound.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isLessThanOrEqualTo(Schema.SObjectField field, Decimal maxInclusive) {
        return isLessThanOrEqualTo(field, maxInclusive, null);
    }

    /**
     * @description Attaches a field error with a custom message if the numeric field is null or > maxInclusive.
     * @param field Schema.SObjectField to inspect.
     * @param maxInclusive Inclusive upper bound.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isLessThanOrEqualTo(
        Schema.SObjectField field,
        Decimal maxInclusive,
        String customMessage
    ) {
        requireNonNullBound(maxInclusive, 'maxInclusive');
        Decimal value = toDecimal(readFieldValue(field));
        if (value == null || value > maxInclusive) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' +
                  fieldName(field) +
                  '\' must be less than or equal to ' +
                  maxInclusive +
                  ', but was ' +
                  value +
                  '.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the numeric value is null or > maxInclusive.
     * @param value Decimal value to inspect.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isLessThanOrEqualTo(Decimal value, Decimal maxInclusive, String paramName) {
        requireNonNullBound(maxInclusive, 'maxInclusive');
        if (value == null || value > maxInclusive) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must be less than or equal to ' +
                    maxInclusive +
                    ', but was ' +
                    value +
                    '.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field error if the numeric field is null or outside [minInclusive, maxInclusive].
     * @param field Schema.SObjectField to inspect.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isInRange(
        Schema.SObjectField field,
        Decimal minInclusive,
        Decimal maxInclusive
    ) {
        return isInRange(field, minInclusive, maxInclusive, null);
    }

    /**
     * @description Attaches a field error with a custom message if the numeric field is outside [minInclusive, maxInclusive].
     * @param field Schema.SObjectField to inspect.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isInRange(
        Schema.SObjectField field,
        Decimal minInclusive,
        Decimal maxInclusive,
        String customMessage
    ) {
        requireValidRange(minInclusive, maxInclusive);
        Decimal value = toDecimal(readFieldValue(field));
        if (value == null || value < minInclusive || value > maxInclusive) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' +
                  fieldName(field) +
                  '\' must be between ' +
                  minInclusive +
                  ' and ' +
                  maxInclusive +
                  ' (inclusive), but was ' +
                  value +
                  '.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the numeric value is outside [minInclusive, maxInclusive].
     * @param value Decimal value to inspect.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isInRange(
        Decimal value,
        Decimal minInclusive,
        Decimal maxInclusive,
        String paramName
    ) {
        requireValidRange(minInclusive, maxInclusive);
        if (value == null || value < minInclusive || value > maxInclusive) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must be between ' +
                    minInclusive +
                    ' and ' +
                    maxInclusive +
                    ' (inclusive), but was ' +
                    value +
                    '.'
            );
        }
        return this;
    }

    /**
     * @description Attaches a field error if the numeric field is null or equal to zero.
     * @param field Schema.SObjectField to inspect.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotZero(Schema.SObjectField field) {
        return isNotZero(field, null);
    }

    /**
     * @description Attaches a field error with a custom message if the numeric field is null or equal to zero.
     * @param field Schema.SObjectField to inspect.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotZero(Schema.SObjectField field, String customMessage) {
        Decimal value = toDecimal(readFieldValue(field));
        if (value == null || value == 0) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' + fieldName(field) + '\' must not be null or zero.';
            addFieldError(field, message);
        }
        return this;
    }

    /**
     * @description Attaches a record-level error if the numeric value is null or equal to zero.
     * @param value Decimal value to inspect.
     * @param paramName Parameter label included in the error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord isNotZero(Decimal value, String paramName) {
        if (value == null || value == 0) {
            addRecordError(
                'Parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must not be null or zero.'
            );
        }
        return this;
    }

    // =========================================================================
    // Salesforce-Native
    // =========================================================================

    /**
     * @description Attaches a field error if the field is not set in memory or holds null.
     * @param field Schema.SObjectField to inspect.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord hasPopulatedField(Schema.SObjectField field) {
        return hasPopulatedField(field, null);
    }

    /**
     * @description Attaches a field error with a custom message if the field is unset or null.
     * @param field Schema.SObjectField to inspect.
     * @param customMessage Optional override error message.
     * @return This GuardRecord instance for fluent chaining.
     */
    public GuardRecord hasPopulatedField(Schema.SObjectField field, String customMessage) {
        requireField(field);
        if (!this.record.isSet(field) || this.record.get(field) == null) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Field \'' + fieldName(field) + '\' must be populated and non-null.';
            addFieldError(field, message);
        }
        return this;
    }

    // =========================================================================
    // Inspection
    // =========================================================================

    /**
     * @description Indicates whether any validation error has been attached to the underlying SObject.
     * @return True if one or more field or record errors exist.
     */
    public Boolean hasErrors() {
        return !this.errorMessages.isEmpty() || this.record.hasErrors();
    }

    /**
     * @description Indicates whether all guard checks passed with no attached errors.
     * @return True when zero errors are present.
     */
    public Boolean isValid() {
        return !hasErrors();
    }

    /**
     * @description Returns the list of error messages attached via this GuardRecord instance.
     * @return Copy of accumulated error message strings.
     */
    public List<String> getErrorMessages() {
        return new List<String>(this.errorMessages);
    }

    /**
     * @description Returns the underlying SObject record.
     * @return Validated SObject instance.
     */
    public SObject getRecord() {
        return this.record;
    }

    // =========================================================================
    // Internal Helpers
    // =========================================================================

    private void addFieldError(Schema.SObjectField field, String message) {
        requireField(field);
        this.record.addError(field, message);
        this.errorMessages.add(message);
    }

    private void addRecordError(String message) {
        this.record.addError(message);
        this.errorMessages.add(message);
    }

    private Object readFieldValue(Schema.SObjectField field) {
        requireField(field);
        return this.record.isSet(field) ? this.record.get(field) : null;
    }

    private String readStringValue(Schema.SObjectField field) {
        Object rawValue = readFieldValue(field);
        return rawValue == null ? null : String.valueOf(rawValue);
    }

    private static String fieldName(Schema.SObjectField field) {
        return field.getDescribe().getName();
    }

    private static void requireField(Schema.SObjectField field) {
        if (field == null) {
            GuardContext.fail(
                'Schema.SObjectField argument \'field\' must not be null.',
                'field',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                null
            );
        }
    }

    private static void requireNonNegativeLength(Integer lengthVal, String argName) {
        if (lengthVal == null || lengthVal < 0) {
            GuardContext.fail(
                'Argument \'' + argName + '\' must be zero or greater.',
                argName,
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                lengthVal
            );
        }
    }

    private static void requireNonEmptyPattern(String regexPattern) {
        if (String.isEmpty(regexPattern)) {
            GuardContext.fail(
                'Regex pattern must not be null or empty.',
                'regexPattern',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                regexPattern
            );
        }
    }

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

    private static void requireValidRange(Decimal minInclusive, Decimal maxInclusive) {
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
    }

    private static Decimal toDecimal(Object rawValue) {
        if (rawValue == null) {
            return null;
        }
        if (rawValue instanceof Decimal) {
            return (Decimal) rawValue;
        }
        if (rawValue instanceof Integer) {
            return Decimal.valueOf((Integer) rawValue);
        }
        if (rawValue instanceof Long) {
            return Decimal.valueOf((Long) rawValue);
        }
        if (rawValue instanceof Double) {
            return Decimal.valueOf((Double) rawValue);
        }
        return Decimal.valueOf(String.valueOf(rawValue));
    }
}
