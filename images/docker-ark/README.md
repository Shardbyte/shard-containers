# Dockerized ARK Server with ARK-Server-Tools

A containerized ARK: Survival Evolved server managed with [ARK-Server-Tools](https://github.com/arkmanager/ark-server-tools).

You can use this image to start an ARK server for either public or private sessions. The server itself is manageable by ARK-Server-Tools.

## Tags

This image always installs the latest version of ARK Server currently available. Thus, the tags are referring to the ARK-Server-Tools version which is used by the corresponding image.

## Usage

### ⚠️ Windows / WSL Notice

**Mount the container volumes directly inside WSL's filesystem.** Mounting them inside a filesystem managed by Windows causes the installation to be painfully slow or even get stuck.

### Startup your ARK Server

#### Basic Configuration

The basic configuration of your server is done by using environment variables when starting the container:

| Variable | Default Value | Explanation |
|:-----------------:|:----------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------:|
| `SESSION_NAME` | `Dockerized ARK Server by github.com/hermsi1337` | The name of your ARK session which is visible in game when searching for servers |
| `SERVER_MAP` | `TheIsland` | Desired map you want to play |
| `SERVER_PASSWORD` | `YouShallNotPass` | Server password which is required to join your session (use empty string to disable password authentication) |
| `ADMIN_PASSWORD` | `Th155houldD3f1n3tlyB3Chang3d` | Admin password to access the admin console of ARK |
| `MAX_PLAYERS` | `20` | Maximum number of players to join your session |
| `UPDATE_ON_START` | `false` | Whether you want to update the ARK server upon startup or not |
| `BACKUP_ON_STOP` | `false` | Create a backup before gracefully stopping the ARK server |
| `PRE_UPDATE_BACKUP` | `true` | Create a backup before updating ARK server |
| `WARN_ON_STOP` | `true` | Broadcast a warning upon graceful shutdown |
| `ENABLE_CROSSPLAY` | `false` | Enable crossplay. When enabled, BattlEye should be disabled as it likes to disconnect Epic players |
| `DISABLE_BATTLEYE` | `false` | Disable BattlEye protection |
| `ARK_SERVER_VOLUME` | `/app` | Path where the server files are stored |
| `GAME_CLIENT_PORT` | `7777` | Exposed game client port |
| `UDP_SOCKET_PORT` | `7778` | Raw UDP socket port (always Game client port +1) |
| `RCON_PORT` | `27020` | Exposed RCON port |
| `SERVER_LIST_PORT` | `27015` | Exposed server list port |
| `GAME_MOD_IDS` | `empty` | Additional game mods you want to install, separated by comma (e.g. `GAME_MOD_IDS=487516323,487516324,487516325`) |

#### Get Things Running

##### Docker Run

I personally prefer `docker-compose` but for those of you who want to run their own ARK server without any "zip and zap", here you go:

```bash
# You may want to change SESSION_NAME, ADMIN_PASSWORD or host-volume
docker run -d \
  --name="ark_server" \
  --restart=always \
  -v "${HOME}/ark-server:/app" \
  -e SESSION_NAME="Awesome ARK is awesome" \
  -e ADMIN_PASSWORD="FooB4r" \
  shardbyte/docker-ark:latest
```

##### Docker Compose

In order to startup your own ARK server with `docker-compose` - which I personally prefer over a simple `docker run` - you may adapt the following `docker-compose.yml`:

```yaml
#################################################
# Copyright (c) Shardbyte. All Rights Reserved. #
# SPDX-License-Identifier: MIT                  #
#################################################
# Shardbyte Docker Compose | docker-compose.yml
#
#
#
services:
#######################################################
  ark_server:
    image: 'ghcr.io/shardbyte/steamcmd:latest'
    container_name: ark_server
    restart: unless-stopped
    environment:
# === This setup is necessary if you have to download a non-anonymous appID/modID
      # STEAM_LOGIN: ${STEAM_LOGIN}
      SESSION_NAME: ${SESSION_NAME}
      SERVER_MAP: ${SERVER_MAP}
      SERVER_PASSWORD: ${SERVER_PASSWORD}
      ADMIN_PASSWORD: ${ADMIN_PASSWORD}
      MAX_PLAYERS: ${MAX_PLAYERS}
      UPDATE_ON_START: ${UPDATE_ON_START}
      BACKUP_ON_STOP: ${BACKUP_ON_STOP}
      PRE_UPDATE_BACKUP: ${PRE_UPDATE_BACKUP}
      WARN_ON_STOP: ${WARN_ON_STOP}
      ENABLE_CROSSPLAY: ${ENABLE_CROSSPLAY}
      DISABLE_BATTLEYE: ${DISABLE_BATTLEYE}
      ARK_SERVER_VOLUME: ${ARK_SERVER_VOLUME}
      GAME_MOD_IDS: ${GAME_MOD_IDS}
      GAME_CLIENT_PORT: ${GAME_CLIENT_PORT}
      UDP_SOCKET_PORT: ${UDP_SOCKET_PORT}
      RCON_PORT: ${RCON_PORT}
      SERVER_LIST_PORT: ${SERVER_LIST_PORT}
    volumes:
# === This setup is necessary if you have to download a non-anonymous appID/modID
      # - '${STEAM_SESSION_VOLUME}:/home/steam/Steam'
      - '${ARK_SERVER_VOLUME}:/app'
      - '${ARK_SERVER_VOLUME}/ark-backups:/home/steam/ARK-Backups'
    networks:
      - ark_network
    ports:
      # Port for connections from ARK game client
      - "${GAME_CLIENT_PORT}:${GAME_CLIENT_PORT}/udp"
      # Raw UDP socket port (always Game client port +1)
      - "${UDP_SOCKET_PORT}:${UDP_SOCKET_PORT}/udp"
      # RCON management port
      - "${RCON_PORT}:${RCON_PORT}/tcp"
      # Steam's server-list port
      - "${SERVER_LIST_PORT}:${SERVER_LIST_PORT}/udp"
#######################################################
networks:
  ark_network:
    name: ark_network
#######################################################
```

After applying your changes to the `docker-compose.yml` above, start it up:

```bash
docker-compose up -d
```

### Tweak Configuration

After your container is up and ARK is installed you can start tweaking your configuration. Basically, you can modify every setting which ARK-Server-Tools are capable of. For reference of the available commands check [their docs](https://github.com/arkmanager/ark-server-tools#configuration).

The main config files are located at the following path in the container:

- `/app/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini`
- `/app/server/ShooterGame/Saved/Config/LinuxServer/Game.ini`

You can easily apply your changes directly into these files.

Alternatively, it is possible to run any available command with ARK-Server-Tools and apply your changes that way:

```bash
docker exec -u steam ark_server arkmanager status
docker exec -u steam ark_server arkmanager update --force
docker exec -u steam ark_server arkmanager installmods
```

For a full list of all available commands [check here](https://github.com/arkmanager/ark-server-tools#commands-acting-on-instances).

### Add Cronjobs

It is also possible to add cronjobs inside the container. You could use the crontab for update or backup tasks. In order to do so, edit the crontab file located directly in the server volume.

```bash
nano "${HOME}/ark-server/crontab"
```

Add your desired cronjobs with valid syntax:

```bash
0 0 * * * arkmanager update --warn --update-mods >> ${SERVER_VOLUME}/log/crontab.log 2>&1
0 0 * * * arkmanager backup >> ${SERVER_VOLUME}/log/crontab.log 2>&1
```

Close file and restart the container:

```bash
docker restart ark_server
```

### Configure Steam Login Session

In order for `steamcmd` to respect your user's non-anonymous DLCs and content, you have to mount the steam session inside the ark-server container.

To do so, you first need to login with steamcmd in order to create a valid session:

```bash
mkdir Steam
chown 1000:1000 Steam
docker run --rm \
  --entrypoint /home/steam/steamcmd/steamcmd.sh \
  -it -u steam \
  -v $(pwd)/Steam:/home/steam/Steam \
  ghcr.io/shardbyte/steamcmd:latest \
  '+login YOUR_STEAM_USERNAME "YOUR_STEAM_PASSWORD"'
```

You'll see output like:

```
Redirecting stderr to '/home/steam/Steam/logs/stderr.txt'
[  0%] Checking for available updates...
[----] Verifying installation...
Steam Console Client (c) Valve Corporation - version 1654574676
-- type 'quit' to exit --
Loading Steam API...OK
Logging in user 'YOUR_STEAM_USERNAME' to Steam Public...
Enter the current code from your Steam Guard Mobile Authenticator app
Two-factor code:FOOBAR
OK
Waiting for client config...OK
Waiting for user info...OK

Steam>quit
```

Afterwards, set the environment variable `STEAM_LOGIN` to your username and mount the newly created `Steam` directory inside your ARK container:

```yaml
environment:
  STEAM_LOGIN: "YOUR_STEAM_USERNAME"
volumes:
  - ./Steam:/home/steam/Steam:rw
```

Then, `arkmanager` will install/update `ark` using your provided login.
