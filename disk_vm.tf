resource "yandex_compute_disk" "storage_disk" {
  count     = var.storage_disks_count

  name      = "${var.storage_disk_name}-${count.index}"
  zone      = var.default_zone
  size      = var.storage_disk_size
}

resource "yandex_compute_instance" "storage" {
    name = var.vm_storage_instance_name
    platform_id = var.vm_platform_id
    resources {
        cores = var.vms_resources.cores
        memory = var.vms_resources.memory
        core_fraction = var.vms_resources.core_fraction
    }
    boot_disk {
       initialize_params {
         image_id = data.yandex_compute_image.ubuntu.image_id
       }
    }
    dynamic "secondary_disk" {
        for_each = yandex_compute_disk.storage_disk
        content  {
            disk_id = lookup(secondary_disk.value, "id", null)
        }        
    }
    scheduling_policy {
        preemptible = var.vm_is_preemptible
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.develop.id
        nat       = var.vm_storage_has_nat
    }

    metadata = {
        serial-port-enable = local.metadata.serial-port-enable
        ssh-keys           = local.metadata.ssh-keys
    }
}
