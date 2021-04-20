module cr 'containerregistry.bicep' = {
  name: 'acrDeploy'
  params: {
    acrName: 'acrcloudengineer'
  }
}

module aks 'kubernetesservice.bicep' = {
  name: 'aksDeploy'
  params: {
    clusterName: 'aks-cloudengineer'
  }
}
