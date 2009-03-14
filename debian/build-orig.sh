#!/bin/bash
REFSPEC=$1
GIT_URL=$2
shift 2

if [ -z "$GIT_URL" ]; then
	GIT_URL=git://git.samba.org/samba.git
fi

if [ -z "$REFSPEC" ]; then
	REFSPEC=origin/v4-0-test
fi

TALLOCTMP=$TMPDIR/$RANDOM.talloc.git
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
git clone --depth 1 -l $GIT_URL $TALLOCTMP
if [ ! -z "$REFSPEC" ]; then
	pushd $TALLOCTMP
	git checkout $REFSPEC || exit 1
	popd
fi

mv $TALLOCTMP/lib/talloc "talloc-$version"
mv $TALLOCTMP/lib/replace "talloc-$version/libreplace"
rm -rf $TALLOCTMP
pushd "talloc-$version" && ./autogen.sh && popd
tar cvz "talloc-$version" > "talloc_$version.orig.tar.gz"
rm -rf "talloc-$version"
