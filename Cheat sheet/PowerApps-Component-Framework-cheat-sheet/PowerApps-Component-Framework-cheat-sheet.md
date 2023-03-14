
## Using the Power Apps CLI to initialize and create a new PCF project
```powershell
pac pcf init -n "name" -ns "namespace" -t [dataset or field ] 
```

* **Name** (-n) is the project name.
* **NameSpace**' (-ns) is the namespace for the project.
* **Type** (-t) can be either dataset or field.

Once you have initialized your project you need to run `npm install` to install the project dependencies.
***

## Connect to environment, create temporary solution and push solution to env
```powershell
//first authenticate (need system administrator/ system customizer permissions)
pac auth create --url https://myenvironment......

//you can use auth list to see current connecions
pac auth list

//select connection
pac auth select --index 2

//then use pcf push to build a temporary solution and then push it to the environment you authenticated with
//When the code is updated you just need to use this command to push the changes again
pac pcf push --publisher-prefix ehs
```

## Pacakge a component
```powershell
pac solution init --publisher-name developer --publisher-prefix dev
```

## Create zip file
```powershell
msbuild /t:build /restore
```
*This command uses MSBuild to build the solution project by pulling down the NuGet dependencies as part of the restore. Use the /restore only for the first time when the solution project is built*


## Add PCF references to solution and import solution to power platform
#### **Create solution**
```powershell
pac solution init --publisher-name <your name> --publisher-prefix <prefix>
```
#### **Add reference to your PCF component to the solution file**
```powershell
pac solution add-reference --path "path-to-PCF-component-pcfproj-file"
```
> _Note: The path can be absolute, or relative to the solution folder._


#### **Build solution for dev/qa or prod**

The first time you build the solution you run msbuild with /t:build and /restore. This will both build the solution and restore the dependencies it needs.
```powershell
msbuild /t:build /restore
```
When you have made changes in your component and need to rebuild the solution you can use
```powershell
msbuild /t:rebuild
```
When building for production add the flag as shown below
```powershell
msbuild /t:rebuild /p:configuration=Release
```
> _Note: A production build will generate a **managed** solution. It will be placed in the bin/Release folder_

#### **Import solution to your environment**
First connect to your environment using pcf auth like described previously
Then use the solution import command to import the solution. 

```powershell
pac solution import --path ".\bin\Debug\solutionName.zip" -pc
```
> _Note! The `-pc` flag stands for “publish changes” and when working with unmanaged solutions you need to add this flag for the PCF components to update. If you try to import the solution without this flag, or you do it manually, the solution import will work – but the changes in your PCF component won’t show up._