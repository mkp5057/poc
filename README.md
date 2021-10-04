# AWS EKS Infrastructure creation using Cloud formation and POC Application Deployment

## Pre-requisite:
- Install docker desktop, install aws cli, install kubectl, insall eksctl

- Create Dedicated VPC for the EKS Cluster

  Stack name 		: **eks-vpc** 
  ```
  CloudFormation Template: 
  0_cloudFormation-eks-vpc.yaml
  ```  
- Create ECR Repository and authenticate Docker

  Repository name : **spring-boot-postgres-poc**  
  Repository name : **eks-angular-poc**
  
  - [x] **Update script placeholder XXXXXXXXXXXX with AWS ACCOUNT ID and Execute below script**
  ```
  ./1-infra-creation/5_ecr-springboot-angular.sh
  ```  

## High Level Tasks
- Step A : Create EKS Cluster using Cloud formation - Infrastructure
  - Step 1: Create IAM role for EKS Cluster  
  - Step 2: Create EKS Cluster
- Step B : Create EKS Worker Nodes using Cloud formation - Infrastructure
  - Step 3: Create IAM Role for EKS Worker Nodes
  - Step 4: Create Worker nodes
- Step C : Deploy POC application using kubernetes manifest 
  - Step 5: Deploy PostgreSQL DB cluster into EKS
    - Step 5.1: Execute kubernetes manifest
    - Step 5.2: Create a config map with the hostname of Postgres    
  - Step 6: Deploy Spring Boot Application into EKS
    - Step 6.1. Build Spring boot docker image, push to ECR and Deploy to EKS    
  - Step 7: Deploy frontend(Angular) into EKS
    - Step 7.1. Build Angular docker image, push to ECR and Deploy to EKS
- Step D : Delete Resouces
    - Step 8: Delete Infra and deployed application
      - Step 8.1: undeploy angular, spring boot and postgres
      - Step 8.2: Delete eks infrastructure (cloudformation stacks)
  
## Step A: Create EKS Cluster using Cloud formation - Infrastructure

### Step 1: Create IAM role for EKS Cluster 

Stack name: **eksClusterRole**
```
CloudFormation Template:  
1_cloudFormation_eksClusterRole.yaml
```

### Step 2: Create EKS Cluster
Stack name 		: **eks-cluster** 
Cluster name 	: **eks-cluster**

 - [x] **Note: Get parameters values from output of cloud formation stack created above ( Pre-requisite: eks-vpc and Step 1: eksClusterRole stack)**
```
CloudFormation Template:  
2_cloudFormation_ekscluster.yaml
```

**Test Cluster**
 - [x] **Note : install aws cli and install kubectl on your local machine**
```
aws  eks --region us-east-1 update-kubeconfig --name eks-cluster
kubectl get svc
```

## Step B : Create EKS Worker Nodes using Cloud formation - Infrastructure

### Step 3: Create IAM Role for EKS Worker Nodes
Stack name 		: **eksWorkerNodeGroupRole** 

Below  template will create amazon eks nodegroup role along with needed Node group cluster autoscaler policy
```
CloudFormation Template:  
3_cloudFormation_eks-nodegroup-role.yaml
```

### Step 4: Create Worker nodes
Stack name 		: **eks-worker-node-group** 

```
CloudFormation Template:  
4_cloudFormation_eksnodegroup.yaml
```

**Test worker nodes**
```
kubectl get nodes -o wide
```

## Step C : Deploy POC application using kubernetes manifest 

### Step 5: Deploy PostgreSQL DB cluster into EKS

- Step 5.1: Execute kubernetes manifest
  Service Name	: **postgres**
  ```
  cd eks-poc
  kubectl create -f 2-deploy-poc-application/1-db/postgres.yaml
  ```
-  Step 5.2: Create a config map with the hostname of Postgres
  This config map will be used in Spring Boot Application as part of JDBC connection URL
  ```
  kubectl create configmap hostname-config --from-literal=postgres_host=$(kubectl get svc postgres -o jsonpath="{.spec.clusterIP}")
  ```

### Step 6: Deploy Spring Boot Application into EKS
  
- Step 6.1. Build Spring boot docker image, push to ECR and Deploy to EKS

  Service Name	: **spring-boot-postgres-poc**
  - [x] **update script placeholder XXXXXXXXXXXX with AWS ACCOUNT ID and**
  - [x] **update spring-boot-app.yaml placeholder XXXXXXXXXXXX with AWS ACCOUNT ID and Execute below script**
  
  ```
  cd eks-poc
  ./2-deploy-poc-application/2-backend-springboot/6_backend-springboot-build-push-to-ecr.sh  
  ```

**Test**
```
kubectl get svc spring-boot-postgres-poc
OPEN FROM BROWSER: 
http://<External IP Address>:8080

REST APIs - Test FROM Postman
API http://<External IP Address>:8080/api/v2/employees
```

### Step 7: Deploy frontend(Angular) into EKS

- Step 7.1. Build Angular docker image, push to ECR and Deploy to EKS

  Service Name	: **eks-angular-poc-loadbalancer**
  importtant files **custom-nginx.conf** and *Dockerfile*
  
  - [x] **update script placeholder XXXXXXXXXXXX with AWS ACCOUNT ID and**
  - [x] **update angular-app.yaml placeholder XXXXXXXXXXXX with AWS ACCOUNT ID and Execute below script**

  ```
  cd eks-poc
  ./2-deploy-poc-application/3-frontend-angular/7_front-angular-build-push-to-ecr.sh
  ```

**Test**
```
kubectl get svc eks-angular-poc-loadbalancer
http://<External IP Address>
```
      
## Step D : Delete Resouces

### Step 8: Delete Infra and deployed application
- Step 8.1: undeploy angular, spring boot and postgres
	```
	cd eks-poc
	./2-deploy-poc-application/undeploy_poc_app.sh
	```
- Step 8.2: Delete eks infrastructure (cloudformation stacks)
	```
	eks-worker-node-group
	eksWorkerNodeGroupRole
	eks-cluster
	eksClusterRole
	eks-vpc
	```
	
## References

- Commands
  ```
  kubectl exec -it postgres-statefulset-0 -- /bin/bash
  #psql -U Username DatabaseName 
  psql -U admin pocdb

  \connect database_name
  \l 	: list all databases
  \dt : : list all tables in the current database
  \d  table name : describe table

  $ kubectl get deploy
  $ kubectl get svc
  $ kubectl get pod

  POD=$(kubectl get pods -l app=spring-boot-postgres-poc | grep 0/1 | awk '{print $1}')
  echo "${POD}"
  kubectl  logs "${POD}"

  aws cloudformation delete-stack --stack-name <my-vpc-stack>
  
  kubectl scale deployment spring-boot-postgres-poc --replicas=3
  ```
- Links
  ```
  https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html
  ```

