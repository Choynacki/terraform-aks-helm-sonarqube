# terraform-aks-helm-sonarqube
# Procedure
terraform init 
terraform plan
terraform apply
echo "$(terraform output kube_config)" > azurek8s
export KUBECONFIG="${PWD}/azurek8s"
kubectl get nodes
kubectl expose deployment sonarqube-sonarqube --type=LoadBalancer --name=my-service
