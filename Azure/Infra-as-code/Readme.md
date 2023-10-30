# Use this script locally

You can setup an environment on your own Azure Subscription to test features.

## Requirements
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Your azure subscription (Visit [Visual Studio Subscriptions](https://my.visualstudio.com/?auth_redirect=true) if you haven't activated your subscription yet)

## Instructions
1. Clone the repo.
1. In a command line, change directory into the Infra folder
1. Login with Azure CLI
    ```ps
    az login
    ```
1. List the subscriptions your account has access to
    ```ps 
    az account subscription list
    # You should see your Visual Studio Subscription
    [
        {
            "displayName": "Abonnement Visual Studio Enterprise – MPN",
            # Record the subscription ID
            "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            [...]
        },
        [...]
        ]
    ```
1. change the active subscription using the subscription ID
    ```ps
    az account set --subscription "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    ```
1. Start the Deployment
    ```ps
    az deployment sub create --location canadacentral --template-file ./main.bicep --parameters environment=dev location=canadacentral resourceGroupExists=false applicationName=#giveitaname
    ...otherParameters
    ```