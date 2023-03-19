## PowerShell Core Utilities
A serie of commands for automate proccess and tasks of your Windows system using PowerShell Core.

#### ps-git-alias
Collection of git command alias for cmdlet of OS.
* g    -> git
* gs   -> git status
* gcf  -> git config 
* gco  -> git checkout
* gs   -> git status 
* gb   -> git branch 
* gcom -> git commit -m $commit-message 
* gcl  -> git clone  repository-url
* gaa  -> git add .
* glg  -> git log
* grl  -> git reflog
* gd   -> git diff
* grs  -> git reset 
* gr   -> git remote
* gpsh -> git push 
* gpl  -> git pull 
* gme  -> git merge 
* gcp  -> git cherry-pick
* grb  -> git rebase 

#### MyPsFunctions
* myps_clean          -> clean recycle bin
* myps_clean_temps    -> delete logs and temp files
* myps_setup_git      -> setup git alias and other configurations
  * softwares includeds
    * chocolatey
    * node
    * npm
    * yarn
    * git
    * vim
    * dotnet
    * vs code
    * docker
    * firefox
    * windows terminal 

#### find-replace
Find and replace words on Windows Explorer and files, supported case sensitive.
 
#### pre-commit
Git Hook script to run **build** and **unit tests** automatic on .NET Core applications before you commit. 
Paste this file on **.git/hooks** folder inside git repository of your project.