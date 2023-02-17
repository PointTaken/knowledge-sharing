import * as MicrosoftGraph from "@microsoft/microsoft-graph-client";
import { getMsalToken } from "./authenticatingWithMsal";

export async function uploadDocument(filename, fileToUpload) {
  const baseURL = "https://graph.microsoft.com/v1.0";
  const uploadURL =
    "<YOUR_SITE_ID>/drive/root:/" +
    filename +
    ":/content";
  await window
    .fetch(baseURL + uploadURL, {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${await getMsalToken()}`,
      },
      body: fileToUpload,
    })
    .then((response) => {
      console.group("Response");
      console.log(response);
      console.groupEnd();
    })
    .catch((error) => {
      console.error("ERROR UPLOADING");
      console.error(error);
    });
}
