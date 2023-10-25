# How to work with SPfx samples

So you found a sample webpart that you would like to use, but you don't know how to clone it - or you get some errors when trying to run the webpart locally? Here is a step by step guide on how to do it.

> **Prerequisites:** <br>You need [Visual Studio Code](https://code.visualstudio.com/) or some other code editor, and a [M365 Developer tenant](https://developer.microsoft.com/en-us/microsoft-365/dev-program). 

## Getting the sample up and running 
Firstly you need a Node version manager, I recommend using [NVM for windows](https://elischei.com/how-to-use-nvm-for-windows/)

_If you are new to git I would recommend [reading this blogpost on cloning and working with repositories](https://elischei.com/an-introduction-to-version-control-using-git-and-github/)._
 
After cloning the sample you would like to use. Open up your preferred Command Line Interface (CLI/Terminal) and navigate to the root folder of the sample. You can also navigate there using the File explorer, and right cliking inside the folder and selecting 'open in terminal'.

Now write `code .` and press enter - this will open the project in VS Code.

Open the package.json file that is located in the root folder of the sample, and take a look at what node version is required. This is listed under "engines".

![](/Code%20samples/How-to-work-with-spfx-samples/img/node-version.png)

_If the node information is not listed in the package.json file, you can see what version of SPfx is being used based of the version on the version on the packages that starts with `@microsoft/sp...`. And then [this matrix will show you which node version is supported with the individual SPfx version](https://learn.microsoft.com/en-gb/sharepoint/dev/spfx/compatibility)_

Go back to your CLI and use nvm to install or select a supported node version.
To see what node versions you already have installed you can use `nvm list`

To install a specific version use: `nvm install 16.13.1`.
Or to use an already installed version: `nvm use 16.13.1`

When this is done, its time to try and install the samples dependencies. Make sure you are still in the root folder of your project and run `npm i`.

_Note: Even if you are on a node version that is supposed to be supportet - it might not be._ 

In the sample used for this post it said that node should be between version 16.13.0 and below 17.0.0.
So I changed it to 16.15.0 since that was a version I already had installed. But that gave me this error `Unexpected token '.'`
![](/Code%20samples/How-to-work-with-spfx-samples/img/getting-error.png)
But after changing to another version, 16.13.1, it worked (with warnings - but ignore those for now).

When the `npm i` has finished (this can take some time, depending on the sample) its time to make the project ready for your developer tenant.

In VS Code, open the serve.json file that is located in the config folder, and add the url to your devtenant sharepoint site where it says `enter-your-SharePoint-site`.
![](/Code%20samples/How-to-work-with-spfx-samples/img/devtenanturl.png).

Now you can run gulp serve in your CLI. This will automatically open up a workbench where you can test the sample.
Note, some samples might require lists and stuff 'in the background' to work correctly. This will be described in the samples README.md file


## Building the sample for deployment

To build the sample you need to run:
* first `gulp bild`
* Then `gulp bundle --ship`
* and lastly `gulp package-solution --ship`

This will create an .sppkg file that can be found in the SharePoint/Solutions folder. This package can be deployed to your SharePoint App Catalog.

**Note:** In the file package-solution.json (config folder), there is a section for developer info

```json
"developer": {
      "name": "",
      "privacyUrl": "",
      "termsOfUseUrl": "",
      "websiteUrl": "",
      "mpnId": "Undefined-1.16.1"
    },
```
This should be filled out before deploying to production. If you are not sure about the mpnId ask a colleague.
