#!/bin/bash
set -e

if ! [[ "$1" =~ "https://github.com/" ]]; then
	echo "Please provide your Github ncyu-2019 project url"
	exit 1
fi

if [ "$2" == "" ]; then
	echo "Please enter your Chinese name"
	exit 1
fi

CHINESE_NAME=$2
GITHUB_URL=$1
GITHUB_REPO=`echo ${GITHUB_URL#https://github.com/}`
GITHUB_ACCOUNT=`echo $GITHUB_REPO | cut -d '/' -f 1`
GITHUB_PROJECT=`echo $GITHUB_REPO | cut -d '/' -f 2`
PROJECT_URL=git@github.com:$GITHUB_REPO
PROJECT_BRANCH=ex0
DIR_LOCAL=$GITHUB_PROJECT

GIT_NAME=`git config -l | grep user.name | cut -d '=' -f 2`
GIT_EMAIL=`git config -l | grep user.email | cut -d '-' -f 2`

COMMIT_MSG="[Example 0] $GIT_NAME"

rm -rf ncyu-2019

git clone -q $PROJECT_URL -b $PROJECT_BRANCH
echo "[STATUS] Example 0: Github clone done"
pushd $DIR_LOCAL

# update local and remote code base
git remote add official https://github.com/jrjang/$GITHUB_PROJECT
git fetch -q official
git push -q -f origin official/$PROJECT_BRANCH:refs/heads/$PROJECT_BRANCH
echo "[STATUS] Example 0: Github update done"
popd

# re-clone source code
[ -d $DIR_LOCAL ] && rm -rf $DIR_LOCAL
git clone -q $PROJECT_URL -b $PROJECT_BRANCH
echo "[STATUS] Example 0: Github re-clone done"
cd $DIR_LOCAL

echo "$GIT_NAME,$GIT_EMAIL,${CHINESE_NAME::1}◯${CHINESE_NAME: -1}" >> ex0.txt

git add ex0.txt
echo "[STATUS] Example 0: Git add done"

git commit -s -m "$COMMIT_MSG"
echo "[STATUS] Example 0: Git commit done"

git push -q origin HEAD:refs/heads/$PROJECT_BRANCH
echo "[STATUS] Example 0: Git push done"

hub pull-request -b jrjang/$GITHUB_PROJECT:$PROJECT_BRANCH -h $GITHUB_REPO:$PROJECT_BRANCH -m "$COMMIT_MSG"
echo "[STATUS] Example 0: Github PR done"

echo "[STATUS] Example 0: done"
