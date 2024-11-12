variable "region" {
  description = "La région où déployer les ressources"
  type        = string
  default     = "fr-par"
}

variable "zone" {
  description = "La zone où déployer les ressources"
  type        = string
  default     = "fr-par-1"
  
}

variable "project_id" {
  description = "calculatrice native"
  type        = string
  default = "123e4567-e89b-12d3-a456-426614174000"
}

variable "nombinome1" {
  description = "variable nombinome1"
  type        = string
  default = "GARRAG_Moad"
}

variable "nombinome2" {
  description = "variable nombinome2"
  type        = string
  default = "BAHAND_Hatim"
}
