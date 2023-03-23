#----------------------------------------------------
# Myterraform
#
# Terraform with GCP - Google Cloud platform
#
# Made by Ellington
#
#----------------------------------------------------


provider "google" {
  credentials = file("GCP-creds.json")
  project     = "managing-379719"
  region      = "us-east1"
  zone        = "us-east1-c"
}

resource "google_compute_instance" "task_gcp" {
  name         = "task-gcp"
  machine_type = "e2-micro"
  tags         = ["elltv", "gcp"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }
  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.gcp-network.name
    access_config {
    }
  }

  metadata_startup_script = file("task4.sh")
}

resource "google_compute_network" "gcp-network" {
  name = "gcp-network"
}

resource "google_compute_firewall" "gcp_firewall" {
  name          = "gcp-firewall"
  network       = google_compute_network.gcp-network.name
  source_ranges = ["0.0.0.0/0"]


  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }
}

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "ssh-keys"
  value = "venomsan95:${tls_private_key.ssh-key.public_key_openssh}"
}

output "private_key_pem" {
  value     = tls_private_key.ssh-key.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value = tls_private_key.ssh-key.public_key_openssh
}

output "public_ip" {
  value = google_compute_instance.task_gcp.network_interface.0.access_config.0.nat_ip
}

