#/bin/bash
# the name of the repository, which will be used as the name of the Azure Storage Account
export REPO_NAME=myrepo

# the name of the suite, used to create the repository and the sources.list file
export SUITE=$(lsb_release -cs)

# the name of the component, used to create the repository and the sources.list file
export COMPONENT=unstable

# the GPG user ID, used to sign the repository
export GPG_USER_ID='me@example.com'
