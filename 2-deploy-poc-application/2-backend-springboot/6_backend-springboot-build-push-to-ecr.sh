#!/bin/sh

cd 2-deploy-poc-application/2-backend-springboot

# Step 1: package spring boot application 
./mvnw -DskipTests clean package

VERSION=v0.0.1
AWS_ACCOUNT_ID=XXXXXXXXXXXX
REPO_SPRING_BOOT=eks-springboot-poc

# Step 2: Create Docker Image
docker build -t $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$REPO_SPRING_BOOT:$VERSION .

# Step 3: Push Image to ECR repository
docker push  $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$REPO_SPRING_BOOT:$VERSION

# Step 4: Deploy application to EKS 
kubectl apply -f k8s-manifest/spring-boot-app.yaml

# Step 5 : LoadBalancer (External URL)
POD=$(kubectl get svc -l app=eks-springboot-poc | grep LoadBalancer | awk '{print $4}')
echo "${POD}"":8080"

cd ../..