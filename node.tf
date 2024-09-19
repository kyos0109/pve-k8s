terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure     = true
    pm_api_url          = "https://${var.proxmox_host}/api2/json"
    pm_api_token_id     = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret
}

locals {
  gateway         = cidrhost(var.ip_config.ip_cidr, -2) # .254
  netmask         = split("/", var.ip_config.ip_cidr)[1]
  agent           = 1
  boot            = "order=virtio0;net0"
  os_type         = "cloud-init"
}

resource "proxmox_vm_qemu" "node-7001" {
    target_node = var.target_node
    count       = var.vm_count
    name        = "${var.name}${format("%04d", count.index)}"
    vmid        = "${count.index + var.start_id}"

    full_clone  = true
    clone       = var.template
    agent       = local.agent
    os_type     = local.os_type
    cores       = var.cpu_config.cores
    sockets     = var.cpu_config.sockets
    cpu         = var.cpu_config.cpu
    memory      = var.ram_config.memory
    scsihw      = var.disk_config.scsihw
    boot        = local.boot

    disks {
        ide {
            ide0 {
                cloudinit {
                    storage = var.disk_config.storage
                }
            }
        }
        virtio {
            virtio0 {
                disk {
                    size     = var.disk_config.size
                    cache    = var.disk_config.cache
                    storage  = var.disk_config.storage
                    iothread = var.disk_config.iothread
                    discard  = var.disk_config.discard
                }
            }
        }
    }

    network {
        model  = var.network_config.model
        bridge = var.network_config.bridge
    }

    ipconfig0 = "ip=${cidrhost(var.ip_config.ip_cidr, count.index + var.ip_config.start_ip)}/${local.netmask},gw=${local.gateway}"
}