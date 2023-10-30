@allowed([
  'pr'
  'dev'
  'staging'
  'prod'
])
param environment string
param location string
param resourceGroupExists bool
param applicationName string
// Optionally set a custom display name for your tenant: {b2cName}.onmicrosoft.com
param b2cName string = ''

// For any resource you create, please follow the recommended abbreviations for Azure
// https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations

targetScope = 'subscription'

resource createResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = if (!resourceGroupExists) {
  name: 'rg-${applicationName}-${environment}'
  location: location
}

#disable-next-line BCP334 // Unless the application name AND environment are empty strings, this will not be a problem. And if happens, then the problem is elsewhere
var b2cTenantDisplayName = b2cName == '' ? toLower('${replace(applicationName, '-', '')}') : b2cName

module azureB2cDirectory 'modules/b2cdirectory.bicep' = {
  scope: createResourceGroup
  name: 'azureB2CTenantDeployment'
  params: {
    tenantName: b2cTenantDisplayName
    b2clocation: 'United States'
    applicationName: applicationName
    environment: environment
    tenantProperties: {
      displayName: b2cTenantDisplayName
      countryCode: 'CA'
    }
  }
}

