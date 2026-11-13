# Versions figées : tout le monde obtient exactement les mêmes outils.
terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
}

# Comment joindre le moteur Docker de Docker Desktop.
provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}