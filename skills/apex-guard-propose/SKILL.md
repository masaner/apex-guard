---
name: apex-guard-propose
description: Use this skill when initiating Stage 1 (Proposal) of the ApexGuard spec-driven workflow to capture user intent, create a timestamped specs/active session folder and 01-proposal.md, run multi-round clarifying Q&A, and automatically transition into apex-guard-explore on confirmation.
---

# Stage 1: Proposal (`apex-guard-propose`)

## Role & Objective

You are executing **Stage 1 (`Propose`)** of the ApexGuard Spec-Driven Workflow:

`Propose (01-proposal.md)` → `Explore (02-exploration.md)` → `Apply (03-apply.md)` → `Verify (04-verification.md)` → `Archive (specs/archived/<session>.md)`

Your job is to listen carefully to the user's intent (refactoring Apex to `Guard.*`, securing an LWC controller with `Guard.forLwc()`, converting Trigger loops to `Guard.onRecord()`, integrating `GuardFlowAction`, wiring Nebula Logger via `IGuardFailureHandler`, or adding new guards/validators), capture every requirement faithfully without guessing missing scope, and guide clarifying Q&A until the user confirms moving to Exploration.

---

## Strict Rules

1. **Zero Hallucinations:** Never claim a file, Apex class, SObject, field, or existing behavior exists unless you have read it directly. Wait until Stage 2 (`apex-guard-explore`) to conduct the full deep codebase audit—or perform only a lightweight path lookup if needed to frame clarifying questions accurately.
2. **Do Not Edit Production Code Yet:** Stage 1 writes **only** inside `specs/active/<YYYY-MM-DD-HHmm>-<slug>/`.
3. **Resumable Multi-Round Q&A:** Expect 1 or more rounds of questions. Every time the user answers or refines requirements, update `01-proposal.md` before asking follow-up questions or proceeding.
4. **Automatic Handoff:** Once all open questions are resolved *and* the user confirms (for example by replying `"continue"`, `"next"`, `"proceed"`, `"explore"`, `"looks good"`, or similar), update `Status` to `CONFIRMED` in `01-proposal.md` and **immediately invoke and execute [`apex-guard-explore`](../apex-guard-explore/SKILL.md)** on that same session folder without waiting for another prompt.

---

## Step-by-Step Instructions

### 1. Create the Active Spec Session Folder
Check `specs/active/` first. If an active session for this request does not yet exist:
* Generate a timestamped folder name using local wall-clock time and a concise kebab-case subject slug:
  `specs/active/<YYYY-MM-DD-HHmm>-<subject-slug>/`
  *(Example: `specs/active/2026-11-17-0035-billing-service-guard-refactor/`)*

### 2. Write `01-proposal.md`
Create `specs/active/<YYYY-MM-DD-HHmm>-<subject-slug>/01-proposal.md` using this exact template:

```markdown
# Proposal: <Clear Title>

- **Session ID:** `<YYYY-MM-DD-HHmm>-<subject-slug>`
- **Created At:** `<YYYY-MM-DD HH:mm>`
- **Status:** `IN_QA` <!-- DRAFT | IN_QA | CONFIRMED -->
- **Owner / Requested By:** User

## 1. User Intent & Problem Statement
<Concise statement of what the user wants to accomplish and why.>

## 2. Proposed Goals & Success Criteria
- [ ] <Goal 1 — testable, unambiguous outcome>
- [ ] <Goal 2 — testable, unambiguous outcome>

## 3. Scope Boundaries
- **In Scope:** <Target components, Apex layers, LWC/Trigger/Flow/Test expectations>
- **Out of Scope:** <Explicit exclusions so Stage 3 does not over-reach>

## 4. Candidate Target Areas (To Be Verified in Exploration)
- <Folders, classes, triggers, or org components mentioned by the user — marked "unverified until Explore">

## 5. Clarifying Q&A Log
### Round 1
- **Q1:** <Question asked>
  - **Answer:** *(Pending)*
```

### 3. Conduct Clarifying Q&A (Multi-Round)
Identify any ambiguity that could change how the codebase is explored or modified—for example:
* Execution context requirements: fail-fast `GuardException` vs. `@AuraEnabled` `AuraHandledException` (`Guard.forLwc()`) vs. non-throwing Trigger `Guard.onRecord(SObject)` vs. `GuardFlowAction` (`throwOnFailure`)
* Security expectation: system mode vs. running-user opt-in CRUD/FLS (`Guard.isAccessible`, `.skipInaccessible()`)
* Custom messages / custom exception classes vs. standard `GuardException`
* Target Salesforce org deployment & test execution scope (`ApexTestSuite` vs. specific `@IsTest` classes)

Ask concise, numbered questions. When the user replies:
* Record their exact answers in `## 5. Clarifying Q&A Log` inside `01-proposal.md`.
* Update Sections 1–3 (`Goals`, `Scope Boundaries`) to reflect every decision.
* If new ambiguities surface from their answers, ask Round 2 questions; otherwise present the finalized Proposal summary and ask the user to reply **`continue`** (or **`next`**) to launch **Stage 2: Exploration (`apex-guard-explore`)**.

### 4. Auto-Transition to `apex-guard-explore`
As soon as the user confirms (`continue`, `next`, `proceed`, `explore`, or explicit confirmation):
1. Change `- **Status:**` in `01-proposal.md` from `IN_QA` to `CONFIRMED`.
2. Immediately load and run [`apex-guard-explore`](../apex-guard-explore/SKILL.md) targeting `specs/active/<YYYY-MM-DD-HHmm>-<subject-slug>/`.

## Related Skills

* **Next Stage:** [apex-guard-explore](../apex-guard-explore/SKILL.md) — Stage 2 thorough codebase audit & style fingerprinting.
* **Overview:** [skills/README.md](../README.md) & [How-To Guide](../../docs/how-to-use-skills.md).
