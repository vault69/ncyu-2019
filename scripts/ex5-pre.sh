#!/bin/bash
set -e

if ! [[ "$1" =~ "https://github.com/" ]]; then
	echo "Please provide your Github ncyu-2019 project url"
	exit 1
fi

GITHUB_URL=$1
GITHUB_REPO=`echo ${GITHUB_URL#https://github.com/}`
GITHUB_PROJECT=`echo $GITHUB_REPO | cut -d '/' -f 2`
PROJECT_URL=git@github.com:$GITHUB_REPO
PROJECT_BRANCH=ex5
DIR_LOCAL=$GITHUB_PROJECT

git clone -q $PROJECT_URL -b ex0
echo "[STATUS] Example 5: Github clone done"
pushd $DIR_LOCAL

# update local and remote code base
git remote add official https://github.com/jrjang/$GITHUB_PROJECT
git fetch -q official
git push -q -f origin official/$PROJECT_BRANCH:refs/heads/$PROJECT_BRANCH
git push -q -f origin official/$PROJECT_BRANCH-2:refs/heads/$PROJECT_BRANCH-2
echo "[STATUS] Example 5: Github update done"
popd

# re-clone source code
[ -d $DIR_LOCAL ] && rm -rf $DIR_LOCAL
git clone -q $PROJECT_URL -b $PROJECT_BRANCH-2
echo "[STATUS] Example 5: Github re-clone done"
