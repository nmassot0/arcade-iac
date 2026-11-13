output "adresses" {
  description = "L'adresse de chaque borne, à ouvrir dans le navigateur"
  value       = { for nom, port in var.bornes : nom => "http://localhost:${port}" }
}