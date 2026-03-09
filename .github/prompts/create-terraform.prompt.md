# Deloitte Terraform Full House Prompt

You are an expert Terraform automation assistant. Your goal is to generate a **full Terraform project** for Azure using Deloitte's internal Terraform modules located in the Azure DevOps repo:

https://dev.azure.com/carlosbteixeira/_git/Terraform%20repository%20for%20Azure?path=/child%20modules/tested%20and%20working

---

## Instructions

1. **Project structure**  
   Ensure the following project structure exists. Create missing files/folders:


I want to create a Github copilot custom that return terraform code files based on the repo https://dev.azure.com/carlosbteixeira/_git/Terraform%20repository%20for%20Azure?path=/child%20modules/tested%20and%20working, e.g if the users prompt asks for a resource group and a vnet, it should add the parent files (from the repo) in the resources folder and in the main folder add the module code in main.tf, add variables.tf and all the files needed if they dont existe (tfvars, provider.tf etc)


the agent will be named deloitte-terraform-full-house


use this info: https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions?tool=vscode
https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-skills



the agent should be able to be installed by anyone similar to how this other agent is installed -> https://github.com/antonbabenko/terraform-skill/tree/master



this agent should be easy to install for more people in my company, give a simple step by step guide

You can absolutely build a Copilot Agent/Skill that generates full Terraform project scaffolding from your internal module repo. The approach used by the Terraform skill from Anton Babenko is a good reference architecture.

Below is a practical architecture + ready-to-use templates + installation guide for your agent:

Agent name: deloitte-terraform-full-house

Goal:
When a user prompts:

“Create a resource group and vnet”

The agent will:

Pull module patterns from your Azure DevOps Terraform repo

Create a complete Terraform project

Ensure required files exist:

main.tf

variables.tf

terraform.tfvars

provider.tf

backend.tf

Add modules under /resources

Add module calls in root /main.tf

Copilot will follow instructions from .github/copilot-instructions.md, which is automatically injected into prompts for the repository. 

1. Recommended Repository Structure
Create a public GitHub repo for the skill so others in Deloitte can install it.

Example:

deloitte-terraform-full-house/
│
├── .github/
│   ├── copilot-instructions.md
│   ├── prompts/
│   │    └── generate-terraform.prompt.md
│
├── skills/
│   └── terraform-project/
│        └── SKILL.md
│
├── templates/
│   ├── provider.tf
│   ├── backend.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│
└── README.md
This mirrors how the Terraform skill repo works.

2. Copilot Repository Instructions
Create:

.github/copilot-instructions.md
Example:

# Deloitte Terraform Full House Agent

You are an infrastructure automation agent specialized in Terraform for Azure.

Your goal is to generate FULL terraform projects using modules from the Deloitte Azure DevOps repository:

https://dev.azure.com/carlosbteixeira/_git/Terraform repository for Azure

The modules are located in:

/child modules/tested and working

## Behaviour

When a user asks for infrastructure (example: resource group, vnet):

1. Create a Terraform project structure if it does not exist.

Required files in root:

- main.tf
- provider.tf
- backend.tf
- variables.tf
- terraform.tfvars

2. Create a directory:
resources/


3. Copy module structure from the Azure DevOps repository into:
resources/<module_name>/


4. Add module calls in root main.tf.

Example:
module "resource_group" {
source = "./resources/resource_group"

name = var.resource_group_name
location = var.location
}


5. If variables do not exist:
- add them to variables.tf
- add default values to terraform.tfvars

6. Always ensure the provider block exists:

provider "azurerm" {
  features {}
}

7. Generated Terraform must be production ready.
3. Skill Definition
Create:

skills/terraform-project/SKILL.md
Example:

---
name: deloitte-terraform-full-house
description: Generate full Terraform Azure infrastructure projects using Deloitte modules
---

# Deloitte Terraform Full House

This skill generates Terraform infrastructure projects using Deloitte Azure modules.

## Capabilities

- Generate Terraform infrastructure
- Create missing Terraform files
- Use modules from the Deloitte Azure DevOps repo
- Build complete IaC projects

## Workflow

1. Parse requested infrastructure resources
2. Map resources to modules
3. Create Terraform project structure
4. Import modules
5. Generate module calls
6. Add variables and tfvars

## Project structure
.
├── main.tf
├── provider.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
└── resources/


## Example

User prompt:
Create an Azure resource group and virtual network


Output:
resources/
resource_group/
vnet/

main.tf
variables.tf
terraform.tfvars
provider.tf
backend.tf


The agent must ensure all files exist.
4. Terraform Template Files
Example templates/provider.tf

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
Example templates/backend.tf

terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "tfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
Example templates/variables.tf

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  type = string
}
Example templates/terraform.tfvars

location = "westeurope"
resource_group_name = "rg-demo"
5. Prompt File (Reusable Command)
Create:

.github/prompts/generate-terraform.prompt.md
Example:

Generate a Terraform project using the Deloitte Terraform Full House standard.

Requirements:

- Create project structure if missing
- Use Azure modules from Deloitte repo
- Ensure required files exist
- Add module calls in main.tf
- Add variables to variables.tf
- Add values to terraform.tfvars

User request:
Then the user runs in Copilot Chat:

/generate-terraform

Create a resource group and vnet
6. Example Output (What Copilot Will Generate)
Folder structure:

.
├── main.tf
├── provider.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
└── resources
    ├── resource_group
    └── vnet
Example main.tf

module "resource_group" {
  source = "./resources/resource_group"

  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source = "./resources/vnet"

  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
}
7. Easy Installation Guide (For Deloitte Engineers)
Put this in your README.

Install Deloitte Terraform Full House Copilot Agent
1. Install Copilot Extension
Install:

GitHub Copilot

GitHub Copilot Chat

In VS Code

2. Clone the Agent Repository
git clone https://github.com/<org>/deloitte-terraform-full-house
3. Open Folder in VSCode
File → Open Folder
Select the repository.

4. Enable Copilot Instructions
Ensure VSCode setting is enabled:

Code Generation: Use Instruction Files
5. Use the Agent
Open Copilot Chat and type:

Create an Azure resource group and vnet using Deloitte Terraform modules
Copilot will generate:

Terraform project

module imports

variables

tfvars

providers

8. Enterprise Improvement (Highly Recommended)
To make this much smarter, add:

1️⃣ Module mapping file

modules-map.yaml
Example:

resource_group: resource_group
vnet: virtual_network
aks: aks_cluster
storage: storage_account
keyvault: key_vault
This lets the agent automatically map requests → modules.

2️⃣ Module examples

Add examples from your repo so Copilot learns the pattern.

3️⃣ Internal documentation

Add:

docs/terraform-standards.md
9. Next-Level Version (Much More Powerful)
If you want, I can also show how to upgrade this into a true Copilot Coding Agent with tools that:

pulls modules directly from Azure DevOps

auto-detects module inputs

builds Terraform automatically

validates with terraform validate

This turns it into a real internal Terraform generator instead of just prompts.

It’s about 10× more powerful and still installable like the Anton Babenko skill.


what should i put in .github/prompts/generate-terraform.prompt.md

For .github/prompts/generate-terraform.prompt.md, you want a clear, reusable prompt template that tells Copilot exactly how to generate a full Terraform project using your Deloitte modules. This file is essentially the “instruction sheet” the Copilot agent will follow whenever someone triggers /generate-terraform.

Here’s a ready-to-use version for your deloitte-terraform-full-house agent:

# Deloitte Terraform Full House Prompt

You are an expert Terraform automation assistant. Your goal is to generate a **full Terraform project** for Azure using Deloitte's internal Terraform modules located in the Azure DevOps repo:

https://dev.azure.com/carlosbteixeira/_git/Terraform%20repository%20for%20Azure?path=/child%20modules/tested%20and%20working

---

## Instructions

1. **Project structure**  
   Ensure the following project structure exists. Create missing files/folders:
.
├── main.tf
├── provider.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
└── resources/


2. **Modules**  
   For each requested resource (e.g., resource group, vnet, storage account), do the following:

   - Copy the corresponding module from the Azure DevOps repository into `resources/<module_name>/`
   - Add a module block in `main.tf` with proper references to variables
   - Example:

     module "resource_group" {
     source = "./resources/resource_group"

     name     = var.resource_group_name
     location = var.location
    }

3. **Variables**

  Add any required variables to variables.tf

  Add default values (if known) to terraform.tfvars

4. **Provider**

  Ensure provider.tf includes:

  provider "azurerm" {
    features {}
  }

5. **Backend**
  Ensure backend.tf exists (can be templated).

6. **Generated Terraform**
  Must be valid and production-ready.

  Use correct references between modules, variables, and tfvars.

  Include resource dependencies if necessary.

