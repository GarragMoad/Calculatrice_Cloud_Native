# Utiliser une image de base officielle de Python
FROM python:3.11-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de l'application dans le conteneur
COPY . /app

# Installer les dépendances directement
RUN pip install --no-cache-dir pika redis

# Définir la commande par défaut pour exécuter le consommateur
CMD ["python", "consumer.py"]