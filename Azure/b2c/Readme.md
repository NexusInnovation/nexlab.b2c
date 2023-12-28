# Configurer un nouvel environnement B2C

## Configuration manuelle nécessaire dans le locataire B2C
1. ### Créer les enregistrements d'applications requis.
    1. Pour les politiques personnalisées, suivez les instructions de la [documentation sur les politiques personnalisées de Microsoft](https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-create-user-flows?pivots=b2c-custom-policy) pour ajouter les enregistrements d'applications `ProxyIdentityExperienceFramework` et `Identity Experience Framework`, ainsi que les clés de politique nécessaires (`TokenSigninKeyContainer` et `TokenEncryptionKeyContainer`).
    
       **Remarque** : Assurez-vous de conserver les identifiants clients des enregistrements d'applications créés, car ils seront utilisés dans la configuration.

    1. Pour le déploiement des politiques Azure B2C, un enregistrement d'application doit être créé avec la permission Microsoft Graph `Policy > Policy.ReadWrite.TrustFramework`. 
Suivez la documentation [Register management application](https://learn.microsoft.com/en-us/azure/active-directory-b2c/microsoft-graph-get-started?tabs=app-reg-ga) de Microsoft pour la création.
    
       **Remarque** : Conservez l'identifiant client et le secret client que vous avez créés pour la configuration du pipeline de déploiement.

1. ### Ajouter les *Policy Keys*. 
    Dans votre locataire azure B2C, allez dans `Identiy Experience Framework > Policy Keys` et ajoutez les clés suivantes.
    
    1. Pour l'envoi d'e-mails via Sendgrid. 
        ```ts
        nom: SendGridSecret
        type: Manuel
        value: Votre clé API Send Grid
        keyUsage: Signature
        ```
    1. Pour la validation de l'inscription, un jeton signé (contenant l'e-mail de l'utilisateur) est créé avant qu'un lien d'inscription avec le jeton ne soit envoyé à votre utilisateur. 
    
        Créez la clé symétrique et ajoutez-la aux clés de politique B2C.
        
        ```ts
        nom: IdTokenHintKey
        type: Manuel
        value: Votre valeur secrète
        keyUsage: Encryption
        ```
        Consultez la [documentation de Microsoft pour plus d'informations](https://learn.microsoft.com/en-us/azure/active-directory-b2c/id-token-hint#issue-a-token-with-symmetric-keys)
    
    **Remarque**: Assurez-vous de garder le secret car il sera utilisé pour la configuration de votre API.

    Si vous utilisez `.NET`, un exemple de code est disponible sur [Azure B2C's Github](https://github.com/azure-ad-b2c/id_token_hint/tree/master/dotnet_core_symmetric_key) pour l'implémentation backend du lien d'inscription.

1.  ### Personnaliser l'apparence
    Dans la page "Company Branding" d'Azure B2C, modifiez le branding par défaut. Ajoutez l'"Image de fond pour la page de connexion" située à `/Branding/company-background.png` et ajoutez le "Logo de la bannière" trouvé dans `/Branding/banner-logo.png`. Enregistrez comme tel.
    * **Note importante**: la taille du logo peut aller jusqu'à 10 kpb.
    + Les pages HTML actuelles dans `/html` ont été extraites du [modèle Microsoft Azure Blue](https://learn.microsoft.com/en-us/azure/active-directory-b2c/customize-ui-with-html?pivots=b2c-custom-policy). Elles définissent les couleurs des boutons et du fond qui doivent être mises à jour avec les vôtres en utilisant la fonction `Rechercher et remplacer` dans votre éditeur de code préféré.
        ```js
        ActiveColor:  #276bfb
        HoverColor: #ff4e1f
        BackgroundColor: #276bfa
        ```
1. Dans votre Azure Devops, mettez à jour votre bibliothèque d'environnement pour ajouter les éléments suivants:  
    | Nom | Description | 
    | ----- | -----| 
    | DeploymentClientId | L'identifiant d'application / client de l'enregistrement d'application que vous avez créé à l'étape 1.2 | 
    | DeploymentClientSecret | Le secret client de l'enregistrement d'application que vous avez créé à l'étape 1.2 | 
    | IdentityExperienceFrameworkId | L'identifiant d'application / client de l'enregistrement d'application `IdentityExperienceFramework` que vous avez créé à l'étape 1.1 |
    | ProxyIdentityFrameworkId | L'identifiant d'application / client de l'enregistrement d'application `ProxyIdentityFramework` que vous avez créé à l'étape 1.1 | 
    | TenantId | Votre identifiant de locataire Azure B2C | 
    | TenantName | Votre nom de locataire Azure B2C | 
    | TokenIssuerId | L'émetteur configuré pour la validation de l'inscription du jeton Id |  
    | SendGridFromEmail | Une adresse e-mail que vous avez configurée dans Sendgrid pour envoyer des e-mails. Utilisé pour envoyer l'e-mail de mot de passe unique pour le mot de passe oublié. | 
    | SendGridVerifyEmailTemplateId | L'ID de modèle Sendgrid pour l'e-mail de mot de passe oublié | 

## Optionnel

### Ajouter l'appel REST à la connexion

Pour la connexion, un appel REST peut être envoyé à votre API pour vérifier qu'il s'agit d'un utilisateur de votre application et améliorer les revendications B2C à envoyer à votre application cliente.

Pour configurer,
1. Décommentez le fournisseur de revendications `Rest API` dans le fichier `TrustFrameworkExtensions.xnl` et décommenter les étapes d'orchestration `Rest-Enhance-Claims` dans `SignIn.xml` .
1. Pour le configurer, générer manuellement un secret et l'ajouter à une clé de stratégie nommée `RestApiPassword` dans Azure B2C. Ajoutez également un nom d'utilisateur à une clé de stratégie nommée `RestApiUsername`. Conservez à la fois le secret et le nom d'utilisateur pour la configuration de l'API.

Pour plus d'informations consulter la [documentation Microsoft sur le sujet](https://learn.microsoft.com/en-us/azure/active-directory-b2c/custom-policies-series-call-rest-api) et si vous utilisez `.NET`, un exemple de code est disponible sur [Azure B2C's Github](https://github.com/azure-ad-b2c/id_token_hint/tree/master/dotnet_core_symmetric_key) pour l'implémentation backend du lien d'inscription.


## Tester les politiques

### Déployer manuellement les politiques personnalisées à des fins de test
Lors de la mise à jour des politiques personnalisées, il peut être très utile de déployer manuellement les politiques. 
Dans ce cas, vous pouvez suivre les étapes suivantes après avoir apporté les modifications souhaitées.

1. Exécutez le script PowerShell `replaceParams`.
    ```ps
    .\replaceParams.ps1 -TenantName azureB2CTenantName -ProxyIdentityFrameworkId proxyIdentityFrameworkId -IdentityExperienceFrameworkId idenityExperienceFramework -BlobStorageName blobstorageName -SendGridVerifyEmailTemplateId templateId -SendGridFromEmail fromEmail ...#otherOptionnalParameters 
    ```
1. Dans votre AzureB2C, sous `Identity Experience Framework > Custom Policies`, téléchargez les politiques personnalisées du dossier `Azure/b2c/PoliciesToUpload` dans l'ordre suivant: 
    
    1. TrustFrameworkBase
    1. TrustFrameworkLocalization
    1. TrustFrameworkExtensions
    1. SignUpOnInvitation & SignIn