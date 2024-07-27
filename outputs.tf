output "vm_output" {
    value = flatten([
        for instances in [
            yandex_compute_instance.web, 
            yandex_compute_instance.db
            ] : [
                for instance in instances: {
                    instance_name   = instance.name,
                    id              = instance.id,
                    fqdn            = instance.fqdn
                }
            ]
    ])
}
