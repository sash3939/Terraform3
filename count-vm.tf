data "yandex_compute_image" "ubuntu" {
    family = var.vm_image
}

resource "yandex_compute_instance" "web" {
    depends_on = [yandex_compute_instance.db]
    count = var.vm_web_count
    name = "web-${count.index+1}"
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
    scheduling_policy {
        preemptible = var.vm_is_preemptible
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.develop.id
        nat       = var.vm_has_nat
        security_group_ids = [yandex_vpc_security_group.example.id]
    }

    metadata = {
        serial-port-enable = local.metadata.serial-port-enable
        ssh-keys           = local.metadata.ssh-keys
    }
}
