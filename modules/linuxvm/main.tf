# Create Key Vault Key for VM Disk encryption
resource "azurerm_key_vault_key" "encryption_set_key" {
  name         = "${var.vm_name}vmkey"
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "disk_encryption_set" {
  name                = "${var.vm_name}-set"
  resource_group_name = var.resourcegroup_name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.encryption_set_key.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "disk_encryption_set_role" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_disk_encryption_set.disk_encryption_set.identity.0.principal_id
}


#######################################
# Virtual Machine Resources
#######################################

# Create VM Network Interfaces
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  tags                = var.tags

  ip_configuration {
    name                          = "${var.vm_name}-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resourcegroup_name
  size                = var.vm_size
  admin_username      = var.admin_username
  provision_vm_agent  = true
  tags                = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.pubkey
  }

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  source_image_reference {
    offer     = lookup(var.vm_image, "offer", "UbuntuServer")
    publisher = lookup(var.vm_image, "publisher", "Canonical")
    sku       = lookup(var.vm_image, "sku", "18.04-LTS")
    version   = lookup(var.vm_image, "version", "latest")
  }

  os_disk {
    name                 = lookup(var.storage_os_disk_config, "name", "${var.vm_name}-osdisk")
    caching              = lookup(var.storage_os_disk_config, "caching", "ReadWrite")
    storage_account_type = lookup(var.storage_os_disk_config, "storage_account_type", "Standard_LRS")
    disk_size_gb         = lookup(var.storage_os_disk_config, "disk_size_gb", "127")
  }

  identity {
    type = "SystemAssigned"
  }
}




# Assign backup policy to the VM
resource "azurerm_backup_protected_vm" "vm_backup" {
  count               = var.assign_backup_policy == true ? 1 : 0
  resource_group_name = var.recovery_vault_resource_group
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = azurerm_linux_virtual_machine.vm.id
  backup_policy_id    = var.backup_policy_id
}