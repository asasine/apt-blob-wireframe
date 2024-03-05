#!/bin/bash
# build deb package from a directory, outputing to the pool
source env.bash
arch=all # TODO: detect arch
pool="repo/pool/$COMPONENT/binary-$arch"
mkdir -p $pool
dpkg-deb --root-owner-group --build hello-blob-repo $pool
