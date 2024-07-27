resource yandex_compute_disk "default" {
    count    = 3 
    name     = "vd-${count.index+1}"
    type     = "network-hdd"
    size     = 1 
}

resource "yandex_compute_instance" "storage" {
    name = "storage"
    platform_id = var.vm_platform
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
        for_each = "${yandex_compute_disk.default.*.id}"
        content  {
            disk_id = secondary_disk.value
        }        
    }
    scheduling_policy {
        preemptible = true
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.develop.id
        nat       = true
    }

    metadata = {
        serial-port-enable = local.metadata.serial-port-enable
        ssh-keys           = local.metadata.ssh-keys
    }
}
