/**
 * @description Unit tests verifying GuardContext execution-context resolution (Quiddity and Trigger),
 *              LWC AuraHandledException message propagation via setMessage(), IGuardFailureHandler
 *              interception/translation, and GuardException structured metadata serialization.
 * @group Tests
 */
@IsTest
private class GuardContextTest {
    private class TranslatedDomainException extends Exception {
    }

    private class RecordingFailureHandler implements IGuardFailureHandler {
        public GuardContext.Failure lastFailure;
        public Boolean throwCustom = false;

        public void handleFailure(GuardContext.Failure failure) {
            this.lastFailure = failure;
            if (this.throwCustom) {
                throw new TranslatedDomainException('Translated: ' + failure.message);
            }
        }
    }

    @IsTest
    private static void testForLwcFluentThrowsAuraHandledExceptionWithMessage() {
        Guard.resetContext();
        try {
            String valid = Guard.forLwc().isNotBlank('Acme', 'accountName');
            System.Assert.areEqual('Acme', valid);

            Guard.forLwc().isNotBlank('', 'accountName');
            System.Assert.fail('Expected AuraHandledException from Guard.forLwc().');
        } catch (AuraHandledException ex) {
            System.Assert.isTrue(
                ex.getMessage().contains('accountName'),
                'AuraHandledException.setMessage() must expose the real message, got: ' +
                ex.getMessage()
            );
            System.Assert.areNotEqual('Script-thrown exception', ex.getMessage());
        } finally {
            Guard.resetContext();
        }

        // Verify one-shot fluent call did not permanently enable LWC mode
        try {
            Guard.isNotBlank('', 'accountName');
            System.Assert.fail('Expected GuardException after fluent LwcScope completed.');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_BLANK_STRING, ex.getErrorCode());
        }
    }

    @IsTest
    private static void testForLwcStatementModeAndDisable() {
        Guard.resetContext();
        try {
            Guard.forLwc();
            Guard.isGreaterThan(-5, 0, 'amount');
            System.Assert.fail('Expected AuraHandledException in explicit LWC statement mode.');
        } catch (AuraHandledException ex) {
            System.Assert.isTrue(ex.getMessage().contains('amount'));
            System.Assert.isTrue(ex.getMessage().contains('-5'));
        } finally {
            Guard.disableLwcMode();
        }

        try {
            Guard.isGreaterThan(-5, 0, 'amount');
            System.Assert.fail('Expected GuardException after disableLwcMode().');
        } catch (GuardException ex) {
            System.Assert.areEqual(GuardException.ERR_GREATER_THAN, ex.getErrorCode());
        } finally {
            Guard.resetContext();
        }
    }

    @IsTest
    private static void testAutoDetectionOfAuraQuiddity() {
        Guard.resetContext();
        try {
            GuardContext.testQuiddityOverride = System.Quiddity.AURA;
            try {
                Guard.isNotNull(null, 'recordId');
                System.Assert.fail('Expected AuraHandledException when Quiddity == AURA.');
            } catch (AuraHandledException ex) {
                System.Assert.isTrue(ex.getMessage().contains('recordId'));
                System.Assert.areNotEqual('Script-thrown exception', ex.getMessage());
            }

            // Disabling auto-detection reverts to GuardException even with Quiddity == AURA
            Guard.setAutoDetectAuraQuiddity(false);
            try {
                Guard.isNotNull(null, 'recordId');
                System.Assert.fail('Expected GuardException when auto-detect is disabled.');
            } catch (GuardException ex) {
                System.Assert.areEqual(System.Quiddity.AURA, ex.getQuiddity());
                System.Assert.areEqual('AURA', ex.getExecutionContext());
            }
        } finally {
            Guard.resetContext();
        }
    }

    @IsTest
    private static void testQuiddityMetadataAndToMapForRestAndAsync() {
        Guard.resetContext();
        try {
            GuardContext.testQuiddityOverride = System.Quiddity.REST;
            try {
                Guard.isGreaterThan(0, 0, 'quantity');
                System.Assert.fail('Expected GuardException in REST context.');
            } catch (GuardException ex) {
                System.Assert.areEqual('quantity', ex.getParamName());
                System.Assert.areEqual(GuardException.ERR_GREATER_THAN, ex.getErrorCode());
                System.Assert.areEqual(0, ex.getActualValue());
                System.Assert.areEqual(System.Quiddity.REST, ex.getQuiddity());
                System.Assert.areEqual('REST', ex.getExecutionContext());

                Map<String, Object> serialized = ex.toMap();
                System.Assert.areEqual('quantity', serialized.get('paramName'));
                System.Assert.areEqual(
                    GuardException.ERR_GREATER_THAN,
                    serialized.get('errorCode')
                );
                System.Assert.areEqual('REST', serialized.get('quiddity'));
                System.Assert.areEqual('REST', serialized.get('executionContext'));
                System.Assert.isNotNull(JSON.serialize(serialized));
            }

            GuardContext.testQuiddityOverride = System.Quiddity.BATCH_APEX;
            try {
                Guard.isNotEmpty(new List<String>(), 'scope');
                System.Assert.fail('Expected GuardException in BATCH_APEX context.');
            } catch (GuardException ex) {
                System.Assert.areEqual(System.Quiddity.BATCH_APEX, ex.getQuiddity());
                System.Assert.areEqual('BATCH_APEX', ex.getExecutionContext());
            }

            GuardContext.testTriggerExecutingOverride = true;
            try {
                Guard.isNotNull(null, 'triggerNew');
                System.Assert.fail('Expected GuardException in TRIGGER context.');
            } catch (GuardException ex) {
                System.Assert.areEqual('TRIGGER', ex.getExecutionContext());
            }
        } finally {
            Guard.resetContext();
        }
    }

    @IsTest
    private static void testFailureHandlerInterceptionAndTranslation() {
        Guard.resetContext();
        RecordingFailureHandler handler = new RecordingFailureHandler();
        Guard.setFailureHandler(handler);

        try {
            GuardContext.testQuiddityOverride = System.Quiddity.QUEUEABLE;
            try {
                Guard.isNotBlank('', 'jobKey');
                System.Assert.fail('Expected GuardException after logging handler returns.');
            } catch (GuardException ex) {
                System.Assert.isNotNull(handler.lastFailure);
                System.Assert.areEqual('jobKey', handler.lastFailure.paramName);
                System.Assert.areEqual(
                    GuardException.ERR_BLANK_STRING,
                    handler.lastFailure.errorCode
                );
                System.Assert.areEqual(System.Quiddity.QUEUEABLE, handler.lastFailure.quiddity);
                System.Assert.areEqual('QUEUEABLE', handler.lastFailure.executionContext);
            }

            handler.throwCustom = true;
            try {
                Guard.isGreaterThan(-1, 0, 'retryDelay');
                System.Assert.fail('Expected TranslatedDomainException from handler.');
            } catch (TranslatedDomainException ex) {
                System.Assert.isTrue(ex.getMessage().startsWith('Translated: '));
            }

            Guard.resetFailureHandler();
            try {
                Guard.isNotNull(null, 'afterReset');
                System.Assert.fail('Expected GuardException after resetFailureHandler.');
            } catch (GuardException ex) {
                System.Assert.areEqual('afterReset', ex.getParamName());
            }
        } finally {
            Guard.resetContext();
        }
    }

    @IsTest
    private static void testLwcScopeAllWrapperMethods() {
        Guard.resetContext();
        Id accId = Id.valueOf('001000000000001AAA');
        Account acc = new Account(Name = 'Lwc Corp');

        GuardContext.LwcScope lwc = Guard.forLwc();
        System.Assert.areEqual(acc, lwc.isNotNull(acc, 'acc'));
        System.Assert.isNull(lwc.isNull(null, 'nullable'));
        System.Assert.isTrue(lwc.isTrue(true, 'flag'));
        System.Assert.isFalse(lwc.isFalse(false, 'flag'));
        System.Assert.areEqual('a', lwc.isNotEmpty('a', 's'));
        System.Assert.areEqual('abc', lwc.isNotBlank('abc', 's'));
        System.Assert.areEqual('USD', lwc.hasLengthEqualTo('USD', 3, 'cur'));
        System.Assert.areEqual('hi', lwc.hasMaxLength('hi', 5, 'greeting'));
        System.Assert.areEqual('123', lwc.matchesRegex('123', '^\\d+$', 'digits'));
        System.Assert.areEqual(5.0, lwc.isGreaterThan(5.0, 1.0, 'dec'));
        System.Assert.areEqual(5, lwc.isGreaterThan(5, 1, 'intVal'));
        System.Assert.areEqual(5.0, lwc.isGreaterThanOrEqualTo(5.0, 5.0, 'dec'));
        System.Assert.areEqual(2.0, lwc.isLessThan(2.0, 5.0, 'dec'));
        System.Assert.areEqual(5.0, lwc.isLessThanOrEqualTo(5.0, 5.0, 'dec'));
        System.Assert.areEqual(5.0, lwc.isInRange(5.0, 1.0, 10.0, 'dec'));
        System.Assert.areEqual(1.0, lwc.isNotZero(1.0, 'dec'));
        System.Assert.areEqual(1, lwc.isNotEmpty(new List<String>{ 'x' }, 'list').size());
        System.Assert.areEqual(1, lwc.isNotEmpty(new Set<Id>{ accId }, 'ids').size());
        System.Assert.areEqual(1, lwc.isNotEmpty(new Set<String>{ 'x' }, 'strs').size());
        System.Assert.areEqual(accId, lwc.isValidId('001000000000001AAA', 'accId'));
        System.Assert.areEqual(accId, lwc.isIdOfType(accId, Account.SObjectType, 'accId'));
        System.Assert.areEqual(acc, lwc.isSObjectType(acc, Account.SObjectType, 'acc'));
        System.Assert.areEqual(acc, lwc.hasPopulatedField(acc, Account.Name, 'acc'));
        System.Assert.areEqual(Account.SObjectType, lwc.isAccessible(Account.SObjectType));
        System.Assert.areEqual(Account.SObjectType, lwc.isCreateable(Account.SObjectType));
        System.Assert.areEqual(Account.SObjectType, lwc.isUpdateable(Account.SObjectType));
        System.Assert.areEqual(Account.SObjectType, lwc.isDeletable(Account.SObjectType));
        System.Assert.areEqual(Account.Name, lwc.isFieldAccessible(Account.Name));
        System.Assert.areEqual(Account.Name, lwc.isFieldCreateable(Account.Name));
        System.Assert.areEqual(Account.Name, lwc.isFieldUpdateable(Account.Name));

        try {
            lwc.isFieldCreateable(Account.CreatedDate);
            System.Assert.fail('Expected AuraHandledException from LwcScope.isFieldCreateable.');
        } catch (AuraHandledException ex) {
            System.Assert.isTrue(ex.getMessage().contains('CreatedDate'));
        }

        try {
            lwc.isNotZero(0, 'divisor');
            System.Assert.fail('Expected AuraHandledException from LwcScope.isNotZero.');
        } catch (AuraHandledException ex) {
            System.Assert.isTrue(ex.getMessage().contains('divisor'));
        } finally {
            Guard.resetContext();
        }
    }
}
