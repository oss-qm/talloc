#!/bin/bash
GIT_URL=$1
REFSPEC=$2
shift 2

if [ -z "$GIT_URL" ]; then
	GIT_URL=git://git.samba.org/samba.git
fi

TALLOCTMP=$TMPDIR/$RANDOM.talloc.git
git clone --depth 1 $GIT_URL $TALLOCTMP
if [ ! -z "$REFSPEC" ]; then
	pushd $TALLOCTMP
	git checkout $REFSPEC || exit 1
	popd
fi
pushd $TALLOCTMP/lib/talloc
./autogen-waf.sh
./configure
make dist
popd
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
mv $TALLOCTMP/lib/talloc/talloc-*.tar.gz talloc-$version.tar.gz
rm -rf $TALLOCTMP
