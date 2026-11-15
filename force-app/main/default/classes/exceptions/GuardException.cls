/**
 * @description Structured exception thrown by ApexGuard when a precondition fails in standard Apex,
 *              REST, Async Apex, or Flow contexts. Carries parameter, error-code, and runtime
 *              Quiddity metadata for observability frameworks and API error serializers.
 * @group Exceptions
 */
public inherited sharing class GuardException extends Exception {
    public static final String ERR_NULL_VALUE = 'GUARD_NULL_VALUE';
    public static final String ERR_NOT_NULL_VALUE = 'GUARD_NOT_NULL_VALUE';
    public static final String ERR_TRUE_EXPECTED = 'GUARD_TRUE_EXPECTED';
    public static final String ERR_FALSE_EXPECTED = 'GUARD_FALSE_EXPECTED';
    public static final String ERR_EMPTY_STRING = 'GUARD_EMPTY_STRING';
    public static final String ERR_BLANK_STRING = 'GUARD_BLANK_STRING';
    public static final String ERR_STRING_LENGTH = 'GUARD_STRING_LENGTH';
    public static final String ERR_MAX_LENGTH = 'GUARD_MAX_LENGTH';
    public static final String ERR_REGEX_MISMATCH = 'GUARD_REGEX_MISMATCH';
    public static final String ERR_GREATER_THAN = 'GUARD_GREATER_THAN';
    public static final String ERR_GREATER_OR_EQUAL = 'GUARD_GREATER_OR_EQUAL';
    public static final String ERR_LESS_THAN = 'GUARD_LESS_THAN';
    public static final String ERR_LESS_OR_EQUAL = 'GUARD_LESS_OR_EQUAL';
    public static final String ERR_OUT_OF_RANGE = 'GUARD_OUT_OF_RANGE';
    public static final String ERR_ZERO_VALUE = 'GUARD_ZERO_VALUE';
    public static final String ERR_EMPTY_COLLECTION = 'GUARD_EMPTY_COLLECTION';
    public static final String ERR_COLLECTION_SIZE = 'GUARD_COLLECTION_SIZE';
    public static final String ERR_MISSING_KEY = 'GUARD_MISSING_KEY';
    public static final String ERR_INVALID_ID = 'GUARD_INVALID_ID';
    public static final String ERR_ID_SOBJECT_TYPE = 'GUARD_ID_SOBJECT_TYPE';
    public static final String ERR_SOBJECT_TYPE = 'GUARD_SOBJECT_TYPE';
    public static final String ERR_UNPOPULATED_FIELD = 'GUARD_UNPOPULATED_FIELD';
    public static final String ERR_INVALID_GUARD_ARGUMENT = 'GUARD_INVALID_ARGUMENT';

    private String paramName;
    private String errorCode;
    private Object actualValue;
    private System.Quiddity quiddity;
    private String executionContext;

    /**
     * @description Factory method creating a fully populated GuardException instance.
     * @param message Human-readable validation failure description.
     * @param paramName Name of the parameter or field that failed validation.
     * @param errorCode Standardized ApexGuard error code constant.
     * @param actualValue Offending runtime value that caused the guard failure.
     * @param quiddity Salesforce runtime Quiddity detected when the failure occurred.
     * @param executionContext Resolved execution context label (e.g., TRIGGER, AURA, REST).
     * @return GuardException instance populated with diagnostic metadata.
     */
    public static GuardException create(
        String message,
        String paramName,
        String errorCode,
        Object actualValue,
        System.Quiddity quiddity,
        String executionContext
    ) {
        GuardException ex = new GuardException(message);
        ex.paramName = paramName;
        ex.errorCode = errorCode;
        ex.actualValue = actualValue;
        ex.quiddity = quiddity;
        ex.executionContext = executionContext;
        return ex;
    }

    /**
     * @description Returns the parameter or field name associated with this guard failure.
     * @return The validated parameter name, or null if not applicable.
     */
    public String getParamName() {
        return this.paramName;
    }

    /**
     * @description Returns the machine-readable error code categorizing the guard failure.
     * @return Standardized error code string (e.g., GUARD_NULL_VALUE).
     */
    public String getErrorCode() {
        return this.errorCode;
    }

    /**
     * @description Returns the offending value passed to the guard clause.
     * @return The actual runtime value that failed validation.
     */
    public Object getActualValue() {
        return this.actualValue;
    }

    /**
     * @description Returns the System.Quiddity of the request where the failure occurred.
     * @return The captured System.Quiddity enum value, or null if unavailable.
     */
    public System.Quiddity getQuiddity() {
        return this.quiddity;
    }

    /**
     * @description Returns the resolved execution context label (such as TRIGGER, AURA, REST, or SYNCHRONOUS).
     * @return Execution context string suitable for logging and API error responses.
     */
    public String getExecutionContext() {
        return this.executionContext;
    }

    /**
     * @description Serializes exception metadata into a JSON-friendly Map for REST error payloads,
     *              Async TransactionFinalizer logs, or logging frameworks such as Nebula Logger.
     * @return Map containing message, paramName, errorCode, actualValue, quiddity, and executionContext.
     */
    public Map<String, Object> toMap() {
        return new Map<String, Object>{
            'message' => this.getMessage(),
            'paramName' => this.paramName,
            'errorCode' => this.errorCode,
            'actualValue' => this.actualValue,
            'quiddity' => this.quiddity != null ? String.valueOf(this.quiddity) : null,
            'executionContext' => this.executionContext
        };
    }
}
