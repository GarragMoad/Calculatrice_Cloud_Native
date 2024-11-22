variable "region" {
  description = "La région où déployer les ressources"
  type        = string
  default     = "europe-west9-b"
}

variable "zones" {
  description = "Les zones pour créer 3 VM"
  type    = list(string)
  default = ["europe-west9-a", "europe-west9-b", "europe-west9-c"]
}


variable "project_id" {
  description = "projet Esirem"
  type = string
  default = "esirem"

}
