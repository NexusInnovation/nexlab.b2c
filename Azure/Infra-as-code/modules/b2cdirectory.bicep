param environment string
param applicationName string
param tenantName string
param tenantlocation B2CLocation
param tenantCountryCode string
param b2cSku B2CSku = { tier: 'A0', name: 'PremiumP1' }

resource symbolicname 'Microsoft.AzureActiveDirectory/b2cDirectories@2021-04-01' = {
  name: '${tenantName}.onmicrosoft.com'
  location: tenantlocation
  sku: {
    name: b2cSku.name
    tier: b2cSku.tier
  }
  properties: {
    createTenantProperties: {
      countryCode: tenantCountryCode
      displayName: 'b2c${applicationName}${environment}'
    }
  }
}

type B2CSku = { 
  tier: 'A0'
  name: 'PremiumP1' | 'PremiumP2' | 'Standard'
}

type B2CLocation = 'Global' | 'United States' | 'Europe' | 'Asia Pacific' | 'Japan' | 'Australia'
