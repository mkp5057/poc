#!/bin/sh

REPO_SPRING_BOOT=eks-springboot-poc
REPO_ANGULAR=eks-angular-poc

# Step 1: Delete Angular
cd 2-deploy-poc-application/3-frontend-angular
kubectl delete -f k8s-manifest/angular-app.yaml
cd ../..

# Step 2: Delete Spring boot
cd 2-deploy-poc-application/2-backend-springboot
kubectl delete -f k8s-manifest/spring-boot-app.yaml
cd ../..

# Step 3: Delete  Config map
kubectl delete cm hostname-config

# Step 4: Delete DB POstgress
cd 2-deploy-poc-application/1-db
kubectl delete -f postgres.yaml
cd ../..

# Step 5: Delete ECR
aws ecr delete-repository \
    --repository-name  $REPO_ANGULAR \
    --force
aws ecr delete-repository \
    --repository-name  $REPO_SPRING_BOOT \
    --force


