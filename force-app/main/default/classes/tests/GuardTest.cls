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
        System.Assert.areEqual(acc, returned, 'isNotNull should return the validated instance.');

        System.Assert.isNull(Guard.isNull(null, 'optionalArg'), 'isNull should return null.');

        try {
            Guard.isNotNull(null, 'customerId');
            System.Assert.fail('Expected GuardException for null value.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
            System.Assert.areEqual('customerId', ex.getParamName());
            System.Assert.isTrue(ex.getMessage().contains('customerId'));
        }

        try {
            Guard.isNotNull(null, 'customerId', 'Custom null message');
            System.Assert.fail('Expected GuardException with custom message.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom null message', ex.getMessage());
        }

        try {
            Guard.isNotNull(null, new CustomDomainException('Domain null error'));
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Domain null error', ex.getMessage());
        }

        try {
            Guard.isNull('unexpected', 'cleanupField');
            System.Assert.fail('Expected GuardException for non-null value.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_NOT_NULL_VALUE, ex.getErrorCode());
            System.Assert.areEqual('cleanupField', ex.getParamName());
        }

        try {
            Guard.isNull('unexpected', new CustomDomainException('Must be null'));
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Must be null', ex.getMessage());
        }
    }

    // =========================================================================
    // 2. Boolean / State Assertions
    // =========================================================================

    @IsTest
    private static void testIsTrueAndIsFalse() {
        System.Assert.isTrue(Guard.isTrue(true, 'Should be true.'));
        System.Assert.isFalse(Guard.isFalse(false, 'Should be false.'));

        for (Boolean invalidTrue : new List<Boolean>{ false, null }) {
            try {
                Guard.isTrue(invalidTrue, 'Account must be active.');
                System.Assert.fail('Expected GuardException for isTrue.');
            } catch (GuardException ex) {
                System.Assert.areEqual(GuardException.ERR_TRUE_EXPECTED, ex.getErrorCode());
                System.Assert.areEqual('Account must be active.', ex.getMessage());
            }
        }

        for (Boolean invalidFalse : new List<Boolean>{ true, null }) {
            try {
                Guard.isFalse(invalidFalse, 'Record must not be locked.');
                System.Assert.fail('Expected GuardException for isFalse.');
            } catch (GuardException ex) {
                System.Assert.areEqual(GuardException.ERR_FALSE_EXPECTED, ex.getErrorCode());
                System.Assert.areEqual('Record must not be locked.', ex.getMessage());
            }
        }

        try {
            Guard.isTrue(false, new CustomDomainException('Custom state error'));
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom state error', ex.getMessage());
        }

        try {
            Guard.isFalse(true, new CustomDomainException('Custom false error'));
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom false error', ex.getMessage());
        }
    }

    // =========================================================================
    // 3. Strings
    // =========================================================================

    @IsTest
    private static void testStringGuards() {
        System.Assert.areEqual(' ', Guard.isNotEmpty(' ', 'spaced'));
        System.Assert.areEqual('ApexGuard', Guard.isNotBlank('ApexGuard', 'libName'));
        System.Assert.areEqual('USD', Guard.hasLengthEqualTo('USD', 3, 'currencyCode'));
        System.Assert.areEqual('abc', Guard.hasMaxLength('abc', 3, 'shortCode'));
        System.Assert.areEqual('INV-1042', Guard.matchesRegex('INV-1042', '^INV-\\d{4}$', 'inv'));

        try {
            Guard.isNotEmpty('', 'emptyStr');
            System.Assert.fail('Expected GuardException for empty string.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_EMPTY_STRING, ex.getErrorCode());
        }

        try {
            Guard.isNotBlank('   \t\n ', 'blankStr');
            System.Assert.fail('Expected GuardException for whitespace-only string.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_BLANK_STRING, ex.getErrorCode());
        }

        try {
            Guard.hasLengthEqualTo('US', 3, 'currencyCode');
            System.Assert.fail('Expected GuardException for wrong length.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_STRING_LENGTH, ex.getErrorCode());
        }

        try {
            Guard.hasLengthEqualTo((String) null, 3, 'currencyCode');
            System.Assert.fail('Expected GuardException for null length check.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_STRING_LENGTH, ex.getErrorCode());
        }

        try {
            Guard.hasMaxLength('abcd', 3, 'shortCode');
            System.Assert.fail('Expected GuardException for exceeding max length.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_MAX_LENGTH, ex.getErrorCode());
        }

        try {
            Guard.hasMaxLength('abc', -1, 'shortCode');
            System.Assert.fail('Expected GuardException for negative maxLength.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }

        try {
            Guard.matchesRegex('BAD-CODE', '^INV-\\d{4}$', 'inv');
            System.Assert.fail('Expected GuardException for regex mismatch.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_REGEX_MISMATCH, ex.getErrorCode());
        }

        try {
            Guard.isNotBlank(null, new CustomDomainException('Custom blank error'));
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom blank error', ex.getMessage());
        }
    }

    // =========================================================================
    // 4. Numeric
    // =========================================================================

    @IsTest
    private static void testNumericGuards() {
        System.Assert.areEqual(10.5, Guard.isGreaterThan(10.5, 0, 'amount'));
        System.Assert.areEqual(5, Guard.isGreaterThan(5, 4, 'count'));
        System.Assert.areEqual(100L, Guard.isGreaterThan(100L, 99L, 'bigCount'));

        Double doubleVal = 12.25;
        System.Assert.areEqual(12.25, Guard.isGreaterThan(doubleVal, 10.0, 'doubleAmount'));

        System.Assert.areEqual(0, Guard.isGreaterThanOrEqualTo(0, 0, 'offset'));
        System.Assert.areEqual(10.0, Guard.isGreaterThanOrEqualTo(10.0, 10.0, 'minAmt'));
        System.Assert.areEqual(4, Guard.isLessThan(4, 5, 'retries'));
        System.Assert.areEqual(5.0, Guard.isLessThanOrEqualTo(5.0, 5.0, 'discountPct'));
        System.Assert.areEqual(50, Guard.isInRange(50, 0, 100, 'score'));
        System.Assert.areEqual(0, Guard.isInRange(0, 0, 100, 'scoreMin'));
        System.Assert.areEqual(100, Guard.isInRange(100, 0, 100, 'scoreMax'));
        System.Assert.areEqual(-2.5, Guard.isNotZero(-2.5, 'delta'));
        System.Assert.areEqual(1, Guard.isNotZero(1, 'divisor'));

        try {
            Guard.isGreaterThan(-5, 0, 'amount');
            System.Assert.fail('Expected GuardException for amount <= 0.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_GREATER_THAN, ex.getErrorCode());
            System.Assert.areEqual('amount', ex.getParamName());
            System.Assert.isTrue(ex.getMessage().contains('-5'));
        }

        try {
            Guard.isGreaterThan((Decimal) null, 0, 'amount');
            System.Assert.fail('Expected GuardException for null numeric.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
        }

        try {
            Guard.isGreaterThanOrEqualTo(9, 10, 'qty');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_GREATER_OR_EQUAL, ex.getErrorCode());
        }

        try {
            Guard.isLessThan(10, 10, 'limit');
            System.Assert.fail('Expected GuardException for boundary equality.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_LESS_THAN, ex.getErrorCode());
        }

        try {
            Guard.isLessThanOrEqualTo(11, 10, 'limit');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_LESS_OR_EQUAL, ex.getErrorCode());
        }

        try {
            Guard.isInRange(101, 0, 100, 'percentage');
            System.Assert.fail('Expected GuardException for out of range.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_OUT_OF_RANGE, ex.getErrorCode());
        }

        try {
            Guard.isInRange(5, 10, 1, 'inverted');
            System.Assert.fail('Expected GuardException for inverted range.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }

        try {
            Guard.isNotZero(0, 'divisor');
            System.Assert.fail('Expected GuardException for zero divisor.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_ZERO_VALUE, ex.getErrorCode());
        }

        try {
            Guard.isNotZero(0.0, new CustomDomainException('Zero not permitted'));
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Zero not permitted', ex.getMessage());
        }
    }

    // =========================================================================
    // 5. Collections (List, Set, Map Covariance Overloads)
    // =========================================================================

    @IsTest
    private static void testCollectionGuards() {
        Id accId = Id.valueOf('001000000000001AAA');

        List<Account> accounts = new List<Account>{ new Account(Name = 'Test') };
        System.Assert.areEqual(1, Guard.isNotEmpty(accounts, 'accounts').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(accounts, 1, 'accounts').size());

        Set<Id> accountIds = new Set<Id>{ accId };
        System.Assert.areEqual(1, Guard.isNotEmpty(accountIds, 'accountIds').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(accountIds, 1, 'accountIds').size());

        Set<String> codes = new Set<String>{ 'A', 'B' };
        System.Assert.areEqual(2, Guard.isNotEmpty(codes, 'codes').size());
        System.Assert.areEqual(2, Guard.hasSizeEqualTo(codes, 2, 'codes').size());

        Set<Integer> nums = new Set<Integer>{ 1 };
        System.Assert.areEqual(1, Guard.isNotEmpty(nums, 'nums').size());

        Map<Id, Account> accMap = new Map<Id, Account>{ accId => accounts[0] };
        System.Assert.areEqual(1, Guard.isNotEmpty(accMap, 'accMap').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(accMap, 1, 'accMap').size());
        System.Assert.isTrue(Guard.containsKey(accMap, accId, 'accMap').containsKey(accId));

        Map<String, Object> payload = new Map<String, Object>{ 'status' => 'OK' };
        System.Assert.areEqual(1, Guard.isNotEmpty(payload, 'payload').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(payload, 1, 'payload').size());
        System.Assert.isTrue(Guard.containsKey(payload, 'status', 'payload').containsKey('status'));

        Map<String, Account> accByKey = new Map<String, Account>{ 'main' => accounts[0] };
        System.Assert.areEqual(1, Guard.isNotEmpty(accByKey, 'accByKey').size());
        System.Assert.isTrue(Guard.containsKey(accByKey, 'main', 'accByKey').containsKey('main'));

        Map<String, String> headers = new Map<String, String>{ 'Content-Type' => 'application/json' };
        System.Assert.areEqual(1, Guard.isNotEmpty(headers, 'headers').size());
        System.Assert.isTrue(
            Guard.containsKey(headers, 'Content-Type', 'headers').containsKey('Content-Type')
        );

        try {
            Guard.isNotEmpty(new Set<Id>(), 'emptyIds');
            System.Assert.fail('Expected GuardException for empty Set<Id>.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_EMPTY_COLLECTION, ex.getErrorCode());
            System.Assert.areEqual('emptyIds', ex.getParamName());
        }

        try {
            Guard.isNotEmpty((List<Account>) null, 'nullList');
            System.Assert.fail('Expected GuardException for null List.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_EMPTY_COLLECTION, ex.getErrorCode());
        }

        try {
            Guard.hasSizeEqualTo(new List<String>{ 'onlyOne' }, 2, 'pair');
            System.Assert.fail('Expected GuardException for size mismatch.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_COLLECTION_SIZE, ex.getErrorCode());
        }

        try {
            Guard.containsKey(payload, 'missingKey', 'payload');
            System.Assert.fail('Expected GuardException for missing key.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_MISSING_KEY, ex.getErrorCode());
        }

        try {
            Guard.containsKey(headers, 'Authorization', new CustomDomainException('Missing auth'));
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Missing auth', ex.getMessage());
        }
    }

    // =========================================================================
    // 6. Salesforce-Native (Id, SObject, Schema)
    // =========================================================================

    @IsTest
    private static void testSalesforceNativeGuards() {
        Id accId18 = Guard.isValidId('001000000000001AAA', 'accountId');
        System.Assert.areEqual(Id.valueOf('001000000000001AAA'), accId18);

        Id accIdFrom15 = Guard.isValidId('001000000000001', 'accountId15');
        System.Assert.areEqual(Account.SObjectType, accIdFrom15.getSObjectType());

        System.Assert.areEqual(
            accId18,
            Guard.isIdOfType(accId18, Account.SObjectType, 'accountId')
        );

        Account acc = new Account(Name = 'Global Corp');
        SObject validatedSObj = Guard.isSObjectType(acc, Account.SObjectType, 'record');
        System.Assert.areEqual(acc, validatedSObj);

        Guard.hasPopulatedField(acc, Account.Name, 'acc');

        for (String badId : new List<String>{ null, '', '   ', 'invalid-id', '0010000000000012' }) {
            try {
                Guard.isValidId(badId, 'recordId');
                System.Assert.fail('Expected GuardException for invalid Id: ' + badId);
            } catch (GuardException ex) {
                System.Assert.areEqual(GuardException.ERR_INVALID_ID, ex.getErrorCode());
            }
        }

        Id contactId = Id.valueOf('003000000000001AAA');
        try {
            Guard.isIdOfType(contactId, Account.SObjectType, 'targetId');
            System.Assert.fail('Expected GuardException for wrong SObjectType Id.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_ID_SOBJECT_TYPE, ex.getErrorCode());
        }

        try {
            Guard.isSObjectType(new Contact(LastName = 'Doe'), Account.SObjectType, 'record');
            System.Assert.fail('Expected GuardException for wrong SObjectType record.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_SOBJECT_TYPE, ex.getErrorCode());
        }

        try {
            Guard.hasPopulatedField(new Account(), Account.Name, 'acc');
            System.Assert.fail('Expected GuardException for unset field.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_UNPOPULATED_FIELD, ex.getErrorCode());
        }

        try {
            Guard.hasPopulatedField(new Account(Name = null), Account.Name, 'acc');
            System.Assert.fail('Expected GuardException for null field value.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_UNPOPULATED_FIELD, ex.getErrorCode());
        }

        try {
            Guard.isValidId('bad', new CustomDomainException('Bad Id custom'));
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Bad Id custom', ex.getMessage());
        }
    }

    @IsTest
    private static void testAllOverloadsCustomMessagesAndCustomExceptions() {
        CustomDomainException customEx = new CustomDomainException('Custom domain failure');
        Id accId = Id.valueOf('001000000000001AAA');
        Id conId = Id.valueOf('003000000000001AAA');
        Account acc = new Account(Name = 'Acme');

        // 1. General / Nullability & Boolean
        System.Assert.areEqual(acc, Guard.isNotNull(acc, 'acc', 'Must not be null'));
        System.Assert.areEqual(acc, Guard.isNotNull(acc, customEx));
        System.Assert.isNull(Guard.isNull(null, 'opt', 'Must be null'));
        System.Assert.isNull(Guard.isNull(null, customEx));
        System.Assert.isTrue(Guard.isTrue(true, customEx));
        System.Assert.isFalse(Guard.isFalse(false, customEx));
        assertThrowsGuardWithMessage('Custom isNull', new GuardRunnerIsNullFail());

        // 2. String customMessage and customException overloads (pass + fail)
        System.Assert.areEqual('ok', Guard.isNotEmpty('ok', 's', 'Custom empty'));
        System.Assert.areEqual('ok', Guard.isNotEmpty('ok', customEx));
        System.Assert.areEqual('ok', Guard.isNotBlank('ok', 's', 'Custom blank'));
        System.Assert.areEqual('ok', Guard.isNotBlank('ok', customEx));
        System.Assert.areEqual('ok', Guard.hasLengthEqualTo('ok', 2, 's', 'Custom len'));
        System.Assert.areEqual('ok', Guard.hasLengthEqualTo('ok', 2, customEx));
        System.Assert.areEqual('ok', Guard.hasMaxLength('ok', 2, 's', 'Custom max'));
        System.Assert.areEqual('ok', Guard.hasMaxLength('ok', 2, customEx));
        System.Assert.areEqual('ok', Guard.matchesRegex('ok', '^[a-z]+$', 's', 'Custom regex'));
        System.Assert.areEqual('ok', Guard.matchesRegex('ok', '^[a-z]+$', customEx));

        assertCustomMessageThrows(GuardException.ERR_EMPTY_STRING, 'Custom empty');
        try {
            Guard.isNotEmpty('', customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotBlank(' ', 's', 'Custom blank');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom blank', ex.getMessage());
        }
        try {
            Guard.hasLengthEqualTo('a', 2, 's', 'Custom len');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom len', ex.getMessage());
        }
        try {
            Guard.hasLengthEqualTo('a', 2, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasLengthEqualTo('a', -1, 's');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }
        try {
            Guard.hasMaxLength('abcd', 2, 's', 'Custom max');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom max', ex.getMessage());
        }
        try {
            Guard.hasMaxLength('abcd', 2, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.matchesRegex('123', '^[a-z]+$', 's', 'Custom regex');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom regex', ex.getMessage());
        }
        try {
            Guard.matchesRegex('123', '^[a-z]+$', customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.matchesRegex('123', '', 's');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }

        // 3. Numeric Decimal / Integer / Long customMessage & customException overloads
        System.Assert.areEqual(5.0, Guard.isGreaterThan(5.0, 1.0, 'd', 'gt'));
        System.Assert.areEqual(5.0, Guard.isGreaterThan(5.0, 1.0, customEx));
        System.Assert.areEqual(5, Guard.isGreaterThan(5, 1, 'i', 'gt'));
        System.Assert.areEqual(5, Guard.isGreaterThan(5, 1, customEx));
        System.Assert.areEqual(5L, Guard.isGreaterThan(5L, 1L, 'l', 'gt'));
        System.Assert.areEqual(5L, Guard.isGreaterThan(5L, 1L, customEx));

        System.Assert.areEqual(5.0, Guard.isGreaterThanOrEqualTo(5.0, 5.0, 'd', 'gte'));
        System.Assert.areEqual(5.0, Guard.isGreaterThanOrEqualTo(5.0, 5.0, customEx));
        System.Assert.areEqual(5, Guard.isGreaterThanOrEqualTo(5, 5, 'i', 'gte'));
        System.Assert.areEqual(5, Guard.isGreaterThanOrEqualTo(5, 5, customEx));
        System.Assert.areEqual(5L, Guard.isGreaterThanOrEqualTo(5L, 5L, 'l', 'gte'));
        System.Assert.areEqual(5L, Guard.isGreaterThanOrEqualTo(5L, 5L, customEx));

        System.Assert.areEqual(1.0, Guard.isLessThan(1.0, 5.0, 'd', 'lt'));
        System.Assert.areEqual(1.0, Guard.isLessThan(1.0, 5.0, customEx));
        System.Assert.areEqual(1, Guard.isLessThan(1, 5, 'i', 'lt'));
        System.Assert.areEqual(1, Guard.isLessThan(1, 5, customEx));
        System.Assert.areEqual(1L, Guard.isLessThan(1L, 5L, 'l', 'lt'));
        System.Assert.areEqual(1L, Guard.isLessThan(1L, 5L, customEx));

        System.Assert.areEqual(5.0, Guard.isLessThanOrEqualTo(5.0, 5.0, 'd', 'lte'));
        System.Assert.areEqual(5.0, Guard.isLessThanOrEqualTo(5.0, 5.0, customEx));
        System.Assert.areEqual(5, Guard.isLessThanOrEqualTo(5, 5, 'i', 'lte'));
        System.Assert.areEqual(5, Guard.isLessThanOrEqualTo(5, 5, customEx));
        System.Assert.areEqual(5L, Guard.isLessThanOrEqualTo(5L, 5L, 'l', 'lte'));
        System.Assert.areEqual(5L, Guard.isLessThanOrEqualTo(5L, 5L, customEx));

        System.Assert.areEqual(5.0, Guard.isInRange(5.0, 1.0, 10.0, 'd', 'range'));
        System.Assert.areEqual(5.0, Guard.isInRange(5.0, 1.0, 10.0, customEx));
        System.Assert.areEqual(5, Guard.isInRange(5, 1, 10, 'i', 'range'));
        System.Assert.areEqual(5, Guard.isInRange(5, 1, 10, customEx));
        System.Assert.areEqual(5L, Guard.isInRange(5L, 1L, 10L, 'l', 'range'));
        System.Assert.areEqual(5L, Guard.isInRange(5L, 1L, 10L, customEx));

        System.Assert.areEqual(5.0, Guard.isNotZero(5.0, 'd', 'nz'));
        System.Assert.areEqual(5.0, Guard.isNotZero(5.0, customEx));
        System.Assert.areEqual(5, Guard.isNotZero(5, 'i', 'nz'));
        System.Assert.areEqual(5, Guard.isNotZero(5, customEx));
        System.Assert.areEqual(5L, Guard.isNotZero(5L, 'l', 'nz'));
        System.Assert.areEqual(5L, Guard.isNotZero(5L, customEx));

        verifyNumericFailures(customEx);

        // 4. Collection overloads across List<Object>, Set<*>, Map<*, *>
        verifyCollectionOverloads(accId, acc, customEx);

        // 5. Salesforce-Native overloads
        System.Assert.areEqual(accId, Guard.isValidId(String.valueOf(accId), 'id', 'bad id'));
        System.Assert.areEqual(accId, Guard.isValidId(String.valueOf(accId), customEx));
        System.Assert.areEqual(
            accId,
            Guard.isIdOfType(accId, Account.SObjectType, 'id', 'wrong id type')
        );
        System.Assert.areEqual(accId, Guard.isIdOfType(accId, Account.SObjectType, customEx));
        System.Assert.areEqual(
            acc,
            Guard.isSObjectType(acc, Account.SObjectType, 'acc', 'wrong sobj type')
        );
        System.Assert.areEqual(acc, Guard.isSObjectType(acc, Account.SObjectType, customEx));
        System.Assert.areEqual(
            acc,
            Guard.hasPopulatedField(acc, Account.Name, 'acc', 'missing field')
        );
        System.Assert.areEqual(acc, Guard.hasPopulatedField(acc, Account.Name, customEx));

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
            System.Assert.fail('Expected GuardException: ' + expectedMsg);
        } catch (GuardException ex) {
            System.Assert.areEqual(expectedMsg, ex.getMessage());
        }
    }

    private static void assertCustomMessageThrows(String expectedCode, String customMsg) {
        try {
            Guard.isNotEmpty('', 's', customMsg);
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(expectedCode, ex.getErrorCode());
            System.Assert.areEqual(customMsg, ex.getMessage());
        }
    }

    private static void verifyNumericFailures(CustomDomainException customEx) {
        try {
            Guard.isGreaterThan(1, (Integer) null, 'i');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }
        try {
            Guard.isGreaterThan(0, 1, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isGreaterThan(0L, 1L, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isGreaterThanOrEqualTo(0L, 1L, 'l', 'Custom gte');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom gte', ex.getMessage());
        }
        try {
            Guard.isGreaterThanOrEqualTo(0, 1, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isGreaterThanOrEqualTo(0L, 1L, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isLessThan(5L, 5L, 'l', 'Custom lt');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom lt', ex.getMessage());
        }
        try {
            Guard.isLessThan(5, 5, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isLessThan(5L, 5L, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isLessThanOrEqualTo(6L, 5L, 'l', 'Custom lte');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom lte', ex.getMessage());
        }
        try {
            Guard.isLessThanOrEqualTo(6, 5, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isLessThanOrEqualTo(6L, 5L, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isInRange(20L, 1L, 10L, 'l', 'Custom range');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom range', ex.getMessage());
        }
        try {
            Guard.isInRange(20, 1, 10, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isInRange(20L, 1L, 10L, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotZero(0L, 'l', 'Custom nz');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom nz', ex.getMessage());
        }
        try {
            Guard.isNotZero(0, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotZero(0L, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
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
        System.Assert.areEqual(1, Guard.isNotEmpty(objList, 'l', 'msg').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(objList, customEx).size());
        System.Assert.areEqual(1, Guard.isNotEmpty(objSet, 's').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(objSet, 's', 'msg').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(objSet, customEx).size());
        System.Assert.areEqual(1, Guard.isNotEmpty(idSet, 'ids', 'msg').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(idSet, customEx).size());
        System.Assert.areEqual(1, Guard.isNotEmpty(strSet, 'strs', 'msg').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(strSet, customEx).size());
        System.Assert.areEqual(1, Guard.isNotEmpty(intSet, 'ints', 'msg').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(intSet, customEx).size());
        System.Assert.areEqual(1, Guard.isNotEmpty(objMap, 'om').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(objMap, 'om', 'msg').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(objMap, customEx).size());
        System.Assert.areEqual(1, Guard.isNotEmpty(idMap, 'im', 'msg').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(idMap, customEx).size());
        System.Assert.areEqual(1, Guard.isNotEmpty(strObjMap, 'som', 'msg').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(strObjMap, customEx).size());
        System.Assert.areEqual(1, Guard.isNotEmpty(strStrMap, 'ssm', 'msg').size());
        System.Assert.areEqual(1, Guard.isNotEmpty(strStrMap, customEx).size());

        System.Assert.areEqual(1, Guard.hasSizeEqualTo(objList, 1, 'l', 'msg').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(objList, 1, customEx).size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(objSet, 1, 's').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(objSet, 1, 's', 'msg').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(objSet, 1, customEx).size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(idSet, 1, 'ids', 'msg').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(idSet, 1, customEx).size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(strSet, 1, 'strs', 'msg').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(strSet, 1, customEx).size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(objMap, 1, 'om').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(objMap, 1, 'om', 'msg').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(objMap, 1, customEx).size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(idMap, 1, 'im', 'msg').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(idMap, 1, customEx).size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(strObjMap, 1, 'som', 'msg').size());
        System.Assert.areEqual(1, Guard.hasSizeEqualTo(strObjMap, 1, customEx).size());

        System.Assert.isTrue(Guard.containsKey(objMap, (Object) 'k', 'om').containsKey('k'));
        System.Assert.isTrue(Guard.containsKey(objMap, (Object) 'k', 'om', 'msg').containsKey('k'));
        System.Assert.isTrue(Guard.containsKey(objMap, (Object) 'k', customEx).containsKey('k'));
        System.Assert.isTrue(Guard.containsKey(idMap, accId, 'im', 'msg').containsKey(accId));
        System.Assert.isTrue(Guard.containsKey(idMap, accId, customEx).containsKey(accId));
        System.Assert.isTrue(Guard.containsKey(strObjMap, 'k', 'som', 'msg').containsKey('k'));
        System.Assert.isTrue(Guard.containsKey(strObjMap, 'k', customEx).containsKey('k'));
        System.Assert.isTrue(Guard.containsKey(strStrMap, 'k', 'ssm', 'msg').containsKey('k'));
        System.Assert.isTrue(Guard.containsKey(strStrMap, 'k', customEx).containsKey('k'));

        // Failure branches
        try {
            Guard.isNotEmpty(new Set<Object>(), customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Set<Id>(), customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Set<String>(), customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Set<Integer>(), customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Map<Object, Object>(), customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Map<Id, SObject>(), customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Map<String, Object>(), customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isNotEmpty(new Map<String, String>(), customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(objList, -1, 'l');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }
        try {
            Guard.hasSizeEqualTo(objList, 2, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(objSet, 2, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(idSet, 2, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(strSet, 2, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(objMap, 2, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(idMap, 2, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasSizeEqualTo(strObjMap, 2, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.containsKey(objMap, (Object) 'missing', customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.containsKey(idMap, Id.valueOf('003000000000001AAA'), customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.containsKey(strObjMap, 'missing', customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
    }

    private static void verifySalesforceNativeFailures(
        Id conId,
        CustomDomainException customEx
    ) {
        try {
            Guard.isValidId('bad', 'id', 'Custom bad id');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual('Custom bad id', ex.getMessage());
        }
        try {
            Guard.isIdOfType((Id) null, Account.SObjectType, 'id');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
        }
        try {
            Guard.isIdOfType(conId, (Schema.SObjectType) null, 'id');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }
        try {
            Guard.isIdOfType(conId, Account.SObjectType, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.isSObjectType((SObject) null, Account.SObjectType, 'rec');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
        }
        try {
            Guard.isSObjectType(new Contact(), Account.SObjectType, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
        try {
            Guard.hasPopulatedField((SObject) null, Account.Name, 'rec');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
        }
        try {
            Guard.hasPopulatedField(new Account(), (Schema.SObjectField) null, 'rec');
            System.Assert.fail('Expected GuardException.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_INVALID_GUARD_ARGUMENT, ex.getErrorCode());
        }
        try {
            Guard.hasPopulatedField(new Account(), Account.Name, customEx);
            System.Assert.fail('Expected CustomDomainException.');
        } catch (CustomDomainException ex) {
            System.Assert.areEqual('Custom domain failure', ex.getMessage());
        }
    }
}
