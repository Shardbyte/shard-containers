#################################################
# Copyright (c) Shardbyte. All Rights Reserved. #
# SPDX-License-Identifier: MIT                  #
#################################################
#

FROM debian:bookworm-slim

LABEL   author="Shardbyte" maintainer="yolks@shardbyte.com" \
        org.opencontainers.image.source="https://github.com/Shardbyte/shard-containers" \
        org.opencontainers.image.description="Application packaged by Shardbyte" \
        org.opencontainers.image.title="steamcmd" \
        org.opencontainers.image.licenses="MIT"

ARG PUID=1000
ENV USER=steam
ENV HOMEDIR="/home/${USER}"
ENV DEBIAN_FRONTEND=noninteractive \
    STEAMCMDDIR="${HOMEDIR}/steamcmd"

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends --no-install-suggests \
        curl \
        nano \
        locales \
        ca-certificates \
        lib32gcc-s1 \
        lib32stdc++6 \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && useradd -u "${PUID}" -m "${USER}" \
    && su "${USER}" -c \
    "mkdir -p \"${STEAMCMDDIR}\" \
            && curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMDDIR}\" \
            && \"./${STEAMCMDDIR}/steamcmd.sh\" +quit \
            && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${STEAMCMDDIR}/steamservice.so\" \
            && mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
            && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
            && ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
            && mkdir -p \"${HOMEDIR}/.steam/sdk64\" \
            && ln -s \"${STEAMCMDDIR}/linux64/steamclient.so\" \"${HOMEDIR}/.steam/sdk64/steamclient.so\" \
            && ln -s \"${STEAMCMDDIR}/linux64/steamcmd\" \"${STEAMCMDDIR}/linux64/steam\" \
            && ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
    && ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/steam/Steam/logs/*

WORKDIR ${STEAMCMDDIR}
USER ${USER}

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD test -f "${STEAMCMDDIR}/steamcmd.sh" || exit 1
