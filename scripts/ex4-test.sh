#!/bin/bash
set -e

if ! [[ "$1" =~ "https://github.com/" ]]; then
	echo "Please provide your Github ncyu-2019 project url"
	exit 1
fi

GITHUB_URL=$1
GITHUB_REPO=`echo ${GITHUB_URL#https://github.com/}`
GITHUB_PROJECT=`echo $GITHUB_REPO | cut -d '/' -f 2`
PROJECT_BRANCH=ex4-2
DIR_LOCAL=$GITHUB_PROJECT

GIT_NAME=`git config -l | grep user.name | cut -d '=' -f 2`

COMMIT_MSG="[Example 4] $GIT_NAME"

# update local and remote code base
git remote add official https://github.com/jrjang/$GITHUB_PROJECT
git fetch -q --all

git commit --amend -s -m "Example 4: merge"
git push -f -q origin HEAD:refs/heads/$PROJECT_BRANCH
echo "[STATUS] Example 4: Git push done"

PROJECT_BRANCH=ex4
git checkout -t origin/$PROJECT_BRANCH -b $PROJECT_BRANCH
git log --graph --abbrev-commit --decorate --format=format:'%C(white)%s%C(reset) %C(dim white)' origin/$PROJECT_BRANCH-2 > ex4-graph.txt
git add ex4-graph.txt
git checkout origin/$PROJECT_BRANCH-2 -- ex4.txt
git commit -s -q --amend -m "$COMMIT_MSG"
git push -f -q origin HEAD:refs/heads/$PROJECT_BRANCH

hub pull-request -b jrjang/$GITHUB_PROJECT:$PROJECT_BRANCH -h $GITHUB_REPO:$PROJECT_BRANCH -m "$COMMIT_MSG"
echo "[STATUS] Example 4: Github PR done"

echo "[STATUS] Example 4: done"
