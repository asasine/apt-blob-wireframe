# APT + Blob Repository Wireframe
This repository contains a wireframe for a Debian APT repository hosted on Azure Blob Storage. The repository is designed to be used with the `apt` package manager.

Basic configuration for the repository can be done by copying [env.example.bash](env.example.bash) to `env.bash` and modifying the variables. The `env.bash` file is sourced by the other scripts in the repository. This file is not tracked by git by default.

```bash
cp env.example.bash env.bash
vim env.bash # Modify the variables
```

## Repository
The repository structure follows the standard Debian repository layout.
- `KEY.asc`: The ASCII armored public key used to sign the repository.
- `dists/`: Contains the distribution information.
    - `$(lsb_release -cs)/` (e.g., `focal/`): Contains the release information for the current distribution.
        - `InRelease`: The signed release file.
        - `unstable/`: Contains the package information for the unstable component.
            - `binary-$(ARCH)/` (e.g., `binary-arm64/`): Contains the binary packages for a specific architecture.
- `pool/`: Contains the packages.
    - `unstable/`: Contains the packages for the unstable component.
        - `binary-$(ARCH)/` (e.g., `binary-arm64/`): Contains the binary packages for a specific architecture.
            - `$(PACKAGE)_$(VERSION)_$(ARCH).deb`: The package file.

Scripts in this repo are designed to output the repository structure to the `repo/` directory.

Debian binary packages are built using `dpkg-deb`. See [build-deb.bash](build-deb.bash) for an example. The [hello-blob-repo](hello-blob-repo) package is an example of a package that can be added to the repository. Packages must contain a [DEBIAN/control](hello-blob-repo/DEBIAN/control) file with required fields as specified in the [Debian Policy Manual](https://www.debian.org/doc/debian-policy/ch-controlfields.html).

```bash
./build-deb.bash
```

The repository is signed using `gpg`. The public key is exported to `KEY.asc` and the private key is used to sign the release file.

The repository is managed using `apt-ftparchive`; see [update-repo.bash](update-repo.bash) for an example. `Packages` files are generated using the `apt-ftparchive packages` command using a recursive search of the `pool/` directory. A `Release` file is generated using the `apt-ftparchive release` command, which is immediately piped to `gpg` to sign the file. Note: no `Release` is generated as this wireframe does not support older versions of `apt`.

```bash
./update-repo.bash
```

## Hosting
The repository is hosted on Azure Blob Storage and is managed using the `az` CLI. The storage account is configured for blobs to be publically accessible. The account can be created with:

```bash
./create-storage.bash
```

The repository is hosted in the `debian` container, which is automatically created by the [push-repo.bash](push-repo.bash) script:

```bash
./push-repo.bash
```

## Usage
The repository can be added to the `sources.list` file using the `deb` protocol and the URL of the repository. The URL is the public URL of the `debian` container in the storage account. The public key used to sign the repo is added to `/etc/apt/keyrings/`. See [add-apt-source.bash](add-apt-source.bash) for an example.

```bash
sudo ./add-apt-source.bash
```

Once the repository is added, the `apt` package manager can be used to install packages from the repository.

```bash
sudo apt update
sudo apt install hello-blob-repo
echo $(which hello-blob-repo)
hello-blob-repo
```

## References
- [Debian Repository](https://wiki.debian.org/DebianRepository)
- [Debian Policy manual - Control files and their fields](https://www.debian.org/doc/debian-policy/ch-controlfields.html)
- [dpkg-deb(1)](https://manpages.debian.org/dpkg-deb)
- [gpg(1)](https://manpages.debian.org/gpg)
- [apt-ftparchive(1)](https://manpages.debian.org/apt-ftparchive)
- [sources.list(5)](https://manpages.debian.org/sources.list.5)
- [`az storage`](https://learn.microsoft.com/cli/azure/storage)
