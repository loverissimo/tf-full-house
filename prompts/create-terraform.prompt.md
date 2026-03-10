# Create Terraform Project – Deloitte Terraform Full House

This prompt instructs the **deloitte-terraform-full-house** Copilot agent to generate a **complete Terraform infrastructure project** using Deloitte Terraform modules.

The agent must follow the structure and rules defined below.

---

# Objective

When a user asks for infrastructure (for example: *resource group*, *virtual network*, *storage account*), generate a **complete Terraform project structure** and use modules from the Deloitte Azure DevOps Terraform repository.

# Module Fetch Instructions

- When a user requests a resource (e.g., vnet, subnet, vm), run:
  `fetch-module.sh <resource_name> resources/<resource_name>`
- The script will search all folders in `/child modules/tested and working/` for a folder named `<resource_name>`.
- It copies all module files and `status.md` if it exists.
- Place the module in the project `resources/` folder.
- Only create data.tf if data blocks are needed.

---

# Required Terraform Project Structure

If the project does not already contain Terraform files, create the following structure:

```
.
├── main.tf
├── provider.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
├── data.tf
├── locals.tf
└── resources/
```

If any of these files are missing, create them.

Do **not overwrite existing files** unless adding required content.

---

# File Responsibilities

## main.tf

Contains:

* module blocks
* resource blocks (if necessary)

Do NOT place:

* variables
* locals
* data sources

Example:

```hcl
module "resource_group" {
  source = "./resources/resource_group"

  name     = var.resource_group_name
  location = local.location
}
```

---

## provider.tf

Ensure the AzureRM provider exists.

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

---

## backend.tf

Ensure a Terraform backend configuration exists.

Example template:

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

---

## variables.tf

All Terraform variables must be defined here.

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

---

## terraform.tfvars

Contains default values for variables.

Example:

```hcl
location            = "westeurope"
resource_group_name = "rg-demo"
vnet_name           = "vnet-demo"
```

---

## data.tf

All Terraform **data blocks must be placed here**.

Example:

```hcl
data "azurerm_subscription" "current" {}
```

If `data.tf` does not exist, create it.

---

## locals.tf

All **locals blocks must be placed here**.

Example:

```hcl
locals {
  location = var.location
  environment = "dev"
}
```

If `locals.tf` does not exist, create it.

---

# Module Handling

When the user requests infrastructure resources:

1. Identify the Terraform module required.
2. Copy the module from the Deloitte Terraform repository.
3. Place it in:

```
resources/<module_name>/
```

4. Also copy status.md if it exists in the source module folder. Place it alongside main.tf, variables.tf, and outputs.tf.

Example:

```
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
```

---

# Module Usage in main.tf

Each module must be referenced in `main.tf`.

Example:

```hcl
module "resource_group" {
  source = "./resources/resource_group"

  name     = var.resource_group_name
  location = local.location
}

module "vnet" {
  source = "./resources/vnet"

  name                = var.vnet_name
  location            = local.location
  resource_group_name = var.resource_group_name
}
```

---

# Variable Management

If module inputs require variables:

1. Check if the variable exists in `variables.tf`.
2. If missing, add it.
3. Add a default value in `terraform.tfvars`.

---

# File Creation Rules

Always ensure the following files exist:

* main.tf
* provider.tf
* backend.tf
* variables.tf
* terraform.tfvars
* data.tf
* locals.tf

Create them if missing.

---

# Terraform Quality Rules

Generated Terraform must:

* follow Terraform best practices
* be syntactically valid
* avoid duplicated variables
* reference locals where possible
* keep logic clean and modular

---

# Example User Prompt

User request:

Create an Azure resource group and virtual network

Expected result:

```
resources/
   resource_group/
   vnet/

main.tf
variables.tf
terraform.tfvars
provider.tf
backend.tf
data.tf
locals.tf
```

`main.tf` should contain module calls.

`locals.tf` should contain reusable values.

`data.tf` should contain data sources.

---

# Agent Behavior

The agent must:

* parse the user request
* determine required modules
* generate Terraform structure
* ensure required files exist
* update variables and tfvars
* place blocks in the correct files

Never mix block types across files.

Use:

* `main.tf` → modules/resources
* `variables.tf` → variables
* `terraform.tfvars` → variable values
* `locals.tf` → locals
* `data.tf` → data sources

---

End of instructions.
