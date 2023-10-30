param environment string
param applicationName string
param tenantName string
param tenantProperties CreateTenantProperties
param b2clocation B2CLocation
param b2cSku B2CSku = { tier: 'A0', name: 'PremiumP1' }

resource symbolicname 'Microsoft.AzureActiveDirectory/b2cDirectories@2021-04-01' = {
  name: '${tenantName}.onmicrosoft.com'
  location: b2clocation
  sku: {
    name: b2cSku.name
    tier: b2cSku.tier
  }
  properties: {
    createTenantProperties: {
      countryCode: tenantProperties.countryCode
      displayName: 'b2c${applicationName}${environment}'
    }
  }
}

type B2CSku = { 
  tier: 'A0'
  name: 'PremiumP1' | 'PremiumP2' | 'Standard'
}
type CreateTenantProperties = {
  // For more information on available country codes : https://learn.microsoft.com/fr-fr/azure/active-directory-b2c/data-residency
  countryCode: 'CA' | 'US'
  displayName: string
}

type B2CLocation = 'Global' | 'United States' | 'Europe' | 'Asia Pacific' | 'Japan' | 'Australia'
