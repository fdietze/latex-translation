#!/bin/bash

REPO=../rulebook-latex
POOTLE=../pootle

cd $REPO
  git reset --hard 2>&1 | tee $REPO/out/make.log
  git clean -df 2>&1 | tee -a $REPO/out/make.log
  git pull 2>&1 | tee -a $REPO/out/make.log
cd -

make REPO=$REPO POOTLE=$POOTLE 2>&1 | tee -a $REPO/out/make.log
