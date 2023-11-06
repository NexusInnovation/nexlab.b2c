@allowed([
  'dev'
  'stg'
  'prd'
])
param environment string
param location string
param resourceGroupExists bool
param applicationName string
param b2cTenantName string

targetScope = 'subscription'

resource createResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = if (!resourceGroupExists) {
  name: 'rg-${applicationName}-${environment}'
  location: location
}
/* This Will work locally but there's an authorisation issue when using it in Azure Devops
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
/*
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
*/
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
