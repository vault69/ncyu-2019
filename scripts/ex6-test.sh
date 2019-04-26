#!/bin/bash
set -e

if ! [[ "$1" =~ "https://github.com/" ]]; then
	echo "Please provide your Github ncyu-2019 project url"
	exit 1
fi

GITHUB_URL=$1
GITHUB_REPO=`echo ${GITHUB_URL#https://github.com/}`
GITHUB_PROJECT=`echo $GITHUB_REPO | cut -d '/' -f 2`
PROJECT_BRANCH=ex6
DIR_LOCAL=$GITHUB_PROJECT

GIT_NAME=`git config -l | grep user.name | cut -d '=' -f 2`

COMMIT_MSG="[Example 6] $GIT_NAME"

git checkout -t origin/$PROJECT_BRANCH -b $PROJECT_BRANCH
git diff origin/ex0 origin/$PROJECT_BRANCH-2 --name-only > ex6.txt
git add ex6.txt
git branch -r > ex6-branch.txt
git add ex6-branch.txt
git commit -s -q --amend -m "$COMMIT_MSG"
git push -f -q origin HEAD:refs/heads/$PROJECT_BRANCH

hub pull-request -b jrjang/$GITHUB_PROJECT:$PROJECT_BRANCH -h $GITHUB_REPO:$PROJECT_BRANCH -m "$COMMIT_MSG"
echo "[STATUS] Example 6: Github PR done"

echo "[STATUS] Example 6: done"
