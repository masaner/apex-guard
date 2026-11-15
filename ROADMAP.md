# ApexGuard Roadmap

## Phase 1: Core Library, Context Foundation & Enablement (Completed)

- **Zero-Dependency SFDX Package:** `Guard.cls` public facade with modular internal validators (`GuardObjectValidator`, `GuardStringValidator`, `GuardNumericValidator`, `GuardCollectionValidator`, `GuardSObjectValidator`, `GuardSchemaValidator`).
- **Context-Aware Failure Dispatch:** `GuardContext.cls` resolving `System.Request.getCurrent().getQuiddity()` and `Trigger.isExecuting`, with automatic/explicit `AuraHandledException.setMessage()` wrapping for LWC (`Guard.forLwc()`).
- **Opt-In Running-User Schema Permissions (CRUD & FLS):** `GuardSchemaValidator.cls` providing `Guard.isAccessible`, `isCreateable`, `isUpdateable`, `isDeletable`, `isFieldAccessible`, `isFieldCreateable`, and `isFieldUpdateable`, plus opt-in `Guard.onRecord(record).skipInaccessible()`.
- **Non-Throwing Trigger Validation:** Fluent `Guard.onRecord(SObject)` builder (`GuardRecord.cls`) routing field-level and record-level failures to `SObject.addError()`.
- **Flow & Agentforce Action:** Bulkified `GuardFlowAction.cls` (`@InvocableMethod`) supporting both Flow Fault paths (`throwOnFailure = true`) and Decision routing (`throwOnFailure = false`).
- **Extensibility:** `IGuardFailureHandler` hook and structured `GuardException.toMap()` metadata for **Nebula Logger**, REST APIs, and `TransactionFinalizer`.
- **Comprehensive Tests & Docs:** Full `@IsTest` suite, ApexDoc comments, `README.md`, `CONTRIBUTING.md`, `docs/execution-contexts.md`, and `docs/custom-exceptions.md`.

---

## Phase 2: Tooling, Automation & Ecosystem Adapters (Planned)

> **Scope Note:** Phase 2 tooling is intentionally scoped as a separate future milestone. No Python scripts are included in Phase 1.

### 1. Python Static-Analysis & Automated Refactoring CLI (`apex-guard-codemod`)
A standalone Python CLI tool designed to modernize legacy Salesforce codebases automatically:
- **Anti-Pattern Scanner:** Parses Apex `.cls` and `.trigger` files (via tree-sitter / Apex AST parser) to detect:
  - Deeply nested `if/else` precondition pyramids ("arrow anti-pattern") at the start of methods.
  - Manual null/blank checks followed by `throw new ...Exception(...)`.
  - Unsafe `new AuraHandledException(msg)` throws missing `.setMessage(msg)`.
  - Trigger `if (acc.Name == null) { acc.Name.addError(...); }` boilerplate convertible to `Guard.onRecord(acc)`.
- **Automated Safe Codemod:** Generates clean diffs converting detected patterns into pass-through `Guard.*` calls while preserving comments, formatting, and behavior.
- **CI/CD Report Mode:** Outputs SARIF / JSON complexity-reduction metrics (cyclomatic complexity and nesting depth before vs. after).

### 2. Specialized Flow & Agentforce Invocable Adapters
- Dedicated typed Flow actions for SObject field-set requiredness validation (`GuardFieldSetFlowAction`) and bulk collection size validation.
- Declarative Custom Metadata (`Guard_Config__mdt`) option for orgs that want declarative failure-handler toggling without Apex initialization code.

### 3. Enterprise Trigger & Logging Framework Recipes
- Reference adapter packages (separate optional extensions so `ApexGuard` core remains zero-dependency) for:
  - **Nebula Logger** (`NebulaGuardFailureHandler`)
  - **Trigger Actions Framework** & **fflib Apex Enterprise Patterns**
  - **PMD / Salesforce Code Analyzer** custom rules encouraging `Guard.*` preconditions in service layers.

### 4. Additional Validator Domains
- `GuardDateValidator`: `isAfter`, `isBefore`, `isFutureDate`, `isPastDate`, `isWithinDateRange` for `Date` and `Datetime`.
- Additional String formats: `isEmail`, `isUrl`, `isUuid`.
