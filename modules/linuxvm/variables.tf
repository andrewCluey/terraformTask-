variable "location" {
  description = "The azure region where the new resource will be created"
  type        = string
}

variable "resourcegroup_name" {
  description = "The name of the Resource Group where the new VM should be created."
  type        = string
}

variable "tags" {
  description = "(optional) describe your variable"
  type        = map(string)
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the VMs main NIC will reside"
}

variable "vm_image" {
  description = "Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html#source_image_reference"
  type        = map(string)
  default     = {}
}

variable "vm_size" {
  description = "The size of the new Vm to deploy. Options can be found HERE."
  default     = "standard_b2s"
  type        = string
}

variable "vm_name" {
  description = "The name to assign to the new VM"
  type        = string
}

variable "storage_os_disk_config" {
  description = "Map to configure OS storage disk. (Caching, size, storage account type...)"
  type        = map(string)
  default = {}
}

variable "admin_username" {
  description = "The admin username to set."
  type        = string
  default     = "adminuser"
}

variable "pubkey" {
  description = "The SSH Public Key to use for the admin user on the new Linux VM"
  type        = string
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the keyvault where the VM disk encryptionkey is to be held."
}




variable "recovery_vault_resource_group" {
  type        = string
  description = "The name of the resource group where the recovery vault resides."
  default = ""
}


variable "assign_backup_policy" {
  type        = bool
  description = "Should a backup olicy be assigned to the new VM"
  default     = false
}


variable "recovery_vault_name" {
  type        = string
  description = "The name of the recovery vault to use"
  default     = ""
}

variable "backup_policy_id" {
  type        = string
  description = "The ID of the backup policy to assign to the new VM"
  default     = ""
}
