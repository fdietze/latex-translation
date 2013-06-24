#!/bin/bash

# TODO: integrate pdfopt

PATH=/usr/local/texlive/2013/bin/x86_64-linux:$PATH

REPO=../rulebook-latex
POOTLE=../pootle
LOGFILE=$REPO/out/make.log
PWD=’pwd’


cd $REPO

git reset --hard 2>&1 | tee $LOGFILE
git clean -df 2>&1 | tee -a $LOGFILE
git checkout master 2>&1 | tee -a $LOGFILE #triggers checkout hook
git pull --rebase 2>&1 | tee -a $LOGFILE #rebase, to track history changes

make --makefile=$PWD/Makefile REPO=$REPO POOTLE=$POOTLE 2>&1 | tee -a $LOGFILE
