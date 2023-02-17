import * as msal from "@azure/msal-browser";

/** Configuration. Here you need to exchange the values with your own */
const msalConfig = {
  auth: {
    clientId: "<YOUR_APP_ID",
    // comment out if you use a multi-tenant AAD app
    authority:
      "https://login.microsoftonline.com/<YOUR_TENANT_ID>",
    redirectUri: "http://localhost:3000/" //This URL must match the one set in azure app reg
  },
};
const msalRequest = {
  scopes: ["User.Read", "Files.ReadWrite", "Files.ReadWrite.All"],
};

//Initialize MSAL client - you will use this to communicate with your azure app registration to log in the user
const msalClient = new msal.PublicClientApplication(msalConfig);

export async function signInWithMsal() {
  const authResponse = await msalClient.loginPopup(msalRequest);
  sessionStorage.setItem("msalAuthName", authResponse.account.username);

  //You can also add functionallity to get the token silently first if the user is allready logged in.
  // resource: https://docs.microsoft.com/en-us/azure/active-directory/develop/scenario-spa-acquire-token?tabs=javascript1
}

export async function getMsalToken() {
  let username = sessionStorage.getItem("msalAuthName");
  try {
    const silentRequest = {
      scopes: msalRequest.scopes,
      account: msalClient.getAccountByUsername(username),
    };
    const silentResult = await msalClient.acquireTokenSilent(silentRequest);
    return silentResult.accessToken;
  } catch (error) {
      //Add handling for new login promt here - if the silent request should fail
    console.error(error);
  }
}
