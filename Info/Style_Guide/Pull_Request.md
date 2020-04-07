# Pull Request Guidelines

## Creating and managing a branch
When you do a pull request on a branch, you can continue to work on another branch and make another pull request on this other branch.

Before creating a new branch, pull the changes from upstream. Your master needs to be up to date.
```
$ git pull
```
Create the branch on your local machine and switch in this branch :
```
$ git checkout -b [name_of_your_new_branch]
```
Push the branch on github :
```
$ git push origin [name_of_your_new_branch]
```
When you want to commit something in your branch, be sure to be in your branch. Add -u parameter to set-upstream.

You can see all the branches created by using :
```
$ git branch -a
```
Which will show :
```
* approval_messages
  master
  master_clean
```
Add a new remote for your branch :
```
$ git remote add [name_of_your_remote] [name_of_your_new_branch]
```
Push changes from your commit into your branch :
```
$ git push [name_of_your_new_remote] [url]
```
Update your branch when the original branch from official repository has been updated :
```
$ git fetch [name_of_your_remote]
```
Then you need to apply to merge changes if your branch is derivated from develop you need to do :
```
$ git merge [name_of_your_remote]/develop
```
Delete a branch on your local filesystem :
```
$ git branch -d [name_of_your_new_branch]
```
To force the deletion of local branch on your filesystem :
```
$ git branch -D [name_of_your_new_branch]
```
Delete the branch on github :
```
$ git push origin :[name_of_your_new_branch]
```

## Updating your fork

    ```shell
    git rebase master -i
    git push -f
    ```

## Commit message
> See commit_guidelines.md for more info

The format is <type>: <subject> (#pull request)

Example:

```
feature: add script names to debug log (#82)
```
## After your pull request is merged

After your pull request is merged, you can safely delete your branch and pull the changes
from the main (upstream) repository:

* Delete the remote branch on GitHub either through the GitHub web UI or your local shell as
    follows:

    ```shell
    git push my-fork --delete my-fix-branch
    ```

* Check out the master branch:

    ```shell
    git checkout master -f
    ```

* Delete the local branch:

    ```shell
    git branch -D my-fix-branch
    ```

* Update your master with the latest upstream version:

    ```shell
    git pull --ff upstream master
    ```
