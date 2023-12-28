## Foreword
For our clients, we are often asked to integrate an authentification system for their company's users. Being a company that integrates Azure cloud solutions, the most likely solution for that use case is Azure B2C.

Azure B2C offers prebuilt _user flows_ that can quickly create sign in and signup page. However, these are limited in customazitation possibilities and in our history of integrating Azure B2C, we were often asked for features that extended the possibilities of _user flows_. Therefore we always had the need to implement _Custom Policies_. 

The goal of this project is to facilitate the development and integration of custom policies for a multi-tenant application.  

We have integrated in these policies the most common use cases we have been asked with Azure B2C, which are :
- Customizing the Look and feel of Sign-In, Sign-Up and Forgot Password pages (using Html & Css)
- Securing the signup page to limit the users who have access to it (using Id Tokens).
- Send customized emails for Forgot Password to match the company's brand (using SendGrid).
- Extending the claims of Azure B2C by calling a rest API during Sign-In.

*It is important to note that [Microsoft Entra ID for Customers](https://learn.microsoft.com/en-us/entra/external-id/customers/overview-customers-ciam) is currently in preview and will eventually replace Azure B2C*

## What's included
- Separate Custom Policy for Signin and Signup
    - Sign In policy with a Forgot Password page that sends a One Time Password via a Sengrid's template.
    - Signup policy with Id Token validation to make sure the user was invited and can only signup with the email the invitation was sent to.
- Custom html page to change the appearance and titles of sign-in, sign-up and forgot password pages. 
- Azure Devops Pipelines to deploy in multiples environments:
    - The required infrastructure (a Blob storage for B2C Html Pages)
    - Azure B2C Custom Policies and html templates. 
## Configuration 
1. Create the service principal
    
    In your Azure Devops project settigns a service principal must be configured for Azure Portal.
1. Create the required Libraries
    
    In the `Pipeline > Library`` section, three libraries must be created. The names of which can be replaced in the pipeline files.
    By default, the required libraries are : `B2CClient-Common`, `B2CClient-Staging` & `B2CClient-Prod`.

    The library must contain the following variables
    
    | Name | Description | Value example |
    | ----- | -----| -------|
    | ServicePrincipalName | Value of the service principal created in step 1 or your existing Service Principal Name | B2CAzure
    | Location | Location for the Azure storage account | canadacentral, eastus, etc
    | ApplicationName | Name used for creating the different azure ressources. Will be suffixed with the environment and prefixed with ressource type | rg-{ApplicationName}-stg

1. Configure each Azure B2C tenant as described in the Readme file available in the repo at the following path: `Azure/b2c/Readme.md`.
1. Create the environments

    In the `Pipeline > Environment`` sections of Azure Devops, two environments must be added. The names of which can be updated in the azure-pipelines file.
    The required environment by default are : `dev` & `prod`

1. Create or integrate the Infra Pipeline.
   
   Available at :  `Azure/Pipelines/infra-pipeline/azure-pipelines.yml`
1. After deploying the infra, you will have to give "Storage Blob Data Contributor" access to the Service Principal over the blob storage to deploy html files when they are changes.

1. Create the Policy Pipeline 
   
   Available at :  `Azure/Pipelines/b2c-policies/azure-pipelines.yml`

## What's not included
- Automatisation of B2C Tenant, AppRegistrations and Policy keys creation
- Automatisation of Sendgrid environment and Email Template creation
- Id token BE Generation Implementation
- Rest API Call BE Implementation

## How to take it further
- Internationnalisation of Html Pages (to support multiple languages)
- Deployment of B2C tenant through Powershell script.
- Improving secret security by using Key Vault in the Library