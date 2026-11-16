---
name: apex-guard-verify
description: Use this skill for Stage 4 (Confirmation & Verification) of the ApexGuard spec-driven workflow. Audits all applied files against every Proposal goal and Exploration checklist item, runs format/CI/Apex unit test verification, writes 04-verification.md, and prompts the user to proceed to apex-guard-archive.
---

# Stage 4: Confirmation & Verification (`apex-guard-verify`)

## Role & Objective

You are executing **Stage 4 (`Verify`)** of the ApexGuard Spec-Driven Workflow.

Your mission is to independently verify that **every single requirement captured in `01-proposal.md`** and **every single checklist item planned in `02-exploration.md`** was accurately implemented in `03-apply.md`—with zero missing pieces, zero unverified test claims, and full adherence to codebase conventions—before giving the user the ability to run **Stage 5 (`apex-guard-archive`)**.

---

## Strict Rules

1. **Evidence-Only Verification:** Never claim a file, symbol, formatting check, deployment, or unit test passed unless you directly observed it in tool output *after* the final edit in Stage 3 (`apex-guard-apply`).
2. **Full End-to-End Traceability:** Cross-reference every goal in `01-proposal.md` -> every step in `02-exploration.md` -> every edit in `03-apply.md` -> actual code on disk.
3. **Fail Honest, Never Paper Over Failures:** If any goal was missed, any test fails, any Prettier rule fails, or any `.cls` lacks `-meta.xml` / `ApexTestSuite` membership, report `FAIL` cleanly in `04-verification.md` and ask the user whether to loop back to [`apex-guard-apply`](../apex-guard-apply/SKILL.md) before archiving.
4. **Prompt to Archive on `PASS` (No Auto-Delete Without Confirmation):** Once everything verifies `PASS`, present the summary and let the user confirm archiving (replying `"archive"`, `"continue"`, `"next"`, or `"done"` automatically triggers [`apex-guard-archive`](../apex-guard-archive/SKILL.md)). Never delete `specs/active/<session>/` prematurely before the user confirms!

---

## Step-by-Step Instructions

### 1. Read All Three Prior Spec Files & Inspect Changed Files
Read `01-proposal.md`, `02-exploration.md`, and `03-apply.md` inside `specs/active/<YYYY-MM-DD-HHmm>-<slug>/`. Then inspect the actual files listed in `03-apply.md` to verify exact behavior, line formatting, error codes, sharing modifiers, and cleanup blocks (`Guard.resetContext()`).

### 2. Run Objective Verification Commands
Execute the checks defined in `02-exploration.md` `## 4. Verification Plan` (applicable to the workspace):
* **Formatting Check:** e.g., `npm run prettier:verify`
* **Metadata / Structure Check:** e.g., verify `.cls-meta.xml` companions, `ApexGuard.testSuite-meta.xml` coverage (if modified), or Markdown relative links
* **Apex Unit Tests (when connected to an org):**
  * For ApexGuard core repo: `sf apex run test --suite-names ApexGuard --code-coverage --result-format human --wait 10`
  * For target subscriber code: `sf apex run test --tests <YourTestClasses> --code-coverage --result-format human --wait 10`
  * Capture exact `Test Run Id`, `Tests Ran`, `Pass Rate`, `Fail/Skip Counts`, runtime (`ms`), and class coverage percentages.

### 3. Write `04-verification.md`
Create `specs/active/<YYYY-MM-DD-HHmm>-<slug>/04-verification.md`:

```markdown
# Verification Report: <Session Title>

- **Proposal Ref:** [`01-proposal.md`](./01-proposal.md)
- **Exploration Ref:** [`02-exploration.md`](./02-exploration.md)
- **Apply Ref:** [`03-apply.md`](./03-apply.md)
- **Verified At:** `<YYYY-MM-DD HH:mm>`
- **Overall Result:** `PASS` <!-- PASS | FAIL -->

## 1. End-to-End Traceability Matrix
| Proposal Goal | Exploration Step | Applied Implementation | Verification Evidence | Result |
| :--- | :--- | :--- | :--- | :--- |
| Goal 1 | Step 1 | `<File.cls>` (L10-L42) | Inspected code + test assertion | `PASS` |
| Goal 2 | Step 2 | `<FileTest.cls>` (L1-L85) | Observed pass in Test Run `<Id>` | `PASS` |

## 2. Checks & Test Execution Evidence
- **Formatting / Lint:** `<exact command & observed output>`
- **Org Deploy / Metadata Check:** `<Deploy Id / XML / suite validation result>`
- **Apex Test Run:** `<Test Run Id, X/X Passed, 0 Failed, 0 Skipped, coverage summary>`

## 3. Deviations or Follow-Up Notes
- *(None, or exact discrepancies observed)*

## 4. Archive Readiness
- All Proposal goals and Exploration steps verified: **Yes / No**
- Ready for [`apex-guard-archive`](../../../skills/apex-guard-archive/SKILL.md): **Reply `archive` (or `continue`) to consolidate into `specs/archived/` and clean up this active session.**
```

### 4. Report Results & Transition to `apex-guard-archive` on Confirmation
* If **Overall Result** is `FAIL`: list the failing checks clearly and ask the user to approve re-running [`apex-guard-apply`](../apex-guard-apply/SKILL.md) to fix them.
* If **Overall Result** is `PASS`: show the verified traceability summary and test run metrics, and tell the user they can reply **`archive`** (or **`continue`** / **`next`**) to run **Stage 5: Archive (`apex-guard-archive`)**. When they confirm, invoke [`apex-guard-archive`](../apex-guard-archive/SKILL.md) immediately.

## Related Skills

* **Previous Stage:** [apex-guard-apply](../apex-guard-apply/SKILL.md)
* **Next Stage:** [apex-guard-archive](../apex-guard-archive/SKILL.md)
