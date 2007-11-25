#!/bin/sh
# Build a source tarball for talloc

samba_repos=svn://svn.samba.org/samba
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )

if echo $version | grep svn > /dev/null; then
	# SVN Snapshot
	revno=`echo $version | sed 's/^[0-9.]\+~svn//'`
	svn export -r$revno $samba_repos/branches/SAMBA_4_0/source/lib/talloc talloc-$version
	svn export -r$revno $samba_repos/branches/SAMBA_4_0/source/lib/replace talloc-$version/libreplace
else
	# Release
	svn export $samba_repos/tags/TALLOC_`echo $version | sed 's/\./_/g'` talloc-$version
fi

cd talloc-$version && ./autogen.sh && cd ..
tar cvz talloc-$version > talloc_$version.orig.tar.gz
