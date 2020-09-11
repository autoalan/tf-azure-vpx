# Azure VPX Terraform Module
This module will build a VPX instance with two interfaces and the necessary resource group, virtual networks, subnets, security groups, etc.

## Example Usage

    module "my-eastus2-vpx" {
        source = "./modules/citrix-vpx"
        
        region_name = "East US2"
    
        rg_name = "rg-my-eastus2-vpx"
        
        vnet_name = "vnet-my-eastus2-vpx-1"
        vnet_prefix = ["172.16.0.0/24"]
    
        snet_mgmt_name = "snet-my-eastus2-vpx-mgmt"
        snet_mgmt_prefix = ["172.16.0.0/27"]
        snet_client_name = "snet-my-eastus2-vpx-client"
        snet_client_prefix = ["172.16.0.32/27"]
    
        nsg_mgmt_name = "nsg-my-eastus2-vpx-mgmt"    
        nsg_client_name = "nsg-my-eastus2-vpx-client"    
    
        nsr_mgmt_allow_name = "AllowManagement"
        nsr_mgmt_deny_name = "DenyManagement"
        nsr_client_allow_name = "AllowClient"
        nsr_client_deny_name = "DenyClient"
    
        pip_mgmt_name = "pip-my-eastus2-vpx-mgmt"
        pip_client_name = "pip-my-eastus2-vpx-client"
    
        nic_mgmt_name = "nic-prod-my-eastus2-vpx-mgmt"
        nic_mgmt_ip = "172.16.0.4"
        nic_client_name = "nic-my-eastus2-vpx-client"
        nic_client_ip = "172.16.0.36"
    
        vm_name = "vm-prod-urlw-ueast2-adc-1"
        vm_os_computer_name = "azpd-urlw-eastus2-adc-1"
        vm_os_admin_username = "azroot"
        vm_os_admin_password = ""
        vm_os_disk_name = "vhd-prod-url2-eastus2-adc-1"
    }
