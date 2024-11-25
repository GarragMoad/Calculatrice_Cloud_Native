# Utiliser une image de base officielle de Python
FROM python:3.11-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de l'application dans le conteneur
COPY . /app

# Installer les dépendances
RUN pip install --no-cache-dir flask flask-cors pika redis

# Exposer le port sur lequel l'application s'exécute
EXPOSE 5000

# Définir la commande par défaut pour exécuter l'application
CMD ["python", "api.py"]
