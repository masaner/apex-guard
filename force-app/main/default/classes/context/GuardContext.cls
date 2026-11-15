/**
 * @description Resolves the active Salesforce execution runtime (Quiddity and Trigger context)
 *              and routes validation failures through global failure handlers, AuraHandledException
 *              for LWC/Aura controllers, custom exceptions, or structured GuardException instances.
 * @group Context
 */
public inherited sharing class GuardContext {
    private static IGuardFailureHandler failureHandler;
    private static Boolean forceLwcMode = false;
    private static Boolean autoDetectAuraQuiddity = true;

    @TestVisible
    private static System.Quiddity testQuiddityOverride;
    @TestVisible
    private static Boolean testTriggerExecutingOverride;

    /**
     * @description Immutable diagnostic payload passed to IGuardFailureHandler implementations
     *              when a guard precondition fails.
     */
    public class Failure {
        /** @description Human-readable validation failure description. */
        public String message { get; private set; }
        /** @description Name of the parameter or field that failed validation. */
        public String paramName { get; private set; }
        /** @description Machine-readable GuardException error code constant. */
        public String errorCode { get; private set; }
        /** @description Offending runtime value supplied to the guard clause. */
        public Object actualValue { get; private set; }
        /** @description Detected Salesforce System.Quiddity for the request. */
        public System.Quiddity quiddity { get; private set; }
        /** @description True when executing inside an Apex Trigger context. */
        public Boolean isTriggerExecuting { get; private set; }
        /** @description Resolved execution context name (TRIGGER, AURA, REST, etc.). */
        public String executionContext { get; private set; }
        /** @description Optional caller-supplied Exception override. */
        public Exception customException { get; private set; }

        /**
         * @description Constructs a Failure payload capturing runtime metadata.
         * @param message Failure message.
         * @param paramName Parameter or field name.
         * @param errorCode Standardized GuardException error code.
         * @param actualValue Offending runtime value.
         * @param quiddity Current request Quiddity.
         * @param isTriggerExecuting Whether Trigger context is active.
         * @param executionContext Resolved execution context string.
         * @param customException Optional explicit Exception instance.
         */
        public Failure(
            String message,
            String paramName,
            String errorCode,
            Object actualValue,
            System.Quiddity quiddity,
            Boolean isTriggerExecuting,
            String executionContext,
            Exception customException
        ) {
            this.message = message;
            this.paramName = paramName;
            this.errorCode = errorCode;
            this.actualValue = actualValue;
            this.quiddity = quiddity;
            this.isTriggerExecuting = isTriggerExecuting;
            this.executionContext = executionContext;
            this.customException = customException;
        }

        /**
         * @description Materializes a structured GuardException from this Failure payload.
         * @return Populated GuardException ready to throw or log.
         */
        public GuardException toGuardException() {
            return GuardException.create(
                this.message,
                this.paramName,
                this.errorCode,
                this.actualValue,
                this.quiddity,
                this.executionContext
            );
        }
    }

    /**
     * @description Fluent scope returned by Guard.forLwc() enabling single-call or multi-call
     *              AuraHandledException propagation with proper setMessage() initialization.
     */
    public class LwcScope {
        private final Boolean previousForceLwcMode;

        /**
         * @description Creates an LwcScope capturing the prior LWC mode flag.
         * @param previousForceLwcMode Prior value of GuardContext.forceLwcMode.
         */
        public LwcScope(Boolean previousForceLwcMode) {
            this.previousForceLwcMode = previousForceLwcMode;
        }

        /**
         * @description Ensures value is non-null, throwing AuraHandledException on failure.
         * @param value Object reference to validate.
         * @param paramName Parameter name included in error message.
         * @return Validated non-null Object.
         * @throws AuraHandledException when value is null.
         */
        public Object isNotNull(Object value, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardObjectValidator.isNotNull(value, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures value is null, throwing AuraHandledException on failure.
         * @param value Object reference to validate.
         * @param paramName Parameter name included in error message.
         * @return Always returns null when validation succeeds.
         * @throws AuraHandledException when value is non-null.
         */
        public Object isNull(Object value, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardObjectValidator.isNull(value, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures condition is true, throwing AuraHandledException on failure.
         * @param condition Boolean condition to evaluate.
         * @param message Error message displayed to LWC clients.
         * @return Boolean true when validation succeeds.
         * @throws AuraHandledException when condition is false or null.
         */
        public Boolean isTrue(Boolean condition, String message) {
            GuardContext.setLwcMode(true);
            try {
                return GuardObjectValidator.isTrue(condition, message);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures condition is false, throwing AuraHandledException on failure.
         * @param condition Boolean condition to evaluate.
         * @param message Error message displayed to LWC clients.
         * @return Boolean false when validation succeeds.
         * @throws AuraHandledException when condition is true or null.
         */
        public Boolean isFalse(Boolean condition, String message) {
            GuardContext.setLwcMode(true);
            try {
                return GuardObjectValidator.isFalse(condition, message);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures string is non-null and non-empty, throwing AuraHandledException on failure.
         * @param value String value to validate.
         * @param paramName Parameter name included in error message.
         * @return Validated non-empty String.
         * @throws AuraHandledException when value is null or empty.
         */
        public String isNotEmpty(String value, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardStringValidator.isNotEmpty(value, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures string is not null, empty, or whitespace-only, throwing AuraHandledException on failure.
         * @param value String value to validate.
         * @param paramName Parameter name included in error message.
         * @return Validated non-blank String.
         * @throws AuraHandledException when value is blank.
         */
        public String isNotBlank(String value, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardStringValidator.isNotBlank(value, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures string has an exact length, throwing AuraHandledException on failure.
         * @param value String value to validate.
         * @param expectedLength Exact required character length.
         * @param paramName Parameter name included in error message.
         * @return Validated String.
         * @throws AuraHandledException when value is null or length differs.
         */
        public String hasLengthEqualTo(String value, Integer expectedLength, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardStringValidator.hasLengthEqualTo(value, expectedLength, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures string does not exceed maxLength, throwing AuraHandledException on failure.
         * @param value String value to validate.
         * @param maxLength Maximum allowed character length.
         * @param paramName Parameter name included in error message.
         * @return Validated String.
         * @throws AuraHandledException when value is null or exceeds maxLength.
         */
        public String hasMaxLength(String value, Integer maxLength, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardStringValidator.hasMaxLength(value, maxLength, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures string matches regexPattern, throwing AuraHandledException on failure.
         * @param value String value to validate.
         * @param regexPattern Apex regex pattern.
         * @param paramName Parameter name included in error message.
         * @return Validated String.
         * @throws AuraHandledException when value is null or does not match regexPattern.
         */
        public String matchesRegex(String value, String regexPattern, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardStringValidator.matchesRegex(value, regexPattern, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures Decimal value exceeds minExclusive, throwing AuraHandledException on failure.
         * @param value Decimal value to validate.
         * @param minExclusive Exclusive lower bound.
         * @param paramName Parameter name included in error message.
         * @return Validated Decimal value.
         * @throws AuraHandledException when value is null or <= minExclusive.
         */
        public Decimal isGreaterThan(Decimal value, Decimal minExclusive, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardNumericValidator.isGreaterThan(value, minExclusive, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures Integer value exceeds minExclusive, throwing AuraHandledException on failure.
         * @param value Integer value to validate.
         * @param minExclusive Exclusive lower bound.
         * @param paramName Parameter name included in error message.
         * @return Validated Integer value.
         * @throws AuraHandledException when value is null or <= minExclusive.
         */
        public Integer isGreaterThan(Integer value, Integer minExclusive, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardNumericValidator.isGreaterThan(value, minExclusive, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures Decimal value is >= minInclusive, throwing AuraHandledException on failure.
         * @param value Decimal value to validate.
         * @param minInclusive Inclusive lower bound.
         * @param paramName Parameter name included in error message.
         * @return Validated Decimal value.
         * @throws AuraHandledException when value is null or < minInclusive.
         */
        public Decimal isGreaterThanOrEqualTo(
            Decimal value,
            Decimal minInclusive,
            String paramName
        ) {
            GuardContext.setLwcMode(true);
            try {
                return GuardNumericValidator.isGreaterThanOrEqualTo(value, minInclusive, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures Decimal value is < maxExclusive, throwing AuraHandledException on failure.
         * @param value Decimal value to validate.
         * @param maxExclusive Exclusive upper bound.
         * @param paramName Parameter name included in error message.
         * @return Validated Decimal value.
         * @throws AuraHandledException when value is null or >= maxExclusive.
         */
        public Decimal isLessThan(Decimal value, Decimal maxExclusive, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardNumericValidator.isLessThan(value, maxExclusive, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures Decimal value is <= maxInclusive, throwing AuraHandledException on failure.
         * @param value Decimal value to validate.
         * @param maxInclusive Inclusive upper bound.
         * @param paramName Parameter name included in error message.
         * @return Validated Decimal value.
         * @throws AuraHandledException when value is null or > maxInclusive.
         */
        public Decimal isLessThanOrEqualTo(Decimal value, Decimal maxInclusive, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardNumericValidator.isLessThanOrEqualTo(value, maxInclusive, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures Decimal value lies within [minInclusive, maxInclusive], throwing AuraHandledException on failure.
         * @param value Decimal value to validate.
         * @param minInclusive Inclusive lower bound.
         * @param maxInclusive Inclusive upper bound.
         * @param paramName Parameter name included in error message.
         * @return Validated Decimal value.
         * @throws AuraHandledException when value is null or out of range.
         */
        public Decimal isInRange(
            Decimal value,
            Decimal minInclusive,
            Decimal maxInclusive,
            String paramName
        ) {
            GuardContext.setLwcMode(true);
            try {
                return GuardNumericValidator.isInRange(
                    value,
                    minInclusive,
                    maxInclusive,
                    paramName
                );
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures Decimal value is non-null and not zero, throwing AuraHandledException on failure.
         * @param value Decimal value to validate.
         * @param paramName Parameter name included in error message.
         * @return Validated non-zero Decimal value.
         * @throws AuraHandledException when value is null or 0.
         */
        public Decimal isNotZero(Decimal value, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardNumericValidator.isNotZero(value, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures List is non-null and non-empty, throwing AuraHandledException on failure.
         * @param collection List to validate.
         * @param paramName Parameter name included in error message.
         * @return Validated List&lt;Object&gt;.
         * @throws AuraHandledException when collection is null or empty.
         */
        public List<Object> isNotEmpty(List<Object> collection, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardCollectionValidator.isNotEmpty(collection, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures Set&lt;Id&gt; is non-null and non-empty, throwing AuraHandledException on failure.
         * @param collection Set&lt;Id&gt; to validate.
         * @param paramName Parameter name included in error message.
         * @return Validated Set&lt;Id&gt;.
         * @throws AuraHandledException when collection is null or empty.
         */
        public Set<Id> isNotEmpty(Set<Id> collection, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardCollectionValidator.isNotEmpty(collection, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures Set&lt;String&gt; is non-null and non-empty, throwing AuraHandledException on failure.
         * @param collection Set&lt;String&gt; to validate.
         * @param paramName Parameter name included in error message.
         * @return Validated Set&lt;String&gt;.
         * @throws AuraHandledException when collection is null or empty.
         */
        public Set<String> isNotEmpty(Set<String> collection, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardCollectionValidator.isNotEmpty(collection, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures string is a valid 15/18-character Salesforce Id, throwing AuraHandledException on failure.
         * @param value Candidate Id string.
         * @param paramName Parameter name included in error message.
         * @return Parsed Salesforce Id.
         * @throws AuraHandledException when value is not a valid Id.
         */
        public Id isValidId(String value, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardSObjectValidator.isValidId(value, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures Salesforce Id matches expectedType, throwing AuraHandledException on failure.
         * @param recordId Salesforce Id to validate.
         * @param expectedType Expected Schema.SObjectType.
         * @param paramName Parameter name included in error message.
         * @return Validated Salesforce Id.
         * @throws AuraHandledException when recordId is null or wrong SObjectType.
         */
        public Id isIdOfType(Id recordId, Schema.SObjectType expectedType, String paramName) {
            GuardContext.setLwcMode(true);
            try {
                return GuardSObjectValidator.isIdOfType(recordId, expectedType, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures SObject matches expectedType, throwing AuraHandledException on failure.
         * @param record SObject instance to validate.
         * @param expectedType Expected Schema.SObjectType.
         * @param paramName Parameter name included in error message.
         * @return Validated SObject instance.
         * @throws AuraHandledException when record is null or wrong SObjectType.
         */
        public SObject isSObjectType(
            SObject record,
            Schema.SObjectType expectedType,
            String paramName
        ) {
            GuardContext.setLwcMode(true);
            try {
                return GuardSObjectValidator.isSObjectType(record, expectedType, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }

        /**
         * @description Ensures field is set and non-null on record, throwing AuraHandledException on failure.
         * @param record SObject instance to inspect.
         * @param field Schema.SObjectField token to verify.
         * @param paramName Parameter name included in error message.
         * @return Validated SObject instance.
         * @throws AuraHandledException when record is null, field is unset, or field value is null.
         */
        public SObject hasPopulatedField(
            SObject record,
            Schema.SObjectField field,
            String paramName
        ) {
            GuardContext.setLwcMode(true);
            try {
                return GuardSObjectValidator.hasPopulatedField(record, field, paramName);
            } finally {
                GuardContext.setLwcMode(this.previousForceLwcMode);
            }
        }
    }

    /**
     * @description Returns the current request Quiddity, honoring @TestVisible overrides during tests.
     * @return Current System.Quiddity, or null if unavailable.
     */
    public static System.Quiddity getCurrentQuiddity() {
        if (testQuiddityOverride != null) {
            return testQuiddityOverride;
        }
        System.Request currentRequest = System.Request.getCurrent();
        return currentRequest != null ? currentRequest.getQuiddity() : null;
    }

    /**
     * @description Indicates whether the current execution is inside an Apex Trigger context.
     * @return True when Trigger.isExecuting is active (or overridden in tests).
     */
    public static Boolean isTriggerContext() {
        if (testTriggerExecutingOverride != null) {
            return testTriggerExecutingOverride;
        }
        return Trigger.isExecuting == true;
    }

    /**
     * @description Resolves a concise label representing the active Salesforce execution context.
     * @return 'TRIGGER' if executing in a Trigger, otherwise the System.Quiddity name or 'UNKNOWN'.
     */
    public static String getExecutionContextName() {
        if (isTriggerContext()) {
            return 'TRIGGER';
        }
        System.Quiddity quiddity = getCurrentQuiddity();
        return quiddity != null ? String.valueOf(quiddity) : 'UNKNOWN';
    }

    /**
     * @description Determines whether validation failures should throw AuraHandledException.
     * @return True when explicit LWC mode is active or Quiddity.AURA auto-detection applies.
     */
    public static Boolean shouldThrowAuraException() {
        if (forceLwcMode) {
            return true;
        }
        return autoDetectAuraQuiddity && getCurrentQuiddity() == System.Quiddity.AURA;
    }

    /**
     * @description Enables explicit LWC mode for subsequent guard assertions and returns a fluent
     *              LwcScope for single-expression checks.
     * @return GuardContext.LwcScope instance.
     */
    public static LwcScope enableLwcMode() {
        Boolean previousMode = forceLwcMode;
        forceLwcMode = true;
        return new LwcScope(previousMode);
    }

    /**
     * @description Sets explicit LWC mode on or off for the current transaction.
     * @param enabled True to force AuraHandledException wrapping, false to disable.
     */
    public static void setLwcMode(Boolean enabled) {
        forceLwcMode = (enabled == true);
    }

    /**
     * @description Enables or disables automatic Quiddity.AURA detection.
     * @param enabled True (default) to auto-wrap failures as AuraHandledException inside @AuraEnabled calls.
     */
    public static void setAutoDetectAuraQuiddity(Boolean enabled) {
        autoDetectAuraQuiddity = (enabled != false);
    }

    /**
     * @description Registers a global failure handler for the current transaction.
     * @param handler IGuardFailureHandler implementation, or null to clear.
     */
    public static void setFailureHandler(IGuardFailureHandler handler) {
        failureHandler = handler;
    }

    /**
     * @description Returns the currently registered failure handler, if any.
     * @return Registered IGuardFailureHandler or null.
     */
    public static IGuardFailureHandler getFailureHandler() {
        return failureHandler;
    }

    /**
     * @description Resets all transaction-scoped GuardContext settings and test overrides to defaults.
     */
    public static void reset() {
        failureHandler = null;
        forceLwcMode = false;
        autoDetectAuraQuiddity = true;
        testQuiddityOverride = null;
        testTriggerExecutingOverride = null;
    }

    /**
     * @description Constructs an AuraHandledException with setMessage() explicitly invoked so both
     *              LWC client handlers and Apex unit tests receive the actual message rather than
     *              "Script-thrown exception".
     * @param message Human-readable error message to surface.
     * @return Configured AuraHandledException.
     */
    public static AuraHandledException createAuraHandledException(String message) {
        String safeMessage = String.isBlank(message) ? 'Validation failed.' : message;
        AuraHandledException auraEx = new AuraHandledException(safeMessage);
        auraEx.setMessage(safeMessage);
        return auraEx;
    }

    /**
     * @description Dispatches a standard validation failure through any registered handler and throws
     *              the appropriate context-aware exception.
     * @param message Failure message.
     * @param paramName Parameter or field name.
     * @param errorCode Standardized GuardException error code.
     * @param actualValue Offending runtime value.
     */
    public static void fail(
        String message,
        String paramName,
        String errorCode,
        Object actualValue
    ) {
        System.Quiddity quiddity = getCurrentQuiddity();
        Boolean isTrigger = isTriggerContext();
        String contextName = getExecutionContextName();
        Failure failure = new Failure(
            message,
            paramName,
            errorCode,
            actualValue,
            quiddity,
            isTrigger,
            contextName,
            null
        );
        dispatchFailure(failure);
    }

    /**
     * @description Dispatches a validation failure with an explicit caller-provided Exception instance.
     * @param customException Caller-supplied Exception to throw (falls back to GuardException if null).
     * @param paramName Parameter or field name.
     * @param errorCode Standardized GuardException error code.
     * @param actualValue Offending runtime value.
     */
    public static void failWithCustomException(
        Exception customException,
        String paramName,
        String errorCode,
        Object actualValue
    ) {
        if (customException == null) {
            fail('Validation failed.', paramName, errorCode, actualValue);
        }
        System.Quiddity quiddity = getCurrentQuiddity();
        Boolean isTrigger = isTriggerContext();
        String contextName = getExecutionContextName();
        Failure failure = new Failure(
            customException.getMessage(),
            paramName,
            errorCode,
            actualValue,
            quiddity,
            isTrigger,
            contextName,
            customException
        );
        dispatchFailure(failure);
    }

    private static void dispatchFailure(Failure failure) {
        if (failureHandler != null) {
            failureHandler.handleFailure(failure);
        }
        if (failure.customException != null) {
            throw failure.customException;
        }
        if (shouldThrowAuraException()) {
            throw createAuraHandledException(failure.message);
        }
        throw failure.toGuardException();
    }
}
