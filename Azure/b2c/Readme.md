# Setting Up a New B2C Environment

1. Follow the instructions in [Microsoft's Custom Policies documentation](https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-create-user-flows?pivots=b2c-custom-policy) to add the app registrations `ProxyIdentityExperienceFramework` & `Identity Experience Framework`, along with the necessary keys.
    * **Note**: Make sure to keep the client IDs from the created app registrations as they will be used in the configuration.

1. In Azure B2C's "Company Branding" page, edit the default branding. Add the "Background Image for the Login Page" located at `/Branding/white-background.png` and add the "Banner Logo" found in `/Branding/banner-logo.png`. Save as such.
    * **Important note**: the logo's size can be up to 10 kpb.
    + The current HTML Pages in `/html` have been taken extracted from [Microsoft Azure Blue template](https://learn.microsoft.com/en-us/azure/active-directory-b2c/customize-ui-with-html?pivots=b2c-custom-policy). They define colors for buttons and background that should be updated with your own using the `Find And Replace` function in your favorite code editor.
        ```js
        ActiveColor:  rgb(0, 91, 212)
        HoverColor: rgb(0, 55, 101) 
        BackgroundColor: #EAF2FB;
        ```

1. For email sending via Sendgrid (for the template), a `SendGridSecret` should be added to the policy keys from Sendgrid's API key. For "Key Usage," choose "Signature".

## Deploy manually the custom policies
When updating the custom policies it can be quite usefull to deploy manually the policies. 
In that case you can follow the following steps after making the desired changes.

1. Run the `replaceParams` powershell scrip.
    ```ps
    .\replaceParams.ps1 -TenantName azureB2CTenantName -ProxyIdentityFrameworkId proxyIdentityFrameworkId -IdentityExperienceFrameworkId idenityExperienceFramework -BlobStorageName blobstorageName -SendGridVerifyEmailTemplateId templateId -SendGridFromEmail fromEmail ...#otherOptionnalParameters 
    ```

## Optionnal 

### Add Signup Validation
A signed token can be created before the registration of a user to verify the user has access to the application.
When entering the signup page his email will be extracted from the authorized token and will be in readonly. 
1. To setup, create this symmetric key and add it to the B2C policy keys under the name `IdTokenHintKey` (`B2C_1A_` will be prefixed). Refer to [Microsoft's documentation](https://learn.microsoft.com/en-us/azure/active-directory-b2c/id-token-hint#issue-a-token-with-symmetric-keys) if needed.
    * **Note**: Make sure to keep the secret as it will be used for API configuration.

### Add Rest Login Verification

For sign-in, a REST call can be sent to your API to verify he is a user of your application and enhance the claims on B2C sends to your client application.

To setup,
1. Uncomment the `Rest` Claims provider and Add the `Rest-Enhance-Claims` orchestration step.
1. To set it up, manually generate a secret and add it to a policy key named `RestApiPassword` in Azure B2C. Also add a username to a policy key named `RestApiUsername`. Keep both the secret and the username for API configuration.
