<!--
#
#
###########################
#                         #
#  Saint @ Shardbyt5. **Start** the server - initial installation will download ARK files automatically

## 🔧 Pelican Variables

All server configuration is managed through Pelican Panel's variable system. These variables are automatically passed to the conta## 🆘 Support

### Getting Help
- **Pelican Panel Issues**: Check Pelican Panel documentation and community forums
- **Container Issues**: Review server logs in Pelican's console tab
- **ARK Server Issues**: Consult ARK documentation and community forums
- **Mod Problems**: Verify mod compatibility and Steam Workshop status

### Useful Resources
- [Pelican Panel Documentation](https://pelican.dev/docs)
- [ARK Server Configuration Guide](https://ark.wiki.gg/wiki/Server_configuration)
- [Steam Workshop for ARK](https://steamcommunity.com/app/346110/workshop/)
- [Shardbyte Support](https://github.com/Shardbyte/shard-containers/issues)ent variables when the server starts.om  #
#                         #
###########################
# Author: Shardbyte (Saint)
#
#
-->

<div align="center">
  <img src="https://raw.githubusercontent.com/Shardbyte/Shardbyte/main/img/logo-shardbyte-master-light.webp" alt="Shardbyte Logo" width="100"/>

  # 🐳 ARKManager Pelican

  **Enhanced ARK: Survival Evolved server with ARKManager integration for Pelican Panel**

  [![Build Status](https://img.shields.io/github/actions/workflow/status/shardbyte/shard-containers/build.yml)](https://hub.docker.com/r/shardbyte/arkmanager)
  [![Docker Pulls](https://img.shields.io/docker/pulls/shardbyte/arkmanager.svg)](https://hub.docker.com/r/shardbyte/arkmanager)
  [![Image Size](https://img.shields.io/docker/image-size/shardbyte/arkmanager)](https://hub.docker.com/r/shardbyte/arkmanager)
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

  *Production-ready ARK server management for Pelican Panel deployments*
</div>

---

## 📋 What is ARKManager Pelican?

ARKManager Pelican is a specialized Docker container for ARK: Survival Evolved servers designed exclusively for Pelican Panel deployments. It provides automated server lifecycle management, mod support, and advanced configuration options through Pelican's intuitive web interface. This container integrates seamlessly with Pelican Panel's egg system, offering users a streamlined experience for deploying and managing ARK servers without complex command-line setup.

## ✨ Features

- 🔒 **Security-First**: Non-root user execution with proper permission handling
- �️ **Pelican Integration**: Native integration with Pelican Panel's management interface
- �🎮 **ARKManager Integration**: Full server lifecycle management through Pelican's web UI
- 🔧 **Mod Support**: Automatic Steam Workshop mod downloading via Pelican variables
- 🗺️ **Multi-Map Support**: All official ARK maps and DLCs configurable through Pelican
- 🌐 **Crossplay Ready**: Support for PC (Steam/Epic) and console crossplay
- 📦 **Automated Updates**: Optional server and mod updates managed by Pelican
- 🛡️ **RCON Support**: Remote administration through Pelican's console interface
- 📊 **Resource Monitoring**: Built-in performance tracking visible in Pelican Panel
- 🎨 **Colorized Logging**: Enhanced log output in Pelican's log viewer

## 🏗️ Image Details

- **Base Image**: `debian:bookworm-slim`
- **Architecture**: Multi-architecture support (amd64, i386 libraries)
- **User**: `container` (UID: 988) for security
- **Working Directory**: `/home/container`
- **ARK Tools**: `/home/container/.arkmanager`
- **Size**: ~500MB (does not include ARK server files)

## ⚠️ Important Notice

### Pelican Panel Only
**This container is designed exclusively for Pelican Panel deployments.** It requires Pelican Panel's environment variables and file structure to function properly. Do not attempt to run this container standalone.

### Resource Requirements
ARK servers are resource-intensive applications. Ensure your Pelican Panel node has adequate resources:
- **Minimum**: 8GB RAM, 2 CPU cores, 50GB storage per server
- **Recommended**: 16GB+ RAM, 4+ CPU cores, 100GB+ SSD storage per server

### Windows / WSL Hosting
**Mount Pelican Panel volumes directly inside WSL's filesystem.** Mounting on Windows-managed filesystems can cause extremely slow performance or installation failures.

## 🚀 Pelican Panel Setup

### Installing the Egg

1. **Download the Egg**: Get `egg-arkmanager-pelican.json` from the [shard-egg-basket](https://github.com/Shardbyte/shard-egg-basket) repository
2. **Import to Pelican**: Upload the egg file through Pelican Panel's admin interface
3. **Configure Node**: Ensure your node has adequate resources allocated
4. **Create Server**: Deploy a new server using the "ARKManager Pelican" egg

### Server Deployment

1. **Navigate** to your Pelican Panel admin interface
2. **Go to Nests** → **Import Egg** and upload the egg file
3. **Create Server** using the ARKManager Pelican egg
4. **Configure** server variables through Pelican's interface
5. **Start** the server - initial installation will download ARK files automatically

## � Quick Start

### Basic Usage

```bash
# Quick start with default settings
docker run -d \
  --name="arkmanager_server" \
  --restart=unless-stopped \
  -v "${HOME}/ark-server:/home/container" \
  -e SESSION_NAME="My ARK Server" \
  -e ADMIN_PASSWORD="MySecurePassword" \
  -p 7777:7777/udp \
  -p 7778:7778/udp \
  -p 27015:27015/udp \
  -p 27020:27020/tcp \
  shardbyte/arkmanager:pelican
```

### Production Deployment

```yaml
version: '3.8'

services:
  arkserver:
    image: shardbyte/arkmanager:pelican
    container_name: ark-server
    restart: unless-stopped
    environment:
      - SESSION_NAME=My ARK Server
      - MAP=TheIsland
      - ADMIN_PASSWORD=supersecurepassword123
      - MAX_PLAYERS=50
      - SERVER_PVE=false
      - MODS=731604991,889745138
      - UPDATE_ON_START=true
      - PRE_UPDATE_BACKUP=true
      - TZ=America/New_York
    ports:
      - "7777:7777/udp"    # Game Client Port
      - "7778:7778/udp"    # UDP Socket Port
      - "27015:27015/udp"  # Server Browser Port
      - "27020:27020/tcp"  # RCON Port
    volumes:
      - ./ark-data:/home/container
      - ./ark-backups:/home/container/backups
    networks:
      - ark-network

## 🔧 Pelican Variables

All server configuration is managed through Pelican Panel's variable system. These variables are automatically passed to the container as environment variables when the server starts.

### Server Configuration

| Variable | Description | Default | Required |
| `SESSION_NAME` | Server display name | `Pelican ARK Server` | No |
| `MAP` | Game world to load | `TheIsland` | No |
| `SERVER_PVE` | Enable PvE mode | `false` | No |
| `MAX_PLAYERS` | Maximum player count | `20` | No |
| `SERVER_PASSWORD` | Join password | *empty* | No |
| `ADMIN_PASSWORD` | Admin password | `changeMEplease` | **Yes** |

### Network Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `GAME_CLIENT_PORT` | Primary game port | `7777` | No |
| `UDP_SOCKET_PORT` | Communication port | `7778` | No |
| `SERVER_LIST_PORT` | Query port | `27015` | No |
| `RCON_PORT` | Remote admin port | `27020` | No |

### Advanced Features

| Variable | Description | Default | Options |
|----------|-------------|---------|---------|
| `UPDATE_ON_START` | Auto-update server | `false` | `true`/`false` |
| `PRE_UPDATE_BACKUP` | Backup before updates | `false` | `true`/`false` |
| `MODS` | Workshop mod IDs | *empty* | Comma-separated |
| `ENABLE_CROSSPLAY` | Enable crossplay | `false` | `true`/`false` |
| `DISABLE_BATTLEYE` | Disable anti-cheat | `false` | `true`/`false` |
| `DEBUG` | Enable debug mode | `false` | `true`/`false` |

## 🎮 Supported Maps

### Free Maps
- `TheIsland` - Original ARK experience
- `TheCenter` - Community expansion
- `Ragnarok` - Desert and winter biomes
- `Valguero_P` - Underground areas and diverse landscapes
- `CrystalIsles` - Crystal-themed environment
- `Fjordur` - Norse mythology inspired
- `Gen2` - Genesis Part 2

### DLC Maps
- `ScorchedEarth_P` - Desert survival (SE DLC)
- `Aberration_P` - Underground radiation zones (AB DLC)
- `Extinction` - Post-apocalyptic Earth (EX DLC)
- `Genesis` - Genesis Part 1 simulation (GEN DLC)

## 🔌 Port Configuration

Ensure the following ports are properly configured:

```bash
# UFW (Ubuntu Firewall) Example
sudo ufw allow 7777/udp    # Game Client
sudo ufw allow 7778/udp    # UDP Socket
sudo ufw allow 27015/udp   # Server Browser
sudo ufw allow 27020/tcp   # RCON
```

## 🛠️ Workshop Mods

### Adding Mods
Set the `MODS` environment variable with comma-separated Steam Workshop IDs:

```bash
MODS=731604991,889745138,793605978
```

### Popular Mods
- **Structures Plus (S+)**: `731604991`
- **Super Structures**: `889745138`
- **Awesome SpyGlass**: `793605978`
- **Dino Storage v2**: `1609138312`

## 📊 Resource Requirements

### Minimum Requirements
- **CPU**: 2 cores
- **RAM**: 8GB
- **Storage**: 50GB free space
- **Network**: Stable internet connection

### Recommended Requirements
- **CPU**: 4+ cores
- **RAM**: 12GB+
- **Storage**: 100GB+ SSD
- **Network**: High-speed internet with low latency

## 🔍 Monitoring via Pelican Panel

### Server Logs
Pelican Panel provides real-time log viewing through its web interface:
- **File Manager**: Access log files directly
- **Resource Usage**: Monitor CPU, RAM, and disk usage

### Log Levels
The container provides colorized logging visible in Pelican's console:
- 🦕 **ARK Messages**: Server status and events
- ✔️ **Success**: Completed operations
- ⚠️ **Warning**: Non-critical issues
- ✘ **Error**: Critical problems requiring attention
- ◉ **Mod**: Mod-related operations
- ✪ **Server**: Server management actions

## 🔄 Updates and Maintenance

### Automatic Updates
Updates are managed through Pelican Panel variables:
- Set **Auto-Update Server** to `true` for automatic updates on restart
- Enable **Backup Before Updates** for safety
- Updates include both server files and installed mods

### Manual Updates
1. **Stop** the server in Pelican Panel
2. **Enable** Auto-Update Server variable
3. **Start** the server (updates will download automatically)
4. **Disable** Auto-Update Server if desired

### Backup Management
Enable **Pre-Update Backup** variable to automatically backup your world before updates through Pelican Panel.

## � Server Management

### Pelican Panel Controls
All server management is handled through Pelican Panel's interface:
- **Start/Stop/Restart**: Use Pelican's power controls
- **Console Commands**: Send commands via Pelican's console
- **File Management**: Access server files through Pelican's file manager
- **Resource Monitoring**: View performance metrics in Pelican

### Common Admin Tasks
Access server functions through Pelican Panel's console:
- `SaveWorld` - Manual world save
- `ListPlayers` - Show connected players
- `Broadcast <message>` - Server-wide announcement
- `KickPlayer <PlayerName>` - Remove player
- `BanPlayer <PlayerName>` - Ban player

## 📄 License

This container is licensed under the MIT License. ARK: Survival Evolved is a trademark of Studio Wildcard.

---

<div align="center">

**[Shardbyte](https://shardbyte.com) • [GitHub](https://github.com/Shardbyte) • [Docker Hub](https://hub.docker.com/u/shardbyte)**

*Built with ❤️ for the gaming community*

</div>