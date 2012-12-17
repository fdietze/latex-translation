#!/bin/bash

REPO=../rulebook-latex
POOTLE=../pootle

cd $REPO
  git pull 2>&1
cd -

make REPO=$REPO POOTLE=$POOTLE 2>&1 | tee $REPO/out/make.log
