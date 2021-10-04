#!/bin/sh

cd 2-deploy-poc-application/3-frontend-angular

VERSION=v0.0.1
AWS_ACCOUNT_ID=XXXXXXXXXXXX
REPO_ANGULAR=eks-angular-poc

# Step 2: Create Docker Image
docker build -t $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$REPO_ANGULAR:$VERSION .

# Step 3: Push Image to ECR repository
docker push  $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$REPO_ANGULAR:$VERSION

# Step 4: Deploy application to EKS 
kubectl apply -f k8s-manifest/angular-app.yaml

# Step 5 : LoadBalancer (External URL)
POD=$(kubectl get svc -l app=eks-angular-poc-loadbalancer | grep LoadBalancer | awk '{print $4}')
echo "${POD}"

cd ../..