# Quick How-To Guide: Adding & Using ApexGuard Agent Skills

[![skills.sh](https://skills.sh/b/masaner/apex-guard)](https://www.skills.sh/masaner/apex-guard)

This guide walks you through adding ApexGuard's **7 Salesforce-focused Agent Skills** ([skills.sh/masaner/apex-guard](https://www.skills.sh/masaner/apex-guard)) to your AI coding agent and pairing them with our standalone **[`masaner/meric-spec`](https://github.com/masaner/meric-spec)** repository for Spec-Driven (`Propose → Explore → Apply → Verify → Archive`) execution across any project.

- **ApexGuard Skills Catalog:** [skills.sh/masaner/apex-guard](https://www.skills.sh/masaner/apex-guard)
- **Antigravity Platform Directory:** [skills.sh/agent/antigravity](https://www.skills.sh/agent/antigravity)
- **Companion Spec Workflow Framework:** [github.com/masaner/meric-spec](https://github.com/masaner/meric-spec)

---

## Step 1: Add the Skills to Your AI Coding Agent

Run inside any Salesforce DX project (compatible with **Antigravity**, Claude Code, Cursor, GitHub Copilot, Codex, Gemini CLI, and other `skills.sh` agents):

```bash
# Install all 7 ApexGuard skills into your current project (./.agents/skills/)
npx skills add masaner/apex-guard

# Or install globally for Antigravity across every workspace (~/.agents/skills/)
npx skills add masaner/apex-guard -g --agent antigravity --skill '*' -y

# Preview available skills without installing
npx skills add masaner/apex-guard --list
```

### Optional: Pair with `meric-spec` (Universal Spec-Driven Workflow)

Want your agent to always follow a structured **Propose → Explore → Apply → Verify → Archive** specification lifecycle (with multi-round Q&A, zero-hallucination exploration, coding-style preservation, and permanent `specs/archived/` summaries) before editing code? Install [`masaner/meric-spec`](https://github.com/masaner/meric-spec) globally alongside ApexGuard:

```bash
npx skills add masaner/meric-spec -g --agent antigravity --skill '*' -y
```

> **Tip for Antigravity Users:** After installing skills via `npx skills add`, start a new Antigravity session in your workspace so Antigravity loads all installed `SKILL.md` files automatically.

---

## Step 2: How to Use Each ApexGuard Skill

| Task                                                                  | Skill                                                                                                 | Example Prompt                                                                                                                        |
| :-------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------ |
| Install Released 2GP Package (`04td2000000WkULAA0`) or deploy source  | [`apex-guard-install`](../skills/apex-guard-install/SKILL.md)                                         | _"Install ApexGuard using the Released Unlocked Package and run the Execute Anonymous smoke test."_                                   |
| Refactor Apex Services, LWC controllers, or REST APIs                 | [`apex-guard-usage`](../skills/apex-guard-usage/SKILL.md)                                             | _"Refactor this deeply nested service class and `@AuraEnabled` controller to use pass-through `Guard.*` calls and `Guard.forLwc()`."_ |
| Validate records inside Triggers or partial DML (`allOrNone = false`) | [`apex-guard-triggers-and-bulk-dml`](../skills/apex-guard-triggers-and-bulk-dml/SKILL.md)             | _"Convert this Opportunity trigger loop to `Guard.onRecord(opp)` so multi-field errors attach cleanly without breaking partial DML."_ |
| Configure Flow or Agentforce validation rules                         | [`apex-guard-flows-and-agentforce`](../skills/apex-guard-flows-and-agentforce/SKILL.md)               | _"Set up `GuardFlowAction` (`Validate Input (ApexGuard)`) for a Screen Flow using `throwOnFailure = false` Decision routing."_        |
| Integrate **Nebula Logger** or custom exceptions                      | [`apex-guard-extensibility-and-logging`](../skills/apex-guard-extensibility-and-logging/SKILL.md)     | _"Wire `IGuardFailureHandler` to Nebula Logger so guard failures publish before transaction rollback."_                               |
| Write `@IsTest` & locale-safe `System.runAs` unit tests               | [`apex-guard-testing`](../skills/apex-guard-testing/SKILL.md)                                         | _"Add `@IsTest` coverage for LWC `AuraHandledException` messages, `GuardRecord`, and `System.runAs` CRUD/FLS checks."_                |
| Review `inherited sharing`, `isSet()`, & CRUD/FLS policies            | [`apex-guard-security-and-best-practices`](../skills/apex-guard-security-and-best-practices/SKILL.md) | _"Audit these controllers and triggers for `record.isSet()` safety and opt-in CRUD/FLS enforcement."_                                 |

---

## Step 3: Using ApexGuard + `meric-spec` Together

Once both `masaner/apex-guard` and [`masaner/meric-spec`](https://github.com/masaner/meric-spec) are installed, your agent combines **spec discipline** (`meric-spec-*`) with **domain accuracy** (`apex-guard-*`):

```text
You:   "Use meric-spec-propose with ApexGuard patterns to refactor BillingService,
        its LWC controller, and OpportunityTrigger."
       -> Agent asks clarifying questions -> You reply "continue"
       -> Explore audits exact files & Prettier/newline conventions -> You reply "continue"
       -> Apply implements every step cleanly -> Verify runs sf apex run test
       -> You reply "archive" -> Consolidated spec saved under specs/archived/
```

For full CLI commands (`list`, `update`, `remove`) and CI catalog rules, see [`docs/ai-agent-skills.md`](ai-agent-skills.md) and [`skills/README.md`](../skills/README.md).
