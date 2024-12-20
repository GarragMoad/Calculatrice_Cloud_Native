kubernetes
# Configuration Kubernetes pour Calculatrice Cloud Native

Ce dossier contient les fichiers de configuration Kubernetes nécessaires pour déployer les différents services et composants de l'application "Calculatrice Cloud Native".

---

## Structure du dossier

---

## Description des Configurations

### API
#### `api.yaml`
- **Kind**: `ReplicaSet`
- **Image utilisée**: `europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/api-image-2024-v2:Garrag-Bahand`
- **Réplications**: 1 Pod
- **Port exposé**: 5000/TCP

#### `api-service.yaml`
- **Kind**: `Service`
- **Type**: `ClusterIP` (accessible uniquement dans le cluster)
- **Port**: 5000
- **Selector**: 
  - `app: api`
  - `soft: python`

---

### Consumer
#### `consumer-service.yaml`
- **Kind**: `Service`
- **Type**: `ClusterIP` (accessible uniquement dans le cluster)
- **Port externe**: 80
- **Port conteneur**: 8080
- **Selector**: 
  - `app: consumer`
  - `soft: python`

---

### Frontend
#### `front.yaml`
- **Kind**: `ReplicaSet`
- **Image utilisée**: `europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/front-image-v2-2024:Garrag-Bahand`
- **Réplications**: 1 Pod
- **Port exposé**: 80/TCP

#### `svc-front.yaml`
- **Kind**: `Service`
- **Type**: `ClusterIP` (accessible uniquement dans le cluster)
- **Port externe**: 8080
- **Port conteneur**: 80
- **Selector**: 
  - `app: Calculatrice-front`
  - `soft: nginx`

---

### RabbitMQ
#### `rabbitMQ.yaml`
- **Kind**: `ReplicaSet`
- **Image utilisée**: `rabbitmq:3.12-management`
- **Réplications**: 1 Pod
- **Ports exposés**:
  - `5672` (AMQP protocol)
  - `15672` (Management interface)

#### `rabbitMQ-service.yaml`
- **Kind**: `Service`
- **Type**: `ClusterIP` (accessible uniquement dans le cluster)
- **Ports**:
  - `5672` (AMQP)
  - `15672` (Management)
- **Selector**: 
  - `app: message-queue`
  - `soft: rabbitmq`

---

### Redis
#### `redis.yaml`
- **Kind**: `ReplicaSet`
- **Image utilisée**: `redis:alpine`
- **Réplications**: 1 Pod
- **Port exposé**: 8080/TCP

#### `redis-service.yaml`
- **Kind**: `Service`
- **Type**: `ClusterIP` (accessible uniquement dans le cluster)
- **Port externe**: 6379
- **Port conteneur**: 8080
- **Selector**: 
  - `app: Bdd`
  - `soft: redis`

---

### Ingress
#### `ingress.yaml`
- **Kind**: `Ingress`
- **Namespace**: `garrag-bahand`
- **Règles de routage**:
  - URL racine (`/`) redirigée vers `moadservice-front` sur le port 8080.
- **Annotations**: 
  - `nginx.ingress.kubernetes.io/rewrite-target: /`

---

## Schéma Descriptif

Voici un schéma simplifié des composants et leur interaction dans le cluster Kubernetes :

(schema.png)


---

## Comment Déployer ?
1. **Déployer les composants** :
   ```bash
   kubectl apply -f Kubernetes/Api/
   kubectl apply -f Kubernetes/Consumer/
   kubectl apply -f Kubernetes/Front/
   kubectl apply -f Kubernetes/RabbitMQ/
   kubectl apply -f Kubernetes/Redis/
   kubectl apply -f Kubernetes/Ingress/


