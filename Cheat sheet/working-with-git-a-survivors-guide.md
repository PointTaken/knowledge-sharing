# Working with GIT

I've worked with a multitude, some might say a plethora, of source control systems, like
Perforce, SourceSafe (I still remember that product key 335-335-3356 always worked), 
svn, subversion, Team Foundation Server...

git is best, no protest.

In order to avoid merge conflicts and the messy job of cleaning up such conflicts, I have some rules that I use:

Main rules:
* Always use git
* Never work in main
* Make frequent commits
* One feature, one branch

## Always use git
Whenever I've created a new project, my next step is always ``git init``,
followed by ``git add -A``
and ``git commit -m initial``.

"But you haven't done anything worth saving yet!" 
No. But I'm about to - and if something happens, I can diff with the original.

## Never work in main
Before I start making changes, I create a branch where I can do my groundbraking stuff, 
which won't get overwritten by an overzealous colleague.
Indeed, even this tiny file is created in a separate (local) branch ("WorkingWithGit").

I usually create and switch in one line:
```
git checkout -b WorkingWithGit
```

Once done, I'll commit my changes - obviously with a meaningful comment ("It Compiles! 50 Points For Gryffindor.") - pull main, merge, and either push main or make a pull request, depending on project policies.

## Make frequent commits
Because why not. Committing is cheap. It makes it easier to fix that stupid mistake a colleague made (...because we don't make mistakes, do we.).

## One feature, one branch
Make a new branch for each tiny new thing you start to work on.

You may also work on more than one thing at a time!

For example, a user has created a task #335 "Null reference exception".
I might do something like:

```
git branch -b bugs/NullReferenceException335
```

but before I find that elusive null reference a more urgent issue is created.
I save my work, commit it, switch to main, and create another branch
```
git commit -m "still looking for Sasquatch"
git checkout main
git pull
git checkout -b bugs/divisionByZero443
```
And then I can continue on the search for that null reference later.

## Summary
In case you wondered, these rules tries to ensure that the changes you make are as
small as possible. This makes it easier to integrate the with the main branch later.
It also makes it easier to work on several things at once, or to revert your changes 
back to something that works.
