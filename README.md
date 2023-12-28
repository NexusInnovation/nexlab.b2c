## Préface
Pour nos clients, nous sommes souvent sollicités pour intégrer un système d’authentification pour les utilisateurs de leur entreprise. Étant une entreprise qui intègre des solutions cloud Azure, la solution la plus probable pour ce cas d’utilisation est Azure B2C.

Azure B2C offre des flux d’utilisateurs pré-construits qui peuvent rapidement créer une page de connexion et d’inscription. Cependant, ceux-ci sont limités en termes de possibilités de personnalisation et dans notre histoire d’intégration d’Azure B2C, on nous a souvent demandé des fonctionnalités qui étendaient les possibilités des flux d’utilisateurs. Nous avons donc toujours eu besoin de mettre en œuvre des politiques personnalisées.

Le but de ce projet est de faciliter le développement et l’intégration de politiques personnalisées pour une application multi-locataire.

Nous avons intégré dans ces politiques les cas d’utilisation les plus courants que nous avons rencontrés avec Azure B2C, qui sont :

- Personnalisation de l’apparence et de la convivialité des pages de connexion, d’inscription et de mot de passe oublié (à l’aide de Html & Css)
- Sécurisation de la page d’inscription pour limiter les utilisateurs qui y ont accès (à l’aide de jetons d’identification).
- Envoi d’e-mails personnalisés pour le mot de passe oublié pour correspondre à la marque de l’entreprise (à l’aide de SendGrid).
- Extension des claims d’Azure B2C en appelant une API REST lors de la connexion.

*Il est important de noter que [Microsoft Entra ID for Customers](https://learn.microsoft.com/en-us/entra/external-id/customers/overview-customers-ciam) est présentemment en "Preview" et visera à remplacer Azure B2C prochainement.*

## Configuration 
1. Créez le principal de service
    
    Dans les paramètres de votre projet Azure Devops, un principal de service doit être configuré pour Azure Portal.
1. Créez les bibliothèques requises
    
    Dans la section `Pipeline > Library`, trois bibliothèques doivent être créées. Les noms de celles-ci peuvent être remplacés dans les fichiers de pipeline.
    Par défaut, les bibliothèques requises sont : `B2CClient-Common`, `B2CClient-Staging` et `B2CClient-Prod`.

    La bibliothèque doit contenir les variables suivantes
    
    | Nom | Description | Exemple de valeur |
    | ----- | -----| -------|
    | ServicePrincipalName | Valeur du principal de service créé à l'étape 1 ou nom de votre principal de service existant | B2CAzure
    | Location | Emplacement pour le compte de stockage Azure | canadacentral, eastus, etc
    | ApplicationName | Nom utilisé pour créer les différentes ressources Azure. Sera suffixé avec l'environnement et préfixé avec le type de ressource | rg-{ApplicationName}-stg

1. Configurez chaque locataire Azure B2C comme décrit dans le fichier Readme disponible dans le référentiel à l'emplacement suivant : `Azure/b2c/Readme.md`.
1. Créez les environnements

    Dans les sections `Pipeline > Environnement` d'Azure Devops, deux environnements doivent être ajoutés. Les noms de ceux-ci peuvent être mis à jour dans le fichier azure-pipelines.
    Les environnements requis par défaut sont : `dev` et `prod`

1. Créez ou intégrez le pipeline Infra.
   
   Disponible à :  `Azure/Pipelines/infra-pipeline/azure-pipelines.yml`
1. Après le déploiement de l'infrastructure, vous devrez donner l'accès "Contributeur de données de stockage Blob" au principal de service sur le stockage de blobs pour déployer les fichiers html lorsqu'ils sont modifiés.

1. Créez le pipeline de stratégie 
   
   Disponible à :  `Azure/Pipelines/b2c-policies/azure-pipelines.yml`

## Ce qui n'est pas inclus
- Automatisation de la création de locataires B2C, d'inscriptions d'applications et de clés de stratégie (Policy keys)
- Automatisation de l'environnement Sendgrid et de la création de modèles de courrier électronique
- Implémentation backend de la génération de jetons Id Token pour l'inscription. Voir l'[implémentation que Microsoft propose](https://github.com/azure-ad-b2c/id-token-builder).
- Implémentation backend de l'appel REST pour l'ajout claims.

## Comment améliorer cette implémentation
- Support de plusieurs langues pour les pages HTML [Approche recommandé par Micosoft](https://learn.microsoft.com/en-us/azure/active-directory-b2c/customize-ui-with-html?pivots=b2c-user-flow#multi-template-approach)
- Deploiement du locataire B2C à travers d'un script powershell. 
- Amélioration de la sécurité de l'appel rest par API key.
- Centraliser la gestion des secrets en utilisant une Azure Key Vault.
