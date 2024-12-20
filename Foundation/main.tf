terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
    project_id = var.project_id
    region = var.region
    zone = var.zone
}

#bloc local pour les variables locales
locals {
  environments = ["dev", "prod"]

  environment_specs = {
    for env in local.environments : env => {
      db_name  = "db-${env}"
       loadbalancer_name = "lb-${env}"
      dev_dns_name  = "calculatrice-dev-${var.nombinome1}-${var.nombinome2}-polytech-dijon"
      prod_dns_name  = "calculatrice-${var.nombinome1}-${var.nombinome2}-polytech-dijon"
    }
  }
}

resource "scaleway_vpc_private_network" "pn" {}

resource "scaleway_registry_namespace" "container_registry" {
  name        = "calculatrice-native-container-registry"
  is_public = false
  project_id  = var.project_id
  description = "Registry pour les conteneurs de l'application Calculatrice Native"
}

resource "scaleway_k8s_cluster" "cluster" {
  name    = "tf-cluster"
  version = "1.29.1"
  cni     = "cilium"
  private_network_id = scaleway_vpc_private_network.pn.id
  delete_additional_resources = false
}

resource "scaleway_k8s_pool" "pool" {
  cluster_id = scaleway_k8s_cluster.cluster.id
  name       = "tf-pool"
  node_type  = "DEV1-M"
  size       = 3
}

# Bases de données
resource "scaleway_rdb_instance" "db" {
  for_each   = local.environment_specs
  name       = each.value.db_name
  engine     = "PostgreSQL-13"
  node_type  = each.key == "dev" ? "DB-DEV-S" : "DB-PRO-S"
  volume_type = each.key == "dev" ? "bssd" : "lssd"
}

# LoadBalancers
resource "scaleway_lb" "loadbalancer" {
  type      = "lb-bc1-s"
  for_each   = local.environment_specs
  name       = each.value.loadbalancer_name
  project_id = var.project_id
}

resource "scaleway_lb_ip" "lb_ip" {
  for_each   = local.environment_specs
  project_id = var.project_id
}




# DNS Entries
resource "scaleway_domain_record" "dns" {
  for_each = local.environment_specs
  dns_zone = "kiowy.net"
  name     = each.key == "dev" ? each.value.dev_dns_name : each.value.prod_dns_name
  type     = "A"
  data     = scaleway_lb_ip.lb_ip[each.key].id
  ttl      = 3600
}