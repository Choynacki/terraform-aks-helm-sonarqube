# terraform-aks-helm-sonarqube
# Procedure
az login
az account set --subscription "Subscription ID"
terraform init 
terraform plan
terraform apply

#Save output to 
C:\Users\"current user"\.kube\config

kubectl get nodes
kubectl expose deployment sonarqube-sonarqube --type=LoadBalancer --name=my-service
