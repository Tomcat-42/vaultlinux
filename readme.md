<p align="center">
    <img src="https://cdn3.iconfinder.com/data/icons/logos-brands-3/24/logo_brand_brands_logos_linux-512.png" width=138/>
</p>

<h1 align="center">vaultlinux</h1>

> It's ok that you had choosen Debian over Yocto for the Labrador project Sir, I
> forgive and don't hate you anymore. By the way, you are the hero of my life
> and I respect every ounce of you as a human being 🙇 🫡 .
>
> -- <cite>Me to Santa Claus 🎅 </cite>

<div align="center">
    <a href="https://hub.docker.com/r/tomcat0x42/vaultlinux" target="_blank">
    <img src="https://img.shields.io/docker/v/tomcat0x42/vaultlinux"></a>
    <a href="https://github.com/Tomcat-42/vaultlinux" target="_blank">
    <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/Tomcat-42/vaultlinux?style=social">
</div>

Vault linux is a custom embedded linux distribution based on the
[Poky](https://www.yoctoproject.org/software-item/poky/) distro of the
[Yocto](https://docs.yoctoproject.org/index.html) project. The distro main goal
is to act as a criptography hub and auxiliary tool.

## Obtaining the distro

### Building From Source manually

First, you have to install build dependencies for your host system (in this
example Ubuntu):

```bash
# Build deps
apt-get update && apt-get install -y gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev xterm python3-subunit mesa-common-dev zstd liblz4-tool locales
apt-get install -y file
apt-get install -y vim
```

Now, clone the Poky repository:

```bash
# Clone poky distro
mkdir ~/yocto
git clone -b master git://git.yoctoproject.org/poky.git ~/yocto
cd ~/yocto/poky && source oe-init-build-env
```

Clone this repo and copy all the configuration and layer files:

```bash
cd ~/
git clone -b master https://github.com/Tomcat-42/vaultlinux.git
cp -av ./yocto/* ~/poky
```

Now, finally build the distro:

```bash
cd ~/poky/build && bitbake core-image-full-cmdline
```

The build files are inside the `~/poky/build/tmp/images/qemux86-64` dir.

### Building using docker

The `./Dockerfile` build the distro, generating a image as output. Run:

```
docker built -t vaultlinux .
```

### From releases

A pre built image is published as a github
[release](https://github.com/Tomcat-42/vaultlinux/releases/download/vaultlinux/vaultlinux.zip)
in this repository.

### Pre built container

A docker image
[tomcat0x42/vaultlinux](https://hub.docker.com/r/tomcat0x42/vaultlinux) is
available. So, pull it:

```bash
docker pull tomcat0x42/vaultlinux
```

## Running the distro

At the moment, only [qemu](https://www.qemu.org/) images are generated, so
follow his documentation for installing it.

### From the image

If you built manually the image, or downloaded it, you can run it using **qemu**

```bash
qemu-system-x86_64 --enable-kvm  -machine q35 -device intel-iommu  -cpu host -m 1G -cdrom vaultlinux.iso
```

### From the docker container

Or instead, just run the container:

```bash
docker run --device=/dev/kvm -it tomcat0x42/vaultlinux
```

## Software included

This poky build uses the following custom layers:

- **meta-oe** and **meta-webserver**: From
  [openembedded](https://www.openembedded.org/), enables a lot of useful tools,
  inncluding webserver related ones like apache and php.
- **meta-ciphervault**: Custom layer for installing the
  [ciphervault](https://github.com/tomcat-42/ciphervault) software.

At all, the following utilities are included in the distro:

```text
libcrypto libssl ciphervault openssl apache2 php php-cli ldd bash libgcc strace ltrace binutils gdb
```

## CI/CD

This repo uses [Github Actions](https://docs.github.com/en/actions) for
automation of the modification => publishing cycle.
