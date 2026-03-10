# Terraform Modules Generation – Deloitte Terraform Full House

Part of: deloitte-terraform-full-house  
Purpose: Explain how the agent generates and integrates Terraform modules into a complete project according to Deloitte standards.

This document focuses on **module generation behavior**, including file creation, block placement, variable handling, and project scaffolding. It focuses on ensuring the agent can generate a fully scaffolded Terraform project according to Deloitte standards.  

For high-level principles, patterns, and module usage, see the main `SKILL.md` file.
---


# Objective

When a user requests infrastructure (e.g., *resource group*, *virtual network*, *storage account*), the agent must:

- Identify required modules from the Deloitte Azure repository.  
- Generate a complete Terraform project structure.  
- Place module code, variables, locals, and data blocks in the correct files.  
- Ensure modules follow Deloitte standards for tags and consistency.

---

# Required Terraform Project Structure & File Creation

If the project does not already contain Terraform files, create the following structure:

.
├── main.tf
├── provider.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
├── data.tf      # Only if requested
├── locals.tf
└── resources/

- Do not overwrite existing files unless adding required content.
- Always ensure these files exist: main.tf, provider.tf, backend.tf, variables.tf, terraform.tfvars, locals.tf.

# File Responsibilities & Examples

## main.tf
Contains: 
- module blocks

Never place the following blocks in main.tf:
- terraform
- provider
- variable
- locals
- data

- Always include tags = local.tags for consistency.

Example:

```hcl
module "resource_group" {
  source = "./resources/resource_group"

  name     = var.resource_group_name
  location = local.location
  tags     = local.tags
}
```

## provider.tf
Ensure the AzureRM provider exists.
terraform blocks may exist only in provider.tf and backend.tf

Example:

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
Ensure a Terraform backend configuration exists.

Example:

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

- This file must always exist.

## variables.tf
All Terraform variables must be defined here.

- Check if module inputs require variables.
- If missing, add them to variables.tf.

Example:

```hcl
variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}
```

## terraform.tfvars
Contains default values for variables.

Example:

```hcl
location            = "westeurope"
resource_group_name = "rg-demo"
vnet_name           = "vnet-demo"
```

- Add default values in terraform.tfvars.

## data.tf
- Place all Terraform data blocks here.
- Only create data.tf if the prompt explicitly requests data sources.

Example:

```hcl
data "azurerm_subscription" "current" {}
```

## locals.tf
- Place all locals blocks here.
- Always include a default project value and default tags map.

Example:

```hcl
locals {
  project = "demo-project"
  environment = "dev"

  tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Deloitte"
  }
}
```

# Module Handling & Usage
When a user requests infrastructure resources:
1. Identify the required Terraform module.
2. Copy the module from the Deloitte Terraform repository.
3. Place it under:

resources/<module_name>/

4. Also copy status.md if it exists, alongside main.tf, variables.tf, and outputs.tf.

Example module layout:

resources/
   resource_group/
       main.tf
       variables.tf
       outputs.tf
       status.md
   vnet/
       main.tf
       variables.tf
       outputs.tf
       status.md