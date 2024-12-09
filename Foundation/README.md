# Foundation Infrastructure avec Terraform

Ce dossier contient la configuration Terraform permettant de déployer les fondations pour l'application **Calculatrice Cloud Native**. Cette infrastructure comprend un réseau privé, des bases de données, un cluster Kubernetes, des load balancers, et un registre de conteneurs.

---

## Schéma Descriptif

```plaintext
+-------------------------+
|        VPC Privée       | (scaleway_vpc_private_network.pn)
+-------------------------+
          |
+------------------+       +------------------+       +------------------+
|   Base de Données|       |  Load Balancer   |       |   DNS Record     |
|  (RDB Instance)  |       | (scaleway_lb)    |       | (scaleway_domain|
|   - db-dev       |       |  - lb-dev        |       |    _record)      |
|   - db-prod      |       |  - lb-prod       |       |                  |
+------------------+       +------------------+       +------------------+

          |
+-------------------------+
|      Cluster K8s        | (scaleway_k8s_cluster.cluster)
|                         |
|  + Pool de nœuds       | (scaleway_k8s_pool.pool)
|    - 3 instances        |
+-------------------------+

          |
+-------------------------+
| Registre de Conteneurs  | (scaleway_registry_namespace.container_registry)
+-------------------------+


Nous avons choisi d'utiliser un bloc locals dans main.tf pour définir des variables locales qui incluront les spécifications de chaque environnement. Ensuite, on utilise une boucle pour créer les instances (DB , loadBalancer et record DNS) de manière dynamique.

Résultat de la commande terraform plan: 

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # scaleway_domain_record.dns["dev"] will be created
  + resource "scaleway_domain_record" "dns" {
      + data            = (known after apply)
      + dns_zone        = "kiowy.net"
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + keep_empty_zone = false
      + name            = "calculatrice-dev-GARRAG_Moad-BAHAND_Hatim-polytech-dijon"
      + priority        = (known after apply)
      + project_id      = (known after apply)
      + root_zone       = (known after apply)
      + ttl             = 3600
      + type            = "A"
    }

  # scaleway_domain_record.dns["prod"] will be created
  + resource "scaleway_domain_record" "dns" {
      + data            = (known after apply)
      + dns_zone        = "kiowy.net"
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + keep_empty_zone = false
      + name            = "calculatrice-GARRAG_Moad-BAHAND_Hatim-polytech-dijon"
      + priority        = (known after apply)
      + project_id      = (known after apply)
      + root_zone       = (known after apply)
      + ttl             = 3600
      + type            = "A"
    }

  # scaleway_k8s_cluster.cluster will be created
  + resource "scaleway_k8s_cluster" "cluster" {
      + apiserver_url               = (known after apply)
      + cni                         = "cilium"
      + created_at                  = (known after apply)
      + delete_additional_resources = false
      + id                          = (known after apply)
      + kubeconfig                  = (sensitive value)
      + name                        = "tf-cluster"
      + organization_id             = (known after apply)
      + private_network_id          = (known after apply)
      + project_id                  = (known after apply)
      + region                      = (known after apply)
      + status                      = (known after apply)
      + type                        = (known after apply)
      + updated_at                  = (known after apply)
      + upgrade_available           = (known after apply)
      + version                     = "1.29.1"
      + wildcard_dns                = (known after apply)

      + auto_upgrade (known after apply)

      + autoscaler_config (known after apply)

      + open_id_connect_config (known after apply)
    }

  # scaleway_k8s_pool.pool will be created
  + resource "scaleway_k8s_pool" "pool" {
      + autohealing            = false
      + autoscaling            = false
      + cluster_id             = (known after apply)
      + container_runtime      = "containerd"
      + created_at             = (known after apply)
      + current_size           = (known after apply)
      + id                     = (known after apply)
      + max_size               = (known after apply)
      + min_size               = 1
      + name                   = "tf-pool"
      + node_type              = "DEV1-M"
      + nodes                  = (known after apply)
      + public_ip_disabled     = false
      + region                 = (known after apply)
      + root_volume_size_in_gb = (known after apply)
      + root_volume_type       = (known after apply)
      + size                   = 3
      + status                 = (known after apply)
      + updated_at             = (known after apply)
      + version                = (known after apply)
      + wait_for_pool_ready    = true
      + zone                   = (known after apply)

      + upgrade_policy (known after apply)
    }

  # scaleway_lb.loadbalancer["dev"] will be created
  + resource "scaleway_lb" "loadbalancer" {
      + id                      = (known after apply)
      + ip_address              = (known after apply)
      + ip_id                   = (known after apply)
      + ip_ids                  = (known after apply)
      + ipv6_address            = (known after apply)
      + name                    = "lb-dev"
      + organization_id         = (known after apply)
      + project_id              = "123e4567-e89b-12d3-a456-426614174000"
      + region                  = (known after apply)
      + ssl_compatibility_level = "ssl_compatibility_level_intermediate"
      + type                    = "lb-bc1-s"
      + zone                    = (known after apply)
    }

  # scaleway_lb.loadbalancer["prod"] will be created
  + resource "scaleway_lb" "loadbalancer" {
      + id                      = (known after apply)
      + ip_address              = (known after apply)
      + ip_id                   = (known after apply)
      + ip_ids                  = (known after apply)
      + ipv6_address            = (known after apply)
      + name                    = "lb-prod"
      + organization_id         = (known after apply)
      + project_id              = "123e4567-e89b-12d3-a456-426614174000"
      + region                  = (known after apply)
      + ssl_compatibility_level = "ssl_compatibility_level_intermediate"
      + type                    = "lb-bc1-s"
      + zone                    = (known after apply)
    }

  # scaleway_lb_ip.lb_ip["dev"] will be created
  + resource "scaleway_lb_ip" "lb_ip" {
      + id              = (known after apply)
      + ip_address      = (known after apply)
      + is_ipv6         = false
      + lb_id           = (known after apply)
      + organization_id = (known after apply)
      + project_id      = "123e4567-e89b-12d3-a456-426614174000"
      + region          = (known after apply)
      + reverse         = (known after apply)
      + zone            = (known after apply)
    }

  # scaleway_lb_ip.lb_ip["prod"] will be created
  + resource "scaleway_lb_ip" "lb_ip" {
      + id              = (known after apply)
      + ip_address      = (known after apply)
      + is_ipv6         = false
      + lb_id           = (known after apply)
      + organization_id = (known after apply)
      + project_id      = "123e4567-e89b-12d3-a456-426614174000"
      + region          = (known after apply)
      + reverse         = (known after apply)
      + zone            = (known after apply)
    }

  # scaleway_rdb_instance.db["dev"] will be created
  + resource "scaleway_rdb_instance" "db" {
      + backup_same_region        = (known after apply)
      + backup_schedule_frequency = (known after apply)
      + backup_schedule_retention = (known after apply)
      + certificate               = (known after apply)
      + disable_backup            = false
      + endpoint_ip               = (known after apply)
      + endpoint_port             = (known after apply)
      + engine                    = "PostgreSQL-13"
      + id                        = (known after apply)
      + is_ha_cluster             = false
      + name                      = "db-dev"
      + node_type                 = "DB-DEV-S"
      + organization_id           = (known after apply)
      + project_id                = (known after apply)
      + read_replicas             = (known after apply)
      + region                    = (known after apply)
      + settings                  = (known after apply)
      + user_name                 = (known after apply)
      + volume_size_in_gb         = (known after apply)
      + volume_type               = "bssd"

      + load_balancer (known after apply)

      + logs_policy (known after apply)
    }

  # scaleway_rdb_instance.db["prod"] will be created
  + resource "scaleway_rdb_instance" "db" {
      + backup_same_region        = (known after apply)
      + backup_schedule_frequency = (known after apply)
      + backup_schedule_retention = (known after apply)
      + certificate               = (known after apply)
      + disable_backup            = false
      + endpoint_ip               = (known after apply)
      + endpoint_port             = (known after apply)
      + engine                    = "PostgreSQL-13"
      + id                        = (known after apply)
      + is_ha_cluster             = false
      + name                      = "db-prod"
      + node_type                 = "DB-PRO-S"
      + organization_id           = (known after apply)
      + project_id                = (known after apply)
      + read_replicas             = (known after apply)
      + region                    = (known after apply)
      + settings                  = (known after apply)
      + user_name                 = (known after apply)
      + volume_size_in_gb         = (known after apply)
      + volume_type               = "lssd"

      + load_balancer (known after apply)

      + logs_policy (known after apply)
    }

  # scaleway_registry_namespace.container_registry will be created
  + resource "scaleway_registry_namespace" "container_registry" {
      + description     = "Registry pour les conteneurs de l'application Calculatrice Native"
      + endpoint        = (known after apply)
      + id              = (known after apply)
      + is_public       = false
      + name            = "calculatrice-native-container-registry"
      + organization_id = (known after apply)
      + project_id      = "123e4567-e89b-12d3-a456-426614174000"
      + region          = (known after apply)
    }

  # scaleway_vpc_private_network.pn will be created
  + resource "scaleway_vpc_private_network" "pn" {
      + created_at      = (known after apply)
      + id              = (known after apply)
      + is_regional     = (known after apply)
      + name            = (known after apply)
      + organization_id = (known after apply)
      + project_id      = (known after apply)
      + region          = (known after apply)
      + updated_at      = (known after apply)
      + vpc_id          = (known after apply)
      + zone            = (known after apply)

      + ipv4_subnet (known after apply)

      + ipv6_subnets (known after apply)
    }

Plan: 12 to add, 0 to change, 0 to destroy.