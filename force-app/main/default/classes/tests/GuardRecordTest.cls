/**
 * @description Unit tests for Guard.onRecord(SObject) non-throwing Trigger validation,
 *              field-level addError() attachment, record-level errors, and unset-field safety.
 * @group Tests
 */
@IsTest
private class GuardRecordTest {
    @IsTest
    private static void testValidRecordPassesWithoutErrors() {
        Account acc = new Account(
            Name = 'Acme Industries',
            Industry = 'Technology',
            AnnualRevenue = 250000,
            NumberOfEmployees = 120,
            TickerSymbol = 'ACME'
        );

        GuardRecord validator = Guard.onRecord(acc)
            .isNotBlank(Account.Name)
            .hasPopulatedField(Account.Industry)
            .isGreaterThan(Account.AnnualRevenue, 0)
            .isInRange(Account.NumberOfEmployees, 1, 10000)
            .matchesRegex(Account.TickerSymbol, '^[A-Z]{2,5}$');

        System.Assert.isTrue(validator.isValid());
        System.Assert.isFalse(validator.hasErrors());
        System.Assert.isFalse(acc.hasErrors());
        System.Assert.areEqual(0, validator.getErrorMessages().size());
        System.Assert.areEqual(acc, validator.getRecord());
    }

    @IsTest
    private static void testInvalidFieldsAttachFieldErrorsWithoutThrowing() {
        Account acc = new Account(
            Name = '   ',
            AnnualRevenue = -100,
            NumberOfEmployees = 0,
            TickerSymbol = 'TOOLONGTICKER',
            AccountNumber = '12'
        );

        GuardRecord validator = Guard.onRecord(acc)
            .isNotBlank(Account.Name, 'Account Name is required.')
            .isGreaterThan(Account.AnnualRevenue, 0)
            .isNotZero(Account.NumberOfEmployees)
            .hasMaxLength(Account.TickerSymbol, 5)
            .hasLengthEqualTo(Account.AccountNumber, 6)
            .hasPopulatedField(Account.Industry)
            .isTrue(false, 'Cross-field business rule failed.');

        System.Assert.isFalse(validator.isValid());
        System.Assert.isTrue(validator.hasErrors());
        System.Assert.isTrue(acc.hasErrors());

        List<String> recordedMessages = validator.getErrorMessages();
        System.Assert.areEqual(7, recordedMessages.size());
        System.Assert.areEqual('Account Name is required.', recordedMessages[0]);
        System.Assert.areEqual('Cross-field business rule failed.', recordedMessages[6]);

        List<Database.Error> dbErrors = acc.getErrors();
        System.Assert.areEqual(7, dbErrors.size());
        Map<String, String> messageByField = new Map<String, String>();
        Set<String> recordLevelMessages = new Set<String>();
        for (Database.Error err : dbErrors) {
            List<String> fields = err.getFields();
            if (fields == null || fields.isEmpty()) {
                recordLevelMessages.add(err.getMessage());
            } else {
                for (String fieldName : fields) {
                    messageByField.put(fieldName, err.getMessage());
                }
            }
        }

        System.Assert.isTrue(recordLevelMessages.contains('Cross-field business rule failed.'));
        System.Assert.areEqual('Account Name is required.', messageByField.get('Name'));
        System.Assert.isTrue(messageByField.containsKey('AnnualRevenue'));
        System.Assert.isTrue(messageByField.containsKey('NumberOfEmployees'));
        System.Assert.isTrue(messageByField.containsKey('TickerSymbol'));
        System.Assert.isTrue(messageByField.containsKey('AccountNumber'));
        System.Assert.isTrue(messageByField.containsKey('Industry'));
    }

    @IsTest
    private static void testUnsetFieldDoesNotThrowSObjectException() {
        Account sparseAcc = new Account();
        GuardRecord validator = Guard.onRecord(sparseAcc)
            .isNotNull(Account.Name)
            .isLessThan(Account.AnnualRevenue, 1000);

        System.Assert.isTrue(validator.hasErrors());
        System.Assert.areEqual(2, sparseAcc.getErrors().size());
    }

    @IsTest
    private static void testNullRecordThrowsGuardException() {
        try {
            Guard.onRecord(null);
            System.Assert.fail('Expected GuardException for null record.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
            System.Assert.areEqual('record', ex.getParamName());
        }
    }

    @IsTest
    private static void testAdditionalFieldAndRecordGuards() {
        Account acc = new Account(
            Name = 'Acme',
            AccountNumber = 'ACC-1',
            AnnualRevenue = 500,
            NumberOfEmployees = 25,
            Site = 'HQ'
        );

        GuardRecord passing = Guard.onRecord(acc)
            .isNotNull(Account.Name)
            .isNull(Account.Description)
            .isNotEmpty(Account.AccountNumber)
            .isGreaterThanOrEqualTo(Account.AnnualRevenue, 500)
            .isLessThanOrEqualTo(Account.NumberOfEmployees, 25)
            .isTrue(true, Account.Name, 'Must be true')
            .isFalse(false, Account.Name, 'Must be false')
            .isNull((Object) null, 'optionalCtx')
            .isNotNull('ok', 'ctx')
            .isNotEmpty('ok', 'ctxStr')
            .isNotBlank('ok', 'ctxBlank')
            .hasLengthEqualTo('ABC', 3, 'code')
            .hasMaxLength('ABC', 5, 'code')
            .matchesRegex('ABC', '^[A-Z]+$', 'code')
            .isGreaterThan(2, 1, 'num')
            .isGreaterThanOrEqualTo(2, 2, 'num')
            .isLessThan(1, 2, 'num')
            .isLessThanOrEqualTo(2, 2, 'num')
            .isInRange(5, 1, 10, 'num')
            .isNotZero(1, 'num');
        System.Assert.isTrue(passing.isValid());

        Account failingAcc = new Account(
            Name = 'Bad',
            AnnualRevenue = 1000,
            NumberOfEmployees = 500
        );
        GuardRecord failing = Guard.onRecord(failingAcc)
            .isNull(Account.Name)
            .isNotEmpty(Account.Description)
            .isGreaterThanOrEqualTo(Account.AnnualRevenue, 2000)
            .isLessThan(Account.AnnualRevenue, 500)
            .isLessThanOrEqualTo(Account.NumberOfEmployees, 100)
            .isInRange(Account.NumberOfEmployees, 1, 100)
            .matchesRegex(Account.Name, '^\\d+$')
            .isTrue(false, Account.Name, 'Field condition failed')
            .isFalse(true, Account.Name, 'Field must be false')
            .isFalse(true, 'Record must be false')
            .isNotNull((Object) null, 'param')
            .isNull('nonNull', 'param')
            .isNotEmpty('', 'param')
            .isNotBlank('  ', 'param')
            .hasLengthEqualTo('A', 2, 'param')
            .hasMaxLength('ABCD', 2, 'param')
            .matchesRegex('123', '^[A-Z]+$', 'param')
            .isGreaterThan(0, 1, 'param')
            .isGreaterThanOrEqualTo(0, 1, 'param')
            .isLessThan(5, 1, 'param')
            .isLessThanOrEqualTo(5, 1, 'param')
            .isInRange(99, 1, 10, 'param')
            .isNotZero(0, 'param');

        System.Assert.isTrue(failing.hasErrors());
        System.Assert.areEqual(23, failing.getErrorMessages().size());
    }
}
