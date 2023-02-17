<template>
  <div class="container demo-wrapper">
    <h1>{{ msg }}</h1>
    <form @submit="onSubmit" id="uploadDocForm" class="container">
      <div class="row">
        <label class="col-3 col-md-3 col-sm-12">Date </label>
        <div class="col-3 col-md-3 col-sm-12">
          <input required id="customDate" type="date" />
        </div>
      </div>
      <div class="row">
        <label class="col-3 col-md-3 col-sm-12">Type:</label>
        <div class="col-3 col-md-3 col-sm-12">
          <select required id="customType" name="customType">
            <option value="" selected disabled hidden>Select a type</option>
            <option
              v-for="(customType, i) in typeValues"
              v-bind:key="'thistype' + i"
              v-bind:value="customType"
            >
              {{ customType }}
            </option>
          </select>
        </div>
      </div>
      <div class="row">
        <label class="col-3 col-md-3 col-sm-12"> Another value: </label>
        <div class="col-3 col-md-3 col-sm-12">
          <input required id="anotherValue" name="anotherValue" />
        </div>
      </div>
      <div class="row">
        <label class="col-3">Tags: </label>
        <div class="col-9">
          <div 
            v-for="(tag, i) in tagsValues"
            v-bind:key="'customTag' + i"
          >
            <input
              v-model="selectedTags"
              type="checkbox"
              name="customTag"
              v-bind:key="'tag' + i"
              v-bind:value="tag"
            />
            {{ tag }}
          </div>
        </div>
      </div>
      <div class="row selectFileArea">
        <div class="col-3 col-md-3 col-sm-12">
          <input required id="selectedFile" type="file" />
        </div>
      </div>
      <div class="row">
        <div class="col-sm-12">
          <button type="submit" form="uploadDocForm">
            Upload file to SharePoint
          </button>
        </div>
      </div>
    </form>
  </div>
</template>

<script>
import { signInWithMsal } from "../authenticatingWithMsal";
import { uploadDocument } from "../uploadingDocWithGraph";
import { typeValues, tagsValues } from "../fieldSelectValues";
import { ref } from 'vue';
export default {
  name: "UploadIncidentForm",
  props: ["msg"],
  setup() {
    const selectedTags = ref([]);
    const onSubmit = async (event) => {
      event.preventDefault();
      await signInWithMsal();
      //Creating an object with the file metadata
      const fileMetadata = {
        filename: document.getElementById("selectedFile").files[0].name,
        fileCustomDate: event.target["customDate"].value,
        fileCustomType: event.target["customType"].value,
        fileAnotherValue: event.target["anotherValue"].value,
        fileTags: selectedTags.value
      };

      // Getting the file and creating an arrayBuffer object using FileReader.
      const fileToUplode = document.getElementById("selectedFile").files[0];
      const filereader = new FileReader();
      filereader.onload = async (event) => {
        //Sending the fileMetadata and file as ArrayBuffer to the upload function
       await uploadDocument(fileMetadata, event.target.result);
      };
      filereader.readAsArrayBuffer(fileToUplode);
    };
    return {
      onSubmit,
      typeValues,
      tagsValues,
      selectedTags
    };
  },
};
</script>

<style>
.demo-wrapper {
  text-align: left;
  border: 1px solid grey;
  border-radius: 10px;
  padding: 20px;
}

.demo-wrapper h1 {
  margin-bottom: 30px;
}

.demo-wrapper .row {
  margin-bottom: 15px;
  text-align: left;
}

.demo-wrapper button {
  padding: 10px;
  border-radius: 10px;
  background: #aed1ca;
  color: black;
  border: none;
}
.selectFileArea {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #aed1ca;
}
.demo-wrapper button:hover {
  background: #333333;
  color: white;
}
</style>
