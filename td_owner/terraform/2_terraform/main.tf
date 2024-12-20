provider "google" {
    project = var.project_id
    region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}

# Créer un sous-réseau dans le VPCdcdf
resource "google_compute_subnetwork" "my_subnet" {
  name          = "my-subnet"
  region        = "europe-west9"
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.vpc_network.self_link
}



resource "google_compute_instance" "VM" {
  count        = length(var.zones)             #VM par zone
  name         = "my-instance-${count.index}"  # Nom unique pour chaque instance
  machine_type = "n2-standard-2"
  zone         = "europe-west9-b"


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.my_subnet.name

    access_config {
      // Ephemeral public IP
    }
  }
}
# Réserver une adresse IP pour la connexion de service VPC peering
resource "google_compute_global_address" "private_ip_address" {
  name          = "sql-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_subnetwork.my_subnet.id 
}

# Créer la connexion de service pour activer le VPC peering
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 =  google_compute_subnetwork.my_subnet.id 
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}


# Créer l'instance Cloud SQL avec une IP privée
resource "google_sql_database_instance" "DB" {
  name             = "DB_postgreSql"
  database_version = "POSTGRES_15"
  region           = var.region

  # Activer la connexion via une IP privée
  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false  # Désactiver l'IP publique
      private_network = google_compute_subnetwork.my_subnet.self_link
    }
  }

  # Dépendance sur la connexion VPC pour s'assurer qu'elle est créée d'abord
  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_dns_record_set" "endPoint" {
  name = "endPoint.${google_dns_managed_zone.prod.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.prod.name

  rrdatas = [google_compute_instance.VM[0].network_interface[0].access_config[0].nat_ip]
}

resource "google_dns_managed_zone" "prod" {
  name     = "prod-zone"
  dns_name = "prod.mydomain.com."
}