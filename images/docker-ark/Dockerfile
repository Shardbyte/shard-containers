#################################################
# Copyright (c) Shardbyte. All Rights Reserved. #
# SPDX-License-Identifier: MIT                  #
#################################################

FROM ghcr.io/shardbyte/steamcmd:latest

LABEL author="Shardbyte" \
      maintainer="containers@shardbyte.com" \
      org.opencontainers.image.source="https://github.com/Shardbyte/docker-ark-server" \
      org.opencontainers.image.description="Application packaged by Shardbyte" \
      org.opencontainers.image.title="docker-ark-server" \
      org.opencontainers.image.licenses="MIT"

ARG ARK_TOOLS_VERSION="latest"
ARG IMAGE_VERSION="dev"

ENV IMAGE_VERSION="${IMAGE_VERSION}" \
    SESSION_NAME="Dockerized ARK Server" \
    SERVER_MAP="TheIsland" \
    SERVER_PASSWORD="theDEFAULTpassword" \
    ADMIN_PASSWORD="changeMEplease" \
    MAX_PLAYERS="20" \
    GAME_MOD_IDS="" \
    UPDATE_ON_START="false" \
    BACKUP_ON_STOP="false" \
    PRE_UPDATE_BACKUP="true" \
    WARN_ON_STOP="true" \
    ARK_TOOLS_VERSION="${ARK_TOOLS_VERSION}" \
    ARK_SERVER_VOLUME="/app" \
    TEMPLATE_DIRECTORY="/conf.d" \
    STEAM_HOME="/home/${USER}" \
    STEAM_USER="${USER}" \
    STEAM_LOGIN="anonymous" \
    GAME_CLIENT_PORT="7777" \
    UDP_SOCKET_PORT="7778" \
    RCON_PORT="27020" \
    SERVER_LIST_PORT="27015"

ENV ARK_TOOLS_DIR="${ARK_SERVER_VOLUME}/arkmanager"

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends --no-install-suggests \
        jq \
        curl \
        cron \
        lsof \
        gosu \
        bzip2 \
        libc6-i386 \
        lib32gcc-s1 \
        perl-modules && \
    if [ "${ARK_TOOLS_VERSION}" = "latest" ]; then \
        DOWNLOAD_VERSION=$(curl -s https://api.github.com/repos/arkmanager/ark-server-tools/releases/latest | jq -r '.tag_name' | sed 's/^v//'); \
    else \
        DOWNLOAD_VERSION="${ARK_TOOLS_VERSION}"; \
    fi && \
    echo "Downloading ARK server tools version: ${DOWNLOAD_VERSION}" && \
    curl -fsSL "https://github.com/arkmanager/ark-server-tools/archive/v${DOWNLOAD_VERSION}.tar.gz" | \
        tar xzf - -C /tmp/ && \
    cd "/tmp/ark-server-tools-${DOWNLOAD_VERSION}/tools" && \
    bash -x install.sh "${USER}" && \
    ln -s /usr/local/bin/arkmanager /usr/bin/arkmanager && \
    install -d -o "${USER}" "${ARK_SERVER_VOLUME}" && \
    su "${USER}" -c "bash -x ${STEAMCMDDIR}/steamcmd.sh +login anonymous +quit" && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/steam/Steam/logs/*

COPY bin/ /
COPY conf.d ${TEMPLATE_DIRECTORY}

EXPOSE ${GAME_CLIENT_PORT}/udp \
       ${UDP_SOCKET_PORT}/udp \
       ${SERVER_LIST_PORT}/udp \
       ${RCON_PORT}/tcp

VOLUME ["${ARK_SERVER_VOLUME}"]
WORKDIR ${ARK_SERVER_VOLUME}

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD []
