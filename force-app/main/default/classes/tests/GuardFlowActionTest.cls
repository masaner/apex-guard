/**
 * @description Unit tests for GuardFlowAction invocable validation in Flows and Agentforce,
 *              covering bulk evaluation, throwOnFailure fault-path propagation, and
 *              non-throwing Decision-routing outputs.
 * @group Tests
 */
@IsTest
private class GuardFlowActionTest {
    @IsTest
    private static void testBulkValidRequestsPass() {
        GuardFlowAction.Request notNullReq = new GuardFlowAction.Request();
        notNullReq.rule = 'IS_NOT_NULL';
        notNullReq.paramName = 'accountRecord';
        notNullReq.recordValue = new Account(Name = 'Acme');

        GuardFlowAction.Request notBlankReq = new GuardFlowAction.Request();
        notBlankReq.rule = 'IS_NOT_BLANK';
        notBlankReq.paramName = 'subject';
        notBlankReq.stringValue = 'Follow up';

        GuardFlowAction.Request rangeReq = new GuardFlowAction.Request();
        rangeReq.rule = 'IS_IN_RANGE';
        rangeReq.paramName = 'discount';
        rangeReq.numericValue = 15;
        rangeReq.minValue = 0;
        rangeReq.maxValue = 50;

        GuardFlowAction.Request idTypeReq = new GuardFlowAction.Request();
        idTypeReq.rule = 'IS_ID_OF_TYPE';
        idTypeReq.paramName = 'accountId';
        idTypeReq.stringValue = '001000000000001AAA';
        idTypeReq.comparisonValue = 'Account';

        GuardFlowAction.Request sobjReq = new GuardFlowAction.Request();
        sobjReq.rule = 'IS_SOBJECT_TYPE';
        sobjReq.paramName = 'record';
        sobjReq.recordValue = new Account(Name = 'Acme');
        sobjReq.comparisonValue = 'Account';

        GuardFlowAction.Request regexReq = new GuardFlowAction.Request();
        regexReq.rule = 'MATCHES_REGEX';
        regexReq.paramName = 'postalCode';
        regexReq.stringValue = '94105';
        regexReq.comparisonValue = '^\\d{5}$';

        List<GuardFlowAction.Result> results = GuardFlowAction.validate(
            new List<GuardFlowAction.Request>{
                notNullReq,
                notBlankReq,
                rangeReq,
                idTypeReq,
                sobjReq,
                regexReq
            }
        );

        Assert.areEqual(6, results.size());
        for (GuardFlowAction.Result res : results) {
            Assert.isTrue(res.isValid, 'Expected valid result for ' + res.paramName);
            Assert.isNull(res.errorMessage);
            Assert.isNull(res.errorCode);
        }
    }

    @IsTest
    private static void testThrowOnFailureDefaultsToTrueForFlowFaultPaths() {
        GuardFlowAction.Request failingReq = new GuardFlowAction.Request();
        failingReq.rule = 'IS_GREATER_THAN';
        failingReq.paramName = 'opportunityAmount';
        failingReq.numericValue = -10;
        failingReq.minValue = 0;
        // throwOnFailure intentionally omitted (null -> defaults to true)

        try {
            GuardFlowAction.validate(new List<GuardFlowAction.Request>{ failingReq });
            Assert.fail('Expected GuardException when throwOnFailure defaults to true.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_GREATER_THAN, ex.getErrorCode());
            Assert.areEqual('opportunityAmount', ex.getParamName());
        }
    }

    @IsTest
    private static void testNonThrowingDecisionModeReturnsStructuredOutputs() {
        GuardFlowAction.Request validReq = new GuardFlowAction.Request();
        validReq.rule = 'IS_VALID_ID';
        validReq.paramName = 'contactId';
        validReq.stringValue = '003000000000001AAA';
        validReq.throwOnFailure = false;

        GuardFlowAction.Request invalidBlank = new GuardFlowAction.Request();
        invalidBlank.rule = 'IS_NOT_BLANK';
        invalidBlank.paramName = 'caseSubject';
        invalidBlank.stringValue = '   ';
        invalidBlank.throwOnFailure = false;

        GuardFlowAction.Request invalidLength = new GuardFlowAction.Request();
        invalidLength.rule = 'HAS_MAX_LENGTH';
        invalidLength.paramName = 'code';
        invalidLength.stringValue = 'TOOLONG';
        invalidLength.integerValue = 3;
        invalidLength.throwOnFailure = false;

        GuardFlowAction.Request invalidZero = new GuardFlowAction.Request();
        invalidZero.rule = 'IS_NOT_ZERO';
        invalidZero.paramName = 'quantity';
        invalidZero.numericValue = 0;
        invalidZero.customMessage = 'Quantity cannot be zero in Flow.';
        invalidZero.throwOnFailure = false;

        GuardFlowAction.Request unknownRule = new GuardFlowAction.Request();
        unknownRule.rule = 'NON_EXISTENT_RULE';
        unknownRule.paramName = 'badRule';
        unknownRule.throwOnFailure = false;

        List<GuardFlowAction.Result> results = GuardFlowAction.validate(
            new List<GuardFlowAction.Request>{
                validReq,
                invalidBlank,
                invalidLength,
                invalidZero,
                unknownRule
            }
        );

        Assert.areEqual(5, results.size());

        Assert.isTrue(results[0].isValid);

        Assert.isFalse(results[1].isValid);
        Assert.areEqual(GuardException.ERR_BLANK_STRING, results[1].errorCode);
        Assert.areEqual('caseSubject', results[1].paramName);
        Assert.isTrue(results[1].errorMessage.contains('caseSubject'));

        Assert.isFalse(results[2].isValid);
        Assert.areEqual(GuardException.ERR_MAX_LENGTH, results[2].errorCode);

        Assert.isFalse(results[3].isValid);
        Assert.areEqual(GuardException.ERR_ZERO_VALUE, results[3].errorCode);
        Assert.areEqual('Quantity cannot be zero in Flow.', results[3].errorMessage);

        Assert.isFalse(results[4].isValid);
        Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, results[4].errorCode);
    }

    @IsTest
    private static void testEmptyAndNullRequestLists() {
        Assert.areEqual(0, GuardFlowAction.validate(null).size());
        Assert.areEqual(0, GuardFlowAction.validate(new List<GuardFlowAction.Request>()).size());
    }

    @IsTest
    private static void testRemainingFlowRules() {
        List<GuardFlowAction.Request> reqs = new List<GuardFlowAction.Request>();

        GuardFlowAction.Request nullReq = new GuardFlowAction.Request();
        nullReq.rule = 'IS_NULL';
        nullReq.paramName = 'clearedField';
        reqs.add(nullReq);

        GuardFlowAction.Request trueReq = new GuardFlowAction.Request();
        trueReq.rule = 'IS_TRUE';
        trueReq.paramName = 'isActive';
        trueReq.booleanValue = true;
        reqs.add(trueReq);

        GuardFlowAction.Request falseReq = new GuardFlowAction.Request();
        falseReq.rule = 'IS_FALSE';
        falseReq.paramName = 'isBlocked';
        falseReq.booleanValue = false;
        reqs.add(falseReq);

        GuardFlowAction.Request notEmptyReq = new GuardFlowAction.Request();
        notEmptyReq.rule = 'IS_NOT_EMPTY';
        notEmptyReq.paramName = 'text';
        notEmptyReq.stringValue = ' ';
        reqs.add(notEmptyReq);

        GuardFlowAction.Request exactLenReq = new GuardFlowAction.Request();
        exactLenReq.rule = 'HAS_LENGTH_EQUAL_TO';
        exactLenReq.paramName = 'currencyCode';
        exactLenReq.stringValue = 'EUR';
        exactLenReq.integerValue = 3;
        reqs.add(exactLenReq);

        GuardFlowAction.Request gteReq = new GuardFlowAction.Request();
        gteReq.rule = 'IS_GREATER_THAN_OR_EQUAL_TO';
        gteReq.paramName = 'minOrder';
        gteReq.numericValue = 10;
        gteReq.comparisonValue = '10';
        reqs.add(gteReq);

        GuardFlowAction.Request ltReq = new GuardFlowAction.Request();
        ltReq.rule = 'IS_LESS_THAN';
        ltReq.paramName = 'retries';
        ltReq.numericValue = 2;
        ltReq.maxValue = 3;
        reqs.add(ltReq);

        GuardFlowAction.Request lteReq = new GuardFlowAction.Request();
        lteReq.rule = 'IS_LESS_THAN_OR_EQUAL_TO';
        lteReq.paramName = 'discount';
        lteReq.numericValue = 25;
        lteReq.maxValue = 25;
        reqs.add(lteReq);

        List<GuardFlowAction.Result> results = GuardFlowAction.validate(reqs);
        Assert.areEqual(8, results.size());
        for (GuardFlowAction.Result res : results) {
            Assert.isTrue(res.isValid, 'Expected valid for ' + res.paramName);
        }
    }
}
