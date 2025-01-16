# ⚙️ Configuration Kubernetes pour Calculatrice Cloud Native

Ce dossier contient les fichiers de configuration Kubernetes nécessaires pour déployer les différents services et composants de l'application **"Calculatrice Cloud Native"** ainsi qu'une description des problèmes rencontrés qui nous ont retardés. 🚀

---

## 🗂️ Structure du Dossier

Ce répertoire est organisé en sous-dossiers pour chaque composant : 
- `Api/` : Configurations liées à l'API.
- `Consumer/` : Configurations pour le service consommateur.
- `Front/` : Configurations pour le Frontend.
- `RabbitMQ/` : Configurations pour RabbitMQ.
- `Redis/` : Configurations pour Redis.
- `Ingress/` : Configurations pour les règles de routage.

---

## 📝 Description des Configurations

### 🧩 API
#### 📄 `api.yaml`
- **Kind** : `ReplicaSet`
- **Image utilisée** :  
  `europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/api-image-2024-v3.2:Garrag-Bahand`
- **Réplications** : 1 Pod
- **Port exposé** : `5000/TCP`

#### 📄 `api-service.yaml`
- **Kind** : `Service`
- **Type** : `ClusterIP` (accessible uniquement dans le cluster)
- **Port** : 5000
- **Selector** :  
  - `app: api`
  - `soft: python`

---

### 🔄 Consumer
#### 📄 `consumer-service.yaml`
- **Kind** : `Service`
- **Type** : `ClusterIP` (accessible uniquement dans le cluster)
- **Port externe** : 80
- **Port conteneur** : 8080
- **Selector** :  
  - `app: consumer`
  - `soft: python`

---

### 🎨 Frontend
#### 📄 `front.yaml`
- **Kind** : `ReplicaSet`
- **Image utilisée** :  
  `europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/front-image-v2-2024:Garrag-Bahand`
- **Réplications** : 1 Pod
- **Port exposé** : `80/TCP`

#### 📄 `svc-front.yaml`
- **Kind** : `Service`
- **Type** : `ClusterIP` (accessible uniquement dans le cluster)
- **Port externe** : 8080
- **Port conteneur** : 80
- **Selector** :  
  - `app: Calculatrice-front`
  - `soft: nginx`

---

### ✉️ RabbitMQ
#### 📄 `rabbitMQ.yaml`
- **Kind** : `ReplicaSet`
- **Image utilisée** : `rabbitmq:3.12-management`
- **Réplications** : 1 Pod
- **Ports exposés** :  
  - `5672` (AMQP protocol)  
  - `15672` (Management interface)

#### 📄 `rabbitMQ-service.yaml`
- **Kind** : `Service`
- **Type** : `ClusterIP` (accessible uniquement dans le cluster)
- **Ports** :  
  - `5672` (AMQP)  
  - `15672` (Management)
- **Selector** :  
  - `app: message-queue`
  - `soft: rabbitmq`

---

### 📦 Redis
#### 📄 `redis.yaml`
- **Kind** : `ReplicaSet`
- **Image utilisée** : `redis:alpine`
- **Réplications** : 1 Pod
- **Port exposé** : `6379/TCP`

#### 📄 `redis-service.yaml`
- **Kind** : `Service`
- **Type** : `ClusterIP` (accessible uniquement dans le cluster)
- **Port externe** : 6379
- **Port conteneur** : 6379
- **Selector** :  
  - `app: Bdd`
  - `soft: redis`

---

### 🌐 Ingress
#### 📄 `ingress.yaml`
- **Kind** : `Ingress`
- **Namespace** : `garrag-bahand`
- **Règles de routage** :  
  - URL racine (`/`) redirigée vers `moadservice-front` sur le port 8080.  
  - URL (`/api`) redirigée vers `moadservice-api` sur le port 5000.  

**Problème rencontré** : Nous étions bloqués par une erreur de communication entre l'API et le Frontend à cause de l'absence d'une URL publique. Ce problème a été résolu en ajoutant une règle Ingress pour exposer l'API avec un URL public.

---

## 📌 Schéma Descriptif

Voici un schéma simplifié des composants et leur interaction dans le cluster Kubernetes :  

![Schéma des interactions](./schema.png)

---

## 📤 Comment Déployer ?
1. **Déployer les composants** :
   ```bash
   kubectl apply -f Kubernetes/Api/api.yaml
   kubectl apply -f Kubernetes/Api/api-service.yaml
   kubectl apply -f Kubernetes/Consumer/consumer.yaml
   kubectl apply -f Kubernetes/Consumer/consumer-service.yaml
   kubectl apply -f Kubernetes/Front/front.yaml
   kubectl apply -f Kubernetes/Front/svc-front.yaml
   kubectl apply -f Kubernetes/RabbitMQ/rabbitMQ.yaml
   kubectl apply -f Kubernetes/RabbitMQ/rabbitMQ-service.yaml
   kubectl apply -f Kubernetes/Redis/redis.yaml
   kubectl apply -f Kubernetes/Redis/redis-service.yaml
   kubectl apply -f Kubernetes/Ingress/ingress.yaml
   
# ❗ Erreurs Rencontrées

## 🛠️ Communication entre le Front et l'API
- Résolu par l'ajout d'une règle Ingress pour exposer l'API avec un URL public.

## 📉 Ressources Insuffisantes
- Certains pods restaient en `Pending` à cause de la surcharge du cluster.

## 🚫 Erreur HTTP 405
- Une requête POST n'était pas autorisée pour l'URL demandée.
- Grâce aux logs des pods, nous avons découvert que l'Ingress réécrivait les paths avec cette annotation :
  ```yaml
  nginx.ingress.kubernetes.io/rewrite-target: /
