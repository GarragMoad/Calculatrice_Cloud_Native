#!/bin/bash

# Définir le namespace
NAMESPACE="garrag-bahand"

# Supprimer tous les éléments dans le namespace
kubectl delete all --all -n $NAMESPACE

# Créer le namespace s'il n'existe pas
kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE

# Appliquer les fichiers de configuration YAML
kubectl apply -f Redis/redis.yaml -n $NAMESPACE
kubectl apply -f Redis/redis-service.yaml -n $NAMESPACE
kubectl apply -f RabbitMQ/rabbitMQ.yaml -n $NAMESPACE
kubectl apply -f RabbitMQ/rabbitMQ-service.yaml -n $NAMESPACE
kubectl apply -f Api/api.yaml -n $NAMESPACE
kubectl apply -f Api/api-service.yaml -n $NAMESPACE
kubectl apply -f Front/front.yaml -n $NAMESPACE
kubectl apply -f Front/svc-front.yaml -n $NAMESPACE
kubectl apply -f Consumer/consumer.yaml -n $NAMESPACE
kubectl apply -f Consumer/consumer-service.yaml -n $NAMESPACE

# Vérifier l'état des Pods
kubectl get pods -n $NAMESPACE

# Vérifier l'état des Services
kubectl get svc -n $NAMESPACE

# Vérifier l'état de l'Ingress
kubectl get ingress -n $NAMESPACE