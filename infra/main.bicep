param appName string

module cr 'containerregistry.bicep' = {
  name: 'acrDeploy'
  params: {
    acrName: 'acr${appName}'
  }
}

module aks 'kubernetesservice.bicep' = {
  name: 'aksDeploy'
  params: {
    clusterName: 'aks-${appName}'
  }
}
