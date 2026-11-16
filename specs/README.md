# ApexGuard Specifications (`specs/`)

This directory powers ApexGuard's **5-stage Spec-Driven AI Agent Workflow** ([`Propose → Explore → Apply → Verify → Archive`](../docs/how-to-use-skills.md)):

```text
specs/
├── README.md                              # Index of active and archived spec sessions
├── active/                                # In-progress sessions (created per proposal timestamp & subject)
│   ├── .gitkeep
│   └── <YYYY-MM-DD-HHmm>-<slug>/
│       ├── 01-proposal.md                 # Stage 1: User intent, scope & Q&A decisions (apex-guard-propose)
│       ├── 02-exploration.md              # Stage 2: Zero-hallucination audit, style fingerprint & checklist (apex-guard-explore)
│       ├── 03-apply.md                    # Stage 3: Step-by-step execution log & command outputs (apex-guard-apply)
│       └── 04-verification.md             # Stage 4: Traceability matrix & test verification evidence (apex-guard-verify)
└── archived/                              # Completed & verified sessions consolidated for future AI agents
    ├── .gitkeep
    └── <YYYY-MM-DD-HHmm>-<slug>.md        # Stage 5: Single self-contained knowledge file (apex-guard-archive)
```

---

## Folder Lifecycle Rules

1. **`specs/active/<YYYY-MM-DD-HHmm>-<slug>/`:** Holds working documents while a proposal is being clarified, explored, applied, and verified.
   * Multiple rounds of user Q&A update `01-proposal.md` or `02-exploration.md` in place before code changes begin.
   * Each skill appends structured state (`Status: DRAFT | IN_QA | CONFIRMED | APPLIED | VERIFIED`) and automatically hands off to the next stage when the user confirms (`continue`, `next`, `proceed`, or `archive`).
2. **`specs/archived/<YYYY-MM-DD-HHmm>-<slug>.md`:** Once `04-verification.md` confirms every requirement passed, `apex-guard-archive` distills all four working Markdown files into a single permanent Markdown specification record containing exact files touched, codebase conventions matched, APIs applied, test evidence, and lessons learned—then removes the `specs/active/<YYYY-MM-DD-HHmm>-<slug>/` working folder.

---

## Archived Specifications Index

| Archive File | Date | Subject / Intent | Status |
| :--- | :--- | :--- | :--- |
| *(None archived yet — start a proposal with [`apex-guard-propose`](../skills/apex-guard-propose/SKILL.md))* | — | — | — |
