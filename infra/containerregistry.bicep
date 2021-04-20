@description('Specifies the name of the azure container registry.')
param acrName string

@description('Specifies the Azure location where the key vault should be created.')
param location string = resourceGroup().location

// azure container registry
resource acr 'Microsoft.ContainerRegistry/registries@2019-12-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
}

output acrLoginServer string = acr.properties.loginServer
