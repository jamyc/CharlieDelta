param appName string

var acrName = 'acr${appName}'
var aksName = 'aks${appName}'

module cr 'containerregistry.bicep' = {
  name: 'acrDeploy'
  params: {
    acrName: acrName
  }
}

module aks 'kubernetesservice.bicep' = {
  name: 'aksDeploy'
  params: {
    clusterName: aksName
  }
}

output aksClusterName string = aksName
