param environment string
param location string
param applicationName string
param properties object = {}
param containers ContainerProperties[] = []
param lifecycleManagementRules ManagementPolicyRule[] = []
param blobServicePropertiesCors BlobServicePropertiesCors[] = []

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  #disable-next-line BCP334 // Unless the application name AND environment are empty strings, this will not be a probleme. And if happens, then the problem is elsewhere
  name: toLower('${replace(applicationName, '-', '')}${environment}st')
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: properties
}

resource lifecycleManangement 'Microsoft.Storage/storageAccounts/managementPolicies@2022-09-01' = if (!empty(lifecycleManagementRules)) {
  name: 'default'
  parent: storageAccount
  properties: {
    policy: {
      rules: lifecycleManagementRules
    }
  }
}

resource blobservices 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    cors: {
      corsRules: blobServicePropertiesCors
    }
  }
}

resource storageContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = [for container in containers: {
  name: container.name
  parent: blobservices
  properties: {
    publicAccess: container.publicAccess
  }
}]

type ManagementPolicyRule = {
  definition: {
    actions: {
      baseBlob: {
        delete: {
          daysAfterCreationGreaterThan: int
        }
      }
    }

    filters: {
      blobTypes: string[]
      prefixMatch: string[]
    }
  }
  enabled: bool
  name: string
  type: string
}

type BlobServicePropertiesCors = {
  allowedOrigins: string[]
  allowedMethods: string[]
  allowedHeaders: string[]
  exposedHeaders: string[]
  maxAgeInSeconds: int
}

type ContainerProperties = {
  name: string
  publicAccess: 'Blob' | 'Container' | 'None' | null
}
