---
name: apex-guard-install
description: Use this skill when the user wants to install, deploy, or verify ApexGuard in a Salesforce org for the first time. Covers Released 2GP Unlocked Package links (04t), SFDX source deployment, install screen options (All Users vs Admins Only, Apex Compile), running the ApexGuard ApexTestSuite, and Execute Anonymous verification.
---

# Installing and Verifying ApexGuard

## Why ApexGuard Instead of Ad-Hoc Validation

Enterprise Salesforce orgs mix synchronous Services, Triggers, `@AuraEnabled` LWC controllers, Flows, Agentforce actions, `@RestResource` endpoints, and Async Apex (`Batchable`, `Queueable`, `@future`). Ad-hoc `if/else` validation duplicates boilerplate, leaks `"Script-thrown exception"` errors from LWC controllers, crashes triggers on unqueried `SObject` fields (`System.SObjectException`), and breaks partial DML in bulk transactions.

`ApexGuard` ships zero external dependencies, executes zero SOQL/DML, and handles every Salesforce runtime natively behind one static facade (`Guard`).

---

## Installation Options

Choose between the **Released 2GP Unlocked Package** (fastest for most orgs) or **SFDX Source Deployment** (best if your team maintains monorepo source customization).

### Option A: Released 2GP Unlocked Package (`ApexGuard@1.0.0-1`, Recommended)

* **Package ID (`Package2Id`):** `0Hod2000000768jCAA`
* **Subscriber Package Version ID:** `04td2000000WiM5AAK` (`Version 1.0.0.1`, Promoted/Released, `94%` package code coverage validated)
* **Namespace:** None (un-namespaced; all classes are called directly as `Guard.*`)
* **Salesforce API Version:** `62.0`

**1-Click Browser Install Links:**
* **Production / Developer Edition:** `https://login.salesforce.com/packaging/installPackage.apexp?p0=04td2000000WiM5AAK`
* **Sandbox / Scratch Org:** `https://test.salesforce.com/packaging/installPackage.apexp?p0=04td2000000WiM5AAK`

**Salesforce CLI (`sf`):**
```bash
sf package install \
  --package 04td2000000WiM5AAK \
  --security-type AllUsers \
  --apex-compile package \
  --wait 10 \
  --target-org my-org
```

> Always verify the latest version alias in [`sfdx-project.json`](../../sfdx-project.json) (`packageAliases`) or on the GitHub repository releases/README.

### Option B: Deploy Metadata from Source

```bash
git clone https://github.com/masaner/apex-guard.git
cd apex-guard
sf project deploy start --source-dir force-app --target-org my-org --wait 10
```

---

## Choosing Options on the Salesforce Package Install Screen

When installing in Setup UI via the 1-click browser link, Salesforce prompts for two settings:

### 1. Security Level: `Install for All Users` vs. `Install for Admins Only`

| Setting | When to Choose It | Impact on `ApexGuard` |
| :--- | :--- | :--- |
| **`Install for All Users`** *(Recommended Default)* | Most orgs, especially if Flows or Agentforce call `GuardFlowAction` (`@InvocableMethod`). | Grants Apex Class Access on all classes—including `GuardFlowAction`—so Screen Flows and Agentforce actions work immediately for non-admin users without runtime permission errors. |
| **`Install for Admins Only`** | Strict least-privilege orgs that manage all permissions via Permission Sets instead of Profiles. | `Guard.*` calls inside your Apex classes, Triggers, and `@AuraEnabled` controllers still work for every user immediately (Salesforce enforces class access only on entry-point classes). If non-admin users run Screen Flows or Agentforce topics calling `GuardFlowAction`, grant `GuardFlowAction` class access via a Permission Set. |

### 2. Advanced Options → Apex Compile

* **Select `Compile only the Apex in the package`** (`--apex-compile package`) — compiles only `ApexGuard`'s classes in seconds without being slowed down or blocked by unrelated pre-existing Apex in a large org.
* `Compile all Apex in the org (default)` is only needed if you intentionally want a full org-wide recompile during installation.

---

## Verify Installation with the Included `ApexTestSuite`

`ApexGuard` includes an official Salesforce `ApexTestSuite` (`ApexGuard.testSuite-meta.xml`) grouping all four test classes (`GuardContextTest`, `GuardFlowActionTest`, `GuardRecordTest`, `GuardTest`):

```bash
sf apex run test \
  --suite-names ApexGuard \
  --code-coverage \
  --result-format human \
  --wait 10 \
  --target-org my-org
```

Expect all **25/25 unit tests** to pass (`100%` pass rate).

---

## 30-Second Execute Anonymous Smoke Test (`0 SOQL | 0 DML`)

After installing the package or deploying source, run this script in **Developer Console → Debug → Open Execute Anonymous Window** (or VS Code `SFDX: Execute Anonymous Apex`) to verify pass-through returns, `GuardException.toMap()`, `GuardRecord.addError()`, LWC `AuraHandledException.setMessage()`, and opt-in CRUD/FLS checks:

```apex
// 1. Happy Path: Pass-through validation & opt-in schema check
String company = Guard.isNotBlank('Acme Corp', 'company');
Decimal discount = Guard.isInRange(15.5, 0, 50, 'discount');
Id sampleAccId = Guard.isIdOfType(
    Guard.isValidId('001000000000000AAA', 'sampleAccId'),
    Account.SObjectType,
    'sampleAccId'
);
Guard.isAccessible(Account.SObjectType);
Guard.isFieldAccessible(Account.Name);
System.debug('1. Happy path passed: ' + company + ' | discount=' + discount + ' | id=' + sampleAccId);

// 2. Fail-Fast GuardException + Structured JSON Metadata (Quiddity = ANONYMOUS)
try {
    Guard.isGreaterThan(-10, 0, 'orderTotal');
} catch (GuardException ex) {
    System.debug('2. Caught GuardException: ' + JSON.serializePretty(ex.toMap()));
}

// 3. Non-Throwing Trigger / Record Validation (Guard.onRecord)
Account invalidAcc = new Account(Name = '   ', NumberOfEmployees = -5);
GuardRecord recCheck = Guard.onRecord(invalidAcc)
    .isNotBlank(Account.Name)
    .isGreaterThan(Account.NumberOfEmployees, 0);
System.debug('3. GuardRecord hasErrors=' + recCheck.hasErrors() + ' | errors=' + recCheck.getErrorMessages());

// 4. LWC Mode (AuraHandledException with setMessage() populated)
try {
    Guard.forLwc().isNotBlank('', 'searchKey');
} catch (AuraHandledException auraEx) {
    System.debug('4. Caught AuraHandledException message: ' + auraEx.getMessage());
}
```

## Post-Install Troubleshooting

* **`You do not have access to the Apex class named 'GuardFlowAction'` in a Screen Flow or Agentforce action:** The package was installed for Admins Only and the running user lacks Apex Class Access to `GuardFlowAction`. Grant access via the user's Profile or a Permission Set.
* **Installing into a Production org fails saying package version is Beta:** Ensure you are using the promoted/released Subscriber Package Version ID `04td2000000WiM5AAK` (not an unpromoted build ID).

## Related Skills

* [apex-guard-usage](../apex-guard-usage/SKILL.md) — Refactor Apex Services, `@AuraEnabled` LWC controllers, REST APIs, and Async Apex.
* [apex-guard-triggers-and-bulk-dml](../apex-guard-triggers-and-bulk-dml/SKILL.md) — Use `Guard.onRecord()` in Triggers and partial DML.
* [apex-guard-flows-and-agentforce](../apex-guard-flows-and-agentforce/SKILL.md) — Configure `GuardFlowAction` in Flows and Agentforce.
* [apex-guard-testing](../apex-guard-testing/SKILL.md) — Write unit tests for code consuming `ApexGuard`.
