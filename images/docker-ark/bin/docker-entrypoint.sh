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

# Set ownership of ARK server volume (skip if mounted volume)
echo "Setting ownership of ${ARK_SERVER_VOLUME} to ${STEAM_USER}"
if ! chown "${STEAM_USER}:${STEAM_USER}" "${ARK_SERVER_VOLUME}" 2>/dev/null; then
    echo "WARNING: Failed to set ownership on ${ARK_SERVER_VOLUME} (likely mounted volume), continuing startup..."
fi

# Ensure essential directories exist and have correct ownership
echo "Creating essential directories with proper ownership..."
create_dirs_with_ownership() {
    local dirs=(
        "${ARK_SERVER_VOLUME}/server"
        "${ARK_SERVER_VOLUME}/server/ShooterGame"
        "${ARK_SERVER_VOLUME}/server/ShooterGame/Saved"
        "${ARK_SERVER_VOLUME}/server/ShooterGame/Saved/SavedArks"
        "${ARK_SERVER_VOLUME}/server/ShooterGame/Content"
        "${ARK_SERVER_VOLUME}/server/ShooterGame/Content/Mods"
        "${ARK_SERVER_VOLUME}/server/ShooterGame/Binaries"
        "${ARK_SERVER_VOLUME}/server/ShooterGame/Binaries/Linux"
        "${ARK_SERVER_VOLUME}/log"
        "${ARK_SERVER_VOLUME}/backup"
        "${ARK_SERVER_VOLUME}/staging"
    )

    for dir in "${dirs[@]}"; do
        if [[ ! -d "${dir}" ]]; then
            mkdir -p "${dir}" 2>/dev/null || echo "WARNING: Could not create ${dir}"
        fi
        chown "${STEAM_USER}:${STEAM_USER}" "${dir}" 2>/dev/null || true
    done
}

create_dirs_with_ownership

# ===============================================================================
# ARK TOOLS CONFIGURATION
# ===============================================================================

# Initialize ARK tools directory if it doesn't exist
if [[ ! -d "${ARK_TOOLS_DIR}" ]]; then
    echo "Initializing ARK tools directory: ${ARK_TOOLS_DIR}"

    # Create the directory first
    mkdir -p "${ARK_TOOLS_DIR}"

    # Move default arkmanager config to persistent location if it exists
    if [[ -d "/etc/arkmanager" ]] && [[ ! -L "/etc/arkmanager" ]]; then
        echo "Moving /etc/arkmanager to ${ARK_TOOLS_DIR}"
        cp -r "/etc/arkmanager"/* "${ARK_TOOLS_DIR}/" 2>/dev/null || echo "WARNING: Could not copy arkmanager config files"
        rm -rf "/etc/arkmanager" 2>/dev/null || echo "WARNING: Could not remove original /etc/arkmanager"
    fi

    # Remove default config files (will be regenerated from templates)
    rm -f "${ARK_TOOLS_DIR}/arkmanager.cfg" "${ARK_TOOLS_DIR}/instances/main.cfg" 2>/dev/null || true

    echo "ARK tools directory initialized successfully"
fi

# Set ownership of ARK tools directory
echo "Setting ownership of ${ARK_TOOLS_DIR} to ${STEAM_USER}"
if ! chown -R "${STEAM_USER}:${STEAM_USER}" "${ARK_TOOLS_DIR}" 2>/dev/null; then
    echo "WARNING: Failed to set ownership on ${ARK_TOOLS_DIR}, continuing startup..."
fi

# ===============================================================================
# SYMLINK MANAGEMENT
# ===============================================================================

# Create symlink for arkmanager configuration
echo "Creating symlink from ${ARK_TOOLS_DIR} to /etc/arkmanager"
if [[ -e "/etc/arkmanager" ]] || [[ -L "/etc/arkmanager" ]]; then
    rm -rf "/etc/arkmanager" 2>/dev/null || echo "WARNING: Could not remove existing /etc/arkmanager"
fi
ln -sf "${ARK_TOOLS_DIR}" "/etc/arkmanager"

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
