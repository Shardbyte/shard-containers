<!--
#
#
###########################
#                         #
#  Saint @ Shardbyte.com  #
#                         #
###########################
# Author: Shardbyte (Saint)
#
#
-->

<div align="center">
  <img src="https://raw.githubusercontent.com/Shardbyte/Shardbyte/main/img/logo-shardbyte-master-light.webp" alt="Shardbyte Logo" width="100"/>

  # 🐳 SteamCMD Container

  **Optimized Steam Console Client for containerized gaming servers**

  [![Build Status](https://img.shields.io/github/actions/workflow/status/shardbyte/shard-containers/build.yml)](https://hub.docker.com/r/shardbyte/steamcmd)
  [![Docker Pulls](https://img.shields.io/docker/pulls/shardbyte/steamcmd.svg)](https://hub.docker.com/r/shardbyte/steamcmd)
  [![Image Size](https://img.shields.io/docker/image-size/shardbyte/steamcmd)](https://hub.docker.com/r/shardbyte/steamcmd)
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

  *Production-ready base image for Steam-powered game servers*
</div>

---

## 📋 What is SteamCMD?

The Steam Console Client (SteamCMD) is a command-line version of the Steam client designed for server environments. It enables automated installation and updates of Steam-based dedicated game servers using the SteamPipe content system. This containerized version provides a secure, optimized foundation for building gaming server containers.

**Source**: [Valve Developer Documentation](https://developer.valvesoftware.com/wiki/SteamCMD)

## ✨ Features

- 🔒 **Security-First**: Non-root user execution with proper permission handling
- 📦 **Debian Package**: Uses official Debian steamcmd package for stability
- 🚀 **Optimized**: Minimal image size with essential dependencies only
- 🔧 **Container-Ready**: Pre-configured for containerized environments
- 🛡️ **Hardened**: Reduced attack surface with unnecessary packages removed
- 📊 **Health Checks**: Built-in container health monitoring

## 🏗️ Image Details

- **Base Image**: `debian:bookworm-slim`
- **Architecture**: `linux/amd64`
- **User**: `steam` (UID: 1000)
- **Working Directory**: `/home/steam/steamcmd`
- **Size**: ~200MB (optimized)

## 🚀 Quick Start

### Basic Usage

```bash
# Run SteamCMD interactively
docker run -it --rm shardbyte/steamcmd:latest

# Download a specific app (example: ARK server files)
docker run --rm \
  -v "${PWD}/steamapps:/home/steam/steamcmd/steamapps" \
  shardbyte/steamcmd:latest \
  +login anonymous \
  +app_update 376030 validate \
  +quit
```

### As Base Image

```dockerfile
FROM shardbyte/steamcmd:latest

# Your game server setup
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Continue with your game server configuration
```

## 🎮 Gaming Servers Built on This Image

| Game Server | Container | Docker Pulls |
|-------------|-----------|--------------|
| **ARK: Survival Evolved** | [shardbyte/docker-ark](https://hub.docker.com/r/shardbyte/docker-ark/) | [![Docker Pulls](https://img.shields.io/docker/pulls/shardbyte/docker-ark.svg)](https://hub.docker.com/r/shardbyte/docker-ark/) |
| **More Coming Soon** | - | - |

## 🔧 Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `USER` | `steam` | System user for SteamCMD |
| `HOMEDIR` | `/home/steam` | User home directory |
| `STEAMCMDDIR` | `/home/steam/steamcmd` | SteamCMD installation directory |
| `LANG` | `en_US.UTF-8` | System locale |

## 📁 Directory Structure

```
/home/steam/
├── steamcmd/
│   ├── steamcmd.sh          # SteamCMD executable
│   ├── steamapps/           # Downloaded applications
│   └── logs/                # SteamCMD logs
├── .steam/
│   ├── sdk32/               # 32-bit Steam SDK
│   ├── sdk64/               # 64-bit Steam SDK
│   └── logs/                # Steam client logs
└── .local/share/Steam/      # Steam data directory
```

## 🛡️ Security Features

### User Security
- **Non-root execution**: Runs as `steam` user (UID: 1000)
- **Minimal privileges**: Only necessary permissions granted
- **Isolated environment**: Contained within user home directory

### System Security
- **Minimal packages**: Only essential dependencies installed
- **Regular updates**: Base image updated frequently
- **Clean installation**: Temporary files and caches removed
- **Debian security**: Benefits from Debian's security updates

## 🔨 Development

### Building the Image

```bash
# Clone the repository
git clone https://github.com/Shardbyte/shard-containers.git
cd shard-containers/images/steamcmd

# Build the image
docker build -t shardbyte/steamcmd:latest .

# Test the build
docker run --rm shardbyte/steamcmd:latest +help +quit
```

### Health Check

The container includes a health check that verifies SteamCMD is properly installed:

```bash
# Check container health
docker run --rm shardbyte/steamcmd:latest \
  sh -c 'test -f /home/steam/steamcmd/steamcmd.sh && echo "Healthy" || exit 1'
```

## 📖 Common Use Cases

### Anonymous Downloads
```bash
# Download free game server files
docker run --rm \
  -v "${PWD}/gameserver:/home/steam/steamcmd/steamapps" \
  shardbyte/steamcmd:latest \
  +login anonymous \
  +app_update <APP_ID> validate \
  +quit
```

### Authenticated Downloads
```bash
# For games requiring Steam account
docker run --rm -it \
  -v "${PWD}/gameserver:/home/steam/steamcmd/steamapps" \
  -v "${PWD}/steam_session:/home/steam/Steam" \
  shardbyte/steamcmd:latest \
  +login <username> \
  +app_update <APP_ID> validate \
  +quit
```

### Persistent Session
```bash
# Maintain Steam login session
docker run --rm -it \
  -v steam_session:/home/steam/Steam \
  shardbyte/steamcmd:latest \
  +login <username> <password> \
  +quit
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes and test thoroughly
4. Commit your changes
5. Push to the branch
6. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../LICENSE) file for details.

## 🔗 Links

- **Docker Hub**: [shardbyte/steamcmd](https://hub.docker.com/r/shardbyte/steamcmd)
- **Source Code**: [GitHub Repository](https://github.com/Shardbyte/shard-containers)
- **Website**: [shardbyte.com](https://shardbyte.com)
- **Contact**: containers@shardbyte.com

## 💡 Acknowledgments

- Thanks to Valve for providing SteamCMD
- Debian maintainers for the steamcmd package
- The gaming server community for feedback and testing

---

<div align="center">
  <sub>Part of the <a href="https://github.com/Shardbyte/shard-containers">Shard Containers</a> collection</sub>
</div>

