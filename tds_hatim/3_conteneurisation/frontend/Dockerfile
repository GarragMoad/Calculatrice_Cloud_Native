# Utiliser l'image nginx la plus récente disponible sur Docker Hub
FROM nginx:latest

# Copier le fichier index.html local dans le répertoire par défaut de Nginx
COPY index.html /usr/share/nginx/html/index.html

COPY style.css /usr/share/nginx/html/style.css

COPY img /usr/share/nginx/html/img

# Exposer le port 80 pour accéder à la page web via HTTP
EXPOSE 80
