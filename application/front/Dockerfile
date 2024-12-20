# Utiliser une image de base officielle de Nginx
FROM nginx:alpine

# Copier les fichiers de l'application dans le répertoire par défaut de Nginx
COPY . /usr/share/nginx/html

# Copier une configuration personnalisée de NGINX
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port sur lequel Nginx s'exécute
EXPOSE 80
