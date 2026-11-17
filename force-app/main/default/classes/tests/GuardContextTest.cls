/**
 * @description Unit tests verifying GuardContext execution-context resolution (Quiddity and Trigger),
 *              LWC AuraHandledException message propagation via setMessage(), IGuardFailureHandler
 *              interception/translation (including native Apex Stub API / Test.createStub), and
 *              GuardException structured metadata serialization.
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

    private class FailureHandlerStubProvider implements System.StubProvider {
        public Integer callCount = 0;
        public String lastMethodName;
        public List<Type> lastParamTypes;
        public GuardContext.Failure lastFailure;
        public Exception exceptionToThrow;

        public Object handleMethodCall(
            Object stubbedObject,
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs
        ) {
            this.callCount++;
            this.lastMethodName = stubbedMethodName;
            this.lastParamTypes = listOfParamTypes;
            if (
                listOfArgs != null &&
                !listOfArgs.isEmpty() &&
                listOfArgs[0] instanceof GuardContext.Failure
            ) {
                this.lastFailure = (GuardContext.Failure) listOfArgs[0];
            }
            if (this.exceptionToThrow != null) {
                throw this.exceptionToThrow;
            }
            return null;
        }
    }

    @IsTest
    private static void testForLwcFluentThrowsAuraHandledExceptionWithMessage() {
        Guard.resetContext();
        try {
            String valid = Guard.forLwc().isNotBlank('Acme', 'accountName');
            Assert.areEqual('Acme', valid);

            Guard.forLwc().isNotBlank('', 'accountName');
            Assert.fail('Expected AuraHandledException from Guard.forLwc().');
        } catch (AuraHandledException ex) {
            Assert.isTrue(
                ex.getMessage().contains('accountName'),
                'AuraHandledException.setMessage() must expose the real message, got: ' +
                ex.getMessage()
            );
            Assert.areNotEqual('Script-thrown exception', ex.getMessage());
        } finally {
            Guard.resetContext();
        }

        // Verify one-shot fluent call did not permanently enable LWC mode
        try {
            Guard.isNotBlank('', 'accountName');
            Assert.fail('Expected GuardException after fluent LwcScope completed.');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_BLANK_STRING, ex.getErrorCode());
        }
    }

    @IsTest
    private static void testForLwcStatementModeAndDisable() {
        Guard.resetContext();
        try {
            Guard.forLwc();
            Guard.isGreaterThan(-5, 0, 'amount');
            Assert.fail('Expected AuraHandledException in explicit LWC statement mode.');
        } catch (AuraHandledException ex) {
            Assert.isTrue(ex.getMessage().contains('amount'));
            Assert.isTrue(ex.getMessage().contains('-5'));
        } finally {
            Guard.disableLwcMode();
        }

        try {
            Guard.isGreaterThan(-5, 0, 'amount');
            Assert.fail('Expected GuardException after disableLwcMode().');
        } catch (GuardException ex) {
            Assert.areEqual(GuardException.ERR_GREATER_THAN, ex.getErrorCode());
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
                Assert.fail('Expected AuraHandledException when Quiddity == AURA.');
            } catch (AuraHandledException ex) {
                Assert.isTrue(ex.getMessage().contains('recordId'));
                Assert.areNotEqual('Script-thrown exception', ex.getMessage());
            }

            // Disabling auto-detection reverts to GuardException even with Quiddity == AURA
            Guard.setAutoDetectAuraQuiddity(false);
            try {
                Guard.isNotNull(null, 'recordId');
                Assert.fail('Expected GuardException when auto-detect is disabled.');
            } catch (GuardException ex) {
                Assert.areEqual(System.Quiddity.AURA, ex.getQuiddity());
                Assert.areEqual('AURA', ex.getExecutionContext());
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
                Assert.fail('Expected GuardException in REST context.');
            } catch (GuardException ex) {
                Assert.areEqual('quantity', ex.getParamName());
                Assert.areEqual(GuardException.ERR_GREATER_THAN, ex.getErrorCode());
                Assert.areEqual(0, ex.getActualValue());
                Assert.areEqual(System.Quiddity.REST, ex.getQuiddity());
                Assert.areEqual('REST', ex.getExecutionContext());

                Map<String, Object> serialized = ex.toMap();
                Assert.areEqual('quantity', serialized.get('paramName'));
                Assert.areEqual(GuardException.ERR_GREATER_THAN, serialized.get('errorCode'));
                Assert.areEqual('REST', serialized.get('quiddity'));
                Assert.areEqual('REST', serialized.get('executionContext'));
                Assert.isNotNull(JSON.serialize(serialized));
            }

            GuardContext.testQuiddityOverride = System.Quiddity.BATCH_APEX;
            try {
                Guard.isNotEmpty(new List<String>(), 'scope');
                Assert.fail('Expected GuardException in BATCH_APEX context.');
            } catch (GuardException ex) {
                Assert.areEqual(System.Quiddity.BATCH_APEX, ex.getQuiddity());
                Assert.areEqual('BATCH_APEX', ex.getExecutionContext());
            }

            GuardContext.testTriggerExecutingOverride = true;
            try {
                Guard.isNotNull(null, 'triggerNew');
                Assert.fail('Expected GuardException in TRIGGER context.');
            } catch (GuardException ex) {
                Assert.areEqual('TRIGGER', ex.getExecutionContext());
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
                Assert.fail('Expected GuardException after logging handler returns.');
            } catch (GuardException ex) {
                Assert.isNotNull(handler.lastFailure);
                Assert.areEqual('jobKey', handler.lastFailure.paramName);
                Assert.areEqual(GuardException.ERR_BLANK_STRING, handler.lastFailure.errorCode);
                Assert.areEqual(System.Quiddity.QUEUEABLE, handler.lastFailure.quiddity);
                Assert.areEqual('QUEUEABLE', handler.lastFailure.executionContext);
            }

            handler.throwCustom = true;
            try {
                Guard.isGreaterThan(-1, 0, 'retryDelay');
                Assert.fail('Expected TranslatedDomainException from handler.');
            } catch (TranslatedDomainException ex) {
                Assert.isTrue(ex.getMessage().startsWith('Translated: '));
            }

            Guard.resetFailureHandler();
            try {
                Guard.isNotNull(null, 'afterReset');
                Assert.fail('Expected GuardException after resetFailureHandler.');
            } catch (GuardException ex) {
                Assert.areEqual('afterReset', ex.getParamName());
            }
        } finally {
            Guard.resetContext();
        }
    }

    @IsTest
    private static void testFailureHandlerWithStubApi() {
        Guard.resetContext();
        FailureHandlerStubProvider spy = new FailureHandlerStubProvider();
        IGuardFailureHandler stubHandler = (IGuardFailureHandler) Test.createStub(
            IGuardFailureHandler.class,
            spy
        );
        Guard.setFailureHandler(stubHandler);

        try {
            GuardContext.testQuiddityOverride = System.Quiddity.REST;
            try {
                Guard.isNotBlank('', 'orderRef');
                Assert.fail('Expected GuardException after stub handler returned.');
            } catch (GuardException ex) {
                Assert.areEqual(1, spy.callCount);
                Assert.areEqual('handleFailure', spy.lastMethodName);
                Assert.areEqual(1, spy.lastParamTypes.size());
                Assert.areEqual(GuardContext.Failure.class, spy.lastParamTypes[0]);
                Assert.isNotNull(spy.lastFailure);
                Assert.areEqual('orderRef', spy.lastFailure.paramName);
                Assert.areEqual(GuardException.ERR_BLANK_STRING, spy.lastFailure.errorCode);
                Assert.areEqual('REST', spy.lastFailure.executionContext);
                Assert.areEqual(GuardException.ERR_BLANK_STRING, ex.getErrorCode());
            }

            spy.exceptionToThrow = new TranslatedDomainException('Stub-translated domain error');
            try {
                Guard.isGreaterThan(-10, 0, 'amount');
                Assert.fail('Expected TranslatedDomainException thrown by StubProvider.');
            } catch (TranslatedDomainException ex) {
                Assert.areEqual(2, spy.callCount);
                Assert.areEqual('amount', spy.lastFailure.paramName);
                Assert.areEqual(GuardException.ERR_GREATER_THAN, spy.lastFailure.errorCode);
                Assert.areEqual('Stub-translated domain error', ex.getMessage());
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
        Assert.areEqual(acc, lwc.isNotNull(acc, 'acc'));
        Assert.isNull(lwc.isNull(null, 'nullable'));
        Assert.isTrue(lwc.isTrue(true, 'flag'));
        Assert.isFalse(lwc.isFalse(false, 'flag'));
        Assert.areEqual('a', lwc.isNotEmpty('a', 's'));
        Assert.areEqual('abc', lwc.isNotBlank('abc', 's'));
        Assert.areEqual('USD', lwc.hasLengthEqualTo('USD', 3, 'cur'));
        Assert.areEqual('hi', lwc.hasMaxLength('hi', 5, 'greeting'));
        Assert.areEqual('123', lwc.matchesRegex('123', '^\\d+$', 'digits'));
        Assert.areEqual(5.0, lwc.isGreaterThan(5.0, 1.0, 'dec'));
        Assert.areEqual(5, lwc.isGreaterThan(5, 1, 'intVal'));
        Assert.areEqual(5.0, lwc.isGreaterThanOrEqualTo(5.0, 5.0, 'dec'));
        Assert.areEqual(2.0, lwc.isLessThan(2.0, 5.0, 'dec'));
        Assert.areEqual(5.0, lwc.isLessThanOrEqualTo(5.0, 5.0, 'dec'));
        Assert.areEqual(5.0, lwc.isInRange(5.0, 1.0, 10.0, 'dec'));
        Assert.areEqual(1.0, lwc.isNotZero(1.0, 'dec'));
        Assert.areEqual(1, lwc.isNotEmpty(new List<String>{ 'x' }, 'list').size());
        Assert.areEqual(1, lwc.isNotEmpty(new Set<Id>{ accId }, 'ids').size());
        Assert.areEqual(1, lwc.isNotEmpty(new Set<String>{ 'x' }, 'strs').size());
        Assert.areEqual(accId, lwc.isValidId('001000000000001AAA', 'accId'));
        Assert.areEqual(accId, lwc.isIdOfType(accId, Account.SObjectType, 'accId'));
        Assert.areEqual(acc, lwc.isSObjectType(acc, Account.SObjectType, 'acc'));
        Assert.areEqual(acc, lwc.hasPopulatedField(acc, Account.Name, 'acc'));
        Assert.areEqual(Account.SObjectType, lwc.isAccessible(Account.SObjectType));
        Assert.areEqual(Account.SObjectType, lwc.isCreateable(Account.SObjectType));
        Assert.areEqual(Account.SObjectType, lwc.isUpdateable(Account.SObjectType));
        Assert.areEqual(Account.SObjectType, lwc.isDeletable(Account.SObjectType));
        Assert.areEqual(Account.Name, lwc.isFieldAccessible(Account.Name));
        Assert.areEqual(Account.Name, lwc.isFieldCreateable(Account.Name));
        Assert.areEqual(Account.Name, lwc.isFieldUpdateable(Account.Name));

        try {
            lwc.isFieldCreateable(Account.CreatedDate);
            Assert.fail('Expected AuraHandledException from LwcScope.isFieldCreateable.');
        } catch (AuraHandledException ex) {
            Assert.isTrue(ex.getMessage().contains('CreatedDate'));
        }

        try {
            lwc.isNotZero(0, 'divisor');
            Assert.fail('Expected AuraHandledException from LwcScope.isNotZero.');
        } catch (AuraHandledException ex) {
            Assert.isTrue(ex.getMessage().contains('divisor'));
        } finally {
            Guard.resetContext();
        }
    }
}
