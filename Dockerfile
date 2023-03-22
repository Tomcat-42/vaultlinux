FROM ubuntu:18.04 as builder

RUN apt-get update && apt-get install -y gawk wget git-core diffstat unzip \
            texinfo gcc-multilib build-essential chrpath socat cpio python \
            python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping \
            python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev xterm locales \
            vim bash-completion screen

ARG USERNAME=vaultlinux
ARG PUID=1000
ARG PGID=1000

RUN groupadd -g ${PGID} ${USERNAME} \
            && useradd -u ${PUID} -g ${USERNAME} -d /home/${USERNAME} ${USERNAME} \
            && mkdir /home/${USERNAME} \
            && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV YOCTO_ENTRYPOINT ${YOCTO_ENTRYPOINT:-/yocto-entrypoint.sh}

# Copy required Files
COPY ./assets/.bashrc /home/${USERNAME}/.bashrc
# COPY ./build/ /home/${USERNAME}/

USER ${USERNAME}

WORKDIR /home/${USERNAME}

COPY ./scripts/docker-entrypoint.sh /
COPY ./scripts/yocto-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
