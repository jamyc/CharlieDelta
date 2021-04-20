@description('The name of the Managed Cluster resource.')
param clusterName string

@description('The location of AKS resource.')
param location string = resourceGroup().location

@description('The version of Kubernetes.')
param kubernetesVersion string = '1.18.14'

resource aks 'Microsoft.ContainerService/managedClusters@2020-09-01' = {
  location: location
  name: clusterName
  properties: {
    kubernetesVersion: kubernetesVersion
    enableRBAC: true
    dnsPrefix: 'dnsprefix'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: 0
        count: 1
        vmSize: 'Standard_B2s'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        maxPods: 30
      }
    ]
    networkProfile: {
      loadBalancerSku: 'standard'
      networkPlugin: 'kubenet'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output controlPlaneFQDN string = reference('Microsoft.ContainerService/managedClusters/${clusterName}').fqdn
