<template>
  <div>
    <h1>{{ msg }}</h1>
    <form id="uploadDocForm">
      <input id="selectedFile" type="file" />
      <button type="submit" form="uploadDocForm" v-on:click="onSubmit">
        Upload file to SharePoint
      </button>
    </form>
  </div>
</template>

<script>
import { signInWithMsal } from "../authenticatingWithMsal";
import { uploadDocument } from "../uploadingDocWithGraph";
export default {
  name: "UploadIncidentForm",
  props: ["msg"],
  setup() {

    const onSubmit = async (event) => {
      event.preventDefault();
      await signInWithMsal();
      const filename = document.getElementById("selectedFile").files[0].name;
      const fileToUplode = 
          document.getElementById("selectedFile").files[0];
      const filereader = new FileReader();
      filereader.onload = async (event) => {
        const test = await uploadDocument(filename, event.target.result);
      };
      filereader.readAsArrayBuffer(fileToUplode);
    };
    return {
      onSubmit,
    };
  },
};
</script>
