variable "image_web" {
  description = "Image Docker du serveur web"
  type        = string
}

variable "bornes" {
  description = "Les bornes à déployer : un nom et un port par borne"
  type        = map(number)
}