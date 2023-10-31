@allowed([
  'pr'
  'dev'
  'staging'
  'prod'
])
param environment string
param location string
param resourceGroupExists bool
param b2cTenantExists bool
param applicationName string
@allowed([
  'Global'
  'United States'
  'Europe'
  'Asia Pacific'
  'Japan'
  'Australia'
])
param tenantLocation string = 'United States'
// For more information on possible tenantCountryCode visit: https://learn.microsoft.com/en-us/azure/active-directory-b2c/data-residency
param tenantCountryCode string = 'CA'
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
var b2cTenantName = b2cName == '' ? '${replace(applicationName, '-', '')}${environment}' :  '${b2cName}${environment}'

module azureB2cDirectory 'modules/b2cdirectory.bicep' = if (!b2cTenantExists) {
  scope: createResourceGroup
  name: 'azureB2CTenantDeployment'
  params: {
    tenantName: b2cTenantName
    tenantlocation: tenantLocation
    tenantCountryCode: tenantCountryCode
    applicationName: applicationName
    environment: environment
  }
}
// This will host the files to update the default b2c html
module storageAccount 'modules/storageAccount.bicep' = {
  scope: createResourceGroup
  name: 'b2cstorageAccountDeployment'
  params: {
    applicationName: applicationName
    environment: environment
    properties: {
      accessTier: 'Hot'
      allowBlobPublicAccess: true
      allowCrossTenantReplication: true
      allowSharedKeyAccess: true
    }
    containers: [ { 
      name: 'templates'
      publicAccess: 'Blob'
    }]
    location: location
    blobServicePropertiesCors: [
      {
        allowedOrigins: ['https://${b2cTenantName}.b2clogin.com']
        allowedHeaders: ['*']
        exposedHeaders: ['*']
        allowedMethods: ['GET', 'OPTIONS']
        maxAgeInSeconds: 200
      }
    ]
  }
}
