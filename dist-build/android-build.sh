#! /bin/sh

if [ -z "$NDK_PLATFORM" ]; then
  export NDK_PLATFORM="android-24"
  export NDK_PLATFORM_COMPAT="${NDK_PLATFORM_COMPAT:-android-16}"
else
  export NDK_PLATFORM_COMPAT="${NDK_PLATFORM_COMPAT:-${NDK_PLATFORM}}"
fi

if [ -z "$ANDROID_NDK_HOME" ]; then
    echo "You should probably set ANDROID_NDK_HOME to the directory containing"
    echo "the Android NDK"
    exit
fi

if [ ! -f ./configure ]; then
	echo "Can't find ./configure. Wrong directory or haven't run autogen.sh?"
	exit 1
fi

if [ "x$TARGET_ARCH" = 'x' ] || [ "x$ARCH" = 'x' ] || [ "x$HOST_COMPILER" = 'x' ]; then
    echo "You shouldn't use android-build.sh directly, use android-[arch].sh instead"
    exit 1
fi

export MAKE_TOOLCHAIN="${ANDROID_NDK_HOME}/build/tools/make-standalone-toolchain.sh"

export PREFIX="$(pwd)/opus-android-${TARGET_ARCH}"
export TOOLCHAIN_DIR="$(pwd)/android-toolchain-${TARGET_ARCH}"
export PATH="${PATH}:${TOOLCHAIN_DIR}/bin"

rm -rf "${TOOLCHAIN_DIR}" "${PREFIX}"

echo
echo "Building for platform [${NDK_PLATFORM}], retaining compatibility with platform [${NDK_PLATFORM_COMPAT}]"
echo

bash $MAKE_TOOLCHAIN --platform="$NDK_PLATFORM_COMPAT" \
    --arch="$ARCH" --install-dir="$TOOLCHAIN_DIR" || exit 1

./configure \
    --enable-fixed-point \
    --host="${HOST_COMPILER}" \
    --prefix="${PREFIX}" \
    --with-sysroot="${TOOLCHAIN_DIR}/sysroot" || exit 1

make clean && \
make -j3 install && \
echo "opus has been installed into ${PREFIX}"
