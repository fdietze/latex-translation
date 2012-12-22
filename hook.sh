#!/bin/bash

REPO=../rulebook-latex
POOTLE=../pootle

cd $REPO
  git reset --hard
  git clean -df
  git pull 2>&1 | tee $REPO/out/make.log
cd -

make REPO=$REPO POOTLE=$POOTLE 2>&1 | tee -a $REPO/out/make.log
