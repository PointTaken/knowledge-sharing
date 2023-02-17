import * as MicrosoftGraph from "@microsoft/microsoft-graph-client";
import { getMsalToken } from "./authenticatingWithMsal";

export async function uploadDocument(fieldValues, fileToUpload) {
  const baseURL = "https://graph.microsoft.com/v1.0";
  //Creating the URL used for uploading the element. If you want to put the file in a folder inside the library just add <folder_name> after root like this "/root:/<folder_name>/<another_folder>/".
  const uploadURL =
    "/sites/<YOUR_SITE_ID>/drive/root:/" + fieldValues.filename + ":/content";
  //Making PUT request to upload file
  await window
    .fetch(baseURL + uploadURL, {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${await getMsalToken()}`,
      },
      body: fileToUpload,
    })
    .then(function (response) {
      response
        .json()
        .then(function (data) {
          //When file is uploaded, get the driveItemId and send it to updateFieldValues
          const driveItemId = data.id;
          updateFieldValues(driveItemId, fieldValues);
        })
        .catch((error) => {
          console.error("ERROR UPLOADING");
          console.error(error);
        });
    });
}

export async function updateFieldValues(driveItemId, fieldValues) {
  //Creating URL for updating the related ListItem field Values
  const site_id = "YOUR_SITE_ID";
  const updateURL =
    "https://graph.microsoft.com/v1.0/sites/" +
    site_id +
    "/drive/items/" +
    driveItemId +
    "/ListItem/fields";

  const fieldUpdateValues = {
    //Date values need to be a iso string
    CustomDate: new Date(fieldValues.fileCustomDate).toISOString(),
    ChoiceTest: fieldValues.fileCustomType,
  };

  //Checks if fileTags contain any info and adds them to metadata (Object.assign will ignore null values)
  const fileTags =
    fieldValues.fileTags.length > 0 ? { Tags: fieldValues.fileTags } : null;
  if (fileTags) {
    Object.assign(fieldUpdateValues, fileTags);
    //For multiple choice values we also need to set odata.type or the request will fail
    Object.assign(fieldUpdateValues, {
      "Tags@odata.type": "Collection(Edm.String)",
    });
  }

  window
    .fetch(updateURL, {
      method: "PATCH",
      headers: {
        Authorization: await getMsalToken(),
        "Content-Type": "application/json",
      },
      body: JSON.stringify(fieldUpdateValues),
    })
    .then((response) => response.json())
    .then((data) => {
      console.log("Update success");
    })
    .catch((error) => {
      console.error("ERROR");
      console.error(error);
    });
}
