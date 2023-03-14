# Install required modules (if you are local admin) (only needed first time).
Install-Module -Name DCToolbox -Force
Install-Module -Name AzureADPreview -Force -AllowClobber
Install-Package msal.ps -Force​

# Install required modules as curren user (if you're not local admin) (only needed first time).
Install-Module -Name DCToolbox -Scope CurrentUser -Force
Install-Module -Name AzureADPreview -Scope CurrentUser -Force
Install-Package msal.ps -AcceptLicense -Force

# Import required modules if needed
Import-Module DCToolbox

# If you want to, you can run Connect-AzureAD before running Enable-DCAzureADPIMRole, but you don't have to.
Connect-AzureAD​

# Enable one of your Azure AD PIM roles.
Enable-DCAzureADPIMRole​

# Enable multiple Azure AD PIM roles.

# Fully automate Azure AD PIM role activation.
Enable-DCAzureADPIMRole -RolesToActivate 'Exchange Administrator', 'Intune administrator', 'Global Reader', 'User Administrator', 'Security Administrator', 'Cloud Application Administrator', 'Identity Governance Administrator', 'SharePoint Administrator' -UseMaximumTimeAllowed -Reason 'Security Hardening.'