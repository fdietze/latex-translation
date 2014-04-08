#!/bin/bash

# TODO: integrate pdfopt

PATH=/usr/local/texlive/2013/bin/x86_64-linux:$PATH

REPO=../rulebook-latex
POOTLE=../pootle
LOGFILE=$REPO/out/make.log
WORKINGDIR="`pwd`"

cd $REPO

# update master
git checkout master 2>&1 | tee $LOGFILE
git reset --hard 2>&1 | tee -a $LOGFILE
git clean -df 2>&1 | tee -a $LOGFILE
git checkout master 2>&1 | tee -a $LOGFILE #triggers checkout hook
git pull --rebase 2>&1 | tee -a $LOGFILE #rebase, to track history changes

# update 2012
git checkout 2012 2>&1 | tee -a $LOGFILE
git reset --hard 2>&1 | tee -a $LOGFILE
git clean -df 2>&1 | tee -a $LOGFILE
git checkout 2012 2>&1 | tee -a $LOGFILE #triggers checkout hook
git pull --rebase 2>&1 | tee -a $LOGFILE #rebase, to track history changes


# master document
git checkout master
make --makefile=$WORKINGDIR/Makefile REPO=$REPO pdf 2>&1 | tee -a $LOGFILE
make --makefile=$WORKINGDIR/Makefile REPO=$REPO translated 2>&1 | tee -a $LOGFILE

# diff document
make --makefile=$WORKINGDIR/Makefile REPO=$REPO diff 2>&1 | tee -a $LOGFILE

