# Terraform Modules Generation – Deloitte Terraform Full House

Part of: deloitte-terraform-full-house  
Purpose: Define how the agent generates and integrates Terraform modules into a complete project according to Deloitte standards.

This document focuses on **module generation behavior**, including file creation, block placement, variable handling, module naming, and project scaffolding.

---

# Objective

When a user requests infrastructure (e.g., *resource group*, *virtual network*, *storage account*), the agent must:

- Identify required modules from the Deloitte GitHub repository.  
- Generate a complete Terraform project structure.  
- Place module code, variables, locals, and data blocks in the correct files.  
- Ensure modules follow Deloitte standards for tags, consistency, and naming.

---

# Required Terraform Project Structure
.
├── main.tf
├── provider.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
├── data.tf # Optional
├── locals.tf
└── resources/

- Do not overwrite existing files unless adding required content.  
- Ensure these files always exist: main.tf, provider.tf, backend.tf, variables.tf, terraform.tfvars, locals.tf.

---

# File Responsibilities

## main.tf

- **Contains module blocks only**.  
- Each module input must use **`var.<module_name>_<var_name>`**.  
- No hardcoded values allowed.  
- Module blocks must be grouped by resource type with comment headers:

```
###################
# <Resource Type>
###################
```

- Multiple instances of the same module must increment numeric suffixes:

module "resource_group" { ... }
module "resource_group_2" { ... }

## provider.tf

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

## backend.tf

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "tfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

## variables.tf
- Must define all module input variables.
- Never include default values.
- Use naming convention: <module_name>_<var_name>.

```hcl
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for VNet"
  type        = list(string)
}
```

## terraform.tfvars
- All variables defined in variables.tf must appear here.
- Assign values for every variable; comment unknown values.
- Use numeric suffixes for multiple instances.

Example:

```hcl
project             = "terraform-full-house"
environment         = "dev"
resource_group_name  = "rg-demo"
resource_group_2_name = "rg-demo-2"
vnet_name           = "vnet-demo"
vnet_2_name         = "vnet-demo-2"
```

## locals.tf

```hcl
locals {
  project     = var.project
  environment = var.environment

  tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "terraform"
  }
}
```

## data.tf
- Only created if the user prompt requests data sources.
- Place all Terraform data blocks here.

---

# Module Naming & Handling
1. Each module must be named exactly as the repository folder.
2. Module input variables must follow <module_name>_<var_name> convention.
3. If multiple instances exist, increment numeric suffixes (_2, _3, etc.) for both module and variable names.
4. Never hardcode values in modules or module calls.
5. Modules must always be fetched from the repository using:

```bash
./scripts/fetch-module.sh <module_name> resources/<module_name>
```

6. Module blocks must always include tags = local.tags.

---

# Strict Terraform Generation Rules

1. main.tf must contain module blocks only.
2. terraform blocks must never appear in main.tf.
3. provider blocks must never appear in main.tf.
4. Module paths must always use:
./resources/<module_name>
5. Module folder names must match repository names exactly.
6. Infrastructure must never be created using resource blocks in the root project.
7. All variables must be instantiated in terraform.tfvars.
8. Never define default values in variables.tf or inside module calls.
9. Use numeric suffixes for multiple instances of the same module.
10. Module blocks must be grouped by resource type using comment headers.

--- 

# Module Block Example

```hcl
###################
# Resource Groups #
###################

module "resource_group" {
  source = "./resources/resource_group"

  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

module "resource_group_2" {
  source = "./resources/resource_group"

  name     = var.resource_group_2_name
  location = var.location
  tags     = local.tags
}
```

- Repeat similar blocks for networking, compute, storage, security, etc.