/**
 * @description Declarative Flow and Agentforce Invocable Action exposing ApexGuard precondition
 *              checks. Supports fail-fast Fault-path execution (throwOnFailure = true, default)
 *              or non-throwing Decision-routing outputs (throwOnFailure = false).
 * @group Invocable
 */
public inherited sharing class GuardFlowAction {
    /**
     * @description Input payload for a single Flow or Agentforce guard evaluation.
     */
    public class Request {
        @InvocableVariable(
            label='Rule'
            description='Guard rule name: IS_NOT_NULL, IS_NULL, IS_TRUE, IS_FALSE, IS_NOT_EMPTY, IS_NOT_BLANK, HAS_LENGTH_EQUAL_TO, HAS_MAX_LENGTH, MATCHES_REGEX, IS_GREATER_THAN, IS_GREATER_THAN_OR_EQUAL_TO, IS_LESS_THAN, IS_LESS_THAN_OR_EQUAL_TO, IS_IN_RANGE, IS_NOT_ZERO, IS_VALID_ID, IS_ID_OF_TYPE, or IS_SOBJECT_TYPE.'
            required=true
        )
        public String rule;

        @InvocableVariable(
            label='Parameter Name'
            description='Logical parameter or field name included in error messages and diagnostics.'
            required=false
        )
        public String paramName;

        @InvocableVariable(
            label='String Value'
            description='String or Salesforce Id text input.'
            required=false
        )
        public String stringValue;

        @InvocableVariable(
            label='Numeric Value'
            description='Decimal or Integer value for numeric comparisons and range checks.'
            required=false
        )
        public Decimal numericValue;

        @InvocableVariable(
            label='Boolean Value'
            description='Boolean value for IS_TRUE, IS_FALSE, and nullability checks.'
            required=false
        )
        public Boolean booleanValue;

        @InvocableVariable(
            label='Record Value'
            description='SObject record input for IS_NOT_NULL, IS_NULL, and IS_SOBJECT_TYPE.'
            required=false
        )
        public SObject recordValue;

        @InvocableVariable(
            label='Comparison Value'
            description='Regex pattern, SObject API name (e.g., Account), or string-encoded numeric/length bound.'
            required=false
        )
        public String comparisonValue;

        @InvocableVariable(
            label='Numeric Bound / Min'
            description='Threshold for single-bound numeric guards or inclusive lower bound for IS_IN_RANGE.'
            required=false
        )
        public Decimal minValue;

        @InvocableVariable(
            label='Numeric Max (Range)'
            description='Inclusive upper bound for IS_IN_RANGE (also accepted as fallback for IS_LESS_THAN / IS_LESS_THAN_OR_EQUAL_TO).'
            required=false
        )
        public Decimal maxValue;

        @InvocableVariable(
            label='Integer Bound / Length'
            description='Expected or maximum length for HAS_LENGTH_EQUAL_TO and HAS_MAX_LENGTH.'
            required=false
        )
        public Integer integerValue;

        @InvocableVariable(
            label='Custom Error Message'
            description='Optional override error message.'
            required=false
        )
        public String customMessage;

        @InvocableVariable(
            label='Throw On Failure'
            description='Defaults to true (throws GuardException to trigger Flow Fault path). Set to false to return isValid=false and error details for Flow Decision branching.'
            required=false
        )
        public Boolean throwOnFailure;
    }

    /**
     * @description Output payload returned for each evaluated Request.
     */
    public class Result {
        @InvocableVariable(
            label='Is Valid'
            description='True when the guard precondition succeeded; false when throwOnFailure is false and validation failed.'
        )
        public Boolean isValid;

        @InvocableVariable(
            label='Error Message'
            description='Validation failure message when isValid is false.'
        )
        public String errorMessage;

        @InvocableVariable(
            label='Error Code'
            description='Standardized GuardException error code when isValid is false.'
        )
        public String errorCode;

        @InvocableVariable(
            label='Parameter Name'
            description='Parameter name associated with the check.'
        )
        public String paramName;

        @InvocableVariable(
            label='Execution Context'
            description='Resolved Salesforce execution context label.'
        )
        public String executionContext;
    }

    /**
     * @description Evaluates a bulk list of ApexGuard rules for Flow or Agentforce invocations.
     * @param requests List of GuardFlowAction.Request items to evaluate in order.
     * @return List of GuardFlowAction.Result items matching the input list size and order.
     * @throws GuardException when validation fails and throwOnFailure is true (or omitted).
     */
    @InvocableMethod(
        label='Validate Input (ApexGuard)'
        description='Executes a fail-fast or decision-routed guard clause in Flows and Agentforce actions.'
        category='ApexGuard'
    )
    public static List<Result> validate(List<Request> requests) {
        List<Result> results = new List<Result>();
        if (requests == null || requests.isEmpty()) {
            return results;
        }

        for (Request req : requests) {
            results.add(evaluateSingle(req));
        }
        return results;
    }

    private static Result evaluateSingle(Request req) {
        Result res = new Result();
        res.isValid = true;
        res.paramName = req != null ? req.paramName : null;
        res.executionContext = GuardContext.getExecutionContextName();

        Boolean shouldThrow = req == null || req.throwOnFailure != false;
        try {
            if (req == null) {
                GuardObjectValidator.isNotNull(null, 'request');
            }
            executeRule(req);
        } catch (GuardException ex) {
            if (shouldThrow) {
                throw ex;
            }
            res.isValid = false;
            res.errorMessage = ex.getMessage();
            res.errorCode = ex.getErrorCode();
            res.paramName = ex.getParamName() != null ? ex.getParamName() : req.paramName;
            if (ex.getExecutionContext() != null) {
                res.executionContext = ex.getExecutionContext();
            }
        } catch (AuraHandledException auraEx) {
            if (shouldThrow) {
                throw auraEx;
            }
            res.isValid = false;
            res.errorMessage = auraEx.getMessage();
            res.errorCode = 'AURA_HANDLED_EXCEPTION';
        }
        return res;
    }

    private static void executeRule(Request req) {
        String ruleName = req.rule != null ? req.rule.trim().toUpperCase() : '';
        String paramLabel = GuardObjectValidator.safeParamName(req.paramName);

        if (ruleName == 'IS_NOT_NULL') {
            GuardObjectValidator.isNotNull(resolveAnyValue(req), paramLabel, req.customMessage);
        } else if (ruleName == 'IS_NULL') {
            GuardObjectValidator.isNull(resolveAnyValue(req), paramLabel, req.customMessage);
        } else if (ruleName == 'IS_TRUE') {
            String msg = String.isNotBlank(req.customMessage)
                ? req.customMessage
                : (String.isNotBlank(req.paramName)
                      ? 'Parameter \'' + req.paramName + '\' must be true.'
                      : 'Condition must evaluate to true.');
            GuardObjectValidator.isTrue(req.booleanValue, msg);
        } else if (ruleName == 'IS_FALSE') {
            String msg = String.isNotBlank(req.customMessage)
                ? req.customMessage
                : (String.isNotBlank(req.paramName)
                      ? 'Parameter \'' + req.paramName + '\' must be false.'
                      : 'Condition must evaluate to false.');
            GuardObjectValidator.isFalse(req.booleanValue, msg);
        } else if (ruleName == 'IS_NOT_EMPTY') {
            GuardStringValidator.isNotEmpty(req.stringValue, paramLabel, req.customMessage);
        } else if (ruleName == 'IS_NOT_BLANK') {
            GuardStringValidator.isNotBlank(req.stringValue, paramLabel, req.customMessage);
        } else if (ruleName == 'HAS_LENGTH_EQUAL_TO') {
            GuardStringValidator.hasLengthEqualTo(
                req.stringValue,
                resolveIntegerBound(req),
                paramLabel,
                req.customMessage
            );
        } else if (ruleName == 'HAS_MAX_LENGTH') {
            GuardStringValidator.hasMaxLength(
                req.stringValue,
                resolveIntegerBound(req),
                paramLabel,
                req.customMessage
            );
        } else if (ruleName == 'MATCHES_REGEX') {
            GuardStringValidator.matchesRegex(
                req.stringValue,
                req.comparisonValue,
                paramLabel,
                req.customMessage
            );
        } else if (ruleName == 'IS_GREATER_THAN') {
            GuardNumericValidator.isGreaterThan(
                req.numericValue,
                resolveDecimalBound(req, false),
                paramLabel,
                req.customMessage
            );
        } else if (ruleName == 'IS_GREATER_THAN_OR_EQUAL_TO') {
            GuardNumericValidator.isGreaterThanOrEqualTo(
                req.numericValue,
                resolveDecimalBound(req, false),
                paramLabel,
                req.customMessage
            );
        } else if (ruleName == 'IS_LESS_THAN') {
            GuardNumericValidator.isLessThan(
                req.numericValue,
                resolveDecimalBound(req, true),
                paramLabel,
                req.customMessage
            );
        } else if (ruleName == 'IS_LESS_THAN_OR_EQUAL_TO') {
            GuardNumericValidator.isLessThanOrEqualTo(
                req.numericValue,
                resolveDecimalBound(req, true),
                paramLabel,
                req.customMessage
            );
        } else if (ruleName == 'IS_IN_RANGE') {
            GuardNumericValidator.isInRange(
                req.numericValue,
                req.minValue,
                req.maxValue,
                paramLabel,
                req.customMessage
            );
        } else if (ruleName == 'IS_NOT_ZERO') {
            GuardNumericValidator.isNotZero(req.numericValue, paramLabel, req.customMessage);
        } else if (ruleName == 'IS_VALID_ID') {
            GuardSObjectValidator.isValidId(req.stringValue, paramLabel, req.customMessage);
        } else if (ruleName == 'IS_ID_OF_TYPE') {
            Id parsedId = GuardSObjectValidator.isValidId(
                req.stringValue,
                paramLabel,
                req.customMessage
            );
            Schema.SObjectType expectedType = resolveSObjectType(req.comparisonValue);
            GuardSObjectValidator.isIdOfType(parsedId, expectedType, paramLabel, req.customMessage);
        } else if (ruleName == 'IS_SOBJECT_TYPE') {
            Schema.SObjectType expectedType = resolveSObjectType(req.comparisonValue);
            GuardSObjectValidator.isSObjectType(
                req.recordValue,
                expectedType,
                paramLabel,
                req.customMessage
            );
        } else {
            GuardContext.fail(
                'Unsupported GuardFlowAction rule \'' + req.rule + '\'.',
                'rule',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                req.rule
            );
        }
    }

    private static Object resolveAnyValue(Request req) {
        if (req.recordValue != null) {
            return req.recordValue;
        }
        if (req.stringValue != null) {
            return req.stringValue;
        }
        if (req.numericValue != null) {
            return req.numericValue;
        }
        if (req.booleanValue != null) {
            return req.booleanValue;
        }
        return null;
    }

    private static Integer resolveIntegerBound(Request req) {
        if (req.integerValue != null) {
            return req.integerValue;
        }
        if (req.minValue != null) {
            return req.minValue.intValue();
        }
        if (String.isNotBlank(req.comparisonValue)) {
            try {
                return Integer.valueOf(req.comparisonValue.trim());
            } catch (Exception ex) {
                return null;
            }
        }
        return null;
    }

    private static Decimal resolveDecimalBound(Request req, Boolean allowMaxFallback) {
        if (req.minValue != null) {
            return req.minValue;
        }
        if (allowMaxFallback && req.maxValue != null) {
            return req.maxValue;
        }
        if (req.integerValue != null) {
            return Decimal.valueOf(req.integerValue);
        }
        if (String.isNotBlank(req.comparisonValue)) {
            try {
                return Decimal.valueOf(req.comparisonValue.trim());
            } catch (Exception ex) {
                return null;
            }
        }
        return null;
    }

    private static Schema.SObjectType resolveSObjectType(String apiName) {
        if (String.isBlank(apiName)) {
            return null;
        }
        try {
            List<Schema.DescribeSObjectResult> described = Schema.describeSObjects(
                new List<String>{ apiName.trim() },
                SObjectDescribeOptions.DEFERRED
            );
            return described.isEmpty() ? null : described[0].getSObjectType();
        } catch (Exception ex) {
            return null;
        }
    }
}
