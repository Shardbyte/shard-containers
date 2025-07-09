#!/usr/bin/env bash
#################################################
# Copyright (c) Shardbyte. All Rights Reserved. #
# SPDX-License-Identifier: MIT                  #
#################################################

# ===============================================================================
# ARK Server Docker Entrypoint Script
# ===============================================================================

# Enable strict error handling
set -e

# ===============================================================================
# DEBUG CONFIGURATION
# ===============================================================================

# Enable debug mode if DEBUG environment variable is set
if [[ -n "${DEBUG}" ]] && [[ "${DEBUG,,}" != "false" ]] && [[ "${DEBUG,,}" != "0" ]]; then
    echo "Debug mode enabled - showing all commands"
    set -x
fi

# ===============================================================================
# DIRECTORY INITIALIZATION
# ===============================================================================

# Create ARK server volume directory if it doesn't exist
if [[ ! -d "${ARK_SERVER_VOLUME}" ]]; then
    echo "Creating ARK server volume directory: ${ARK_SERVER_VOLUME}"
    mkdir -p "${ARK_SERVER_VOLUME}"
fi

# Set ownership of ARK server volume
echo "Setting ownership of ${ARK_SERVER_VOLUME} to ${STEAM_USER}"
if ! chown "${STEAM_USER}". "${ARK_SERVER_VOLUME}"; then
    echo "WARNING: Failed to set ownership on ${ARK_SERVER_VOLUME}, continuing startup..."
fi

# ===============================================================================
# ARK TOOLS CONFIGURATION
# ===============================================================================

# Initialize ARK tools directory if it doesn't exist
if [[ ! -d "${ARK_TOOLS_DIR}" ]]; then
    echo "Initializing ARK tools directory: ${ARK_TOOLS_DIR}"

    # Move default arkmanager config to persistent location
    mv "/etc/arkmanager" "${ARK_TOOLS_DIR}"

    # Remove default config files (will be regenerated from templates)
    rm -f "${ARK_TOOLS_DIR}/arkmanager.cfg" "${ARK_TOOLS_DIR}/instances/main.cfg"

    echo "ARK tools directory initialized successfully"
fi

# Set ownership of ARK tools directory
echo "Setting ownership of ${ARK_TOOLS_DIR} to ${STEAM_USER}"
if ! chown -R "${STEAM_USER}". "${ARK_TOOLS_DIR}"; then
    echo "WARNING: Failed to set ownership on ${ARK_TOOLS_DIR}, continuing startup..."
fi

# ===============================================================================
# SYMLINK MANAGEMENT
# ===============================================================================

# Create symlink for arkmanager configuration
echo "Creating symlink from ${ARK_TOOLS_DIR} to /etc/arkmanager"
rm -rf "/etc/arkmanager"
ln -s "${ARK_TOOLS_DIR}" "/etc/arkmanager"

# ===============================================================================
# SERVICE INITIALIZATION
# ===============================================================================

# Start cron service for scheduled tasks
echo "Starting cron service for scheduled tasks"
service cron start

# ===============================================================================
# STARTUP SUMMARY
# ===============================================================================

echo "==============================================================================="
echo "ARK Server Docker Container Initialization Complete"
echo "==============================================================================="
echo "ARK Server Volume: ${ARK_SERVER_VOLUME}"
echo "ARK Tools Directory: ${ARK_TOOLS_DIR}"
echo "Steam User: ${STEAM_USER}"
echo "Debug Mode: ${DEBUG:-false}"
echo "==============================================================================="

# ===============================================================================
# HANDOFF TO STEAM ENTRYPOINT
# ===============================================================================

# Execute the steam entrypoint script as the steam user
echo "Handing off to steam entrypoint script..."
exec gosu "${STEAM_USER}" /steam-entrypoint.sh "$@"
