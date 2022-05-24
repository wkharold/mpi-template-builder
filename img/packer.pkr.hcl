variable "machine_type" {
    type    = string
}

variable "source_image" {
    type    = string
}

variable "source_image_project_id" {
    type    = string
}

variable "project_id" {
    type    = string
}

variable "zone" {
    type    = string
}

source "googlecompute" "julia_mpi_node_builder" {
    project_id              = var.project_id
    source_image            = var.source_image
    source_image_project_id = [var.source_image_project_id]
    zone                    = var.zone
    image_name              = "julia-mpi-v{{timestamp}}"
    image_family            = "julia-mpi"
    image_description       = "julia-mpi-compute"
    machine_type            = var.machine_type
    disk_size               = 256
    on_host_maintenance     = "TERMINATE"
    tags                    = ["packer","julia","mpi"]
    account_file            = "image-builder.key"
    startup_script_file     = "julia_mpi_install.sh"
    ssh_username            = "rocky"
}

build {
    sources = ["source.googlecompute.julia_mpi_node_builder"]
}
