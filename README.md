## Foreword
In the consultation industry, we are often asked to integrate an authentification system for a company's users. Being a company that integrates Azure cloud solutions, the most likely solution for that use case is Azure B2C.
Azure B2C offers prebuilt _user flows_ that can quickly create sign in and signup page. However, these are limited in customazitation possibilities and in our history of integrating Azure B2C, we were often asked for features that extended the possibilities of _user flows_. Therefore we needed to implement _Custom Policies_. 

The goal of this project is to facilitate the development and integration for the most common use cases we have been asked with Azure B2C, which are :
- Customizing the Look and feel of Sign-In, Sign-Up and Forgot Password pages (using Html & Css)
- Securing the signup page to limit the users who have access to it.
- Send customized emails for Forgot Password to match the company's brand (using sengrid).
- Extending the claims of Azure B2C by calling a rest API during Sign-In.

## What's included
- Azure Devops Pipelines to deploy in multiples environments:
    - An Azure B2C Tenant and a Blob storage for B2C Html Pages
    - Azure B2C Custom Policies 
- Seperate Custom Policy for Signin and Signup
    - Sign In policy includes a Forgot Password page that sends a One Time Password via a Sengrid's template and possible rest call to enhance claims sent.
    - Signup policy includes a Id Token extract step to validate the user has access to the signup page. The user can only signup with the email the invitation was sent to.
- Custom html page to change the titles of sign-in, sign-up and forgot password pages. 

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
    | B2CTenantLocation | Location where B2C will store consumer data. | 'United States', 'Europe', etc. [For more information](https://learn.microsoft.com/en-us/azure/active-directory-b2c/data-residency)
    | B2CTenantCountryCode | Must match the B2CTenant Location. [For more information](https://learn.microsoft.com/en-us/azure/active-directory-b2c/data-residency) | 'CA', 'US' for example will be stored in 'United States'
    |
- Create the environments

    In the `Pipeline > Environment`` sections of Azure Devops, two environments must be added. The names of which can be updated in the azure-pipelines file.
    The required environment by default are : `stg` & `prod`


## What's not included
- Automatisation of AppRegistration and Policy key creation
- Automatisation of Sendgrid Template creation
- Id token BE Generation Implementation
- Rest API Call BE Implementation

## How to take it further
- Internationnalisation of Html Pages (to support multiple languages)