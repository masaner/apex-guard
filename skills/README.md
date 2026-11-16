# ApexGuard Skills

[![skills.sh](https://skills.sh/b/masaner/apex-guard)](https://www.skills.sh/masaner/apex-guard)

This folder contains ApexGuard's [skills.sh](https://skills.sh) catalog. Each subfolder defines one specialized skill with a `SKILL.md` file covering installation, fail-fast defensive Apex patterns, Salesforce execution contexts, observability hooks, security/FLS governance, and unit testing. The top-level [`skills.sh.json`](../skills.sh.json) groups these skills into logical categories for the live catalog page at [skills.sh/masaner/apex-guard](https://www.skills.sh/masaner/apex-guard).

For setup walkthroughs and Antigravity sample prompts, see [`docs/ai-agent-skills.md`](../docs/ai-agent-skills.md).

## Installing These Skills

Add all ApexGuard skills to your AI coding agent (**[Antigravity](https://www.skills.sh/agent/antigravity)**, Claude Code, Cursor, GitHub Copilot, Codex, Gemini CLI, and other [skills.sh](https://skills.sh/docs)-compatible tools):

```bash
# Install all 7 skills into ./.agents/skills/ (project scope)
npx skills add masaner/apex-guard

# Install globally for Antigravity (~/.agents/skills/)
npx skills add masaner/apex-guard -g --agent antigravity --skill '*' -y

# Preview skills without installing
npx skills add masaner/apex-guard --list
```

## Skills

| Skill | Purpose |
| :--- | :--- |
| [apex-guard-install](./apex-guard-install/SKILL.md) | Installing `ApexGuard` via the Released 2GP Unlocked Package (`04td2000000WiM5AAK`) or SFDX source deploy, choosing install security/compile options, running the `ApexGuard` `ApexTestSuite`, and running the 30-second Execute Anonymous smoke test. |
| [apex-guard-usage](./apex-guard-usage/SKILL.md) | Refactoring nested `if/else` pyramids ("arrow anti-pattern") using `Guard.*` positive-assertion pass-through calls across Apex Services, Selectors, `@AuraEnabled` LWC controllers (`Quiddity.AURA` / `Guard.forLwc()`), `@RestResource` APIs, and Async Apex. |
| [apex-guard-triggers-and-bulk-dml](./apex-guard-triggers-and-bulk-dml/SKILL.md) | Non-throwing Trigger and bulk DML validation with `Guard.onRecord(SObject record)` (`GuardRecord`), combining fail-fast batch checks with `record.addError(field, message)`, `.skipInaccessible()`, and partial DML (`allOrNone = false`) support. |
| [apex-guard-flows-and-agentforce](./apex-guard-flows-and-agentforce/SKILL.md) | Declarative validation in Screen Flows, Autolaunched Flows, Record-Triggered Flows, and Agentforce topics via `GuardFlowAction` (`@InvocableMethod`), covering all 18 rules and Fault-path vs. Decision-routing outputs (`throwOnFailure`). |
| [apex-guard-extensibility-and-logging](./apex-guard-extensibility-and-logging/SKILL.md) | Intercepting, logging, or translating failures globally with `IGuardFailureHandler` (`Guard.setFailureHandler()`), integrating **Nebula Logger** (`PublishImmediately` survival across rollbacks), passing custom `Exception` instances, and reading all 30 `GuardException.ERR_*` constants. |
| [apex-guard-testing](./apex-guard-testing/SKILL.md) | Writing deterministic `@IsTest` suites for code using `ApexGuard`: `GuardException` assertions, simulating `Quiddity.AURA` via `Guard.forLwc()` or `GuardContext.testQuiddityOverride`, testing `GuardRecord` without DML, locale-safe `System.runAs` profile queries, and `@TestVisible` schema denial overrides. |
| [apex-guard-security-and-best-practices](./apex-guard-security-and-best-practices/SKILL.md) | Applying `public inherited sharing class` semantics, `record.isSet(field)` sparse-SOQL / `Security.stripInaccessible()` safety, explicit opt-in CRUD/FLS guards (`Guard.isAccessible`..`Guard.isFieldUpdateable`), governor-limit guarantees (0 SOQL / 0 DML), and code-review standards. |

## Supported API Surface

Every skill in this catalog targets ApexGuard's public facade and extension entry points:

* `Guard` (`force-app/main/default/classes/core/Guard.cls`) — primary static entry point for all validation assertions, opt-in CRUD/FLS guards, `Guard.onRecord(record)`, `Guard.forLwc()`, and `Guard.setFailureHandler(...)`.
* `GuardRecord` (`force-app/main/default/classes/core/GuardRecord.cls`) — fluent, non-throwing `SObject.addError()` builder returned by `Guard.onRecord(record)`.
* `GuardException` (`force-app/main/default/classes/exceptions/GuardException.cls`) — structured exception carrying `getParamName()`, `getErrorCode()`, `getActualValue()`, `getQuiddity()`, `getExecutionContext()`, `toMap()`, and `ERR_*` constants.
* `GuardContext.Failure` & `GuardContext.LwcScope` (`force-app/main/default/classes/context/GuardContext.cls`) — diagnostic payload passed to `IGuardFailureHandler` and fluent LWC wrapper returned by `Guard.forLwc()`.
* `IGuardFailureHandler` (`force-app/main/default/classes/context/IGuardFailureHandler.cls`) — transaction-scoped hook interface for telemetry, Nebula Logger adapters, and global exception translation.
* `GuardFlowAction` (`force-app/main/default/classes/invocable/GuardFlowAction.cls`) — `@InvocableMethod` class (`GuardFlowAction.Request` and `GuardFlowAction.Result`) for Flows and Agentforce.

> **Internal Validator Modules:** The six classes in `force-app/main/default/classes/validators/` (`GuardObjectValidator`, `GuardStringValidator`, `GuardNumericValidator`, `GuardCollectionValidator`, `GuardSObjectValidator`, and `GuardSchemaValidator`) are modular implementation units backing `Guard`. Production consumer code should always call `Guard.*` rather than internal validators directly. The only intentional exception in `@IsTest` methods is resetting or toggling `@TestVisible` test overrides (`GuardContext.testQuiddityOverride`, `GuardContext.testTriggerExecutingOverride`, `GuardSchemaValidator.testForceDenyCrud`, `GuardSchemaValidator.testForceDenyFls`), followed by `Guard.resetContext()` in a `finally` block.

## Publishing

`skills.sh` indexes this repository directly from GitHub (`masaner/apex-guard`). Changes merged to `main` are validated by GitHub Actions CI ([`.github/workflows/ci.yml`](../.github/workflows/ci.yml)) to confirm every skill referenced in `skills.sh.json` has a valid `SKILL.md` companion.

## Contributing

If a skill drifts from the codebase (a new guard rule, updated Unlocked Package `04t` version ID, or new validator module), please open an issue or Pull Request at [github.com/masaner/apex-guard](https://github.com/masaner/apex-guard). See [`CONTRIBUTING.md`](../CONTRIBUTING.md) for coding and Prettier formatting standards.
