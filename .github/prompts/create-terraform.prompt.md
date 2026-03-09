---
agent: agent
description: Generate Terraform infrastructure using Deloitte Terraform modules
---

Use the **deloitte-terraform-full-house** agent.

Task:

1. Identify Azure resources requested by the user
2. Generate a Terraform project structure
3. Use modules from the Deloitte Terraform repository

User request:

{{input}}

Required output:

terraform-project/
main.tf
variables.tf
terraform.tfvars
providers.tf
backend.tf
resources/

Add all Terraform files needed.