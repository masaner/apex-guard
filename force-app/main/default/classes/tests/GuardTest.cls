/**
 * @description Comprehensive unit tests for all Guard facade methods, pass-through return values,
 *              numeric/collection covariance overloads, Salesforce-native Id/SObject checks,
 *              and custom message/Exception overrides.
 * @group Tests
 */
@IsTest
private class GuardTest {
    private class CustomDomainException extends Exception {
    }

    // =========================================================================
    // 1. General / Nullability
    // =========================================================================

    @IsTest
    private static void testIsNotNullAndIsNull() {
        Account acc = new Account(Name = 'Acme');
        Object returned = Guard.isNotNull(acc, 'acc');
        Assert.areEqual(acc, returned, 'isNotNull should return the validated instance.');

        Assert.isNull(Guard.isNull(null, 'optionalArg'), 'isNull should return null.');

        try {
            Guard.isNotNull(null, 'customerId');
            Assert.fail('Expected GuardException for null value.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
            Assert.areEqual('customerId', ex.getParamName());
            Assert.isTrue(ex.getMessage().contains('customerId'));
        }

        try {
            Guard.isNotNull(null, 'customerId', 'Custom null message');
            Assert.fail('Expected GuardException with custom message.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom null message', ex.getMessage());
        }

        try {
            Guard.isNotNull(null, new CustomDomainException('Domain null error'));
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Domain null error', ex.getMessage());
        }

        try {
            Guard.isNull('unexpected', 'cleanupField');
            Assert.fail('Expected GuardException for non-null value.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_NOT_NULL_VALUE, ex.getErrorCode());
            Assert.areEqual('cleanupField', ex.getParamName());
        }

        try {
            Guard.isNull('unexpected', new CustomDomainException('Must be null'));
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Must be null', ex.getMessage());
        }
    }

    // =========================================================================
    // 2. Boolean / State Assertions
    // =========================================================================

    @IsTest
    private static void testIsTrueAndIsFalse() {
        Assert.isTrue(Guard.isTrue(true, 'Should be true.'));
        Assert.isFalse(Guard.isFalse(false, 'Should be false.'));

        for (Boolean invalidTrue : new List<Boolean>{ false, null }) {
            try {
                Guard.isTrue(invalidTrue, 'Account must be active.');
                Assert.fail('Expected GuardException for isTrue.');
            } catch (GuardException ex) {
                Assert.areEqual(GuardException.ERR_TRUE_EXPECTED, ex.getErrorCode());
                Assert.areEqual('Account must be active.', ex.getMessage());
            }
        }

        for (Boolean invalidFalse : new List<Boolean>{ true, null }) {
            try {
                Guard.isFalse(invalidFalse, 'Record must not be locked.');
                Assert.fail('Expected GuardException for isFalse.');
            } catch (GuardException ex) {
                Assert.areEqual(GuardException.ERR_FALSE_EXPECTED, ex.getErrorCode());
                Assert.areEqual('Record must not be locked.', ex.getMessage());
            }
        }

        try {
            Guard.isTrue(false, new CustomDomainException('Custom state error'));
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom state error', ex.getMessage());
        }

        try {
            Guard.isFalse(true, new CustomDomainException('Custom false error'));
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom false error', ex.getMessage());
        }
    }

    // =========================================================================
    // 3. Strings
    // =========================================================================

    @IsTest
    private static void testStringGuards() {
        Assert.areEqual(' ', Guard.isNotEmpty(' ', 'spaced'));
        Assert.areEqual('ApexGuard', Guard.isNotBlank('ApexGuard', 'libName'));
        Assert.areEqual('USD', Guard.hasLengthEqualTo('USD', 3, 'currencyCode'));
        Assert.areEqual('abc', Guard.hasMaxLength('abc', 3, 'shortCode'));
        Assert.areEqual('INV-1042', Guard.matchesRegex('INV-1042', '^INV-\\d{4}$', 'inv'));

        try {
            Guard.isNotEmpty('', 'emptyStr');
            Assert.fail('Expected GuardException for empty string.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_EMPTY_STRING, ex.getErrorCode());
        }

        try {
            Guard.isNotBlank('   \t\n ', 'blankStr');
            Assert.fail('Expected GuardException for whitespace-only string.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_BLANK_STRING, ex.getErrorCode());
        }

        try {
            Guard.hasLengthEqualTo('US', 3, 'currencyCode');
            Assert.fail('Expected GuardException for wrong length.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_STRING_LENGTH, ex.getErrorCode());
        }

        try {
            Guard.hasLengthEqualTo((String) null, 3, 'currencyCode');
            Assert.fail('Expected GuardException for null length check.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_STRING_LENGTH, ex.getErrorCode());
        }

        try {
            Guard.hasMaxLength('abcd', 3, 'shortCode');
            Assert.fail('Expected GuardException for exceeding max length.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_MAX_LENGTH, ex.getErrorCode());
        }

        try {
            Guard.hasMaxLength('abc', -1, 'shortCode');
            Assert.fail('Expected GuardException for negative maxLength.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }

        try {
            Guard.matchesRegex('BAD-CODE', '^INV-\\d{4}$', 'inv');
            Assert.fail('Expected GuardException for regex mismatch.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_REGEX_MISMATCH, ex.getErrorCode());
        }

        try {
            Guard.isNotBlank(null, new CustomDomainException('Custom blank error'));
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom blank error', ex.getMessage());
        }
    }

    // =========================================================================
    // 4. Numeric
    // =========================================================================

    @IsTest
    private static void testNumericGuards() {
        Assert.areEqual(10.5, Guard.isGreaterThan(10.5, 0, 'amount'));
        Assert.areEqual(5, Guard.isGreaterThan(5, 4, 'count'));
        Assert.areEqual(100L, Guard.isGreaterThan(100L, 99L, 'bigCount'));

        Double doubleVal = 12.25;
        Assert.areEqual(12.25, Guard.isGreaterThan(doubleVal, 10.0, 'doubleAmount'));

        Assert.areEqual(0, Guard.isGreaterThanOrEqualTo(0, 0, 'offset'));
        Assert.areEqual(10.0, Guard.isGreaterThanOrEqualTo(10.0, 10.0, 'minAmt'));
        Assert.areEqual(4, Guard.isLessThan(4, 5, 'retries'));
        Assert.areEqual(5.0, Guard.isLessThanOrEqualTo(5.0, 5.0, 'discountPct'));
        Assert.areEqual(50, Guard.isInRange(50, 0, 100, 'score'));
        Assert.areEqual(0, Guard.isInRange(0, 0, 100, 'scoreMin'));
        Assert.areEqual(100, Guard.isInRange(100, 0, 100, 'scoreMax'));
        Assert.areEqual(-2.5, Guard.isNotZero(-2.5, 'delta'));
        Assert.areEqual(1, Guard.isNotZero(1, 'divisor'));

        try {
            Guard.isGreaterThan(-5, 0, 'amount');
            Assert.fail('Expected GuardException for amount <= 0.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_GREATER_THAN, ex.getErrorCode());
            Assert.areEqual('amount', ex.getParamName());
            Assert.isTrue(ex.getMessage().contains('-5'));
        }

        try {
            Guard.isGreaterThan((Decimal) null, 0, 'amount');
            Assert.fail('Expected GuardException for null numeric.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
        }

        try {
            Guard.isGreaterThanOrEqualTo(9, 10, 'qty');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_GREATER_OR_EQUAL, ex.getErrorCode());
        }

        try {
            Guard.isLessThan(10, 10, 'limit');
            Assert.fail('Expected GuardException for boundary equality.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_LESS_THAN, ex.getErrorCode());
        }

        try {
            Guard.isLessThanOrEqualTo(11, 10, 'limit');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_LESS_OR_EQUAL, ex.getErrorCode());
        }

        try {
            Guard.isInRange(101, 0, 100, 'percentage');
            Assert.fail('Expected GuardException for out of range.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_OUT_OF_RANGE, ex.getErrorCode());
        }

        try {
            Guard.isInRange(5, 10, 1, 'inverted');
            Assert.fail('Expected GuardException for inverted range.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }

        try {
            Guard.isNotZero(0, 'divisor');
            Assert.fail('Expected GuardException for zero divisor.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_ZERO_VALUE, ex.getErrorCode());
        }

        try {
            Guard.isNotZero(0.0, new CustomDomainException('Zero not permitted'));
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Zero not permitted', ex.getMessage());
        }
    }

    // =========================================================================
    // 5. Collections (List, Set, Map Covariance Overloads)
    // =========================================================================

    @IsTest
    private static void testCollectionGuards() {
        Id accId = Id.valueOf('001000000000001AAA');

        List<Account> accounts = new List<Account>{ new Account(Name = 'Test') };
        Assert.areEqual(1, Guard.isNotEmpty(accounts, 'accounts').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(accounts, 1, 'accounts').size());

        Set<Id> accountIds = new Set<Id>{ accId };
        Assert.areEqual(1, Guard.isNotEmpty(accountIds, 'accountIds').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(accountIds, 1, 'accountIds').size());

        Set<String> codes = new Set<String>{ 'A', 'B' };
        Assert.areEqual(2, Guard.isNotEmpty(codes, 'codes').size());
        Assert.areEqual(2, Guard.hasSizeEqualTo(codes, 2, 'codes').size());

        Set<Integer> nums = new Set<Integer>{ 1 };
        Assert.areEqual(1, Guard.isNotEmpty(nums, 'nums').size());

        Map<Id, Account> accMap = new Map<Id, Account>{ accId => accounts[0] };
        Assert.areEqual(1, Guard.isNotEmpty(accMap, 'accMap').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(accMap, 1, 'accMap').size());
        Assert.isTrue(Guard.containsKey(accMap, accId, 'accMap').containsKey(accId));

        Map<String, Object> payload = new Map<String, Object>{ 'status' => 'OK' };
        Assert.areEqual(1, Guard.isNotEmpty(payload, 'payload').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(payload, 1, 'payload').size());
        Assert.isTrue(Guard.containsKey(payload, 'status', 'payload').containsKey('status'));

        Map<String, Account> accByKey = new Map<String, Account>{ 'main' => accounts[0] };
        Assert.areEqual(1, Guard.isNotEmpty(accByKey, 'accByKey').size());
        Assert.isTrue(Guard.containsKey(accByKey, 'main', 'accByKey').containsKey('main'));

        Map<String, String> headers = new Map<String, String>{
            'Content-Type' => 'application/json'
        };
        Assert.areEqual(1, Guard.isNotEmpty(headers, 'headers').size());
        Assert.isTrue(
            Guard.containsKey(headers, 'Content-Type', 'headers').containsKey('Content-Type')
        );

        try {
            Guard.isNotEmpty(new Set<Id>(), 'emptyIds');
            Assert.fail('Expected GuardException for empty Set<Id>.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_EMPTY_COLLECTION, ex.getErrorCode());
            Assert.areEqual('emptyIds', ex.getParamName());
        }

        try {
            Guard.isNotEmpty((List<Account>) null, 'nullList');
            Assert.fail('Expected GuardException for null List.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_EMPTY_COLLECTION, ex.getErrorCode());
        }

        try {
            Guard.hasSizeEqualTo(new List<String>{ 'onlyOne' }, 2, 'pair');
            Assert.fail('Expected GuardException for size mismatch.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_COLLECTION_SIZE, ex.getErrorCode());
        }

        try {
            Guard.containsKey(payload, 'missingKey', 'payload');
            Assert.fail('Expected GuardException for missing key.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_MISSING_KEY, ex.getErrorCode());
        }

        try {
            Guard.containsKey(headers, 'Authorization', new CustomDomainException('Missing auth'));
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Missing auth', ex.getMessage());
        }
    }

    // =========================================================================
    // 6. Salesforce-Native (Id, SObject, Schema)
    // =========================================================================

    @IsTest
    private static void testSalesforceNativeGuards() {
        Id accId18 = Guard.isValidId('001000000000001AAA', 'accountId');
        Assert.areEqual(Id.valueOf('001000000000001AAA'), accId18);

        Id accIdFrom15 = Guard.isValidId('001000000000001', 'accountId15');
        Assert.areEqual(Account.SObjectType, accIdFrom15.getSObjectType());

        Assert.areEqual(accId18, Guard.isIdOfType(accId18, Account.SObjectType, 'accountId'));

        Account acc = new Account(Name = 'Global Corp');
        SObject validatedSObj = Guard.isSObjectType(acc, Account.SObjectType, 'record');
        Assert.areEqual(acc, validatedSObj);

        Guard.hasPopulatedField(acc, Account.Name, 'acc');

        for (String badId : new List<String>{ null, '', '   ', 'invalid-id', '0010000000000012' }) {
            try {
                Guard.isValidId(badId, 'recordId');
                Assert.fail('Expected GuardException for invalid Id: ' + badId);
            } catch (GuardException ex) {
                Assert.areEqual(GuardException.ERR_INVALID_ID, ex.getErrorCode());
            }
        }

        Id contactId = Id.valueOf('003000000000001AAA');
        try {
            Guard.isIdOfType(contactId, Account.SObjectType, 'targetId');
            Assert.fail('Expected GuardException for wrong SObjectType Id.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_ID_SOBJECT_TYPE, ex.getErrorCode());
        }

        try {
            Guard.isSObjectType(new Contact(LastName = 'Doe'), Account.SObjectType, 'record');
            Assert.fail('Expected GuardException for wrong SObjectType record.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_SOBJECT_TYPE, ex.getErrorCode());
        }

        try {
            Guard.hasPopulatedField(new Account(), Account.Name, 'acc');
            Assert.fail('Expected GuardException for unset field.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_UNPOPULATED_FIELD, ex.getErrorCode());
        }

        try {
            Guard.hasPopulatedField(new Account(Name = null), Account.Name, 'acc');
            Assert.fail('Expected GuardException for null field value.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_UNPOPULATED_FIELD, ex.getErrorCode());
        }

        try {
            Guard.isValidId('bad', new CustomDomainException('Bad Id custom'));
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Bad Id custom', ex.getMessage());
        }
    }

    @IsTest
    private static void testAllOverloadsCustomMessagesAndCustomExceptions() {
        CustomDomainException customEx = new CustomDomainException('Custom domain failure');
        Id accId = Id.valueOf('001000000000001AAA');
        Id conId = Id.valueOf('003000000000001AAA');
        Account acc = new Account(Name = 'Acme');

        // 1. General / Nullability & Boolean
        Assert.areEqual(acc, Guard.isNotNull(acc, 'acc', 'Must not be null'));
        Assert.areEqual(acc, Guard.isNotNull(acc, customEx));
        Assert.isNull(Guard.isNull(null, 'opt', 'Must be null'));
        Assert.isNull(Guard.isNull(null, customEx));
        Assert.isTrue(Guard.isTrue(true, customEx));
        Assert.isFalse(Guard.isFalse(false, customEx));
        assertThrowsGuardWithMessage('Custom isNull', new GuardRunnerIsNullFail());

        // 2. String customMessage and customException overloads (pass + fail)
        Assert.areEqual('ok', Guard.isNotEmpty('ok', 's', 'Custom empty'));
        Assert.areEqual('ok', Guard.isNotEmpty('ok', customEx));
        Assert.areEqual('ok', Guard.isNotBlank('ok', 's', 'Custom blank'));
        Assert.areEqual('ok', Guard.isNotBlank('ok', customEx));
        Assert.areEqual('ok', Guard.hasLengthEqualTo('ok', 2, 's', 'Custom len'));
        Assert.areEqual('ok', Guard.hasLengthEqualTo('ok', 2, customEx));
        Assert.areEqual('ok', Guard.hasMaxLength('ok', 2, 's', 'Custom max'));
        Assert.areEqual('ok', Guard.hasMaxLength('ok', 2, customEx));
        Assert.areEqual('ok', Guard.matchesRegex('ok', '^[a-z]+$', 's', 'Custom regex'));
        Assert.areEqual('ok', Guard.matchesRegex('ok', '^[a-z]+$', customEx));

        assertCustomMessageThrows(GuardException.ERR_EMPTY_STRING, 'Custom empty');
        try {
            Guard.isNotEmpty('', customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotBlank(' ', 's', 'Custom blank');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom blank', ex.getMessage());
        }
        try {
            Guard.hasLengthEqualTo('a', 2, 's', 'Custom len');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom len', ex.getMessage());
        }
        try {
            Guard.hasLengthEqualTo('a', 2, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasLengthEqualTo('a', -1, 's');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }
        try {
            Guard.hasMaxLength('abcd', 2, 's', 'Custom max');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom max', ex.getMessage());
        }
        try {
            Guard.hasMaxLength('abcd', 2, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.matchesRegex('123', '^[a-z]+$', 's', 'Custom regex');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom regex', ex.getMessage());
        }
        try {
            Guard.matchesRegex('123', '^[a-z]+$', customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.matchesRegex('123', '', 's');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }

        // 3. Numeric Decimal / Integer / Long customMessage & customException overloads
        Assert.areEqual(5.0, Guard.isGreaterThan(5.0, 1.0, 'd', 'gt'));
        Assert.areEqual(5.0, Guard.isGreaterThan(5.0, 1.0, customEx));
        Assert.areEqual(5, Guard.isGreaterThan(5, 1, 'i', 'gt'));
        Assert.areEqual(5, Guard.isGreaterThan(5, 1, customEx));
        Assert.areEqual(5L, Guard.isGreaterThan(5L, 1L, 'l', 'gt'));
        Assert.areEqual(5L, Guard.isGreaterThan(5L, 1L, customEx));

        Assert.areEqual(5.0, Guard.isGreaterThanOrEqualTo(5.0, 5.0, 'd', 'gte'));
        Assert.areEqual(5.0, Guard.isGreaterThanOrEqualTo(5.0, 5.0, customEx));
        Assert.areEqual(5, Guard.isGreaterThanOrEqualTo(5, 5, 'i', 'gte'));
        Assert.areEqual(5, Guard.isGreaterThanOrEqualTo(5, 5, customEx));
        Assert.areEqual(5L, Guard.isGreaterThanOrEqualTo(5L, 5L, 'l', 'gte'));
        Assert.areEqual(5L, Guard.isGreaterThanOrEqualTo(5L, 5L, customEx));

        Assert.areEqual(1.0, Guard.isLessThan(1.0, 5.0, 'd', 'lt'));
        Assert.areEqual(1.0, Guard.isLessThan(1.0, 5.0, customEx));
        Assert.areEqual(1, Guard.isLessThan(1, 5, 'i', 'lt'));
        Assert.areEqual(1, Guard.isLessThan(1, 5, customEx));
        Assert.areEqual(1L, Guard.isLessThan(1L, 5L, 'l', 'lt'));
        Assert.areEqual(1L, Guard.isLessThan(1L, 5L, customEx));

        Assert.areEqual(5.0, Guard.isLessThanOrEqualTo(5.0, 5.0, 'd', 'lte'));
        Assert.areEqual(5.0, Guard.isLessThanOrEqualTo(5.0, 5.0, customEx));
        Assert.areEqual(5, Guard.isLessThanOrEqualTo(5, 5, 'i', 'lte'));
        Assert.areEqual(5, Guard.isLessThanOrEqualTo(5, 5, customEx));
        Assert.areEqual(5L, Guard.isLessThanOrEqualTo(5L, 5L, 'l', 'lte'));
        Assert.areEqual(5L, Guard.isLessThanOrEqualTo(5L, 5L, customEx));

        Assert.areEqual(5.0, Guard.isInRange(5.0, 1.0, 10.0, 'd', 'range'));
        Assert.areEqual(5.0, Guard.isInRange(5.0, 1.0, 10.0, customEx));
        Assert.areEqual(5, Guard.isInRange(5, 1, 10, 'i', 'range'));
        Assert.areEqual(5, Guard.isInRange(5, 1, 10, customEx));
        Assert.areEqual(5L, Guard.isInRange(5L, 1L, 10L, 'l', 'range'));
        Assert.areEqual(5L, Guard.isInRange(5L, 1L, 10L, customEx));

        Assert.areEqual(5.0, Guard.isNotZero(5.0, 'd', 'nz'));
        Assert.areEqual(5.0, Guard.isNotZero(5.0, customEx));
        Assert.areEqual(5, Guard.isNotZero(5, 'i', 'nz'));
        Assert.areEqual(5, Guard.isNotZero(5, customEx));
        Assert.areEqual(5L, Guard.isNotZero(5L, 'l', 'nz'));
        Assert.areEqual(5L, Guard.isNotZero(5L, customEx));

        verifyNumericFailures(customEx);

        // 4. Collection overloads across List<Object>, Set<*>, Map<*, *>
        verifyCollectionOverloads(accId, acc, customEx);

        // 5. Salesforce-Native overloads
        Assert.areEqual(accId, Guard.isValidId(String.valueOf(accId), 'id', 'bad id'));
        Assert.areEqual(accId, Guard.isValidId(String.valueOf(accId), customEx));
        Assert.areEqual(accId, Guard.isIdOfType(accId, Account.SObjectType, 'id', 'wrong id type'));
        Assert.areEqual(accId, Guard.isIdOfType(accId, Account.SObjectType, customEx));
        Assert.areEqual(
            acc,
            Guard.isSObjectType(acc, Account.SObjectType, 'acc', 'wrong sobj type')
        );
        Assert.areEqual(acc, Guard.isSObjectType(acc, Account.SObjectType, customEx));
        Assert.areEqual(acc, Guard.hasPopulatedField(acc, Account.Name, 'acc', 'missing field'));
        Assert.areEqual(acc, Guard.hasPopulatedField(acc, Account.Name, customEx));

        verifySalesforceNativeFailures(conId, customEx);
    }

    private interface IFailingAction {
        void run();
    }

    private class GuardRunnerIsNullFail implements IFailingAction {
        public void run() {
            Guard.isNull('x', 'opt', 'Custom isNull');
        }
    }

    private static void assertThrowsGuardWithMessage(String expectedMsg, IFailingAction action) {
        try {
            action.run();
            Assert.fail('Expected GuardException: ' + expectedMsg);
        } catch (GuardException ex) {
            Assert.areEqual(expectedMsg, ex.getMessage());
        }
    }

    private static void assertCustomMessageThrows(String expectedCode, String customMsg) {
        try {
            Guard.isNotEmpty('', 's', customMsg);
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(expectedCode, ex.getErrorCode());
            Assert.areEqual(customMsg, ex.getMessage());
        }
    }

    private static void verifyNumericFailures(CustomDomainException customEx) {
        try {
            Guard.isGreaterThan(1, (Integer) null, 'i');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }
        try {
            Guard.isGreaterThan(0, 1, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isGreaterThan(0L, 1L, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isGreaterThanOrEqualTo(0L, 1L, 'l', 'Custom gte');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom gte', ex.getMessage());
        }
        try {
            Guard.isGreaterThanOrEqualTo(0, 1, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isGreaterThanOrEqualTo(0L, 1L, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isLessThan(5L, 5L, 'l', 'Custom lt');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom lt', ex.getMessage());
        }
        try {
            Guard.isLessThan(5, 5, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isLessThan(5L, 5L, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isLessThanOrEqualTo(6L, 5L, 'l', 'Custom lte');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom lte', ex.getMessage());
        }
        try {
            Guard.isLessThanOrEqualTo(6, 5, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isLessThanOrEqualTo(6L, 5L, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isInRange(20L, 1L, 10L, 'l', 'Custom range');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom range', ex.getMessage());
        }
        try {
            Guard.isInRange(20, 1, 10, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isInRange(20L, 1L, 10L, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotZero(0L, 'l', 'Custom nz');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom nz', ex.getMessage());
        }
        try {
            Guard.isNotZero(0, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotZero(0L, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
    }

    private static void verifyCollectionOverloads(
        Id accId,
        Account acc,
        CustomDomainException customEx
    ) {
        List<Object> objList = new List<Object>{ 'a' };
        Set<Object> objSet = new Set<Object>{ 'a' };
        Set<Id> idSet = new Set<Id>{ accId };
        Set<String> strSet = new Set<String>{ 'a' };
        Set<Integer> intSet = new Set<Integer>{ 1 };
        Map<Object, Object> objMap = new Map<Object, Object>{ 'k' => 'v' };
        Map<Id, SObject> idMap = new Map<Id, SObject>{ accId => acc };
        Map<String, Object> strObjMap = new Map<String, Object>{ 'k' => 1 };
        Map<String, String> strStrMap = new Map<String, String>{ 'k' => 'v' };

        // Happy paths for customMessage and customException overloads
        Assert.areEqual(1, Guard.isNotEmpty(objList, 'l', 'msg').size());
        Assert.areEqual(1, Guard.isNotEmpty(objList, customEx).size());
        Assert.areEqual(1, Guard.isNotEmpty(objSet, 's').size());
        Assert.areEqual(1, Guard.isNotEmpty(objSet, 's', 'msg').size());
        Assert.areEqual(1, Guard.isNotEmpty(objSet, customEx).size());
        Assert.areEqual(1, Guard.isNotEmpty(idSet, 'ids', 'msg').size());
        Assert.areEqual(1, Guard.isNotEmpty(idSet, customEx).size());
        Assert.areEqual(1, Guard.isNotEmpty(strSet, 'strs', 'msg').size());
        Assert.areEqual(1, Guard.isNotEmpty(strSet, customEx).size());
        Assert.areEqual(1, Guard.isNotEmpty(intSet, 'ints', 'msg').size());
        Assert.areEqual(1, Guard.isNotEmpty(intSet, customEx).size());
        Assert.areEqual(1, Guard.isNotEmpty(objMap, 'om').size());
        Assert.areEqual(1, Guard.isNotEmpty(objMap, 'om', 'msg').size());
        Assert.areEqual(1, Guard.isNotEmpty(objMap, customEx).size());
        Assert.areEqual(1, Guard.isNotEmpty(idMap, 'im', 'msg').size());
        Assert.areEqual(1, Guard.isNotEmpty(idMap, customEx).size());
        Assert.areEqual(1, Guard.isNotEmpty(strObjMap, 'som', 'msg').size());
        Assert.areEqual(1, Guard.isNotEmpty(strObjMap, customEx).size());
        Assert.areEqual(1, Guard.isNotEmpty(strStrMap, 'ssm', 'msg').size());
        Assert.areEqual(1, Guard.isNotEmpty(strStrMap, customEx).size());

        Assert.areEqual(1, Guard.hasSizeEqualTo(objList, 1, 'l', 'msg').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(objList, 1, customEx).size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(objSet, 1, 's').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(objSet, 1, 's', 'msg').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(objSet, 1, customEx).size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(idSet, 1, 'ids', 'msg').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(idSet, 1, customEx).size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(strSet, 1, 'strs', 'msg').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(strSet, 1, customEx).size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(objMap, 1, 'om').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(objMap, 1, 'om', 'msg').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(objMap, 1, customEx).size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(idMap, 1, 'im', 'msg').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(idMap, 1, customEx).size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(strObjMap, 1, 'som', 'msg').size());
        Assert.areEqual(1, Guard.hasSizeEqualTo(strObjMap, 1, customEx).size());

        Assert.isTrue(Guard.containsKey(objMap, (Object) 'k', 'om').containsKey('k'));
        Assert.isTrue(Guard.containsKey(objMap, (Object) 'k', 'om', 'msg').containsKey('k'));
        Assert.isTrue(Guard.containsKey(objMap, (Object) 'k', customEx).containsKey('k'));
        Assert.isTrue(Guard.containsKey(idMap, accId, 'im', 'msg').containsKey(accId));
        Assert.isTrue(Guard.containsKey(idMap, accId, customEx).containsKey(accId));
        Assert.isTrue(Guard.containsKey(strObjMap, 'k', 'som', 'msg').containsKey('k'));
        Assert.isTrue(Guard.containsKey(strObjMap, 'k', customEx).containsKey('k'));
        Assert.isTrue(Guard.containsKey(strStrMap, 'k', 'ssm', 'msg').containsKey('k'));
        Assert.isTrue(Guard.containsKey(strStrMap, 'k', customEx).containsKey('k'));

        // Failure branches
        try {
            Guard.isNotEmpty(new Set<Object>(), customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Set<Id>(), customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Set<String>(), customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Set<Integer>(), customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Map<Object, Object>(), customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Map<Id, SObject>(), customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Map<String, Object>(), customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Map<String, String>(), customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(objList, -1, 'l');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }
        try {
            Guard.hasSizeEqualTo(objList, 2, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(objSet, 2, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(idSet, 2, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(strSet, 2, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(objMap, 2, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(idMap, 2, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(strObjMap, 2, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.containsKey(objMap, (Object) 'missing', customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.containsKey(idMap, Id.valueOf('003000000000001AAA'), customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.containsKey(strObjMap, 'missing', customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
    }

    private static void verifySalesforceNativeFailures(Id conId, CustomDomainException customEx) {
        try {
            Guard.isValidId('bad', 'id', 'Custom bad id');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual('Custom bad id', ex.getMessage());
        }
        try {
            Guard.isIdOfType((Id) null, Account.SObjectType, 'id');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
        }
        try {
            Guard.isIdOfType(conId, (Schema.SObjectType) null, 'id');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }
        try {
            Guard.isIdOfType(conId, Account.SObjectType, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isSObjectType((SObject) null, Account.SObjectType, 'rec');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
        }
        try {
            Guard.isSObjectType(new Contact(), Account.SObjectType, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasPopulatedField((SObject) null, Account.Name, 'rec');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
        }
        try {
            Guard.hasPopulatedField(new Account(), (Schema.SObjectField) null, 'rec');
            Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }
        try {
            Guard.hasPopulatedField(new Account(), Account.Name, customEx);
            Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            Assert.areEqual('Custom domain failure', ex.getMessage());
        }
    }

    // =========================================================================
    // 7. Schema Permissions (CRUD & FLS — Opt-In & Running-User Context)
    // =========================================================================

    @IsTest
    private static void testSchemaCrudAndFlsGuardsWithSystemRunAs() {
        Guard.resetContext();
        CustomDomainException customEx = new CustomDomainException('CRUD denied');

        // Verify passing overloads (default, customMessage, customException) under privileged context
        if (Schema.SObjectType.Account.isAccessible()) {
            Assert.areEqual(Account.SObjectType, Guard.isAccessible(Account.SObjectType));
            Assert.areEqual(
                Account.SObjectType,
                Guard.isAccessible(Account.SObjectType, 'Read required')
            );
            Assert.areEqual(Account.SObjectType, Guard.isAccessible(Account.SObjectType, customEx));
        }
        if (Schema.SObjectType.Account.isCreateable()) {
            Assert.areEqual(Account.SObjectType, Guard.isCreateable(Account.SObjectType));
            Assert.areEqual(
                Account.SObjectType,
                Guard.isCreateable(Account.SObjectType, 'Create required')
            );
            Assert.areEqual(Account.SObjectType, Guard.isCreateable(Account.SObjectType, customEx));
        }
        if (Schema.SObjectType.Account.isUpdateable()) {
            Assert.areEqual(Account.SObjectType, Guard.isUpdateable(Account.SObjectType));
            Assert.areEqual(
                Account.SObjectType,
                Guard.isUpdateable(Account.SObjectType, 'Update required')
            );
            Assert.areEqual(Account.SObjectType, Guard.isUpdateable(Account.SObjectType, customEx));
        }
        if (Schema.SObjectType.Account.isDeletable()) {
            Assert.areEqual(Account.SObjectType, Guard.isDeletable(Account.SObjectType));
            Assert.areEqual(
                Account.SObjectType,
                Guard.isDeletable(Account.SObjectType, 'Delete required')
            );
            Assert.areEqual(Account.SObjectType, Guard.isDeletable(Account.SObjectType, customEx));
        }
        if (Schema.SObjectType.Account.fields.Name.isAccessible()) {
            Assert.areEqual(Account.Name, Guard.isFieldAccessible(Account.Name));
            Assert.areEqual(
                Account.Name,
                Guard.isFieldAccessible(Account.Name, 'Field read required')
            );
            Assert.areEqual(Account.Name, Guard.isFieldAccessible(Account.Name, customEx));
        }
        if (Schema.SObjectType.Account.fields.Name.isCreateable()) {
            Assert.areEqual(Account.Name, Guard.isFieldCreateable(Account.Name));
            Assert.areEqual(
                Account.Name,
                Guard.isFieldCreateable(Account.Name, 'Field create required')
            );
            Assert.areEqual(Account.Name, Guard.isFieldCreateable(Account.Name, customEx));
        }
        if (Schema.SObjectType.Account.fields.Name.isUpdateable()) {
            Assert.areEqual(Account.Name, Guard.isFieldUpdateable(Account.Name));
            Assert.areEqual(
                Account.Name,
                Guard.isFieldUpdateable(Account.Name, 'Field update required')
            );
            Assert.areEqual(Account.Name, Guard.isFieldUpdateable(Account.Name, customEx));
        }

        User runAsUser = createStandardTestUser();

        System.runAs(runAsUser) {
            Guard.resetContext();
            try {
                // Guard against Security.stripInaccessible NoAccessException when restricted user lacks Account access
                Account rawAcc = new Account(Name = 'Security Safe Corp', AnnualRevenue = 50000);
                Account sparseOrStrippedAcc;
                if (Schema.SObjectType.Account.isAccessible()) {
                    Assert.areEqual(Account.SObjectType, Guard.isAccessible(Account.SObjectType));
                    SObjectAccessDecision decision = Security.stripInaccessible(
                        AccessType.READABLE,
                        new List<Account>{ rawAcc }
                    );
                    sparseOrStrippedAcc = (Account) decision.getRecords()[0];
                } else {
                    try {
                        Guard.isAccessible(Account.SObjectType);
                        Assert.fail('Expected GuardException for restricted Account access.');
                    } catch (GuardException ex) {
                        Assert.areEqual(
                            GuardException.ERR_SOBJECT_NOT_ACCESSIBLE,
                            ex.getErrorCode()
                        );
                    }
                    sparseOrStrippedAcc = rawAcc;
                }

                // Unset field throws structured GuardException instead of System.SObjectException
                try {
                    Guard.hasPopulatedField(sparseOrStrippedAcc, Account.TickerSymbol, 'account');
                    Assert.fail('Expected GuardException for unset TickerSymbol.');
                } catch (GuardException ex) {
                    Assert.areEqual(GuardException.ERR_UNPOPULATED_FIELD, ex.getErrorCode());
                }

                // Trigger builder safely reads stripped/unset fields without SObjectException
                GuardRecord safeValidator = Guard.onRecord(sparseOrStrippedAcc)
                    .isNotBlank(Account.Name)
                    .isGreaterThan(Account.AnnualRevenue, 0);
                Assert.isTrue(safeValidator.isValid() || safeValidator.hasErrors());

                // Pass-through returns on remaining accessible schema tokens
                if (Schema.SObjectType.Account.isCreateable()) {
                    Assert.areEqual(Account.SObjectType, Guard.isCreateable(Account.SObjectType));
                }
                if (Schema.SObjectType.Account.isUpdateable()) {
                    Assert.areEqual(Account.SObjectType, Guard.isUpdateable(Account.SObjectType));
                }
                if (Schema.SObjectType.Account.isDeletable()) {
                    Assert.areEqual(Account.SObjectType, Guard.isDeletable(Account.SObjectType));
                }
                if (Schema.SObjectType.Account.fields.Name.isAccessible()) {
                    Assert.areEqual(Account.Name, Guard.isFieldAccessible(Account.Name));
                }

                // Naturally non-createable / non-updateable audit field check
                try {
                    Guard.isFieldCreateable(Account.CreatedDate);
                    Assert.fail('Expected GuardException for CreatedDate createability.');
                } catch (GuardException ex) {
                    Assert.areEqual(GuardException.ERR_FIELD_NOT_CREATEABLE, ex.getErrorCode());
                    Assert.areEqual('CreatedDate', ex.getParamName());
                }

                try {
                    Guard.isFieldUpdateable(Account.CreatedDate);
                    Assert.fail('Expected GuardException for CreatedDate updateability.');
                } catch (GuardException ex) {
                    Assert.areEqual(GuardException.ERR_FIELD_NOT_UPDATEABLE, ex.getErrorCode());
                    Assert.areEqual('CreatedDate', ex.getParamName());
                }

                // Deterministic CRUD denial simulation across default, customMessage & customException overloads
                GuardSchemaValidator.testForceDenyCrud = true;

                try {
                    Guard.isAccessible(Account.SObjectType);
                    Assert.fail('Expected GuardException for denied read access.');
                } catch (GuardException ex) {
                    Assert.areEqual(GuardException.ERR_SOBJECT_NOT_ACCESSIBLE, ex.getErrorCode());
                }
                try {
                    Guard.isAccessible(Account.SObjectType, 'Custom no read');
                    Assert.fail('Expected GuardException.');
                } catch (GuardException ex) {
                    Assert.areEqual('Custom no read', ex.getMessage());
                }
                try {
                    Guard.isAccessible(Account.SObjectType, customEx);
                    Assert.fail('Expected CustomDomainException.');
                } catch (CustomDomainException ex) {
                    Assert.areEqual('CRUD denied', ex.getMessage());
                }

                try {
                    Guard.isCreateable(Account.SObjectType);
                    Assert.fail('Expected GuardException for denied create access.');
                } catch (GuardException ex) {
                    Assert.areEqual(GuardException.ERR_SOBJECT_NOT_CREATEABLE, ex.getErrorCode());
                }
                try {
                    Guard.isCreateable(Account.SObjectType, 'Custom no create');
                    Assert.fail('Expected GuardException.');
                } catch (GuardException ex) {
                    Assert.areEqual('Custom no create', ex.getMessage());
                }
                try {
                    Guard.isCreateable(Account.SObjectType, customEx);
                    Assert.fail('Expected CustomDomainException.');
                } catch (CustomDomainException ex) {
                    Assert.areEqual('CRUD denied', ex.getMessage());
                }

                try {
                    Guard.isUpdateable(Account.SObjectType);
                    Assert.fail('Expected GuardException for denied update access.');
                } catch (GuardException ex) {
                    Assert.areEqual(GuardException.ERR_SOBJECT_NOT_UPDATEABLE, ex.getErrorCode());
                }
                try {
                    Guard.isUpdateable(Account.SObjectType, 'Custom no update');
                    Assert.fail('Expected GuardException.');
                } catch (GuardException ex) {
                    Assert.areEqual('Custom no update', ex.getMessage());
                }
                try {
                    Guard.isUpdateable(Account.SObjectType, customEx);
                    Assert.fail('Expected CustomDomainException.');
                } catch (CustomDomainException ex) {
                    Assert.areEqual('CRUD denied', ex.getMessage());
                }

                try {
                    Guard.isDeletable(Account.SObjectType);
                    Assert.fail('Expected GuardException for denied delete access.');
                } catch (GuardException ex) {
                    Assert.areEqual(GuardException.ERR_SOBJECT_NOT_DELETABLE, ex.getErrorCode());
                }
                try {
                    Guard.isDeletable(Account.SObjectType, 'Custom no delete');
                    Assert.fail('Expected GuardException.');
                } catch (GuardException ex) {
                    Assert.areEqual('Custom no delete', ex.getMessage());
                }
                try {
                    Guard.isDeletable(Account.SObjectType, customEx);
                    Assert.fail('Expected CustomDomainException.');
                } catch (CustomDomainException ex) {
                    Assert.areEqual('CRUD denied', ex.getMessage());
                }

                // Deterministic FLS denial simulation
                GuardSchemaValidator.testForceDenyFls = true;

                try {
                    Guard.isFieldAccessible(Account.Name);
                    Assert.fail('Expected GuardException for denied field read.');
                } catch (GuardException ex) {
                    Assert.areEqual(GuardException.ERR_FIELD_NOT_ACCESSIBLE, ex.getErrorCode());
                }
                try {
                    Guard.isFieldAccessible(Account.Name, 'Custom FLS read');
                    Assert.fail('Expected GuardException.');
                } catch (GuardException ex) {
                    Assert.areEqual('Custom FLS read', ex.getMessage());
                }
                try {
                    Guard.isFieldAccessible(Account.Name, customEx);
                    Assert.fail('Expected CustomDomainException.');
                } catch (CustomDomainException ex) {
                    Assert.areEqual('CRUD denied', ex.getMessage());
                }

                try {
                    Guard.isFieldCreateable(Account.Name, 'Custom FLS create');
                    Assert.fail('Expected GuardException.');
                } catch (GuardException ex) {
                    Assert.areEqual('Custom FLS create', ex.getMessage());
                }
                try {
                    Guard.isFieldCreateable(Account.Name, customEx);
                    Assert.fail('Expected CustomDomainException.');
                } catch (CustomDomainException ex) {
                    Assert.areEqual('CRUD denied', ex.getMessage());
                }

                try {
                    Guard.isFieldUpdateable(Account.Name, 'Custom FLS update');
                    Assert.fail('Expected GuardException.');
                } catch (GuardException ex) {
                    Assert.areEqual('Custom FLS update', ex.getMessage());
                }
                try {
                    Guard.isFieldUpdateable(Account.Name, customEx);
                    Assert.fail('Expected CustomDomainException.');
                } catch (CustomDomainException ex) {
                    Assert.areEqual('CRUD denied', ex.getMessage());
                }

                // Null schema token checks fail with ERR_INVALID_GUARD_ARGUMENT
                try {
                    Guard.isAccessible((Schema.SObjectType) null);
                    Assert.fail('Expected GuardException for null SObjectType.');
                } catch (GuardException ex) {
                    Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
                }
                try {
                    Guard.isFieldAccessible((Schema.SObjectField) null);
                    Assert.fail('Expected GuardException for null SObjectField.');
                } catch (GuardException ex) {
                    Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
                }
            } finally {
                Guard.resetContext();
            }
        }
    }

    private static User createStandardTestUser() {
        List<Profile> profiles = [
            SELECT Id
            FROM Profile
            WHERE UserType = 'Standard' AND PermissionsModifyAllData = FALSE
            LIMIT 1
        ];
        Id profileId = !profiles.isEmpty() ? profiles[0].Id : UserInfo.getProfileId();
        String uniqueToken =
            String.valueOf(System.now().getTime()) +
            '.' +
            String.valueOf(Math.abs(Crypto.getRandomInteger()));

        return new User(
            Alias = 'guardusr',
            Email = 'apexguard.' + uniqueToken + '@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'GuardTestUser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profileId,
            TimeZoneSidKey = 'GMT',
            Username = 'apexguard.' + uniqueToken + '@' + UserInfo.getOrganizationId() + '.test'
        );
    }
}
