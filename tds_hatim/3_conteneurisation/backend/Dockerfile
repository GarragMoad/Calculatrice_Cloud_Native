# Utiliser l'image Debian comme base
FROM debian:latest


# Installer les paquets bash, htop, vim et net-tools (qui contient netstat)
RUN apt-get update && \
    apt-get install -y bash htop vim net-tools && \
    apt-get clean

# Définir une variable d'environnement avec votre prénom
ENV OWNER="hatim"
RUN adduser nonroot

# Commande par défaut pour garder le conteneur actif
CMD ["sleep", "3600"]
USER nonroot