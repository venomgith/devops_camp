provider "aws" {
  access_key = "" # Your akey
  secret_key = "" # Your skey  
  region     = "us-east-1"
}


#before this you must write in terminal next words: "az login"
provider "azurerm" {
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
  features {}
}

module "aws" {
  source = "./modules/aws"
}

module "azure" {
  source = "./modules/azure"
}

output "IP_Public_AWS" {
  value = module.aws.instance_public_ip_AWS
}

output "IP_Public_Azure" {
  value = module.azure.public_ip_address_Azure
}