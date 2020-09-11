variable "rg_name" {
    type = string
}

variable "region_name" {
    type = string
}

variable "vnet_name" {
    type = string
}

variable "vnet_prefix" {
    type = list(string)
}

variable "snet_mgmt_name" {
    type = string
}

variable "snet_mgmt_prefix" {
    type = list(string)
}

variable "snet_client_name" {
    type = string
}

variable "snet_client_prefix" {
  type = list(string)
}

variable "nsg_mgmt_name" {
    type = string
}

variable "nsg_client_name" {
    type = string
}

variable "nsr_mgmt_allow_name" {
    type = string
}

variable "nsr_mgmt_allow_prefixes" {
    type = list(string)
    default = ["10.26.0.0/16", "136.228.177.0/24"]
}

variable "nsr_mgmt_allow_ports" {
    type = list(number)
    default  = ["22", "80", "443"]
}

variable "nsr_mgmt_deny_name" {
    type = string
}

variable "nsr_client_allow_name" {
    type = string
}

variable "nsr_client_allow_ports" {
    type = list(number)
    default  = ["80", "443"]
}

variable "nsr_client_deny_name" {
    type = string
}

variable "pip_mgmt_name" {
    type = string
}

variable "pip_client_name" {
    type = string
}

variable "nic_mgmt_name" {
    type = string
}

variable "nic_mgmt_ip" {
    type = string
}

variable "nic_client_name" {
    type = string
}

variable "nic_client_ip" {
    type = string
}

variable "vm_name" {
    type = string
}

variable "vm_size" {
    type = string
    default  = "Standard_D2s_v3"  
}

variable "vm_os_computer_name" {
    type = string
}

variable "vm_os_admin_username" {
    type = string
    default  = "azadmin"
}

variable "vm_os_admin_password" {
    type = string
}

variable "vm_os_disk_name" {
    type = string
}

variable "vm_image_publisher" {
    type = string
    default   = "citrix"
}

variable "vm_image_offer" {
    type = string
    default   = "netscalervpx-130"
}

variable "vm_image_sku" {
    type = string
    default   = "netscalervpxexpress"
}

variable "vm_image_version" {
    type = string
    default   = "latest"
}

variable "vm_plan_name" {
    type = string
    default   = "netscalervpxexpress"
}

variable "vm_plan_publisher" {
    type = string
    default   = "citrix"
}

variable "vm_plan_product" {
    type = string
    default   = "netscalervpx-130"
}