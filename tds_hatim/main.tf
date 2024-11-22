provider "google" {
	project = var.project_id
	region = var.region
}

resource "google_compute_instance" "vm_instance" {
	count = var.instance_count
	name = "instance-${count.index}"
	machine_type = "f1-micro"
	zone = "${var.region}-a"


	boot_disk {
		initialize_params {
			image = "debian-cloud/debian-10"
		}
	}

	network_interface {
		network = "default"
		access_config {}
	}

}
