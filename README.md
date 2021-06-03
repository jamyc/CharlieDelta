# What are we doing here?
This repository contains two simple APIs built in Go: Charlie and Delta. When Charlie receives a request, it will send a request to Delta, wait for the response and combine Delta's result to respond with the following:
```
I'm charlie-deployment-7cd9bb6d4b-wmtwb! Who are you? I'm delta-deployment-6f868b498c-mgm8k!
[                      Charlie                      ] [               Delta                ]
```

Tech/tools used:
- [Golang](https://golang.org/) for the API's
- Azure DevOps multistage yaml pipelines for CI/CD
- [Bicep](https://github.com/Azure/bicep) for infrastructure deployment
- [Kustomize](https://github.com/kubernetes-sigs/kustomize) for manifest baking based on the environment
	- For example: only the prod release will create a HorizontalPodAutoscaler with a minimum of 3 replicas. Whereas dev will not have a hpa.

# First time setup
- Import/create the three pipelines in Azure DevOps:
	- infra/azure-pipelines.yml
	- src/charlie/azure-pipelines.yml
	- src/delta/azure-pipelines.yml
- Run the infrastructure pipeline
	- This will deploy an ACR and AKS resource using Bicep
- Execute `initial_setup.sh` from a terminal (requires kubectl and az cli)
	- This will create dev + prod namespaces, public IPs and ingresses. This could theoretically be integrated in an Azure DevOps pipeline. 
- Create new Azure DevOps Service Connections:
	- Docker Registry (ACR). Service connection name: ContainerRegistryServiceConnection
	- Kubernetes (Azure Subscription):
		- Service connection name: KubernetesDevServiceConnection
		- Namespace: dev
	- Kubernetes (Azure Subscription):
		- Service connection name: KubernetesProdServiceConnection
		- Namespace: prod
- Run the pipelines for Charlie + Delta
	- These 'app' pipelines have three stages:
		- Build: Builds and tags the Docker image and pushes it to ACR
		- Deploy Dev: Bake k8s manifests using Kustomize and deploy to dev namespace
		- Deploy Prod: Bake k8s manifests using Kustomize and deploy to prod namespace
After the deployment is done, the ingress is reachable at:
- Dev url: http://ingressdev.westeurope.cloudapp.azure.com/
- Prod url: http://ingressprod.westeurope.cloudapp.azure.com/
