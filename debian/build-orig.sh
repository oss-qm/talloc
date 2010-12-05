#!/bin/bash

if [ -z "$GIT_URL" ]; then
	GIT_URL=git://git.samba.org/samba.git
fi

TALLOCTMP=`mktemp -d`
git clone --depth 1 $GIT_URL $TALLOCTMP
pushd $TALLOCTMP/lib/talloc
./autogen-waf.sh
./configure
make dist
popd
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
mv $TALLOCTMP/lib/talloc/talloc-*.tar.gz talloc_$version.orig.tar.gz
rm -rf $TALLOCTMP
