FROM ubuntu:22.04 as builder
ARG DEBIAN_FRONTEND=noninteractive

# Build deps
RUN apt-get update && apt-get install -y gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev xterm python3-subunit mesa-common-dev zstd liblz4-tool locales
RUN apt-get install -y file
RUN apt-get install -y vim

#RUN update-alternatives --config python

# Environment configuration
ARG USERNAME=vaultlinux
ARG PUID=1000
ARG PGID=1000

RUN groupadd -g ${PGID} ${USERNAME} \
            && useradd -u ${PUID} -g ${USERNAME} -d /home/${USERNAME} ${USERNAME} \
            && mkdir /home/${USERNAME} \
            && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

USER ${USERNAME}
WORKDIR /home/${USERNAME}/yocto
SHELL ["/bin/bash", "-c"]

# Copy required configuration files
COPY --chmod=0755 --chown=vaultlinux:vaultlinux ./assets/.bashrc /home/${USERNAME}/.bashrc

# Clone poky distro
RUN git clone -b master git://git.yoctoproject.org/poky.git
WORKDIR /home/${USERNAME}/yocto/poky
RUN source oe-init-build-env

WORKDIR /home/${USERNAME}/yocto
COPY --chmod=0755 --chown=vaultlinux:vaultlinux ./yocto/ ./
WORKDIR /home/${USERNAME}/yocto/poky

# Build
RUN source oe-init-build-env && bitbake core-image-full-cmdline

# Copy ISO
RUN cp /home/${USERNAME}/yocto/poky/build/tmp/deploy/images/qemux86-64/core-image-full-cmdline-qemux86-64.iso /vaultlinux.iso

FROM ubuntu:22.04 as runner

# Install qemu
RUN apt-get update && apt-get install -y qemu-system-x86

COPY --from=builder \
    /vaultlinux.iso \
    ./

CMD ["qemu-system-x86_64", "--enable-kvm", "-machine", "q35", "-m", "1024", "-cdrom", "vaultlinux.iso", "-device", "intel-iommu", "-cpu", "host", "-nographic", "-smp", "2", "-net", "nic,model=virtio", "-net", "user,hostfwd=tcp::2222-:22", "-serial", "mon:stdio"]
