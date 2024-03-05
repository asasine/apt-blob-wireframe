#!/bin/bash
source env.bash
mkdir -p repo && pushd repo > /dev/null
mkdir -p dists/$SUITE
arch=all # TODO: detect arch
mkdir -p dists/$SUITE/$COMPONENT/binary-$arch
mkdir -p pool/$COMPONENT/binary-$arch

gpg --armor --yes --output KEY.asc --export $GPG_USER_ID

# Update the local Packages file with apt-get and, if it exists, merge it with the existing Packages file.
# This may fail if the local Packages file is not present, such as before the first upload.
packages_file="/var/lib/apt/lists/${REPO_NAME}.blob.core.windows.net_debian_dists_${SUITE}_${COMPONENT}_binary-${arch}_Packages"
sudo apt-get update -o Dir::Etc::sourcelist="/etc/apt/sources.list.d/$REPO_NAME.sources" -o Dir::Etc::sourceparts='-' -o APT::Get::List-Cleanup='0' > /dev/null 2>&1
if [[ $? == 0 && -f $packages_file ]]; then
    echo 'Merging with existing Packages'
    cat "$packages_file" > dists/$SUITE/$COMPONENT/binary-$arch/Packages
    apt-ftparchive packages pool/$COMPONENT/binary-$arch >> dists/$SUITE/$COMPONENT/binary-$arch/Packages
else
    echo 'Creating Packages'
    apt-ftparchive packages pool/$COMPONENT/binary-$arch > dists/$SUITE/$COMPONENT/binary-$arch/Packages
fi

gzip -k -f dists/$SUITE/$COMPONENT/binary-$arch/Packages
apt-ftparchive release dists/$SUITE \
    -o APT::FTPArchive::Release::Suite="$SUITE" \
    -o APT::FTPArchive::Release::Codename="$SUITE" \
    -o APT::FTPArchive::Release::Components="$COMPONENT" \
    -o APT::FTPArchive::Release::archs="$arch" \
    | gpg --batch --yes --local-user $GPG_USER_ID --output dists/$SUITE/InRelease --clearsign
