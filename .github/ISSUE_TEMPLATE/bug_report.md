---
name: Bug Report
about: Report a defect, overload ambiguity, or unexpected Quiddity behavior in ApexGuard
title: '[Bug]: '
labels: bug
assignees: ''
---

## Summary
A clear and concise description of the bug.

## Execution Context
- [ ] Standard Apex Service / Utility
- [ ] Apex Trigger (`Guard.onRecord`)
- [ ] Lightning Web Component / `@AuraEnabled` (`Quiddity.AURA` or `Guard.forLwc()`)
- [ ] Flow / Agentforce (`GuardFlowAction`)
- [ ] REST API (`Quiddity.REST`)
- [ ] Async Apex (`Queueable`, `Batch`, `Future`, `Scheduled`)

## Reproduction Code
```apex
// Minimal Apex snippet or @IsTest reproducing the issue
```

## Expected Behavior
What you expected to happen.

## Actual Behavior / Stack Trace
Paste the exact compiler error, `GuardException`, or `AuraHandledException` output.

## Environment
- Salesforce API Version: (e.g., 62.0)
- `ApexGuard` Version / Commit:
