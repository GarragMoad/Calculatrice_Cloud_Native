# 🌥️ Cloud Native Calculator - Virtualisation Cloud Project

**Moaad GARRAG**  && **Hatim BAHAND**

## ✨ Introduction
Bienvenue dans notre projet de virtualisation Cloud, **Cloud Native Calculator**. Ce projet a été réalisé en équipe par **Hatim BAHAND** et **Moaad GARRAG** dans le cadre d'une exploration des technologies cloud natives. 

La Cloud Native Calculator est une application distribuée qui permet d'exécuter des opérations mathématiques de base : addition (+), soustraction (-), multiplication (×) et division (/). Elle est conçue pour démontrer des compétences dans les domaines suivants : 

- 🏗️ Infrastructure as Code (IaC) avec Terraform.
- ⚙️ Orchestration avec Kubernetes.
- ✉️ Utilisation d'outils de messagerie (RabbitMQ) et de cache (Redis).
- 🖥️ Développement d'application backend et frontend.

## 🛠️ Structure du Projet
L'architecture du projet est composée des éléments suivants :

- **Backend** : Fournit les API pour les opérations mathématiques.
- **Frontend** : Interface utilisateur permettant d'entrer des opérations et de consulter les résultats.
- **Consumer** : Consomme les messages RabbitMQ et traite les opérations.
- **Infrastructure** : Mise en place via Terraform et orchestrée avec Kubernetes.
- **RabbitMQ** : File de messages pour la communication entre services.
- **Redis** : Stockage en cache des résultats pour accélérer les opérations récurrentes.

## 🤝 Répartition du Travail
Nous avons travaillé en étroite collaboration sur toutes les parties du projet. Hatim BAHAND s'est concentré davantage sur l'application backend, le frontend et le consumer, tandis que Moaad Garrag a mis l'accent sur l'infrastructure avec Terraform, Kubernetes, et les services RabbitMQ et Redis. 

## 📋 Prérequis
Pour exécuter le projet, les outils suivants doivent être installés :

- 🐳 Docker
- ☸️ Kubernetes (minikube ou autre cluster)
- 🌍 Terraform
- 💻 Node.js (pour le frontend)
- 🐍 Python (pour le backend et le consumer)

## 🚀 Installation
1. Clonez le dépôt :
   ```bash
   git clone <https://github.com/GarragMoad/Calculatrice_Cloud_Native.git>

## 🌟 Fonctionnalités Principales
- ➕➖ Multiplication et division incluses.
- 🏗️ Infrastructure Cloud Native modulaire et scalable.
- ⚡ Gestion rapide grâce à Redis et RabbitMQ.

## 👥 Auteurs
- Moaad Garrag
- Hatim BAHAND

Merci d'avoir consulté notre projet ! N'hésitez pas à nous contacter pour toute question ou suggestion.

