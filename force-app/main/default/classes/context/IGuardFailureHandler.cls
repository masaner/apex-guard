/**
 * @description Extension hook allowing Salesforce orgs, logging frameworks (such as Nebula Logger),
 *              and Trigger/Enterprise frameworks to intercept, enrich, log, or translate ApexGuard
 *              failures globally within a transaction.
 * @group Context
 */
public interface IGuardFailureHandler {
    /**
     * @description Invoked immediately before ApexGuard throws an exception on validation failure.
     *              Implementations may log diagnostic metadata or throw a custom domain exception
     *              to override default throwing behavior. Returning normally allows ApexGuard to
     *              proceed with its standard context-aware exception dispatch.
     * @param failure Immutable diagnostic payload describing the failed precondition.
     */
    void handleFailure(GuardContext.Failure failure);
}
