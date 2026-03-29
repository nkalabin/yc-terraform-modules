resource "yandex_compute_disk" "test-disk" {
  name     = "disk-${var.vm_name}"
  type = lookup(var.vm_resources, "disk_type", "network-hdd")
  size  = lookup(var.vm_resources, "disk_size", "10")
  image_id = lookup(var.distro_map, var.distro_type)
}

resource "yandex_compute_instance" "vm-1" {
  name = var.vm_name
  platform_id = "standard-v3"

  resources {
    core_fraction = lookup(var.vm_resources, "core_fraction", "20")
    cores  = lookup(var.vm_resources, "cpus", "2")
    memory = lookup(var.vm_resources, "memory", "2")
  }

  boot_disk {
    disk_id = yandex_compute_disk.test-disk.id
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.public_ip
  }

  metadata = {
    user-data = var.cloud_init
  }
}

resource "terraform_data" "ansible_run" {
  count = var.run_ansible ? 1 : 0

  triggers_replace = [
    yandex_compute_instance.vm-1.id
  ]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible -m ping ${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address} -i ${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}, --private-key /Users/nikolajkalabin/.ssh/id_ed25519_server_connect -u user -e ansible_ssh_retries=10"
  }
}