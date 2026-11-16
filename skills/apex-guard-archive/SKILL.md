---
name: apex-guard-archive
description: Use this skill for Stage 5 (Archive) of the ApexGuard spec-driven workflow. Consolidates 01-proposal.md, 02-exploration.md, 03-apply.md, and 04-verification.md into a single self-contained file under specs/archived/, cleans up the specs/active/ session folder, and updates specs/README.md so future AI agents have complete context.
---

# Stage 5: Archive (`apex-guard-archive`)

## Role & Objective

You are executing **Stage 5 (`Archive`)**—the final stage of the ApexGuard Spec-Driven Workflow.

Your mission is to transform a completed, verified active session (`specs/active/<YYYY-MM-DD-HHmm>-<slug>/` containing `01-proposal.md`, `02-exploration.md`, `03-apply.md`, and `04-verification.md`) into **one clean, self-contained permanent archive document** inside `specs/archived/<YYYY-MM-DD-HHmm>-<slug>.md`, delete the temporary active session folder so `specs/active/` stays tidy, and register the archived record in `specs/README.md` so any future AI agent (or human engineer) immediately inherits 100% of the design rationale, exact edits, conventions, and verification proof.

---

## Strict Rules

1. **Verify `PASS` Before Archiving:** Read `04-verification.md` first and ensure `Overall Result: PASS`. If verification has not passed (or `04-verification.md` is missing), stop and invoke [`apex-guard-verify`](../apex-guard-verify/SKILL.md) instead of archiving unverified work.
2. **Preserve Every Essential Fact (Zero Loss Distillation):** Do not lose file paths, Apex method signatures, `GuardException` error codes, codebase spacing/sharing rules, user Q&A decisions, or `Test Run Id` / coverage numbers when summarizing the four files into one. A future AI agent should be able to read **only** `specs/archived/<YYYY-MM-DD-HHmm>-<slug>.md` and know *exactly* what was built, why, and how to extend it safely.
3. **Never Delete `specs/active/.gitkeep` or `specs/archived/.gitkeep`:** Remove **only** the completed session subfolder `specs/active/<YYYY-MM-DD-HHmm>-<slug>/`.
4. **Update [`specs/README.md`](../../specs/README.md):** Always add a row to the `Archived Specifications Index` table pointing to `./archived/<YYYY-MM-DD-HHmm>-<slug>.md`.

---

## Step-by-Step Instructions

### 1. Read All Active Session Documents
From `specs/active/<YYYY-MM-DD-HHmm>-<slug>/`, read:
1. `01-proposal.md`
2. `02-exploration.md`
3. `03-apply.md`
4. `04-verification.md`

Confirm `04-verification.md` shows `Overall Result: PASS`.

### 2. Write the Consolidated Archive File
Create `specs/archived/<YYYY-MM-DD-HHmm>-<slug>.md` with this complete structure:

```markdown
# Archived Spec: <Session Title>

- **Session ID:** `<YYYY-MM-DD-HHmm>-<slug>`
- **Proposed:** `<YYYY-MM-DD HH:mm>`
- **Archived:** `<YYYY-MM-DD HH:mm>`
- **Final Status:** `ARCHIVED & VERIFIED`

---

## 1. Executive Summary & User Intent
<Why this work was done, core requirements, scope boundaries, and key Q&A decisions from 01-proposal.md.>

## 2. Codebase Exploration & Style Conventions Applied
- **Style / Formatting Rules:** <Indentation, newline/EOF, sharing modifiers, assertion style observed in 02-exploration.md>
- **Architectural Constraints:** <e.g., Trigger system mode vs. opt-in FLS, LWC setMessage(), isSet() safety, 0 SOQL/DML>

## 3. Exact Implementation Summary (What Was Built)
| File / Component | Symbols Added / Modified | ApexGuard Patterns Applied |
| :--- | :--- | :--- |
| `<path/File.cls>` | `methodName(...)` (L10-L42) | `Guard.isValidId`, `Guard.forLwc()`, etc. |

## 4. Verification Proof & Traceability
- **Traceability Result:** <All N proposal goals verified `PASS`>
- **Formatting / Lint Check:** `<exact command & result from 04-verification.md>`
- **Deployment / Test Run:** `<exact Deploy Id, Test Run Id, X/X Passed, coverage summary>`

## 5. Knowledge & Know-How for Future AI Agents
- **Entry Points & Extension Seams:** <How future features or refactors should hook into what was built here>
- **Gotchas / Invariants to Preserve:** <Critical behaviors or test teardown requirements such as Guard.resetContext()>
```

### 3. Update `specs/README.md`
Append a row to the `Archived Specifications Index` table in `specs/README.md` (replacing the placeholder row if it was the first archived spec):
```markdown
| [`<YYYY-MM-DD-HHmm>-<slug>.md`](./archived/<YYYY-MM-DD-HHmm>-<slug>.md) | `<YYYY-MM-DD>` | <Concise one-line summary of intent> | `ARCHIVED & VERIFIED` |
```

### 4. Clean Up Active Session Folder
Delete the active session directory `specs/active/<YYYY-MM-DD-HHmm>-<slug>/` (all 4 temporary `01-`..`04-` files are now superseded by `specs/archived/<YYYY-MM-DD-HHmm>-<slug>.md`), verify `specs/active/` and `specs/archived/.gitkeep` remain intact, and report the path of the final archive file to the user.

## Related Skills

* **Previous Stage:** [apex-guard-verify](../apex-guard-verify/SKILL.md)
* **Next Spec Cycle:** [apex-guard-propose](../apex-guard-propose/SKILL.md)
* **Specs Directory Overview:** [specs/README.md](../../specs/README.md)
