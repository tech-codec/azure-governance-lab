# Azure Governance with Terraform

A hands-on **Azure Governance as Code** project built with **Terraform** to demonstrate how cloud governance, security controls, and access management can be automated and version-controlled.

This project implements custom Azure Policy rules, policy assignments, RBAC, tagging standards, and resource protection using Terraform.

---

## Skills Demonstrated

![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA)
![Microsoft Azure](https://img.shields.io/badge/Microsoft-Azure-0078D4)
![Azure Policy](https://img.shields.io/badge/Azure-Policy-0078D4)
![RBAC](https://img.shields.io/badge/Azure-RBAC-0078D4)
![DevOps](https://img.shields.io/badge/DevOps-Governance-success)

This project demonstrates practical experience with:

- Terraform Infrastructure as Code
- Azure Policy
- Azure Policy Parameters
- Policy Assignments
- Azure RBAC
- Azure Resource Locks
- Azure Tags
- Governance enforcement
- Compliance testing
- Terraform variables
- Terraform validation and planning
- Azure CLI
- Git and GitHub

---

# Project Scenario

The project simulates governance requirements for a fictional organization called **TechCorp**.

TechCorp requires that:

- Azure resources are deployed only in approved regions.
- Resources contain an `Environment` tag.
- The `Environment` tag contains an approved value.
- Policies are configurable using parameters.
- Governance rules can operate in `Audit` or `Deny` mode.
- Access is controlled through Azure RBAC.
- Important resources are protected from accidental deletion.

Approved Azure regions:

```text
Canada Central
Canada East
```

Approved environment values:

```text
dev
staging
prod
```

---

# Architecture

```text
                    Azure Subscription
                           |
                           v
                  Resource Group
               rg-governance-demo
                           |
          +----------------+----------------+
          |                |                |
          v                v                v
       Azure RBAC      Azure Policy     Resource Lock
          |                |                |
    Contributor       Definition       CanNotDelete
                           |
                           v
                    Policy Assignment
                           |
               +-----------+-----------+
               |           |           |
               v           v           v
           Location    Required     Environment
            Rules        Tag          Values
               \           |           /
                \          |          /
                 +---------+---------+
                           |
                           v
                    Policy Evaluation
                           |
                   +-------+-------+
                   |               |
                   v               v
               Compliant      Non-Compliant
                                  |
                           Audit / Deny
```

---

# Azure Policy Logic

The custom policy detects three main governance violations:

```text
Invalid Azure region

OR

Missing Environment tag

OR

Environment tag exists
AND
Environment value is invalid
```

Conceptually:

```text
IF
(
    location NOT IN allowedLocations
)

OR

(
    Environment tag does not exist
)

OR

(
    Environment tag exists
    AND
    Environment NOT IN allowedEnvironments
)

THEN

    Audit or Deny
```

---

# Azure Policy Concepts Used

## Policy Parameters

The policy uses reusable parameters instead of hard-coded values.

Examples:

```text
allowedLocations
allowedEnvironments
effect
```

Terraform variables provide values to the Policy Assignment:

```text
terraform.tfvars
       |
       v
Terraform Variables
       |
       v
Policy Assignment
       |
       v
Azure Policy Parameters
       |
       v
Policy Conditions
```

Example:

```text
var.allowed_locations
        |
        v
allowedLocations
        |
        v
parameters('allowedLocations')
        |
        v
location notIn allowedLocations
```

---

## Policy Conditions

The project practices the following Azure Policy operators:

| Operator | Purpose                                 |
| -------- | --------------------------------------- |
| `field`  | Select a resource property              |
| `equals` | Compare against one value               |
| `in`     | Check whether a value exists in a list  |
| `notIn`  | Check whether a value is outside a list |
| `exists` | Check whether a property exists         |
| `allOf`  | Logical AND                             |
| `anyOf`  | Logical OR                              |

Example logic:

```text
anyOf
|
+-- location notIn allowedLocations
|
+-- Environment exists = false
|
+-- allOf
    |
    +-- Environment exists = true
    |
    +-- Environment notIn allowedEnvironments
```

---

# Policy Effects

The project supports configurable policy effects.

### Audit

Allows deployment but identifies the resource as non-compliant.

```text
Violation
    |
    v
Resource deployed
    |
    v
Marked non-compliant
```

### Deny

Blocks deployment when the resource violates governance rules.

```text
Violation
    |
    v
Azure Policy
    |
    v
Deployment blocked
```

### Disabled

Disables policy enforcement.

The recommended workflow used in this project is:

```text
Audit
  |
  v
Observe compliance
  |
  v
Validate policy
  |
  v
Deny
```

---

# RBAC

Azure RBAC controls **who can perform actions**.

The project creates a role assignment similar to:

```text
Identity
+
Contributor
+
Resource Group
=
Role Assignment
```

RBAC and Azure Policy serve different purposes:

```text
RBAC
|
+-- WHO can perform an action?


Azure Policy
|
+-- WHAT configurations are allowed?
```

A user may have permission to deploy a Storage Account through RBAC, while Azure Policy can still block that Storage Account if it violates governance requirements.

---

# Resource Protection

The Resource Group is protected with a:

```text
CanNotDelete
```

Azure Resource Lock.

This helps protect infrastructure from accidental deletion.

---

# Project Structure

```text
azure-governance-lab/
|
├── providers.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── policy.tf
├── rbac.tf
├── lock.tf
├── test-resources.tf
├── outputs.tf
└── README.md
```

### `providers.tf`

Terraform and AzureRM provider configuration.

### `variables.tf`

Reusable Terraform variables.

### `terraform.tfvars`

Environment-specific values.

### `main.tf`

Core Azure resources.

### `policy.tf`

Custom Azure Policy Definition and Policy Assignment.

### `rbac.tf`

Azure Role Assignment configuration.

### `lock.tf`

Azure Resource Lock configuration.

### `test-resources.tf`

Resources used to test compliant and non-compliant configurations.

---

# Prerequisites

Before deploying the project, install:

- Terraform
- Azure CLI
- Git

You also need an Azure subscription with sufficient permissions to create the resources used by the project.

Verify Terraform:

```bash
terraform version
```

Verify Azure CLI:

```bash
az version
```

---

# Deployment

Clone the repository:

```bash
git clone <YOUR-REPOSITORY-URL>
```

Enter the project directory:

```bash
cd azure-governance-lab
```

Authenticate with Azure:

```bash
az login
```

Check the active subscription:

```bash
az account show -o table
```

Initialize Terraform:

```bash
terraform init
```

Format the project:

```bash
terraform fmt -recursive
```

Validate the configuration:

```bash
terraform validate
```

Preview the deployment:

```bash
terraform plan
```

Deploy:

```bash
terraform apply
```

---

# Testing

The project includes multiple governance test scenarios.

## Compliant Resource

```text
Location = Canada Central
Environment = dev
```

Expected result:

```text
Allowed region        ✅
Environment tag       ✅
Valid tag value       ✅

Compliant
```

---

## Invalid Region

```text
Location = East US
Environment = dev
```

Evaluation:

```text
eastus NOT IN

[
  canadacentral,
  canadaeast
]

TRUE
```

Expected result:

```text
Audit → Non-compliant

Deny → Deployment blocked
```

---

## Missing Environment Tag

```text
Location = Canada Central
Environment = missing
```

Expected result:

```text
Environment exists = false

Policy violation
```

---

## Invalid Environment

```text
Location = Canada Central
Environment = production
```

Approved values:

```text
dev
staging
prod
```

Evaluation:

```text
Environment exists = true

AND

production NOT IN allowedEnvironments

TRUE
```

Expected result:

```text
Policy violation
```

---

# Checking Compliance

After deployment, policy compliance can be reviewed in the Azure Portal:

```text
Azure Policy
    |
    +-- Compliance
```

The custom policy can also be inspected under:

```text
Azure Policy
    |
    +-- Definitions
```

and its assignment under:

```text
Azure Policy
    |
    +-- Assignments
```

---

# Key Takeaways

This project demonstrates how Terraform can be used to implement **Governance as Code**.

```text
Azure Governance
=
Azure Policy
+
RBAC
+
Tags
+
Resource Locks
+
Governance Standards
```

Azure Policy can be understood as:

```text
Policy Definition
=
Parameters
+
Conditions
+
Effect
```

A Policy Assignment adds:

```text
Policy Assignment
=
Policy Definition
+
Scope
+
Parameter Values
```

The complete Terraform workflow is:

```text
Terraform Variables
        |
        v
Policy Parameters
        |
        v
Policy Definition
        |
        v
Policy Assignment
        |
        v
Azure Resources
        |
        v
Policy Evaluation
        |
        +------ Compliant
        |
        +------ Non-Compliant
```

---

# Future Improvements

Planned improvements for this project include:

- Azure Policy Initiatives
- Management Groups
- Subscription-level governance
- Allowed VM SKU policies
- Storage Account security policies
- Public network access restrictions
- Required HTTPS policies
- Private Endpoint policies
- Diagnostic Settings policies
- `Modify` policy effects
- `DeployIfNotExists`
- Policy exemptions
- Terraform modules
- GitHub Actions CI/CD
- Separate Dev, Staging, and Production governance configurations

A future enterprise version could use:

```text
Azure Management Group
|
├── Development
|      |
|      +-- Audit policies
|
├── Staging
|      |
|      +-- Audit / Deny
|
└── Production
       |
       +-- Deny policies
```

---

## Project Purpose

This project was built to strengthen hands-on skills in:

**Microsoft Azure, Terraform, Infrastructure as Code, Azure Governance, Azure Policy, RBAC, Cloud Security, and DevOps.**
