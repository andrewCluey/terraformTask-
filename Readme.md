# Example Deployment of Terraform 

## Directory structure

The repository has been structured so that modules are stored locally alongside the configuration code (./config/xxxx/`configuration.tfvars`) and the deployment logic (`./tf-deploy`). This is not necessarily the best way to consume modules and is only shown in this repo' for the purposes of this example. Ideally, Terraform modules should be published to a central registry/library where they can easily be referenced and re-used. This could be the public registry hosted by Hashicorp (`https://registry.terraform.io`) or simply a private git repository. 




## Pipeline example yaml files

There are two `.yml` files in the root of tbis repository that describe an Azure DevOps Pipeline for the Terarform plan and Terraform apply stages of a Terraform deployment. The first pipeline (`demoPipeline_fromTemplate.yml`) shows an example of calling an Azure DevOps Pipeline Template from a seperate repository. This is the best practice method for using Yaml pipelines as it means each Terraform deployment follows the same steps and logic as any other. Defining the steps in a pipeline means consistency between different deployments is easily achieved. 

The second pipeline (`demoPipeline_full`) shows the full pipeline, not taken from the template and is here for reference only so all the steps can be seen.

