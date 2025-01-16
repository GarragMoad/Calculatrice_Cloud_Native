# Configuration Kubernetes pour Calculatrice Cloud Native

Ce dossier contient les fichiers de configuration Kubernetes nécessaires pour déployer les différents services et composants de l'application "Calculatrice Cloud Native" Ainsi que les problèmes rencontrés qui nous ont retardé.

---

## Structure du dossier

---

## Description des Configurations

### API
#### api.yaml
- **Kind**: ReplicaSet
- **Image utilisée**: europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/api-image-2024-v3.2:Garrag-Bahand
- **Réplications**: 1 Pod
- **Port exposé**: 5000/TCP

#### api-service.yaml
- **Kind**: Service
- **Type**: ClusterIP (accessible uniquement dans le cluster)
- **Port**: 5000
- **Selector**: 
  - app: api
  - soft: python

---

### Consumer
#### consumer-service.yaml
- **Kind**: Service
- **Type**: ClusterIP (accessible uniquement dans le cluster)
- **Port externe**: 80
- **Port conteneur**: 8080
- **Selector**: 
  - app: consumer
  - soft: python

---

### Frontend
#### front.yaml
- **Kind**: ReplicaSet
- **Image utilisée**: europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/front-image-v2-2024:Garrag-Bahand
- **Réplications**: 1 Pod
- **Port exposé**: 80/TCP

#### svc-front.yaml
- **Kind**: Service
- **Type**: ClusterIP (accessible uniquement dans le cluster)
- **Port externe**: 8080
- **Port conteneur**: 80
- **Selector**: 
  - app: Calculatrice-front
  - soft: nginx

---

### RabbitMQ
#### rabbitMQ.yaml
- **Kind**: ReplicaSet
- **Image utilisée**: rabbitmq:3.12-management
- **Réplications**: 1 Pod
- **Ports exposés**:
  - 5672 (AMQP protocol)
  - 15672 (Management interface)

#### rabbitMQ-service.yaml
- **Kind**: Service
- **Type**: ClusterIP (accessible uniquement dans le cluster)
- **Ports**:
  - 5672 (AMQP)
  - 15672 (Management)
- **Selector**: 
  - app: message-queue
  - soft: rabbitmq

---

### Redis
#### redis.yaml
- **Kind**: ReplicaSet
- **Image utilisée**: redis:alpine
- **Réplications**: 1 Pod
- **Port exposé**: 6379/TCP

#### redis-service.yaml
- **Kind**: Service
- **Type**: ClusterIP (accessible uniquement dans le cluster)
- **Port externe**: 6379
- **Port conteneur**: 6379
- **Selector**: 
  - app: Bdd
  - soft: redis

---

### Ingress
#### ingress.yaml
- **Kind**: Ingress
- **Namespace**: garrag-bahand
- **Règles de routage**:
  - URL racine (/) redirigée vers moadservice-front sur le port 8080.
  - URL (/api) redirigée vers moadservice-api sur le port 5000.
    Pendant les séances de tp, nous étions bloqués car nous avions pas compris que la communication entre l'api et le front end nécessite un url public. Nous avons compris       ensuite que c'était à cause du navigateur.
---

## Schéma Descriptif

Voici un schéma simplifié des composants et leur interaction dans le cluster Kubernetes :

(schema.png)


---

## Comment Déployer ?
1. **Déployer les composants** :
   

bash
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

## Les erreurs rencontrées?

1. **Communication entre le front et l'api** : Cela était résolu par l'ajout d'un url public qui pointe vers l'api dans l'ingress avec un ingress Rule.
2. **Ressources** : Nous pouvions pas testé nos modifications à cause de la surchage du cluster => des pods en pending.
3. **Une réponse 405 de l'api**
Nous avions un erreur http 405 signifie que le serveur a reçu une requête avec une méthode HTTP POST, mais que cette méthode n'est pas autorisée pour l'URL demandée.
Nous avions passé beaucoup de temps afin de comprendre la source du problème, grâce aux logs des pods nous avions rearqué que toutes les requêtes sont reçus comme suit :
kubectl logs -n garrag-bahand moadreplicataset-api-45lfg
 * Serving Flask app 'api'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://10.1.0.69:5000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 136-831-777
10.1.0.58 - - [16/Jan/2025 13:00:06] "GET / HTTP/1.1" 200 -
10.1.0.58 - - [16/Jan/2025 13:00:24] "POST / HTTP/1.1" 405 -
10.1.0.58 - - [16/Jan/2025 13:01:57] "POST / HTTP/1.1" 405 -
10.1.0.58 - - [16/Jan/2025 13:02:06] "GET / HTTP/1.1" 200 -
10.1.0.58 - - [16/Jan/2025 13:02:10] "POST / HTTP/1.1" 405 -

Après un temps de réflexion , nous avons compris que la source du problème viens de l'ingress qui fait la réecritures des paths à cause de cette instruction.

- **Annotations**: 
  - `nginx.ingress.kubernetes.io/rewrite-target: /`
  Après la correction de l'ingress, l'application a focntionné comme prévu
