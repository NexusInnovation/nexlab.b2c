param
(
  [parameter(Mandatory = $true)] [String] $TenantName,
  [parameter(Mandatory = $true)] [String] $ProxyIdentityFrameworkId,
  [parameter(Mandatory = $true)] [String] $IdentityExperienceFrameworkId,
  [parameter(Mandatory = $true)] [String] $BlobStorageName,
  [parameter(Mandatory = $true)] [String] $SendGridVerifyEmailTemplateId,
  [parameter(Mandatory = $true)] [String] $SendGridFromEmail,
  [parameter(Mandatory = $false)] [String] $TenantId,
  [parameter(Mandatory = $false)] [String] $TokenIssuerId,
  [parameter(Mandatory = $false)] [String] $RestApiUrl
)

$lookupTable = @{
    '{{tenantName}}' = $TenantName
    '{{proxyIdentityExperienceFramework}}' = $ProxyIdentityFrameworkId
    '{{identityExperienceFramework}}' =  $IdentityExperienceFrameworkId
    '{{blobStorageName}}' = $BlobStorageName
    '{{sengridVerifyTemplateId}}' =  $SendGridVerifyEmailTemplateId
    '{{sendGridFromEmail}}' = $SendGridFromEmail
    '{{tenantId}}' = $TenantId
    '{{tokenIssuerApplicationId}}' = $TokenIssuerId
    '{{apiUrl}}' = $RestApiUrl
}

$pathToPolicies = '../Policies'
$destinationPolicyPath = '../PoliciesToUpload' 
$customPolicies = @(
    '/TrustFrameworkBase.xml',
    '/TrustFrameworkExtensions.xml',
    '/TrustFrameworkLocalization.xml',
    '/SignIn.xml',
    '/SignUpOnInvitation.xml'
)

foreach ($policy in $customPolicies) {
    $path = Join-Path -Path $pathToPolicies -ChildPath $policy
    $destinationPath = Join-Path -Path $destinationPolicyPath -ChildPath $policy

     # Check if destination directory exists, create it if not
     if (-Not (Test-Path -Path (Split-Path -Path $destinationPath) -PathType Container)) {
        New-Item -Path (Split-Path -Path $destinationPath) -ItemType Directory
    }
    Get-Content -Path $path | ForEach-Object {
        $line = $_
        
        $lookupTable.GetEnumerator() | ForEach-Object {
            if ($line.Contains($_.Key))
            {
                $line = $line.Replace($_.Key, $_.Value)
            }
        }
        $line
    } | Set-Content -Path $destinationPath
}