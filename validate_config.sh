#!/bin/bash
#
# make sure values in config files are valid

# move to directory that contains the current script (env. variable)
cd "${QSB_WHERE}"

# read config values using functions in library 'config.shlib'
# evaluates potential variables included in text (e.g.: "${HOME}/backups")
source config.shlib
eval BACKUPS_PATH="$(config_get BACKUPS_PATH)"
eval KEEP_X_LAST_BACKUPS="$(config_get KEEP_X_LAST_BACKUPS)"

# validate BACKUPS_PATH
mkdir -p "${BACKUPS_PATH}"  # tries to create directory in case it doesn't exist
if ! [[ -d "${BACKUPS_PATH}" ]]; then
    echo "ERROR: invalid backups directory '${BACKUPS_PATH}'"
    exit 1
fi

# ensure KEEP_X_LAST_BACKUPS is an integer
if ! [[ ${KEEP_X_LAST_BACKUPS} =~ ^[0-9]+$ ]]; then
    echo "Invalid value for KEEP_X_LAST_BACKUPS: '${KEEP_X_LAST_BACKUPS}'"
    echo "ERROR: KEEP_X_LAST_BACKUPS must be an integer"
    exit 1
fi

# ensure KEEP_X_LAST_BACKUPS is an integer betwen 1 and 25 (both inclusive)
if ! (( ${KEEP_X_LAST_BACKUPS} >= 1 && ${KEEP_X_LAST_BACKUPS} <= 25 )); then
    echo "Invalid value for KEEP_X_LAST_BACKUPS: '${KEEP_X_LAST_BACKUPS}'"
    echo "ERROR: KEEP_X_LAST_BACKUPS must be an integer between 1 and 25"
    exit 1
fi
