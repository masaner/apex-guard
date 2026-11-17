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

        Assert.isTrue(validator.isValid());
        Assert.isFalse(validator.hasErrors());
        Assert.isFalse(acc.hasErrors());
        Assert.areEqual(0, validator.getErrorMessages().size());
        Assert.areEqual(acc, validator.getRecord());
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

        Assert.isFalse(validator.isValid());
        Assert.isTrue(validator.hasErrors());
        Assert.isTrue(acc.hasErrors());

        List<String> recordedMessages = validator.getErrorMessages();
        Assert.areEqual(7, recordedMessages.size());
        Assert.areEqual('Account Name is required.', recordedMessages[0]);
        Assert.areEqual('Cross-field business rule failed.', recordedMessages[6]);

        List<Database.Error> dbErrors = acc.getErrors();
        Assert.areEqual(7, dbErrors.size());
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

        Assert.isTrue(recordLevelMessages.contains('Cross-field business rule failed.'));
        Assert.areEqual('Account Name is required.', messageByField.get('Name'));
        Assert.isTrue(messageByField.containsKey('AnnualRevenue'));
        Assert.isTrue(messageByField.containsKey('NumberOfEmployees'));
        Assert.isTrue(messageByField.containsKey('TickerSymbol'));
        Assert.isTrue(messageByField.containsKey('AccountNumber'));
        Assert.isTrue(messageByField.containsKey('Industry'));
    }

    @IsTest
    private static void testUnsetFieldDoesNotThrowSObjectException() {
        Account sparseAcc = new Account();
        GuardRecord validator = Guard.onRecord(sparseAcc)
            .isNotNull(Account.Name)
            .isLessThan(Account.AnnualRevenue, 1000);

        Assert.isTrue(validator.hasErrors());
        Assert.areEqual(2, sparseAcc.getErrors().size());
    }

    @IsTest
    private static void testNullRecordThrowsGuardException() {
        try {
            Guard.onRecord(null);
            Assert.fail('Expected GuardException for null record.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_NULL_VALUE, ex.getErrorCode());
            Assert.areEqual('record', ex.getParamName());
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
        Assert.isTrue(passing.isValid());

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

        Assert.isTrue(failing.hasErrors());
        Assert.areEqual(23, failing.getErrorMessages().size());
    }

    @IsTest
    private static void testSkipInaccessibleAndExplicitFieldFlsGuards() {
        Guard.resetContext();
        try {
            // 1. Default Guard.onRecord() does NOT skip/enforce FLS (safe for system-context Triggers)
            GuardSchemaValidator.testForceDenyFls = true;
            Account defaultModeAcc = new Account(Name = '   ');
            GuardRecord defaultValidator = Guard.onRecord(defaultModeAcc)
                .isNotBlank(Account.Name, 'Name required in trigger system context.');
            Assert.isTrue(defaultValidator.hasErrors());
            Assert.areEqual(1, defaultModeAcc.getErrors().size());

            // 2. Opt-in skipInaccessible() skips FLS-inaccessible fields silently
            Account skippedAcc = new Account(
                Name = ' ',
                Description = 'HasValue',
                AccountNumber = '1',
                TickerSymbol = 'TOOLONG',
                AnnualRevenue = -10,
                NumberOfEmployees = 0
            );
            GuardRecord flsAwareValidator = Guard.onRecord(skippedAcc)
                .skipInaccessible()
                .isNotNull(Account.Name)
                .isNull(Account.Description)
                .isTrue(false, Account.Name, 'Skipped field flag')
                .isFalse(true, Account.Name, 'Skipped field false flag')
                .isNotEmpty(Account.Name)
                .isNotBlank(Account.Name)
                .hasLengthEqualTo(Account.AccountNumber, 5)
                .hasMaxLength(Account.TickerSymbol, 4)
                .matchesRegex(Account.Name, '^\\d+$')
                .isGreaterThan(Account.AnnualRevenue, 0)
                .isGreaterThanOrEqualTo(Account.AnnualRevenue, 0)
                .isLessThan(Account.AnnualRevenue, -100)
                .isLessThanOrEqualTo(Account.AnnualRevenue, -100)
                .isInRange(Account.AnnualRevenue, 1, 100)
                .isNotZero(Account.NumberOfEmployees)
                .hasPopulatedField(Account.Industry)
                .isTrue(false, 'Record-level assertion still executes.');

            Assert.isTrue(flsAwareValidator.hasErrors());
            Assert.areEqual(1, flsAwareValidator.getErrorMessages().size());
            Assert.areEqual(
                'Record-level assertion still executes.',
                flsAwareValidator.getErrorMessages()[0]
            );

            // Re-disabling skipInaccessible resumes validation
            flsAwareValidator.skipInaccessible(false).isNotBlank(Account.Name);
            Assert.areEqual(2, flsAwareValidator.getErrorMessages().size());

            // 3. Explicit opt-in FLS checks attach field errors cleanly
            Guard.resetContext();
            Account auditAcc = new Account(Name = 'Audit Corp');
            GuardRecord explicitFls = Guard.onRecord(auditAcc)
                .isFieldAccessible(Account.Name)
                .isFieldCreateable(Account.Name)
                .isFieldUpdateable(Account.Name)
                .isFieldCreateable(Account.CreatedDate)
                .isFieldUpdateable(Account.CreatedDate, 'Custom CreatedDate read-only message.');

            Assert.isTrue(explicitFls.hasErrors());
            Assert.areEqual(2, explicitFls.getErrorMessages().size());
            Assert.areEqual(
                'Custom CreatedDate read-only message.',
                explicitFls.getErrorMessages()[1]
            );

            GuardSchemaValidator.testForceDenyFls = true;
            Account deniedAcc = new Account(Name = 'Denied Corp');
            GuardRecord deniedFls = Guard.onRecord(deniedAcc)
                .isFieldAccessible(Account.Name)
                .isFieldUpdateable(Account.Name);
            Assert.isTrue(deniedFls.hasErrors());
            Assert.areEqual(2, deniedFls.getErrorMessages().size());
        } finally {
            Guard.resetContext();
        }
    }
}
