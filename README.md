# Infrastructure as Code using Terraform

Infrastructure as code (IaC) uses DevOps methodology and versioning with a
descriptive model to define and deploy infrastructure, such as networks, virtual
machines, load balancers, and connection topologies. Just as the same source
code always generates the same binary, an IaC model generates the same
environment every time it deploys.

There are many tools available for managing your infrastructure using
declarative definition files such as:
* [Ansible](https://www.ansible.com/)
* [ARM (Azure resource manager) template files](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)
* [Chef](https://www.chef.io/)
* [Pulumi](https://www.pulumi.com)
* [Terraform](https://www.terraform.io/)

## Key take-aways
* Repeatable proven process - we will always get the same output
* Automation - we can apply/deploy IaC using Ci/CD pipelines
* Alterations can be made in separate branches, allowing peers to review any
  changes using Pull Requests, before merging to the main branch and applying
  to production
* Abstractions - Most tools have their own definition structure to define IaC,
  allowing DevOps to work on both AWS and Azure resources without knowing the
  exact API's/CLI tools for these cloud providers. (partially true)

We'll discuss terraform in this meeting as we also use this for the Ivenza
platfom deployment in Azure.

# Azure portal

Create resource group
Create storage account (unique name)
Create container within the storage account

# Setup
Setup of Terraform easy, it's available on all platforms. You could either
download the binary, or install using the package manager for your OS (Homebrew,
APT, Chocolatey, DNF, etc).

> Personally, I run this in a container/toolbox, so my Host OS doesn't know
> anything about Terraform, keeping my OS nice and clean.

Make sure, when using the azurerm resources, you also have the azure cli
installed, logged in and set to the proper storage account. Terraform will
translate your files to Azure API calls using the azure cli tooling.

```bash
az login
az account set --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

# Workflow

```bash
terraform init
terraform validate
terraform plan
terraform fmt
terraform apply
terraform output
terraform destroy
```
# Do the same with Terraform for a simple resource.
01 - create resource, creates a resource to the 

## State files / security
Highlight why state files should not be locally stored or kept in a version
control system.

Remote state / state file / definition files...they should be aligned.
* Create a tag in the portal to the resource...terraform will remove it.

## Variables
* For loops
* Validation
* Complex types


## Modules
Tell about modules, and how they can be re-used.
### Outputs
* Tell how to re-use outputs
* Sensitive outputs

## Environments
During our development life cycle, we often encounter the following
environments:
* Development
* Staging
* Production

Ideally, we want to work and tweak each environment separately from each other.
There are 2 ways we can do this:
* Terraform workspaces
* Different working directories

When using terraform workspaces, you'll have to create workspaces from the CLI
tooling:

```shell
terraform workspace new example
Created and switched to workspace "example"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

As pointed out by the [Terraform
docs](https://developer.hashicorp.com/terraform/cli/workspaces), alternate
methods for working with different environments are preferred (re-useable
modules with own state files).

Biggest downsides:
* No visual indication which workspace you're working in. 
* Workspaces are a local thing, and not shared across development machines
* Workspaces work well when using conditional statements
  ```terraform
  resource "aws_instance" "example" {
  count = "${terraform.workspace == "default" ? 5 : 1}"

  # ... other arguments
  }
  ```

I'd rather work with separate environment directories:
* Shared across development machines because these are actual files in your
  version control system (Git).
* You can't forget to switch switch away from an environment you had left open,
  because you have to `cd` to your environment. There is always a visual
  indicator on your terminal prompt, indicating which environment you're working
  in.
* Each environment has it's own state file, meaning you can work on various
  environments simultaneously. I would refer to this as horizontal scaling.
* No fuzzy conditional statements in the lower modules, being dependent on
  workspaces from upper levels.


| Development | Staging     | Production  |
|-------------|-------------|-------------|
| Deployment  | Deployment  | Deployment  | 


## Multi layer architecture
Why is it needed?
Additional benefits
  * Scoped layers
  * Smaller state files
  * Allows for teams to concurrently work on IaC
  * Vertical and horizontal scaling for development

| Development | Staging     | Production  |
|-------------|-------------|-------------|
| Network     | Network     | Network     |
| Kubernetes  | Kubernetes  | Kubernetes  |
| Databases   | Databases   | Databases   | 
| Application | Application | Application | 
