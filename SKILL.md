---
name: deloitte-terraform-full-house
description: Generate full Terraform projects using Deloitte Terraform standards and modules
---

## References

For detailed guidance and supporting instructions, see the following reference documents:

- **[Module Generation](references/module-generation.md)** – Explains how the agent generates Terraform modules, inserts module blocks, manages variables, locals, tags, and ensures the project structure follows Deloitte standards.  
- **[Fetch Instructions](references/fetch-instructions.md)** – Step-by-step instructions for retrieving Terraform modules from the Deloitte Azure repository and placing them in the project correctly.

# Terraform Full House

This skill generates a complete Terraform project for infrastructure.

Capabilities:

- Creates Terraform project structure
- Adds Terraform modules
- Creates required files:
  - main.tf
  - variables.tf
  - terraform.tfvars
  - provider.tf
  - backend.tf
  - locals.tf
- Creates data.tf if data sources are needed
- Organizes modules under resources/
- Copies `status.md` from modules if it exists

Behavior:

1. Parse requested infrastructure from user prompt
2. Map requested resources to Deloitte Terraform modules
3. Run `scripts/fetch-module.sh <module> resources/<module>` to get module code
4. Insert module blocks into main.tf
   - For each module, add `tags = local.tags`
5. Place data blocks in data.tf
6. Place locals block in locals.tf
   - Include `project = <value from prompt or default>`
   - Include `tags = <default tags>`
7. Add missing variables to variables.tf
8. Add default values to terraform.tfvars
9. Ensure backend.tf exists with correct backend configuration