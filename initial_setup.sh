#!/bin/bash
# Setup kubeconfig
az aks get-credentials --resource-group rg-cloudengineerjamy2 --name akscloudengineerjamy2 

ENVIRONMENTS=('dev' 'prod')

for environment in "${ENVIRONMENTS[@]}"
do
	echo "Creating k8s namespaces for '$environment'..."
	kubectl create namespace $environment
	kubectl create namespace ingress-$environment

	echo "Creating public ip for '$environment'..."
	IPADDRESS=$(az network public-ip create --resource-group MC_rg-cloudengineerjamy2_akscloudengineerjamy2_westeurope --name pipcharlie$environment --sku Standard --allocation-method static --query publicIp.ipAddress -o tsv)

	helm install nginx-ingress-$environment ingress-nginx/ingress-nginx \
		--namespace ingress-$environment \
		--set controller.ingressClass=ingress$environment \
		--set controller.watchNamespace=ingress-$environment \
		--set controller.replicaCount=2 \
		--set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
		--set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
		--set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux \
		--set controller.service.loadBalancerIP="$IPADDRESS" \
		--set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="ingress$environment"
done
