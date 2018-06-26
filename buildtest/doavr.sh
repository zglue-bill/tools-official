#!/bin/bash

WD=$PWD

TESTLIST=$1
if [ -z "$TESTLIST" ]; then
  TESTLIST=avrlist.dat
fi

if [ -z "${PATH_ORIG}" ]; then
  export PATH_ORIG="${PATH}"
fi

# Careful: Toolchain path needs to go at the end to avoid picking up MSYS functions instead of Cygwin

export TOOLCHAIN_PREBIN="/sbin:/usr/sbin"
export TOOLCHAIN_POSTBIN="/cygdrive/c/Program Files (x86)/Atmel/Studio/7.0/toolchain/avr8/avr8-gnu-toolchain/bin"
export PATH="${TOOLCHAIN_PREBIN}:${PATH_ORIG}:${TOOLCHAIN_POSTBIN}"

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

$TESTBUILD -w -c $TESTLIST 1>avrtest.log 2>&1
