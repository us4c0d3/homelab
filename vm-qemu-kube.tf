resource "proxmox_vm_qemu" "kube" {
  for_each = var.vm_configs

  # -- General Settings
  name        = each.key
  desc        = "k3s worker node"
  agent       = 1
  target_node = "pve"
  tags        = "rocky8,k3s"
  vmid        = each.value.vmid

  # -- Template Settings
  clone_id   = 9000
  full_clone = true

  # -- Boot Process
  onboot           = true
  automatic_reboot = false

  # -- Hardware Settings
  cores   = 2
  sockets = 1
  memory  = 4096
  balloon = 0

  # -- Network Settings
  network {
    id       = 0
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = false
  }

  # -- Disk Settings
  scsihw = "virtio-scsi-pci"

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage  = "local-lvm"
          size     = "20G"
          iothread = true
        }
      }
    }
  }

  # -- Cloud Init Settings
  ipconfig0  = each.value.ip
  nameserver = "8.8.8.8"
  ciuser     = var.USER
  cipassword = var.PASSWORD
  ciupgrade  = false
  sshkeys    = var.PUBLIC_SSH_KEY
}
