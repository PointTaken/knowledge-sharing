# GIT CHEAT SHEET

## BASICS
### Init / Clone

```
//Initialize git in the current directory
git init


//Clone an existing repo into current directory
git clone <url>


//Clone an existing repo into a new folder 
git clone <url> 'new folder name'
```
### Status
```
//This gives you an overview over the files that have been changed - and if they are tracked or not
git status
```
### Adding files to staging-area
```
//Add a specific (updated) file
git add <file-path/filename>

//Add all updated files
git add .
```
### Commit
_There are some resources on writing good commit messages in the ["Git resources overview"](./git-resources.md)_
```
//Create a commit for the changes in the staging area
git commit -m "write your descriptive commit message here"


//Update latest commit
git commit --amend -m "new message"
```

## BRANCHING
```
//Create new branch
git branch <branch name>


//Switch branch
git checkout <branch name>

// Create new branch and then switch to it
git checkout -b <branch name>

//Create new branch (branch-B) based on existing branch(branch-A) and switch to it
git checkout -b <branch-B-name> <branch-A-name>

//Fetch and create local branch based on remote branch
git fetch && git checkout <remote-branch-name>

//Merge branch (branch-A) into other branch (branch-B)
git checkout <branch-B-name>
git merge <branch-A-name>


//Delete branch
git branch -d <branch name>

```

## CHERRY-PICK
```
//If you want to get just one commit from one branch to another you can cherrypick it
git cherry-pick < commitID >
```

## UPDATE

```
//fetch latest changes from origin (this does not merge them)
git fetch


//pull latest changes from origin (does a fetch followed by a merge)
git pull
```
## REVERT 
```
//Return to latest commit state (NOTE! THIS CANNOT BE UNDONE)
git reset --hard

//revert to a specific commit
git revert <ID>

//revert the last commit
git revert HEAD
```

## MERGE CONFLICTS
_There are a lot of great tools for viewing merge conflicts, and if you are new to git I especially recommend using such a tool (I prefer that myself, even though I have used git for years)_
```
//View the difference that creates the conflict
git diff
```

## CHANGE REMOTE
```
git remote set-url origin <new remote url>
```
Verify remote 
```
git remote -v
```
