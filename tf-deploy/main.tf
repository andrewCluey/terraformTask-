# Vms are deployed using For_each loop. 
# Add a new block of key:value for each new VM required.

locals {
  linux_vms = {
    ubn-vm1 = {
      size      = "standard_b2s"
      subnet_id = "/subscriptions/7df4fea2-d719-4abe-890b-37cd0298be98/resourceGroups/networking/providers/Microsoft.Network/virtualNetworks/vn-vm-demo/subnets/default"
    }
  }
}

# deploy VMs
module "linux_vms" {
  for_each = local.linux_vms
  source   = "../modules/linuxvm"

  resourcegroup_name            = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  vm_name                       = each.key
  vm_size                       = each.value.size
  subnet_id                     = each.value.subnet_id
  pubkey                        = file("./ssh/id_rsa.pub")
  key_vault_id                  = azurerm_key_vault.vm_encryption_keys.id
  assign_backup_policy          = true
  recovery_vault_resource_group = azurerm_resource_group.rg.name
  recovery_vault_name           = azurerm_recovery_services_vault.vm_vault.name
  backup_policy_id              = azurerm_backup_policy_vm.linux_bak_pol.id
}

