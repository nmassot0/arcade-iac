# L'image du serveur web, téléchargée une fois depuis Docker Hub.
resource "docker_image" "web" {
  name         = var.image_web
  keep_locally = true
}

# Un volume : un espace de stockage qui survit aux conteneurs.
resource "docker_volume" "records" {
  name = "arcade-records"
}

# Une borne (un conteneur) par ligne de la variable « bornes ».
resource "docker_container" "borne" {
  for_each = var.bornes

  name    = "arcade-${each.key}"
  image   = docker_image.web.image_id
  restart = "unless-stopped"

  # Le jeu est joignable sur ce poste uniquement, au port choisi.
  ports {
    internal = 80
    external = each.value
    ip       = "127.0.0.1"
  }

  # Le dossier records/ du site est rangé dans le volume.
  volumes {
    volume_name    = docker_volume.records.name
    container_path = "/usr/share/nginx/html/records"
  }

  # Les trois fichiers du jeu, copiés dans le conteneur.
  # source_hash : si un fichier change, Terraform le voit.
  upload {
    file        = "/usr/share/nginx/html/index.html"
    source      = "${path.module}/../app/index.html"
    source_hash = filesha256("${path.module}/../app/index.html")
  }
  upload {
    file        = "/usr/share/nginx/html/style.css"
    source      = "${path.module}/../app/style.css"
    source_hash = filesha256("${path.module}/../app/style.css")
  }
  upload {
    file        = "/usr/share/nginx/html/game.js"
    source      = "${path.module}/../app/game.js"
    source_hash = filesha256("${path.module}/../app/game.js")
  }
  upload {
    file    = "/usr/share/nginx/html/borne.txt"
    content = upper("BORNE ${each.key}")
  }

}