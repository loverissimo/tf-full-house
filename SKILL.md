---
name: full-house
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
  - provider.tf
  - backend.tf
  - variables.tf
  - terraform.tfvars
  - locals.tf
- Creates data.tf if data sources are needed
- Organizes modules under resources/
- Copies `status.md` from modules if it exists

# Behavior

1. Parse requested infrastructure from user prompt.
2. Map requested resources to Deloitte Terraform modules.
3. Resolve and run the fetch script using an explicit path (so it works from any target repository):
   - Prefer repo-local: `./scripts/fetch-modules.sh`
   - Fallback to personal-skill install path:
     - `~/.github/skills/full-house/scripts/fetch-modules.sh`
     - `~/.github/skill/full-house/scripts/fetch-modules.sh`
   - Execute with `bash "<resolved_script_path>" <module> resources/<module>`
4. Insert module blocks into `main.tf` using the canonical project template defined in `module-generation.md`.
   - For each module, always use `tags = local.tags`.
5. Place data blocks in `data.tf` if needed.
6. Place locals block in `locals.tf` with:
   - `project = var.project`
   - `tags = local.tags`
7. Add **all required variables** to `variables.tf` without defaults.
8. Populate **all variables in terraform.tfvars**, including numeric suffixes for multiple instances.
9. Ensure modules follow `<module_name>_<var_name>` naming convention.

# Important Rules

- Always use modules from the Deloitte repository.
- Modules must always be fetched using `fetch-modules.sh`.
- Do not assume the current repository contains the script; resolve the script path first and execute it by explicit path.
- **Never define default values in variables.tf.** All variables must be instantiated in terraform.tfvars.
- **Never hardcode module input values** inside main.tf.
- If more than one module of the same type is requested, increment numeric suffixes (`resource_group_2`, `vnet_2`, etc.) for both module names and variable names.
- Module blocks in main.tf must be grouped by resource type using comment headers:

```
###################
# <Resource Type>
###################
```

- Root project files must **never contain resource blocks**; all infrastructure must be built using modules only.

Example:
module "resource_group" {
source = "./resources/resource_group"

name = var.resource_group_name
location = var.location
tags = local.tags
}
