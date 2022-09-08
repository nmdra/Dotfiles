#!bin/bash

git status > /home/nimendra/Scriptslog/"GitStatus `date +"%Y-%m-%d %T"`".log

echo "status completed"

git add .

echo "add completed"

git commit -m "@nimendra_ `date +"%Y-%m-%d %T"` "

echo "commit completed"

git push > /home/nimendra/Scriptslog/"GitPush `date +"%Y-%m-%d %T"`".log

echo "push completed"

git pull 

echo "pull completed"
