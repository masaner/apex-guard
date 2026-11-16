---
name: apex-guard-apply
description: Use this skill for Stage 3 (Apply) of the ApexGuard spec-driven workflow. Executes every confirmed step in 02-exploration.md sequentially while preserving exact codebase spacing, newline, sharing, and formatting conventions, writes a detailed implementation log in 03-apply.md, and automatically transitions to apex-guard-verify.
---

# Stage 3: Apply (`apex-guard-apply`)

## Role & Objective

You are executing **Stage 3 (`Apply`)** of the ApexGuard Spec-Driven Workflow. You work strictly from the confirmed `01-proposal.md` and `02-exploration.md` inside `specs/active/<YYYY-MM-DD-HHmm>-<slug>/`.

Your responsibility is to apply **every single step** in `02-exploration.md` cleanly, match the connected codebase's exact coding style, spacing, newline conventions, and sharing rules, write complete execution evidence to `03-apply.md` so downstream verification can inspect everything built, and hand off seamlessly to **Stage 4 (`apex-guard-verify`)**.

---

## Strict Rules

1. **Confirm Exploration First:** Verify `- **Status:** CONFIRMED` in `02-exploration.md` (or confirm explicitly with the user if still `PENDING_CONFIRMATION`) before modifying source files.
2. **Execute Steps Strictly in Order:** Go item-by-item through `## 3. Proposal Traceability & Step-by-Step Implementation Checklist` in `02-exploration.md`. Do not silently skip steps or invent unplanned scope.
3. **Preserve Codebase Styling to the Letter:** Match every rule recorded in `02-exploration.md`'s `Codebase Style, Spacing & Convention Fingerprint`:
   * Identical indentation, spacing, brace style, `LF` line endings, and trailing EOF newline
   * Existing sharing keyword conventions (`with sharing`, `inherited sharing`), ApexDoc headers, and `@IsTest` assertions
   * Run the project's formatter check/fix command if available (e.g., `npm run prettier` / `npm run prettier:verify`) so zero formatting diffs creep in.
4. **Apply Only Verified `ApexGuard` Public APIs:** Never invent nonexistent methods or bypass `Guard.onRecord()` in Trigger loops.
5. **Write Complete Verification Inputs in `03-apply.md`:** Log exact files created/edited, line ranges, companion `-meta.xml` / `ApexTestSuite` updates, formatter runs, and deploy results so `apex-guard-verify` can verify every claim independently.
6. **Auto-Transition Rule:** After every checklist step is marked `[x]` in `02-exploration.md` and `03-apply.md` is saved (or when the user replies `"continue"`, `"next"`, or `"verify"`), **immediately invoke [`apex-guard-verify`](../apex-guard-verify/SKILL.md)** (unless the user asked to pause before verification).

---

## Step-by-Step Instructions

### 1. Load Confirmed Spec Artifacts
Read both `01-proposal.md` and `02-exploration.md` from `specs/active/<YYYY-MM-DD-HHmm>-<slug>/` to confirm:
* Every requirement & constraint (`In Scope` / `Out of Scope`)
* The Style, Spacing & Convention Fingerprint
* Every checklist item in `## 3` and the Verification Plan in `## 4`

### 2. Apply Each Step One by One
For each `- [ ] Step N` in `02-exploration.md`:
1. Edit or create only the files named in that step, matching surrounding indentation, blank-line spacing, and trailing newlines.
2. For new Apex `.cls` / `.trigger` files:
   * Create the matching `-meta.xml` companion (`<status>Active</status>`, matching `sourceApiVersion` from `sfdx-project.json`).
   * If adding a new `*Test.cls` file in this repo, register it in [`ApexGuard.testSuite-meta.xml`](../../force-app/main/default/testSuites/ApexGuard.testSuite-meta.xml).
3. If targeting a connected org and deployment is part of the plan, deploy with `sf project deploy start --source-dir <dir> --json` (and verify status with `sf project deploy report --job-id <id> --json`).
4. Mark the completed step `[x]` in `02-exploration.md` as you go.

### 3. Format & Write `03-apply.md`
Run any configured formatter (e.g., `npm run prettier`) and create `specs/active/<YYYY-MM-DD-HHmm>-<slug>/03-apply.md`:

```markdown
# Apply Log: <Session Title>

- **Proposal Ref:** [`01-proposal.md`](./01-proposal.md)
- **Exploration Ref:** [`02-exploration.md`](./02-exploration.md)
- **Applied At:** `<YYYY-MM-DD HH:mm>`
- **Status:** `APPLIED` <!-- IN_PROGRESS | APPLIED -->

## 1. Completed Checklist Execution
| Step | Status | File(s) Touched | Exact Summary of Applied Change |
| :--- | :--- | :--- | :--- |
| Step 1 | Done | `<path/File.cls>` (L10-L42) | <Exact change applied & Guard signature used> |
| Step 2 | Done | `<path/FileTest.cls>` (L1-L85) | <Test methods added + Guard.resetContext() cleanup> |

## 2. Style & Convention Compliance Notes
- Matched <4-space indentation / LF / trailing newline / sharing modifier / ApexDoc tags>.
- Formatter command run: `<exact command & exit status>`

## 3. Deployment / Build Output (For Verification Stage)
- **Command Executed:** `<e.g., sf project deploy start --source-dir ... --json>`
- **Observed Result:** `<Deploy Id / status / component count, or "Not deployed — local repo changes only">`
```

### 4. Auto-Transition to `apex-guard-verify`
Once all steps in `02-exploration.md` are marked `[x]` and `03-apply.md` is written cleanly (and on any `"continue"` / `"next"` / `"verify"` prompt from the user), immediately proceed to Stage 4: [`apex-guard-verify`](../apex-guard-verify/SKILL.md).

## Related Skills

* **Previous Stage:** [apex-guard-explore](../apex-guard-explore/SKILL.md)
* **Next Stage:** [apex-guard-verify](../apex-guard-verify/SKILL.md)
