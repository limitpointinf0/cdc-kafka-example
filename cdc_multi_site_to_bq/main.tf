// Configure the Google Cloud provider
provider "google" {
    credentials = file(var.creds_path)
    project     = var.project
    region      = var.region
}

// Add Firewall Rule
resource "google_compute_firewall" "kafka-fw" {
    name    = "kafka-rule"
    network = var.net

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports    = ["9092"]
    }

    allow {
        protocol = "tcp"
        ports    = ["3306"]
    }
}


resource "random_id" "instance_id" {
    byte_length = 8
}

// Asia Southeast
resource "google_compute_instance" "kafka" {
    name         = "kafka-vm-${random_id.instance_id.hex}"
    machine_type = var.size
    zone         = var.zone_ase

    boot_disk {
        initialize_params {
            image = var.image
        }
    }

    metadata = {
        ssh-keys = "chris:${file("~/.ssh/id_rsa.pub")}"
    }

    metadata_startup_script = file("docker.sh")

    network_interface {
        network = var.net

        access_config {}
    }
}

resource "google_compute_instance" "sql1" {
    name         = "sql1-vm-${random_id.instance_id.hex}"
    machine_type = var.size
    zone         = var.zone_ase

    boot_disk {
        initialize_params {
            image = var.image
        }
    }

    metadata = {
        ssh-keys = "chris:${file("~/.ssh/id_rsa.pub")}"
    }

    metadata_startup_script = file("docker.sh")

    network_interface {
        network = var.net

        access_config {}
    }
}

resource "google_compute_instance" "sql2" {
    name         = "sql2-vm-${random_id.instance_id.hex}"
    machine_type = var.size
    zone         = var.zone_ase

    boot_disk {
        initialize_params {
            image = var.image
        }
    }

    metadata = {
        ssh-keys = "chris:${file("~/.ssh/id_rsa.pub")}"
    }

    metadata_startup_script = file("docker.sh")

    network_interface {
        network = var.net

        access_config {}
    }
}

// External IP outputs
output "kafka-ip" {
    value = google_compute_instance.kafka.network_interface.0.access_config.0.nat_ip
}

output "sql1-ip" {
    value = google_compute_instance.sql1.network_interface.0.access_config.0.nat_ip
}

output "sql2-ip" {
    value = google_compute_instance.sql2.network_interface.0.access_config.0.nat_ip
}