#!/bin/bash
source env.bash
mkdir -p repo && pushd repo
mkdir -p dists/$SUITE
arch=all # TODO: detect arch
mkdir -p dists/$SUITE/$COMPONENT/binary-$arch
mkdir -p pool/$COMPONENT/binary-$arch

gpg --armor --yes --output KEY.asc --export $GPG_USER_ID
apt-ftparchive packages pool/$COMPONENT/binary-$arch > dists/$SUITE/$COMPONENT/binary-$arch/Packages
gzip -k -f dists/$SUITE/$COMPONENT/binary-$arch/Packages
apt-ftparchive release dists/$SUITE \
    -o APT::FTPArchive::Release::Suite="$SUITE" \
    -o APT::FTPArchive::Release::Codename="$SUITE" \
    -o APT::FTPArchive::Release::Components="$COMPONENT" \
    -o APT::FTPArchive::Release::archs="$arch" \
    | gpg --batch --yes --local-user $GPG_USER_ID --output dists/$SUITE/InRelease --clearsign
