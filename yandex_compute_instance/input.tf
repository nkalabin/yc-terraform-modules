variable "vm_name" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "distro_type" {
  type = string
}

variable "distro_map" {
  type = map(string)
  default = {
    "ubuntu_24" = "fd8e5jmcvep85j33nt0e"
    "ubuntu_22" = "fd8rnq92aj5v7sgi91e8"
  }
}

variable "public_ip" {
  type=string
  default = "true"
}

variable "vm_resources" {
  type = map(string)
  default = {
    "disk_size" = "10"
    "disk_type" = "network-hdd"
    "cpus" = "2"
    "core_fraction" = "20"
    "memory" = "2"
  }
}

variable "cloud_init" {
  type = string
}

variable "run_ansible" {
  type=bool
  default=false
}