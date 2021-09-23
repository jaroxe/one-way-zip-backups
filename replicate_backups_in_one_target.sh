#!/bin/bash
#
# replicate backups directory (config value) in specified location (arg 1)

# move to directory that contains the current script (env. variable)
cd "${QSB_WHERE}"

# read config inputs (evaluates potential vars in text, e.g.: "${HOME}/backups")
source config.shlib
eval BACKUPS_PATH="$(config_get BACKUPS_PATH)"

# read argument (first and only) passed to this file
eval TARGET_PATH="${1//' '/'\ '}"     # escape spaces for evaluation
TARGET_PATH="${TARGET_PATH//'\ '/ }"  # put spaces back in place (do not escape)

printf "\n\t'${TARGET_PATH}':\n"

# log attempted replication event into 'replications.log' in BACKUPS_PATH
EVENT="to '${TARGET_PATH}' @ $(date +'%Y-%m-%dT%H-%M')"
printf "\n${EVENT}" >> "${BACKUPS_PATH}/replications.log"

# if target path cannot be found skip backup replication in this target
if ! [[ -d "${TARGET_PATH}" ]]; then
    printf "\t\tSKIP TARGET: path could not be found\n"
    exit 1
fi

# replicate backups directory inside target (bytes diff only)
rsync -avq --delete "${BACKUPS_PATH}" "${TARGET_PATH}" && (

    # log SUCCESS of event to replications.log (same line as attempted event)
    printf ": ## SUCCESS ##" >> "${BACKUPS_PATH}/replications.log"

    # same to stdout
    printf "\t\t## SUCCESS ##\n"
)
