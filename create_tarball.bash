#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPTDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
CURRDIR=$(pwd -P)

# tar on macOS is BSD and useless, make sure we have gtar

ARCH=$(uname -s)

if [[ "$ARCH" == "Darwin" ]]
then
   if ! command -v gtar &> /dev/null
   then
      echo "On macOS we require the gtar executable due to deficiencies in BSD tar"
      echo "Please install gtar, e.g., brew install gnu-tar, and/or "
      echo "make sure it is in the PATH"
   fi
   TARCMD=gtar
else
   TARCMD=tar
fi

# Get some directories to make the tarball name

REPONAME=$(basename $CURRDIR)
REPODIR=$(dirname $CURRDIR)

TARBALL=${REPONAME}.tar.gz

# Now we tar and we exclude the .git, .mepo, and build and install directories to save (a lot of) space

cd $REPODIR
$TARCMD --exclude-vcs --exclude="build*" --exclude="install*" --exclude=".mepo" -czf ${TARBALL} ${REPONAME}
cd $CURRDIR

mv $REPODIR/$TARBALL $CURRDIR
