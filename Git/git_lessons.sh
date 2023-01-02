# == LEARNING git ==
git --version
git config --global user.name "<USER_NAME>"
git config --global user.email "<USER_EMAIL>"
git config --list # view changes
cd folder_of_GIT_project

git init --initial-branch=main
git init -b main

git status # branch? commited?
ls -a # the A flag shows hidden files
touch empty_file_name.txt

git --help
git commit --help

git add . # add all files to staging area aka. the INDEX
git add file_name.txt
git add -A # stage also in subdirectories

git commit file_name.txt -m "Create an empty file"
git commit -a -m "Add a heading to index.html" # the -a flag selects all MODIFIED files but *not* NEWLY created ones. To commit new files you need "git add"
git commit -m "Description" file_name.txt
git commit --amend --no-edit # amend = change history and no-edit = same message form last commit

git log # show all commits
git log --oneline # concise
git log -n2 # show 2nd last commit

git diff # show all changes that are *not* in staging area
git diff HEAD # show all changes compared to last commit
# press the Q key to close the DIFF
git diff HEAD^ # compare latest commit vs previous commit

mkdir sub_folder_name
touch sub_folder_name/.git-keep # empty folders are not detected by GIT so we added something to it
git add sub_folder_name

code .gitignore # contents of this file will not be tracked by GIT
*.bak
*~

rm file_name.txt
git checkout -- file_name.txt # recover file deleated by "rm file_name.txt"

git rm file_name.txt # delete file from disk AND git
git reset HEAD file_name.txt # recover file in git
git checkout -- file_name.txt # recover file even after "git rm"!

git revert --no-edit HEAD # commit a commit that undoes the last commit
git reset --hard HEAD^ # remove last commit

# Collaborator
git clone repository_location/ i_will_save_repo_here/
git request-pull -p origin/main .
# Owner
git remote add name-for-the-remote-collaborator location_of_remote_repo/
git pull name-for-the-remote-collaborator


# Owner: create Shared_repo_name.git
git init --bare # create empty repository with NO BRANCHES, just the contents of the ".git" file
git symbolic-ref HEAD refs/heads/main # cannot add branches to BARE REPOSITORIES (they are just a .git file) so make a promise to use MAIN as default branch
# Owner's local copy
git remote add origin Shared_repo_name.git/
git push origin main # add main branch & files to bare repo
git branch --set-upstream-to origin/main  # from now on "origin main" is the default when pushing/pulling
    # OR
git push --set-upstream origin main
# Collaborator with local CLONE of repo (remote points to owners local copy)
git remote set-url origin Shared_repo_name.git/
# New user
git clone Shared_repo_name.git/ local_copy_name/
# All users for commiting
git diff origin -- name_of_the_file.txt # how does the file in the REMOTE ORIGIN differ from the one in the WORKING TREE?
git stash
git pull
git stash pop
git commit -a -m "Some changes"
git push


#####
# Feature branch COREOGRAPHY
#####
# 1) CREATE FEATURE BRANCH
git branch some-name-for-the-branch
git checkout some-name-for-the-branch
    # OR short
git checkout -b some-other-branch-name
# 2) MAKE AND COMMIT CHANGES
git add -A
git commit -a -m "Do commits"
# 3) CHECK IF MAIN BRANCH HAS CHANGED
git checkout main
git pull
# 4) MERGE NEW FEATURE WITH MAIN BRANCH
git merge --ff-only some-name-for-the-branch # if main branch has not changed
    # OR
git merge some-other-branch-name --no-edit # if main has changed
# 5) CONFLIC RESOLUTION? SEE BELOW
# 6) UPDATE CHANGES TO REPOSITORY
git push


#####
# MERGE CONFLICT RESOLUTION
#####
# 1) Restore state before "git merge" + manual fix
git merge --abort
# 2) Go to last valid LOCAL commit + manual fix
git reset --hard
# 3) Keep conflicted file changed with conflict line-marker + manually edit + mark as solved
git add conflicting_file_name.html # mark conflict as solved
git commit -a -m "Solve conflict & add my changes"
git push




pwd # current folder location
zip -r file_name.zip origin_folder/
download file_name.zip
wget https://example.com/resources.zip
unzip resources.zip
mv old_filename.txt new_location/new_filename.txt
rm file_to_remove.txt