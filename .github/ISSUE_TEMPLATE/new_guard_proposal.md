---
name: New Guard Proposal
about: Propose a new guard method, validator category, or execution-context adapter
title: '[Proposal]: Guard.'
labels: enhancement
assignees: ''
---

## Proposed Guard Method Signature
```apex
// Example:
// public static Date isFutureDate(Date value, String paramName)
```

## Category
- [ ] General / Nullability
- [ ] Strings
- [ ] Numeric
- [ ] Collections
- [ ] Dates / Times
- [ ] Salesforce-Native (`Id`, `SObject`, `Schema`)
- [ ] Flow / Agentforce (`GuardFlowAction`)
- [ ] Context / `IGuardFailureHandler`

## Motivation & Use Case
Describe the repetitive `if/else` or Salesforce defensive pattern this guard eliminates.

## Positive Assertion & Failure Behavior
- **Valid Condition (passes and returns input):**
- **Invalid Condition (fails):**
- **Proposed `GuardException` Error Code Constant:** (e.g., `ERR_FUTURE_DATE`)
- **Default Error Message:** (e.g., `"Parameter 'closeDate' must be in the future, but was ..."`)

## Applicable Contexts
- [ ] `Guard.cls` (Standard / LWC / REST / Async)
- [ ] `GuardRecord.cls` (`SObjectField` `addError` support)
- [ ] `GuardFlowAction.cls` (`@InvocableMethod` rule)
