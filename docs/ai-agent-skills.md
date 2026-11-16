# AI Agent Skills (`skills.sh`)

[![skills.sh](https://skills.sh/b/masaner/apex-guard)](https://www.skills.sh/masaner/apex-guard)

`ApexGuard` publishes **12 official [skills.sh](https://www.skills.sh/docs) agent skills** so **Antigravity** ([skills.sh/agent/antigravity](https://www.skills.sh/agent/antigravity)), Claude Code, Cursor, GitHub Copilot, Codex, Gemini CLI, and other compatible AI coding agents automatically apply ApexGuard's 5-stage Spec-Driven Workflow (`Propose → Explore → Apply → Verify → Archive`), public APIs, Salesforce execution-context patterns, security guarantees, and test helpers.

* **Quick How-To Guide:** [`docs/how-to-use-skills.md`](how-to-use-skills.md)
* **Live skills.sh Catalog:** [skills.sh/masaner/apex-guard](https://www.skills.sh/masaner/apex-guard)
* **Antigravity Platform Directory:** [skills.sh/agent/antigravity](https://www.skills.sh/agent/antigravity)
* **Specs Workspace:** [`specs/README.md`](../specs/README.md) (`specs/active/` & `specs/archived/`)
* **Catalog Configuration:** [`skills.sh.json`](../skills.sh.json)
* **Skill Sources:** [`skills/`](../skills/README.md)

---

## Quick Install for Antigravity & Other Agents

Run from your Salesforce DX repository root to install all 12 skills at **project scope** (`./.agents/skills/apex-guard-*`), or pass `-g` to install them **globally** (`~/.agents/skills/apex-guard-*`) across every Antigravity workspace:

```bash
# Project-scoped install (recommended for teams; writes ./.agents/skills/ & skills-lock.json)
npx skills add masaner/apex-guard

# Global Antigravity install (available across all Salesforce repos on your machine)
npx skills add masaner/apex-guard -g --agent antigravity --skill '*' -y

# Preview available skills without installing
npx skills add masaner/apex-guard --list

# Install a single skill (example: usage patterns only)
npx skills add masaner/apex-guard --skill apex-guard-usage --agent antigravity
```

### Managing Installed Skills

```bash
# List project-scoped or global Antigravity skills
npx skills list
npx skills list -g --agent antigravity

# Update installed skills to the latest commit on masaner/apex-guard
npx skills update

# Remove one or more skills
npx skills remove apex-guard-install
```

After running `npx skills add masaner/apex-guard`, start a new **Antigravity** session in your workspace—Antigravity automatically discovers every `SKILL.md` under `./.agents/skills/` and `~/.agents/skills/`.

---

## Skill-by-Skill Reference & Example Antigravity Prompts

| Catalog Group | Skill | Focus Area | Example Antigravity Prompt |
| :--- | :--- | :--- | :--- |
| **Spec-Driven Workflow** | [`apex-guard-propose`](../skills/apex-guard-propose/SKILL.md) | Stage 1: User intent, timestamped `specs/active/<session>/01-proposal.md`, multi-round Q&A, auto-handoff | *"Use `apex-guard-propose` to refactor `OrderService` and `OrderTrigger` to ApexGuard."* |
| **Spec-Driven Workflow** | [`apex-guard-explore`](../skills/apex-guard-explore/SKILL.md) | Stage 2: Zero-hallucination codebase/org audit, spacing/newline/style fingerprint, ordered `02-exploration.md` checklist | *(`continue` after Proposal Q&A — or invoke directly to explore & audit conventions)* |
| **Spec-Driven Workflow** | [`apex-guard-apply`](../skills/apex-guard-apply/SKILL.md) | Stage 3: Executes `02-exploration.md` checklist sequentially preserving codebase style; logs `03-apply.md` | *(`continue` after Exploration confirmation)* |
| **Spec-Driven Workflow** | [`apex-guard-verify`](../skills/apex-guard-verify/SKILL.md) | Stage 4: Traceability matrix + Prettier/Apex test verification in `04-verification.md` | *(`continue` automatically after Apply completes)* |
| **Spec-Driven Workflow** | [`apex-guard-archive`](../skills/apex-guard-archive/SKILL.md) | Stage 5: Consolidates `01-`..`04-` into `specs/archived/<session>.md`, cleans `specs/active/`, updates `specs/README.md` | *(`archive` after Verify passes)* |
| **Setup** | [`apex-guard-install`](../skills/apex-guard-install/SKILL.md) | 2GP Unlocked Package (`04td2000000WiM5AAK`), SFDX deploy, install options, `ApexTestSuite`, smoke test | *"Install ApexGuard (`04td2000000WiM5AAK`) into my scratch org and run the Execute Anonymous smoke test."* |
| **Usage** | [`apex-guard-usage`](../skills/apex-guard-usage/SKILL.md) | Pass-through `Guard.*` assertions, `Set`/`Map` overloads, LWC `Quiddity.AURA` & `Guard.forLwc()`, REST `toMap()` | *"Refactor this deeply nested Apex service method and `@AuraEnabled` controller to use flat `Guard` clauses."* |
| **Usage** | [`apex-guard-triggers-and-bulk-dml`](../skills/apex-guard-triggers-and-bulk-dml/SKILL.md) | Non-throwing `Guard.onRecord()`, `addError()` accumulation, partial DML (`allOrNone = false`), `.skipInaccessible()` | *"Rewrite this `Opportunity` trigger validation loop with `Guard.onRecord()` so partial DML still saves valid rows."* |
| **Usage** | [`apex-guard-flows-and-agentforce`](../skills/apex-guard-flows-and-agentforce/SKILL.md) | `GuardFlowAction` `@InvocableMethod`, all 18 rules, Fault-path vs. Decision-routing (`throwOnFailure = false`) | *"Set up `GuardFlowAction` (`Validate Input (ApexGuard)`) for a Screen Flow using Decision routing instead of throwing."* |
| **Usage** | [`apex-guard-testing`](../skills/apex-guard-testing/SKILL.md) | `GuardException` assertions, `Guard.forLwc()` / `testQuiddityOverride`, DML-free `GuardRecord`, locale-safe `System.runAs` | *"Write `@IsTest` coverage for our LWC controller and `GuardRecord` trigger handler, resetting `Guard.resetContext()` cleanly."* |
| **Governance & Security** | [`apex-guard-security-and-best-practices`](../skills/apex-guard-security-and-best-practices/SKILL.md) | `inherited sharing`, `isSet()` sparse-SOQL / `Security.stripInaccessible()` safety, opt-in CRUD/FLS vs. Triggers, 0 SOQL/DML | *"Audit this Apex controller for running-user CRUD/FLS guards without breaking Trigger system mode."* |
| **Extending & Observability** | [`apex-guard-extensibility-and-logging`](../skills/apex-guard-extensibility-and-logging/SKILL.md) | `IGuardFailureHandler`, **Nebula Logger** (`EVENT_BUS` survival across rollbacks), custom `Exception` overloads, 30 error codes | *"Connect `ApexGuard` to Nebula Logger via `IGuardFailureHandler` so guard failures log before rolling back."* |

---

## How `skills.sh.json` Organizes the Catalog Page

The repository root [`skills.sh.json`](../skills.sh.json) configures how [skills.sh/masaner/apex-guard](https://www.skills.sh/masaner/apex-guard) groups all 12 skills (`Setup`, `Spec-Driven Workflow`, `Usage`, `Governance & Security`, `Extending & Observability`) using the official `https://skills.sh/schemas/skills.sh.schema.json` schema.

On every push and pull request to `main`, [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) validates that:

1. `skills.sh.json` matches Prettier formatting (`npm run prettier:verify`) and parses as valid JSON.
2. Every skill ID listed in `skills.sh.json` has a matching `skills/<skill>/SKILL.md` with valid `name:` and `description:` YAML frontmatter.
3. Every `skills/*/SKILL.md` directory in the repository is registered inside `skills.sh.json` (no orphaned or ungrouped skills).
