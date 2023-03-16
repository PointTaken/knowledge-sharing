These commands can be run quickly and easily in Azure Clud Shell

### Create a secret in an App Registration with a longer lifetime ( 5 years in this example)

```javascript
az ad app credential reset --id APPREG_CLIENTID --append --years 5 --display-name 5_YEAR_SECRET
```

### Create a certificate in a Key Vault with a longer lifetime (48 months in this example)

```javascript
az keyvault certificate create --vault-name KEYVAULTNAME -n CERTIFICATENAME--validity 48 -p "$(az keyvault certificate get-default-policy)"
```