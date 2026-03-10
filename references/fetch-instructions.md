# Module Fetch Instructions – Deloitte Terraform Full House

Part of: deloitte-terraform-full-house  
Purpose: Describe how the agent retrieves Terraform modules from the Deloitte Azure repository and places them in a new project.

This document outlines the process the agent follows to fetch Terraform modules requested by the user, including repository paths, scripts, and file placement rules.

---

## Repository

All Terraform modules are stored in the Deloitte Azure repository:

[Terraform Repository for Azure](https://dev.azure.com/carlosbteixeira/_git/Terraform%20repository%20for%20Azure?path=/child%20modules/tested%20and%20working)

- Modules are organized under:  

/child modules/tested and working/<theme>/<module_name>/

- Each module may contain:
- `main.tf`  
- `variables.tf`  
- `outputs.tf`  
- `status.md` (optional)

---

## Fetch Script

The agent uses a script to retrieve modules:

```bash
fetch-module.sh <resource_name> resources/<resource_name>
```

- <resource_name>: Name of the module requested by the user (e.g., vnet, subnet, vm).

- resources/<resource_name>: Destination folder in the generated project.

---

# Fetch Process
1. The script searches all folders in:

/child modules/tested and working/

for the folder named <resource_name>.

2. Copies the following files from the module folder:

- main.tf
- variables.tf
- outputs.tf
- status.md (if it exists)

3. Places the module in the project under:

resources/<resource_name>/

4. If the user prompt requires data sources, the agent will also create data.tf in the project.

---

# Best Practices
- Do not overwrite existing module files in the project unless explicitly required.
- Ensure that module names match exactly with the folder names in the repository.
- Use the fetch script consistently for all requested modules to maintain a clean project structure.

---

# Example
User request: “Create an Azure resource group and virtual network.”

The agent will execute:

```bash
fetch-module.sh resource_group resources/resource_group
fetch-module.sh vnet resources/vnet
```

- Module folders are copied into resources/.
- main.tf will include module blocks referencing the copied modules.
- data.tf will be created only if the modules require data sources.