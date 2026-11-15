/**
 * @description Internal validator module for Salesforce-native types: Id parsing/checksums,
 *              Schema.SObjectType matching, and SObject in-memory field population checks.
 *              Consumers should invoke these checks via the Guard facade.
 * @group Validators
 */
public inherited sharing class GuardSObjectValidator {
    /**
     * @description Validates that a string is a properly formatted 15- or 18-character Salesforce Id.
     * @param value Candidate Id string.
     * @param paramName Parameter name included in failure diagnostics.
     * @return Parsed Salesforce Id.
     */
    public static Id isValidId(String value, String paramName) {
        return isValidId(value, paramName, null);
    }

    /**
     * @description Validates that a string is a properly formatted 15- or 18-character Salesforce Id
     *              with an optional custom error message.
     * @param value Candidate Id string.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return Parsed Salesforce Id.
     */
    public static Id isValidId(String value, String paramName, String customMessage) {
        Id parsedId = tryParseId(value);
        if (parsedId == null) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must be a valid 15- or 18-character Salesforce Id, but was \'' +
                  value +
                  '\'.';
            GuardContext.fail(message, paramName, GuardException.ERR_INVALID_ID, value);
        }
        return parsedId;
    }

    /**
     * @description Validates that a string is a valid Salesforce Id, throwing a custom exception on failure.
     * @param value Candidate Id string.
     * @param customException Custom Exception instance to throw on failure.
     * @return Parsed Salesforce Id.
     */
    public static Id isValidId(String value, Exception customException) {
        Id parsedId = tryParseId(value);
        if (parsedId == null) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_INVALID_ID,
                value
            );
        }
        return parsedId;
    }

    /**
     * @description Validates that a Salesforce Id is non-null and belongs to the expected SObjectType.
     * @param recordId Record Id to validate.
     * @param expectedType Expected Schema.SObjectType token (e.g., Account.SObjectType).
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Salesforce Id.
     */
    public static Id isIdOfType(Id recordId, Schema.SObjectType expectedType, String paramName) {
        return isIdOfType(recordId, expectedType, paramName, null);
    }

    /**
     * @description Validates that a Salesforce Id belongs to the expected SObjectType with a custom message.
     * @param recordId Record Id to validate.
     * @param expectedType Expected Schema.SObjectType token.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Salesforce Id.
     */
    public static Id isIdOfType(
        Id recordId,
        Schema.SObjectType expectedType,
        String paramName,
        String customMessage
    ) {
        requireExpectedType(expectedType);
        if (recordId == null) {
            String nullMsg = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must not be null.';
            GuardContext.fail(nullMsg, paramName, GuardException.ERR_NULL_VALUE, null);
        }
        Schema.SObjectType actualType = recordId.getSObjectType();
        if (actualType != expectedType) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must be an Id for SObject type \'' +
                  expectedType.getDescribe().getName() +
                  '\', but was \'' +
                  (actualType != null ? actualType.getDescribe().getName() : 'unknown') +
                  '\'.';
            GuardContext.fail(message, paramName, GuardException.ERR_ID_SOBJECT_TYPE, recordId);
        }
        return recordId;
    }

    /**
     * @description Validates that a Salesforce Id belongs to the expected SObjectType, throwing a custom exception.
     * @param recordId Record Id to validate.
     * @param expectedType Expected Schema.SObjectType token.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Salesforce Id.
     */
    public static Id isIdOfType(
        Id recordId,
        Schema.SObjectType expectedType,
        Exception customException
    ) {
        if (expectedType == null || recordId == null || recordId.getSObjectType() != expectedType) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_ID_SOBJECT_TYPE,
                recordId
            );
        }
        return recordId;
    }

    /**
     * @description Validates that an SObject instance is non-null and matches the expected SObjectType.
     * @param record SObject instance to validate.
     * @param expectedType Expected Schema.SObjectType token.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated SObject instance.
     */
    public static SObject isSObjectType(
        SObject record,
        Schema.SObjectType expectedType,
        String paramName
    ) {
        return isSObjectType(record, expectedType, paramName, null);
    }

    /**
     * @description Validates that an SObject instance matches the expected SObjectType with a custom message.
     * @param record SObject instance to validate.
     * @param expectedType Expected Schema.SObjectType token.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated SObject instance.
     */
    public static SObject isSObjectType(
        SObject record,
        Schema.SObjectType expectedType,
        String paramName,
        String customMessage
    ) {
        requireExpectedType(expectedType);
        if (record == null) {
            String nullMsg = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must not be null.';
            GuardContext.fail(nullMsg, paramName, GuardException.ERR_NULL_VALUE, null);
        }
        Schema.SObjectType actualType = record.getSObjectType();
        if (actualType != expectedType) {
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must be an SObject of type \'' +
                  expectedType.getDescribe().getName() +
                  '\', but was \'' +
                  (actualType != null ? actualType.getDescribe().getName() : 'unknown') +
                  '\'.';
            GuardContext.fail(message, paramName, GuardException.ERR_SOBJECT_TYPE, record);
        }
        return record;
    }

    /**
     * @description Validates that an SObject instance matches the expected SObjectType, throwing a custom exception.
     * @param record SObject instance to validate.
     * @param expectedType Expected Schema.SObjectType token.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated SObject instance.
     */
    public static SObject isSObjectType(
        SObject record,
        Schema.SObjectType expectedType,
        Exception customException
    ) {
        if (expectedType == null || record == null || record.getSObjectType() != expectedType) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_SOBJECT_TYPE,
                record
            );
        }
        return record;
    }

    /**
     * @description Ensures a field is both set in memory on the SObject (preventing SObjectException on
     *              unqueried fields) and holds a non-null value.
     * @param record SObject instance to inspect.
     * @param field Schema.SObjectField token to verify.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated SObject instance.
     */
    public static SObject hasPopulatedField(
        SObject record,
        Schema.SObjectField field,
        String paramName
    ) {
        return hasPopulatedField(record, field, paramName, null);
    }

    /**
     * @description Ensures a field is set in memory and non-null on the SObject, with an optional custom message.
     * @param record SObject instance to inspect.
     * @param field Schema.SObjectField token to verify.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated SObject instance.
     */
    public static SObject hasPopulatedField(
        SObject record,
        Schema.SObjectField field,
        String paramName,
        String customMessage
    ) {
        if (field == null) {
            GuardContext.fail(
                'Schema.SObjectField argument \'field\' must not be null.',
                'field',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                null
            );
        }
        if (record == null) {
            String nullMsg = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must not be null.';
            GuardContext.fail(nullMsg, paramName, GuardException.ERR_NULL_VALUE, null);
        }
        if (!record.isSet(field) || record.get(field) == null) {
            String fieldName = field.getDescribe().getName();
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must have field \'' +
                  fieldName +
                  '\' populated and non-null.';
            GuardContext.fail(message, paramName, GuardException.ERR_UNPOPULATED_FIELD, record);
        }
        return record;
    }

    /**
     * @description Ensures a field is set in memory and non-null on the SObject, throwing a custom exception.
     * @param record SObject instance to inspect.
     * @param field Schema.SObjectField token to verify.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated SObject instance.
     */
    public static SObject hasPopulatedField(
        SObject record,
        Schema.SObjectField field,
        Exception customException
    ) {
        if (field == null || record == null || !record.isSet(field) || record.get(field) == null) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_UNPOPULATED_FIELD,
                record
            );
        }
        return record;
    }

    // =========================================================================
    // Helpers
    // =========================================================================

    private static Id tryParseId(String value) {
        if (String.isBlank(value) || (value.length() != 15 && value.length() != 18)) {
            return null;
        }
        try {
            return Id.valueOf(value);
        } catch (Exception ex) {
            return null;
        }
    }

    private static void requireExpectedType(Schema.SObjectType expectedType) {
        if (expectedType == null) {
            GuardContext.fail(
                'Expected Schema.SObjectType argument must not be null.',
                'expectedType',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                null
            );
        }
    }
}
