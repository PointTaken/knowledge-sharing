# Upgrade your SPfx project using Microsoft 365 CLI

> Prerequesites: Install [Microsoft 365 CLI](https://pnp.github.io/cli-microsoft365/cmd/spfx/project/project-upgrade/). `npm i -g @pnp/cli-microsoft365`

## Use the project upgrade command to create a upgrade report

In the CLI, navigate inside your SPfx project folder and run the upgrade command
```PowerShell
m365 spfx project upgrade --toVersion 1.14.0 --output md > "upgrade-report.md"
```
he above command will generate a markdown file with the name “upgrade-report”, and this will have a list of all the steps you need to take to upgrade your project.

## Common errors and how to fix them (or avoid them)
1. **Check for duplicate dev-dependencies**

1. Run `npm dedupe` to **resolve issues with old versions of node modules**. If that does not work, try deleting the node_modules folder and run `npm install`
1. Deprecated **tslint rules**. You might need to remove some tslint rules that are no longer valid

1. **JavaScript heap out of memory**. If you have done the above steps and still gets this error it might be because the task needs more memory to run, so you can try fixing it by setting the --max_old_space_sice to a higher value. 
```powershell
 gulp bundle --max_old_space_size=8192 --ship
```


## Summary 
In short the steps you shuld take to upgrade your solution is

- Run the M365 CLI project upgrade command
- Do all the steps from the report that is generated
- Check packacke.json for duplicate dev-dependencies
- Try running npm dedupe
- Delete node_modules and package-lock.json, and then run npm install.
- If you get an error on deprecated tslint rules – delete the rules from the tslint file
- If you get an JavaScript heap out of memory error – try adding more memory to the task with `--max_old_space_size=8192`