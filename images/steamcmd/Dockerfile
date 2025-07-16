#################################################
# Copyright (c) Shardbyte. All Rights Reserved. #
# SPDX-License-Identifier: MIT                  #
#################################################
#
FROM debian:bookworm-slim

LABEL   author="Shardbyte" maintainer="containers@shardbyte.com" \
        org.opencontainers.image.source="https://github.com/Shardbyte/shard-containers" \
        org.opencontainers.image.description="Application packaged by Shardbyte" \
        org.opencontainers.image.title="steamcmd" \
        org.opencontainers.image.licenses="MIT"

ARG PUID=1000
ENV USER=steam
ENV HOMEDIR="/home/${USER}"
ENV STEAMCMDDIR="${HOMEDIR}/steamcmd" \
    LANG=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && sed -i 's/^Components: main$/& contrib non-free/' /etc/apt/sources.list.d/debian.sources

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends --no-install-suggests \
        ca-certificates \
        nano \
        locales \
        steamcmd \
        lib32gcc-s1 \
        lib32stdc++6 \
    && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && useradd -u "${PUID}" -m "${USER}" \
    && mkdir -p "${STEAMCMDDIR}" \
    && chown "${USER}:${USER}" "${STEAMCMDDIR}" \
    && ln -s /usr/games/steamcmd "${STEAMCMDDIR}/steamcmd.sh" \
    && ln -s /usr/games/steamcmd /usr/bin/steamcmd \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -rf /var/cache/debconf/*

USER ${USER}
WORKDIR ${HOMEDIR}

RUN steamcmd +quit \
    && mkdir -p "${HOMEDIR}/.steam/sdk32" "${HOMEDIR}/.steam/sdk64" \
    && ln -s "${HOMEDIR}/.local/share/Steam/steamcmd/linux32" "${HOMEDIR}/.steam/sdk32" \
    && ln -s "${HOMEDIR}/.local/share/Steam/steamcmd/linux64" "${HOMEDIR}/.steam/sdk64" \
    && ln -s "${HOMEDIR}/.steam/sdk32/steamclient.so" "${HOMEDIR}/.steam/sdk32/steamservice.so" \
    && ln -s "${HOMEDIR}/.steam/sdk64/steamclient.so" "${HOMEDIR}/.steam/sdk64/steamservice.so" \
    && ln -s "${HOMEDIR}/.local/share/Steam/steamcmd/linux32/steamclient.so" "${STEAMCMDDIR}/steamservice.so" \
    && ln -s "${HOMEDIR}/.local/share/Steam/steamcmd/linux64/steamclient.so" "${STEAMCMDDIR}/steamclient.so" \
    && rm -rf "${HOMEDIR}/.steam/logs"/* \
    && rm -rf "${HOMEDIR}/.local/share/Steam/logs"/* \
    && rm -rf "${HOMEDIR}/.local/share/Steam/steamcmd/logs"/* \
    && rm -rf "${HOMEDIR}/.cache/steam"/* 2>/dev/null || true

WORKDIR ${STEAMCMDDIR}
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD test -f "${STEAMCMDDIR}/steamcmd.sh" || exit 1

ENTRYPOINT ["./steamcmd.sh"]
CMD ["+help", "+quit"]