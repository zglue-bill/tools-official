#!/bin/bash

WD=$PWD

TESTLIST=$1
if [ -z "$TESTLIST" ]; then
  TESTLIST=simlist.dat
fi

if [ -z "${PATH_ORIG}" ]; then
  export PATH_ORIG="${PATH}"
fi

# Careful: Toolchain path needs to go at the end to avoid picking up MSYS functions instead of Cygwin

NUTTX=$PWD/../nuttx
if [ ! -d "$NUTTX" ]; then
  echo "Where are you?"
  exit 1
fi

TESTBUILD=$NUTTX/tools/testbuild.sh
if [ ! -x "$TESTBUILD" ]; then
  echo "Help... I can't find testbuild.sh"
  exit 1
fi

# NOTE: Some linker scripts contain this line: OUTPUT_ARCH(pic32mx)
# This will cause a linking failure in the very last steps and must be ignored

$TESTBUILD -w -l -c $TESTLIST 1>simtest.log 2>&1
