
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
//firts authenticate (need system administrator/ system costumizer permissions)
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
