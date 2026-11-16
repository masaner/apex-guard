---
name: apex-guard-explore
description: Use this skill for Stage 2 (Exploration) of the ApexGuard spec-driven workflow. Conducts a zero-hallucination audit of all relevant files and connected org metadata, captures exact coding style/spacing/newline conventions, writes an ordered implementation checklist in 02-exploration.md, supports confirmation Q&A, and automatically transitions to apex-guard-apply.
---

# Stage 2: Exploration (`apex-guard-explore`)

## Role & Objective

You are executing **Stage 2 (`Explore`)** of the ApexGuard Spec-Driven Workflow, reading `01-proposal.md` in `specs/active/<YYYY-MM-DD-HHmm>-<slug>/` and producing `02-exploration.md`.

Your mission is twofold:
1. Perform a **thorough, zero-hallucination investigation** of every relevant file, Apex class, Trigger, LWC controller, Flow reference, test class, and formatting/org config referenced by the proposal.
2. Document the codebase's **exact coding style, spacing, newline conventions, sharing model, exception/logging patterns, and test patterns** alongside an **ordered, step-by-step implementation checklist** so Stage 3 (`apex-guard-apply`) writes code indistinguishable from existing project conventions.

---

## Strict Rules

1. **Zero Hallucinations Allowed:** NEVER guess file paths, class names, method signatures, SObject fields, Custom Metadata names, or line numbers. Every artifact listed in `02-exploration.md` **must** be directly observed via file searches (`rg` / `grep`), `read_file`, or read-only Salesforce CLI inspection (`sf org display`, `sf sobject describe`) where a connected org is relevant.
2. **Read-Only Codebase Audit:** Do not modify Apex/LWC source files during Exploration; write **only** `02-exploration.md` inside `specs/active/<YYYY-MM-DD-HHmm>-<slug>/`.
3. **Complete Coverage of Proposal Goals:** Every `- [ ] Goal` from `01-proposal.md` must map cleanly to one or more concrete implementation steps in `02-exploration.md`.
4. **Capture Codebase Style & Formatting Fingerprint:** Inspect `.prettierrc`, `prettier.config.*`, `package.json`, `sfdx-project.json`, `.editorconfig`, and the target `.cls`/`.trigger` files themselves to record exact indentation (e.g., 4 spaces vs. 2 spaces), line endings, trailing newline policy, brace placement, sharing keywords (`with sharing` / `inherited sharing`), ApexDoc style, and import/comment conventions.
5. **Multi-Round Confirmation & Auto-Transition:** After writing `02-exploration.md`, present findings and any remaining technical choices to the user. Support multiple Q&A rounds (updating `02-exploration.md` after each answer). When the user confirms (e.g., replies `"continue"`, `"next"`, `"proceed"`, `"apply"`), set `Status: CONFIRMED` in `02-exploration.md` and **immediately run [`apex-guard-apply`](../apex-guard-apply/SKILL.md)**.

---

## Step-by-Step Instructions

### 1. Locate & Read the Active Proposal
Locate the active session folder under `specs/active/` and read `01-proposal.md` in full to extract every in-scope requirement, constraint, and Q&A decision.

### 2. Audit All Relevant Codebase & Org Artifacts
1. Search systematically across `force-app/` (and any additional package directories declared in `sfdx-project.json`) for all candidate classes, triggers, LWCs, flows, and existing `@IsTest` suites.
2. Read every target file and its callers/dependencies carefully—noting exact method signatures, existing defensive `if/else` blocks, DML calls (`insert`/`update`/`Database.insert(..., false)`), `Security.stripInaccessible()` / `WITH USER_MODE` / `as user` usage, and custom exception or Nebula Logger calls.
3. Verify which `ApexGuard` public APIs fit each target (refer to [apex-guard-usage](../apex-guard-usage/SKILL.md), [apex-guard-triggers-and-bulk-dml](../apex-guard-triggers-and-bulk-dml/SKILL.md), [apex-guard-flows-and-agentforce](../apex-guard-flows-and-agentforce/SKILL.md), [apex-guard-security-and-best-practices](../apex-guard-security-and-best-practices/SKILL.md), and [apex-guard-extensibility-and-logging](../apex-guard-extensibility-and-logging/SKILL.md)).
4. If the target codebase runs against a connected Salesforce org and references custom fields/objects/profiles, verify target API names or org API version safely in read-only mode (for example `sf org display` or `sf sobject describe --sobject <ApiName>`)—never assume an object or field exists without observing it.

### 3. Document the Codebase Style & Syntax Fingerprint
Inspect formatting configs and neighboring classes so `apex-guard-apply` introduces **zero formatting drift**:
* Formatter command & rules (e.g., Prettier + `prettier-plugin-apex`, `npm run prettier:verify`)
* Indentation width (spaces vs. tabs), brace style, line wrap width
* Trailing newline requirement on every edited file and line-ending format (`LF` vs. `CRLF`)
* ApexDoc comment conventions (`@description`, `@param`, `@return`, `@throws`)
* Sharing declaration (`with sharing`, `inherited sharing`) and `@IsTest` assertion style (`System.Assert.*` vs. `System.assert*`)

### 4. Write `02-exploration.md`
Write `specs/active/<YYYY-MM-DD-HHmm>-<slug>/02-exploration.md`:

```markdown
# Exploration: <Session Title>

- **Proposal Ref:** [`01-proposal.md`](./01-proposal.md)
- **Explored At:** `<YYYY-MM-DD HH:mm>`
- **Status:** `PENDING_CONFIRMATION` <!-- PENDING_CONFIRMATION | IN_QA | CONFIRMED -->

## 1. Verified Codebase & Org Context (Observed Only)
| Artifact Path | Lines / Symbols Inspected | Existing Behavior & Guard Needs |
| :--- | :--- | :--- |
| `<exact/path/File.cls>` | `methodName(...)` (L12-L48) | <Observed facts only> |

* **Connected Org / API Context:** <Target org / `sfdx-project.json` `sourceApiVersion`, or "N/A — static repo audit">

## 2. Codebase Style, Spacing & Convention Fingerprint
- **Formatter / Linter:** <e.g., Prettier `prettier-plugin-apex` via `npm run prettier:verify`>
- **Indentation & Spacing:** <e.g., 4 spaces, single space after keywords, K&R braces>
- **Newline Convention:** <e.g., `LF`, blank line between methods, trailing newline at EOF>
- **Sharing & Security Model:** <Observed sharing modifiers + `WITH USER_MODE` / system mode rules>
- **Error Handling & Test Style:** <Observed exception types, `System.Assert` conventions, `ApexTestSuite`>

## 3. Proposal Traceability & Step-by-Step Implementation Checklist
- [ ] **Step 1 — `<File.cls>` (`Proposal Goal #1`):** <Exact signature/change, `Guard.*` / `Guard.onRecord()` / `Guard.forLwc()` method, return assignment, exact message/exception behavior>
- [ ] **Step 2 — `<FileTest.cls>` (`Proposal Goal #2`):** <Exact unit test methods & edge cases to add, `Guard.resetContext()` cleanup, `System.runAs` profile safety if CRUD/FLS tested>
- [ ] **Step 3 — Documentation / Metadata (`Proposal Goal #3`):** <Companion `-meta.xml`, `ApexTestSuite` registration, README/docs updates if in scope>

## 4. Verification Plan
- **Format Check:** `<command, e.g., npm run prettier:verify>`
- **Org Deploy & Test Command:** `<command, e.g., sf apex run test --suite-names ...>`

## 5. Open Questions / Confirmations Needed
- *(None, or list technical decisions for user confirmation before Apply begins)*
```

### 5. Confirm with User & Auto-Transition to `apex-guard-apply`
Present a concise summary of observed files, the coding style fingerprint, the ordered checklist, and any open technical questions. Update `02-exploration.md` if the user answers questions or adjusts any step.

As soon as the user confirms (`continue`, `next`, `proceed`, `apply`, or `approved`):
1. Update `- **Status:**` in `02-exploration.md` to `CONFIRMED`.
2. Immediately load and run [`apex-guard-apply`](../apex-guard-apply/SKILL.md) on the same active session folder.

## Related Skills

* **Previous Stage:** [apex-guard-propose](../apex-guard-propose/SKILL.md)
* **Next Stage:** [apex-guard-apply](../apex-guard-apply/SKILL.md)
