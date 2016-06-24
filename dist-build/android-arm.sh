#!/bin/sh
export TARGET_ARCH=armv6
export CFLAGS="-DNULL=0 -DSOCKLEN_T=socklen_t -DLOCALE_NOT_USED -D_LARGEFILE_SOURCE=1 -D_FILE_OFFSET_BITS=64 -Drestrict='' -D__EMX__ -DOPUS_BUILD -DFIXED_POINT=1 -DDISABLE_FLOAT_API -DUSE_ALLOCA -DHAVE_LRINT -DHAVE_LRINTF  -DAVOID_TABLES -w -std=gnu99 -O3 -fno-strict-aliasing -fprefetch-loop-arrays  -fno-math-errno -marm -march=${TARGET_ARCH}"
export CPPFLAGS="-DBSD=1 -ffast-math -O3 -funroll-loops"
ARCH=arm HOST_COMPILER=arm-linux-androideabi "$(dirname "$0")/android-build.sh"
