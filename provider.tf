terraform {
  required_version = ">=0.13.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "PUBLIC_SSH_KEY" {
  type      = string
  sensitive = true
}

variable "USER" {
  type = string
}

variable "PASSWORD" {
  type      = string
  sensitive = true
}

variable "vm_configs" {
  type = map(object({
    vmid = number,
    ip   = string,
    mac  = string
  }))
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = true #proxmox가 적절한 tls 인증서를 보유하고 있지 않을 경우 true로 해줘야한다.
}
