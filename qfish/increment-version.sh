#!/bin/sh

VERSION_PATCH=${1-$(cat version.patch)}

# increase patch version for next package
echo $VERSION_PATCH + 1 | bc > version.patch
