#!/bin/sh

VERSION_MAJOR=${1-$(cat version.maj)}
VERSION_MINOR=${1-$(cat version.min)}
VERSION_PATCH=${1-$(cat version.patch)}

# increase patch version for next package
echo $VERSION_PATCH + 1 | bc > version.patch

# create archive
mkdir -p build
cd sources
tar -cf ../build/sources.tar *
SHASUM=$(sha256sum ../build/sources.tar | cut -d' ' -f1)
cd ..

# create PKGBUILD
sed						\
	-e "s;%Vmajor%;$VERSION_MAJOR;g"	\
	-e "s;%Vminor%;$VERSION_MINOR;g"	\
	-e "s;%Vpatch%;$VERSION_PATCH;g"	\
	-e "s;%sha%;$SHASUM;g"			\
	PKGBUILD.template > build/PKGBUILD

# copy sources and install
cp qde.install build
