# How to register an application in Azure AD using Azure CLI

> Prerequesites: Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

## Sign in to your tenant
When you have installed the Azure CLI you can sign in to your tenant. If you are on a dev-tenant or you don’t have a subscription to your account you should also add the “Allow-no-subscription” flag like shown below.

```powershell
az login

az login --allow-no-subscriptions
```

## Add the app
When you have successfully signed in you can register a new app with a simple line
```powershell
az ad app create --display-name MyApp01 --available-to-other-tenants false
```
This will return a JSON object with the app information. I have shortened it down a bit in the example below.

```json
{
  "acceptMappedClaims": null,
  "addIns": [],
  "allowGuestsSignIn": null,
  "allowPassthroughUsers": null,
  "appId": "ee26ecb3-977f-4520-ac21-be9eec424538",
 ...
  },
  ...
  ],
  "oauth2RequirePostResponse": false,
  "objectId": "301fc40c-a293-4509-8178-9d1b0fd76444",
  ...
  },
  ...
}
```