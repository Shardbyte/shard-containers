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
  <img src="https://raw.githubusercontent.com/Shardbyte/Shardbyte/main/img/logo-shardbyte-master-light.webp" alt="Shardbyte Logo" width="150"/>

  # � Shard Containers

  **Production-ready Docker containers for gaming, development, and infrastructure**

  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
  [![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/Shardbyte/shard-containers/graphs/commit-activity)
  [![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
  [![Linux](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.linux.org/)

  *Hardened, optimized, and security-focused container images for modern infrastructure*
</div>

---

## 📋 Overview

This repository contains a collection of production-ready Docker containers designed for gaming servers, development environments, and infrastructure services. Each container is built with security, performance, and maintainability in mind.

## 🚀 Available Containers

### 🎮 Gaming Servers

#### **docker-ark** - ARK: Survival Evolved Server
- **Based on**: `shardbyte/steamcmd`
- **Features**:
  - Automated server management with ARK-Server-Tools
  - Support for mods and DLCs
  - Automatic backups and updates
  - Configurable via environment variables
  - Hardened security with proper user management
- **Path**: `images/docker-ark/`
- **Tags**: `latest`

### 🛠️ Base Images

#### **steamcmd** - Steam Console Client
- **Based on**: `debian:bookworm-slim`
- **Features**:
  - Official Debian steamcmd package
  - Optimized for container environments
  - Non-root user execution
  - Minimal attack surface
- **Path**: `images/steamcmd/`
- **Tags**: `latest`

## 🏗️ Architecture

All containers follow these design principles:

- **🔒 Security First**: Run as non-root users with proper permission handling
- **📦 Minimal Base**: Built on Debian slim images for reduced attack surface
- **🔧 Configuration**: Environment variable driven configuration
- **📊 Observability**: Structured logging and health checks
- **🔄 Automation**: Automated builds and dependency management

## 🚀 Quick Start

### Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes thoroughly
4. Commit your changes
5. Push to the branch
6. Open a Pull Request

## 📖 Documentation

Detailed documentation for each container can be found in their respective directories:

- [SteamCMD Documentation](images/steamcmd/README.md)
- [ARK Server Documentation](images/docker-ark/README.md)

## �️ Security

### Security Features

- **Non-root execution**: All services run as unprivileged users
- **Minimal packages**: Only essential packages are installed
- **Regular updates**: Base images are regularly updated
- **Secrets management**: Sensitive data handled via environment variables
- **Network isolation**: Containers use custom networks by default

### Reporting Security Issues

Please report security vulnerabilities to: security@shardbyte.com

</div>

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Contact**: saint@shardbyte.com
- **Website**: [shardbyte.com](https://shardbyte.com)
- **GitHub**: [@Shardbyte](https://github.com/Shardbyte)
- **Container Registry**: [Docker Hub](https://hub.docker.com/u/shardbyte)

## 💡 Acknowledgments

- Thanks to the open-source community for inspiration and tools
- Special thanks to the maintainers of steamcmd and ARK-Server-Tools

---

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/Shardbyte">Shardbyte</a></sub>
</div>