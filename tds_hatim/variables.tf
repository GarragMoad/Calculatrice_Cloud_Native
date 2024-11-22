variable "project_id" {
description = "ID du projet Google Cloud"
type = string
}

variable "region" {
description = "Région Google Cloud"
type = string
default = "europe-west1"
}

variable "instance_count" {
description = "Nombre d'instances à déployer"
type = number
default = 1
}
