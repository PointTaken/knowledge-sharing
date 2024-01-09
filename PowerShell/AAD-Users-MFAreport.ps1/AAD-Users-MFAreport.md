# Synopsis
Created by Odd Daniel Taasaasen

# Script content

This script generates a report for Azure Active Directory (AAD) users' authentication methods, RBAC roles, and enterprise roles.
The script imports necessary modules, sets variables for connecting to Azure, retrieves users from Azure AD, and loops through each user to gather their authentication methods, RBAC roles, and enterprise roles. The collected data is then stored in a CSV file.

# Parameters
The Azure AD tenant ID.
The clientid for the service principal used to connect to Azure.
The secret for the service principal used to connect to Azure.

# Prerequsites
An app registration with the role directory.read.all

Powershell 7 

Modules: 
Microsoft.Graph.Identity.Governance
Microsoft.Graph.Identity.Identity
az.resources

---
# Conclution
Microsoft will depricate all old versions of TLS in June 2024. Make sure you run this script before then!
