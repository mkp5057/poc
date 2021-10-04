#!/bin/sh

AWS_ACCOUNT_ID=XXXXXXXXXXXX
REPO_SPRING_BOOT=eks-springboot-poc
REPO_ANGULAR=eks-angular-poc

# Step 1:ECR Repository for spring boot appication 
aws ecr create-repository \
     --repository-name  $REPO_SPRING_BOOT \
     --region us-east-1

aws ecr get-login-password \
     --region us-east-1 | docker login \
     --username AWS \
     --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$REPO_SPRING_BOOT
	 
# Step 2:ECR Repository for Angular appication 
aws ecr create-repository \
   --repository-name  eks-angular-poc \
   --region us-east-1

aws ecr get-login-password \
   --region us-east-1 | docker login \
   --username AWS \
   --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$REPO_SPRING_BOOT