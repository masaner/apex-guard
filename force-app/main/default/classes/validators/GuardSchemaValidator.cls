/**
 * @description Opt-in validator for running-user Salesforce Object (CRUD) and Field-Level Security (FLS)
 *              permissions using Schema Describe metadata without SOQL or DML overhead.
 *              Consumers should invoke these checks explicitly via the Guard facade or GuardRecord.
 * @group Validators
 */
public inherited sharing class GuardSchemaValidator {
    @TestVisible
    private static Boolean testForceDenyCrud = false;

    @TestVisible
    private static Boolean testForceDenyFls = false;

    /**
     * @description Resets all @TestVisible schema permission overrides to false.
     */
    public static void resetTestOverrides() {
        testForceDenyCrud = false;
        testForceDenyFls = false;
    }

    // =========================================================================
    // SObject CRUD Guards
    // =========================================================================

    /**
     * @description Ensures the running user has read (accessible) permission on sObjectType.
     * @param sObjectType Schema.SObjectType token to check.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isAccessible(Schema.SObjectType sObjectType) {
        return isAccessible(sObjectType, (String) null);
    }

    /**
     * @description Ensures the running user has read (accessible) permission on sObjectType with a custom message.
     * @param sObjectType Schema.SObjectType token to check.
     * @param customMessage Optional override error message.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isAccessible(
        Schema.SObjectType sObjectType,
        String customMessage
    ) {
        return enforceSObjectPermission(
            sObjectType,
            checkSObjectAccessible(sObjectType),
            'read',
            GuardException.ERR_SOBJECT_NOT_ACCESSIBLE,
            customMessage,
            null
        );
    }

    /**
     * @description Ensures the running user has read (accessible) permission on sObjectType, throwing customException.
     * @param sObjectType Schema.SObjectType token to check.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isAccessible(
        Schema.SObjectType sObjectType,
        Exception customException
    ) {
        return enforceSObjectPermission(
            sObjectType,
            checkSObjectAccessible(sObjectType),
            'read',
            GuardException.ERR_SOBJECT_NOT_ACCESSIBLE,
            null,
            customException
        );
    }

    /**
     * @description Ensures the running user has create permission on sObjectType.
     * @param sObjectType Schema.SObjectType token to check.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isCreateable(Schema.SObjectType sObjectType) {
        return isCreateable(sObjectType, (String) null);
    }

    /**
     * @description Ensures the running user has create permission on sObjectType with a custom message.
     * @param sObjectType Schema.SObjectType token to check.
     * @param customMessage Optional override error message.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isCreateable(
        Schema.SObjectType sObjectType,
        String customMessage
    ) {
        return enforceSObjectPermission(
            sObjectType,
            checkSObjectCreateable(sObjectType),
            'create',
            GuardException.ERR_SOBJECT_NOT_CREATEABLE,
            customMessage,
            null
        );
    }

    /**
     * @description Ensures the running user has create permission on sObjectType, throwing customException.
     * @param sObjectType Schema.SObjectType token to check.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isCreateable(
        Schema.SObjectType sObjectType,
        Exception customException
    ) {
        return enforceSObjectPermission(
            sObjectType,
            checkSObjectCreateable(sObjectType),
            'create',
            GuardException.ERR_SOBJECT_NOT_CREATEABLE,
            null,
            customException
        );
    }

    /**
     * @description Ensures the running user has update permission on sObjectType.
     * @param sObjectType Schema.SObjectType token to check.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isUpdateable(Schema.SObjectType sObjectType) {
        return isUpdateable(sObjectType, (String) null);
    }

    /**
     * @description Ensures the running user has update permission on sObjectType with a custom message.
     * @param sObjectType Schema.SObjectType token to check.
     * @param customMessage Optional override error message.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isUpdateable(
        Schema.SObjectType sObjectType,
        String customMessage
    ) {
        return enforceSObjectPermission(
            sObjectType,
            checkSObjectUpdateable(sObjectType),
            'update',
            GuardException.ERR_SOBJECT_NOT_UPDATEABLE,
            customMessage,
            null
        );
    }

    /**
     * @description Ensures the running user has update permission on sObjectType, throwing customException.
     * @param sObjectType Schema.SObjectType token to check.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isUpdateable(
        Schema.SObjectType sObjectType,
        Exception customException
    ) {
        return enforceSObjectPermission(
            sObjectType,
            checkSObjectUpdateable(sObjectType),
            'update',
            GuardException.ERR_SOBJECT_NOT_UPDATEABLE,
            null,
            customException
        );
    }

    /**
     * @description Ensures the running user has delete permission on sObjectType.
     * @param sObjectType Schema.SObjectType token to check.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isDeletable(Schema.SObjectType sObjectType) {
        return isDeletable(sObjectType, (String) null);
    }

    /**
     * @description Ensures the running user has delete permission on sObjectType with a custom message.
     * @param sObjectType Schema.SObjectType token to check.
     * @param customMessage Optional override error message.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isDeletable(
        Schema.SObjectType sObjectType,
        String customMessage
    ) {
        return enforceSObjectPermission(
            sObjectType,
            checkSObjectDeletable(sObjectType),
            'delete',
            GuardException.ERR_SOBJECT_NOT_DELETABLE,
            customMessage,
            null
        );
    }

    /**
     * @description Ensures the running user has delete permission on sObjectType, throwing customException.
     * @param sObjectType Schema.SObjectType token to check.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Schema.SObjectType token.
     */
    public static Schema.SObjectType isDeletable(
        Schema.SObjectType sObjectType,
        Exception customException
    ) {
        return enforceSObjectPermission(
            sObjectType,
            checkSObjectDeletable(sObjectType),
            'delete',
            GuardException.ERR_SOBJECT_NOT_DELETABLE,
            null,
            customException
        );
    }

    // =========================================================================
    // Field-Level Security (FLS) Guards
    // =========================================================================

    /**
     * @description Ensures the running user has read (accessible) FLS permission on field.
     * @param field Schema.SObjectField token to check.
     * @return The validated Schema.SObjectField token.
     */
    public static Schema.SObjectField isFieldAccessible(Schema.SObjectField field) {
        return isFieldAccessible(field, (String) null);
    }

    /**
     * @description Ensures the running user has read (accessible) FLS permission on field with a custom message.
     * @param field Schema.SObjectField token to check.
     * @param customMessage Optional override error message.
     * @return The validated Schema.SObjectField token.
     */
    public static Schema.SObjectField isFieldAccessible(
        Schema.SObjectField field,
        String customMessage
    ) {
        return enforceFieldPermission(
            field,
            checkFieldAccessible(field),
            'read',
            GuardException.ERR_FIELD_NOT_ACCESSIBLE,
            customMessage,
            null
        );
    }

    /**
     * @description Ensures the running user has read (accessible) FLS permission on field, throwing customException.
     * @param field Schema.SObjectField token to check.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Schema.SObjectField token.
     */
    public static Schema.SObjectField isFieldAccessible(
        Schema.SObjectField field,
        Exception customException
    ) {
        return enforceFieldPermission(
            field,
            checkFieldAccessible(field),
            'read',
            GuardException.ERR_FIELD_NOT_ACCESSIBLE,
            null,
            customException
        );
    }

    /**
     * @description Ensures the running user has create FLS permission on field.
     * @param field Schema.SObjectField token to check.
     * @return The validated Schema.SObjectField token.
     */
    public static Schema.SObjectField isFieldCreateable(Schema.SObjectField field) {
        return isFieldCreateable(field, (String) null);
    }

    /**
     * @description Ensures the running user has create FLS permission on field with a custom message.
     * @param field Schema.SObjectField token to check.
     * @param customMessage Optional override error message.
     * @return The validated Schema.SObjectField token.
     */
    public static Schema.SObjectField isFieldCreateable(
        Schema.SObjectField field,
        String customMessage
    ) {
        return enforceFieldPermission(
            field,
            checkFieldCreateable(field),
            'create',
            GuardException.ERR_FIELD_NOT_CREATEABLE,
            customMessage,
            null
        );
    }

    /**
     * @description Ensures the running user has create FLS permission on field, throwing customException.
     * @param field Schema.SObjectField token to check.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Schema.SObjectField token.
     */
    public static Schema.SObjectField isFieldCreateable(
        Schema.SObjectField field,
        Exception customException
    ) {
        return enforceFieldPermission(
            field,
            checkFieldCreateable(field),
            'create',
            GuardException.ERR_FIELD_NOT_CREATEABLE,
            null,
            customException
        );
    }

    /**
     * @description Ensures the running user has update FLS permission on field.
     * @param field Schema.SObjectField token to check.
     * @return The validated Schema.SObjectField token.
     */
    public static Schema.SObjectField isFieldUpdateable(Schema.SObjectField field) {
        return isFieldUpdateable(field, (String) null);
    }

    /**
     * @description Ensures the running user has update FLS permission on field with a custom message.
     * @param field Schema.SObjectField token to check.
     * @param customMessage Optional override error message.
     * @return The validated Schema.SObjectField token.
     */
    public static Schema.SObjectField isFieldUpdateable(
        Schema.SObjectField field,
        String customMessage
    ) {
        return enforceFieldPermission(
            field,
            checkFieldUpdateable(field),
            'update',
            GuardException.ERR_FIELD_NOT_UPDATEABLE,
            customMessage,
            null
        );
    }

    /**
     * @description Ensures the running user has update FLS permission on field, throwing customException.
     * @param field Schema.SObjectField token to check.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Schema.SObjectField token.
     */
    public static Schema.SObjectField isFieldUpdateable(
        Schema.SObjectField field,
        Exception customException
    ) {
        return enforceFieldPermission(
            field,
            checkFieldUpdateable(field),
            'update',
            GuardException.ERR_FIELD_NOT_UPDATEABLE,
            null,
            customException
        );
    }

    // =========================================================================
    // Helper Predicates
    // =========================================================================

    /**
     * @description Evaluates whether the running user can read the specified SObjectType.
     * @param sObjectType Schema.SObjectType token to inspect.
     * @return True when non-null and accessible (and not overridden in tests).
     */
    public static Boolean checkSObjectAccessible(Schema.SObjectType sObjectType) {
        if (sObjectType == null || testForceDenyCrud) {
            return false;
        }
        return sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isAccessible();
    }

    /**
     * @description Evaluates whether the running user can create the specified SObjectType.
     * @param sObjectType Schema.SObjectType token to inspect.
     * @return True when non-null and createable (and not overridden in tests).
     */
    public static Boolean checkSObjectCreateable(Schema.SObjectType sObjectType) {
        if (sObjectType == null || testForceDenyCrud) {
            return false;
        }
        return sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isCreateable();
    }

    /**
     * @description Evaluates whether the running user can update the specified SObjectType.
     * @param sObjectType Schema.SObjectType token to inspect.
     * @return True when non-null and updateable (and not overridden in tests).
     */
    public static Boolean checkSObjectUpdateable(Schema.SObjectType sObjectType) {
        if (sObjectType == null || testForceDenyCrud) {
            return false;
        }
        return sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isUpdateable();
    }

    /**
     * @description Evaluates whether the running user can delete the specified SObjectType.
     * @param sObjectType Schema.SObjectType token to inspect.
     * @return True when non-null and deletable (and not overridden in tests).
     */
    public static Boolean checkSObjectDeletable(Schema.SObjectType sObjectType) {
        if (sObjectType == null || testForceDenyCrud) {
            return false;
        }
        return sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isDeletable();
    }

    /**
     * @description Evaluates whether the running user has read FLS permission on field.
     * @param field Schema.SObjectField token to inspect.
     * @return True when non-null and accessible (and not overridden in tests).
     */
    public static Boolean checkFieldAccessible(Schema.SObjectField field) {
        if (field == null || testForceDenyFls) {
            return false;
        }
        return field.getDescribe().isAccessible();
    }

    /**
     * @description Evaluates whether the running user has create FLS permission on field.
     * @param field Schema.SObjectField token to inspect.
     * @return True when non-null and createable (and not overridden in tests).
     */
    public static Boolean checkFieldCreateable(Schema.SObjectField field) {
        if (field == null || testForceDenyFls) {
            return false;
        }
        return field.getDescribe().isCreateable();
    }

    /**
     * @description Evaluates whether the running user has update FLS permission on field.
     * @param field Schema.SObjectField token to inspect.
     * @return True when non-null and updateable (and not overridden in tests).
     */
    public static Boolean checkFieldUpdateable(Schema.SObjectField field) {
        if (field == null || testForceDenyFls) {
            return false;
        }
        return field.getDescribe().isUpdateable();
    }

    // =========================================================================
    // Internal Helpers
    // =========================================================================

    private static Schema.SObjectType enforceSObjectPermission(
        Schema.SObjectType sObjectType,
        Boolean hasPermission,
        String accessLabel,
        String errorCode,
        String customMessage,
        Exception customException
    ) {
        requireSObjectType(sObjectType);
        if (!hasPermission) {
            String objectName = sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).getName();
            if (customException != null) {
                GuardContext.failWithCustomException(
                    customException,
                    objectName,
                    errorCode,
                    objectName
                );
            }
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Running user does not have ' +
                  accessLabel +
                  ' access to SObject \'' +
                  objectName +
                  '\'.';
            GuardContext.fail(message, objectName, errorCode, objectName);
        }
        return sObjectType;
    }

    private static Schema.SObjectField enforceFieldPermission(
        Schema.SObjectField field,
        Boolean hasPermission,
        String accessLabel,
        String errorCode,
        String customMessage,
        Exception customException
    ) {
        requireField(field);
        if (!hasPermission) {
            String fieldName = field.getDescribe().getName();
            if (customException != null) {
                GuardContext.failWithCustomException(
                    customException,
                    fieldName,
                    errorCode,
                    fieldName
                );
            }
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Running user does not have ' +
                  accessLabel +
                  ' access to field \'' +
                  fieldName +
                  '\'.';
            GuardContext.fail(message, fieldName, errorCode, fieldName);
        }
        return field;
    }

    private static void requireSObjectType(Schema.SObjectType sObjectType) {
        if (sObjectType == null) {
            GuardContext.fail(
                'Schema.SObjectType argument \'sObjectType\' must not be null.',
                'sObjectType',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                null
            );
        }
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
}
