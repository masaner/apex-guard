---
name: apex-guard-flows-and-agentforce
description: Use this skill when configuring or invoking GuardFlowAction (@InvocableMethod) inside Salesforce Screen Flows, Autolaunched Flows, Record-Triggered Flows, or Agentforce Topics/Actions. Covers all 18 rules, Request/Result payloads, Fault path vs Decision-routing modes (throwOnFailure), and Flow Quiddity behavior.
---

# Using `GuardFlowAction` in Flows and Agentforce

## Overview

[`GuardFlowAction`](../../force-app/main/default/classes/invocable/GuardFlowAction.cls) exposes `ApexGuard` declaratively via a single bulkified `@InvocableMethod`:

* **Label:** `Validate Input (ApexGuard)`
* **Category:** `ApexGuard`
* **Method Signature:** `public static List<Result> validate(List<Request> requests)`

Because Flows and Agentforce bundle interviews in bulk, `GuardFlowAction.validate(...)` evaluates each `Request` in order and returns a matching `List<Result>` of identical size and order. When an `ApiName` is passed in `comparisonValue` (for `IS_ID_OF_TYPE` or `IS_SOBJECT_TYPE`), `GuardFlowAction` resolves it via targeted `Schema.describeSObjects(...)` without ever calling `Schema.getGlobalDescribe()`.

> **Permissions Prerequisite:** If non-admin users run a **Screen Flow** or **Agentforce Action** invoking `Validate Input (ApexGuard)`, ensure `ApexGuard` was installed with **Install for All Users** or grant the running users Apex Class Access to `GuardFlowAction` via a Permission Set.

---

## Fault Path vs. Decision / Agentforce Output Routing

Control behavior with `Request.throwOnFailure`:

| Mode | `throwOnFailure` Value | Behavior on Validation Failure | Ideal Use Case |
| :--- | :--- | :--- | :--- |
| **Fail-Fast (Default)** | `true` or omitted (`null`) | Throws `GuardException` (or `AuraHandledException` if active), halting the interview and routing execution into the Flow's **Fault connector**. | Autolaunched subflows, pre-DML safety gates, strict data integrity steps. |
| **Structured Decision Mode** | `false` | Suppresses the throw and populates `Result.isValid = false`, `Result.errorMessage`, `Result.errorCode`, `Result.paramName`, and `Result.executionContext`. | **Screen Flows** (route back to a screen with inline error feedback) and **Agentforce Actions** (return diagnostic text to the reasoning engine so the agent can ask the user to correct input). |

---

## Supported Rules (`Request.rule`)

`rule` is case-insensitive and trimmed (`req.rule.trim().toUpperCase()`). An unrecognized or blank `rule` fails with `GuardException.ERR_INVALID_GUARD_ARGUMENT` (`'GUARD_INVALID_ARGUMENT'`).

### Nullability & Boolean

| `rule` | Primary Input Fields | Notes |
| :--- | :--- | :--- |
| `IS_NOT_NULL` | `recordValue`, `stringValue`, `numericValue`, or `booleanValue` | Inspects the first non-null field in order: `recordValue -> stringValue -> numericValue -> booleanValue`. |
| `IS_NULL` | `recordValue`, `stringValue`, `numericValue`, or `booleanValue` | Passes only when all four typed inputs are `null`. |
| `IS_TRUE` | `booleanValue`, optional `paramName` / `customMessage` | Fails if `booleanValue != true`. |
| `IS_FALSE` | `booleanValue`, optional `paramName` / `customMessage` | Fails if `booleanValue != false`. |

### Strings

| `rule` | Primary Input Fields | Notes |
| :--- | :--- | :--- |
| `IS_NOT_EMPTY` | `stringValue` | Passes if `stringValue != null && stringValue.length() > 0`. |
| `IS_NOT_BLANK` | `stringValue` | Passes if not null, empty, or whitespace-only. |
| `HAS_LENGTH_EQUAL_TO` | `stringValue`, plus `integerValue` (or `minValue` / `comparisonValue`) | Exact character count (`>= 0`). |
| `HAS_MAX_LENGTH` | `stringValue`, plus `integerValue` (or `minValue` / `comparisonValue`) | Maximum character count (`>= 0`). |
| `MATCHES_REGEX` | `stringValue`, `comparisonValue` (regex pattern) | Full-string Apex `Pattern` / `Matcher.matches()`. |

### Numeric

| `rule` | Primary Input Fields | Bound Fields |
| :--- | :--- | :--- |
| `IS_GREATER_THAN` | `numericValue` | `minValue` (fallback `integerValue` or numeric `comparisonValue`) |
| `IS_GREATER_THAN_OR_EQUAL_TO` | `numericValue` | `minValue` (fallback `integerValue` or numeric `comparisonValue`) |
| `IS_LESS_THAN` | `numericValue` | `minValue` (fallback `maxValue`, `integerValue`, or numeric `comparisonValue`) |
| `IS_LESS_THAN_OR_EQUAL_TO` | `numericValue` | `minValue` (fallback `maxValue`, `integerValue`, or numeric `comparisonValue`) |
| `IS_IN_RANGE` | `numericValue` | Inclusive lower bound `minValue` and inclusive upper bound `maxValue`. |
| `IS_NOT_ZERO` | `numericValue` | Fails if `numericValue == null` or `numericValue == 0`. |

### Salesforce-Native (`Id` & `SObject`)

| `rule` | Primary Input Fields | Notes |
| :--- | :--- | :--- |
| `IS_VALID_ID` | `stringValue` | Validates 15- or 18-character Salesforce Id format & checksum. |
| `IS_ID_OF_TYPE` | `stringValue`, `comparisonValue` (e.g., `'Account'`, `'Opportunity'`, `'My_Obj__c'`) | Parses Id via `isValidId` and checks `expectedType` resolved by `Schema.describeSObjects`. |
| `IS_SOBJECT_TYPE` | `recordValue`, `comparisonValue` (SObject API name) | Verifies `recordValue != null` and matches `expectedType`. |

---

## `Request` & `Result` Variable Reference

### `GuardFlowAction.Request`

* `rule` (`String`, required) — one of the 18 rules above.
* `paramName` (`String`) — parameter/field name surfaced in error messages and `Result.paramName`.
* `stringValue` (`String`) — text or Salesforce Id string input.
* `numericValue` (`Decimal`) — decimal/integer numeric value.
* `booleanValue` (`Boolean`) — boolean input.
* `recordValue` (`SObject`) — SObject input.
* `comparisonValue` (`String`) — regex pattern, SObject API name (`'Account'`), or string-encoded numeric/length bound.
* `minValue` (`Decimal`) — single-bound numeric threshold or `IS_IN_RANGE` inclusive lower bound.
* `maxValue` (`Decimal`) — `IS_IN_RANGE` inclusive upper bound (or fallback upper bound for `<` / `<=`).
* `integerValue` (`Integer`) — length bound for `HAS_LENGTH_EQUAL_TO` / `HAS_MAX_LENGTH`.
* `customMessage` (`String`) — optional override message.
* `throwOnFailure` (`Boolean`) — defaults to `true`; set `false` for non-throwing Decision outputs.

### `GuardFlowAction.Result`

* `isValid` (`Boolean`) — `true` when validation succeeded; `false` when `throwOnFailure == false` and validation failed.
* `errorMessage` (`String`) — diagnostic message when `isValid == false`.
* `errorCode` (`String`) — standardized `GuardException` error code (or `'AURA_HANDLED_EXCEPTION'` if an `AuraHandledException` occurred in Aura mode with `throwOnFailure = false`).
* `paramName` (`String`) — failed parameter name.
* `executionContext` (`String`) — `'TRIGGER'`, `'INVOCABLE_ACTION'`, `'SYNCHRONOUS'`, etc.

---

## Screen Flow vs. Record-Triggered Flow `Quiddity` Nuances

* **Screen Flows, Autolaunched Flows, and Agentforce Actions** execute under `System.Quiddity.INVOCABLE_ACTION`.
* **Record-Triggered Flows** invoking an `@InvocableMethod` often execute under `System.Quiddity.SYNCHRONOUS` or with `Trigger.isExecuting == true` (`'TRIGGER'`).

`GuardFlowAction` captures `GuardContext.getExecutionContextName()` cleanly in both cases, so non-throwing `Result` outputs report accurate execution context labels without Flow-side branching.

## Related Skills

* [apex-guard-install](../apex-guard-install/SKILL.md) — Ensure `Install for All Users` or `GuardFlowAction` Permission Set access for Screen Flows.
* [apex-guard-usage](../apex-guard-usage/SKILL.md) — Programmatic `Guard.*` usage in Apex & LWC.
* [apex-guard-extensibility-and-logging](../apex-guard-extensibility-and-logging/SKILL.md) — All 30 `GuardException.ERR_*` constants surfaced in `Result.errorCode`.
