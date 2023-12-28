## Utilisation en local

Vous pouvez configurer un environnement sur votre propre abonnement Azure pour tester les fonctionnalités.
Lorsque vous exécutez localement, vous pouvez également déployer le locataire B2C (décommentez simplement le déploiement b2c dans le fichier main.bicep).
Sur Azure Devops, il est, pour le moment, [impossible de déployer avec un principal de service](https://stackoverflow.com/a/68458174).

## Exigences
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Votre abonnement Azure (visitez [Visual Studio Subscriptions](https://my.visualstudio.com/?auth_redirect=true) si vous n'avez pas encore activé votre abonnement)

## Instructions
1. Clonez le référentiel.
1. Dans une ligne de commande, changez de répertoire dans le dossier Infra
1. Connectez-vous avec Azure CLI
    ```ps
    az login
    ```
1. Liste des abonnements auxquels votre compte a accès
    ```ps 
    az account subscription list
    # Vous devriez voir votre abonnement Visual Studio
    [
        {
            "displayName": "Abonnement Visual Studio Enterprise – MPN",
            # Enregistrez l'ID d'abonnement
            "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            [...]
        },
        [...]
        ]
    ```
1. Changez l'abonnement actif en utilisant l'ID d'abonnement
    ```ps
    az account set --subscription "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    ```
1. Démarrez le déploiement
    ```ps
    az deployment sub create --location canadacentral --template-file ./main.bicep --parameters environment=dev location=canadacentral resourceGroupExists=false applicationName=#giveitaname
    ```
