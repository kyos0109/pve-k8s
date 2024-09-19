variable "proxmox_host" {
  type    = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable target_node {
    type    = string
}

variable vm_count {
    type    = number
    default = 8
}

variable cpu_config {
  type = object({
    cores   = number
    sockets = number
    cpu     = string
  })

  default = {
    cores   = 4
    sockets = 1
    cpu     = "host"
  }
}

variable ram_config {
  type = object({
    memory   = number
  })

  default = {
    memory = 8192
  }
}
variable "disk_config" {
  type = object({
    scsihw   = string
    size     = number
    cache    = string
    storage  = string
    iothread = bool
    discard  = bool
  })

  default = {
    scsihw   = "virtio-scsi-single"
    size     = 80
    cache    = "writeback"
    storage  = "vm-data"
    iothread = true
    discard  = true
  }
}

variable network_config {
  type = object({
    model  = string
    bridge = string
  })

  default = {
    model  = "virtio"
    bridge = "vnet60"
  }
}

variable ip_config {
  type = object({
    ip_cidr  = string
    start_ip = number
  })

  default = {
    ip_cidr  = "192.168.60.0/24"
    start_ip = 30
  }
}

variable name {
  type    = string
  default = "n7"
}

variable start_id {
  type    = number
  default = 700
}

variable template {
  type = string
  default = "debian-12.7.0-amd64-netinst-kubeadm-m"
}