# L'image du serveur web, téléchargée une fois depuis Docker Hub.
resource "docker_image" "web" {
  name         = var.image_web
  keep_locally = true
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
}