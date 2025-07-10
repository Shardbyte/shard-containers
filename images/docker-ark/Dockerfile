#################################################
# Copyright (c) Shardbyte. All Rights Reserved. #
# SPDX-License-Identifier: MIT                  #
#################################################

FROM shardbyte/steamcmd

LABEL author="Shardbyte" \
      maintainer="containers@shardbyte.com" \
      org.opencontainers.image.source="https://github.com/Shardbyte/shard-containers" \
      org.opencontainers.image.description="Application packaged by Shardbyte" \
      org.opencontainers.image.title="docker-ark" \
      org.opencontainers.image.licenses="MIT"

ARG ARK_TOOLS_VERSION="latest"
ARG IMAGE_VERSION="dev"
ARG DEBIAN_FRONTEND=noninteractive

ENV IMAGE_VERSION="${IMAGE_VERSION}" \
    SESSION_NAME="Dockerized ARK Server" \
    SERVER_MAP="TheIsland" \
    SERVER_PASSWORD="theDEFAULTpassword" \
    SERVER_PVE="false" \
    ADMIN_PASSWORD="changeMEplease" \
    MAX_PLAYERS="20" \
    GAME_MOD_IDS="" \
    UPDATE_ON_START="false" \
    BACKUP_ON_STOP="false" \
    BACKUP_POST_COMMAND="echo 'Backup Complete!'" \
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

# Switch to root for package installation
USER root

RUN dpkg --add-architecture i386 && \
    apt-get clean && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends --no-install-suggests \
        jq \
        curl \
        perl \
        cron \
        lsof \
        gosu \
        gzip \
        bzip2 \
        perl-base \
        perl-modules \
        libc6-i386 \
        lib32gcc-s1 && \
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

COPY --chown=steam:steam bin/ /
COPY --chown=steam:steam conf.d ${TEMPLATE_DIRECTORY}

RUN chmod +x /docker-entrypoint.sh && \
    chmod +x /steam-entrypoint.sh

EXPOSE ${GAME_CLIENT_PORT}/udp \
       ${UDP_SOCKET_PORT}/udp \
       ${SERVER_LIST_PORT}/udp \
       ${RCON_PORT}/tcp

VOLUME ["${ARK_SERVER_VOLUME}"]
WORKDIR ${ARK_SERVER_VOLUME}
USER ${USER}

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD []