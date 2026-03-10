# Deloitte Terraform Full House

**`deloitte-terraform-full-house`** is a GitHub Copilot agent skill that generates **complete Terraform infrastructure projects** using standardized Deloitte modules.

It helps engineers quickly scaffold production-ready Terraform environments by simply describing the infrastructure they want in **Copilot Chat**.

Example prompt:

```
Create an Azure resource group and virtual network
```

The agent will automatically generate:

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
    ├── resource_group/
    └── vnet/
```

---

# Features

* Generates **full Terraform project structure**
* Uses **Deloitte Terraform modules**
* Automatically creates missing Terraform files
* Separates Terraform logic across best-practice files
* Automatically manages variables and tfvars
* Organizes modules inside `/resources`
* Supports multiple infrastructure resources in one prompt

---

# Terraform File Structure

The generated projects follow this standardized layout:

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

### File responsibilities

| File               | Purpose                      |
| ------------------ | ---------------------------- |
| `main.tf`          | module and resource blocks   |
| `provider.tf`      | Azure provider configuration |
| `backend.tf`       | Terraform remote backend     |
| `variables.tf`     | variable definitions         |
| `terraform.tfvars` | variable values              |
| `data.tf`          | Terraform data blocks        |
| `locals.tf`        | local values                 |
| `resources/`       | Terraform modules            |

# Terraform Modules Source

Modules are sourced from the Deloitte Github repository:

```
https://github.com/loverissimo/tf-full-house
```

Each requested resource will be copied into:

```
resources/<module_name>/
```

---

# Installation

## 1 Install VS Code Extensions

Install the following extensions:

* GitHub Copilot
* GitHub Copilot Chat

---

## 2 Clone the Agent Repository

```
git clone https://github.com/loverissimo/deloitte-terraform-full-house
```

Open the repository in **VS Code**.

---

## 3 Enable Copilot Instruction Files

Make sure this setting is enabled in VS Code:

```
Settings → GitHub Copilot → Use Instruction Files
```

This allows Copilot to read:

```
references/fetch-instructions.md
references/module-generation.md
```

---

## 4 Use the Agent

Open **Copilot Chat** in VS Code and ask for infrastructure.

Example prompts:

```
Create an Azure resource group
```

```
Create an Azure resource group and vnet
```

```
Create an Azure resource group, vnet and storage account
```

The agent will generate the Terraform files automatically.

---

# Prompt Usage

The agent can also be triggered using the prompt file:

```
/full-house
```

Example:

```
/full-house

Create an Azure resource group and vnet
```

---

# Best Practices Enforced

This agent enforces the following Terraform practices:

* modular Terraform architecture
* clear separation of configuration files
* reusable local variables
* organized module structure
* consistent variable management
* production-ready Terraform code

---

# Contributing

If you want to improve this agent:

1. Fork the repository
2. Add new modules or prompt improvements
3. Submit a pull request

---

# License

Internal Deloitte use.
