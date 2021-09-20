#!/bin/bash
#
# make zip backup of source dir (arg 1) and store it in backups dir (config var)

# read config inputs (evaluates potential vars in text, e.g.: "${HOME}/backups")
source config.shlib
eval BACKUPS_PATH="$(config_get BACKUPS_PATH)"
eval KEEP_X_LAST_BACKUPS="$(config_get KEEP_X_LAST_BACKUPS)"

# read argument (first and only) passed to this file
eval SOURCE_PATH="${1//' '/'\ '}"     # escape spaces for evaluation
SOURCE_PATH="${SOURCE_PATH//'\ '/ }"  # put spaces back in place (do not escape)

printf "\n\t'${SOURCE_PATH}':\n"

# if source path is not valid skip backup for source
if ! [[ -d "${SOURCE_PATH}" ]]; then
    printf "\t\tSKIP SOURCE: invalid source directory\n"
    exit 1
fi

# get name of source directory (strip path)
SOURCE_NAME="${SOURCE_PATH%"${SOURCE_PATH##*[!/]}"}" # trim trailing '/' chars
SOURCE_NAME="${SOURCE_NAME##*/}"  # remove everything before last '/'

# get path where zip backup for source will be stored (inside backups dir)
TARGET_PATH="${BACKUPS_PATH}/${SOURCE_NAME}/${SOURCE_NAME}_backups"

# build zip file name with time & date: '<SOURCE_NAME>-bak-yyyy-mm-ddTHH-MM.zip'
ZIP_NAME="${SOURCE_NAME}-bak-$(date +'%Y-%m-%dT%H-%M').zip"
ZIP_PATH="${TARGET_PATH}/${ZIP_NAME}"

# if backup path for source does not exist, create it
if ! [[ -d ${TARGET_PATH} ]]; then
    mkdir "${BACKUPS_PATH}/${SOURCE_NAME}"
    mkdir "${TARGET_PATH}"
    printf "\t\tCreated backup directories for '${SOURCE_NAME}'\n"
fi

# generate zip file with source contents (backup)
cd "${SOURCE_PATH}"
zip -qr "${ZIP_PATH}" ./*  # put everything in current dir into zip file
printf "\t\tCreated zip file '${ZIP_NAME}'\n"

# calculate number of excess zip files (see 'ternary operator')
cd "${TARGET_PATH}"
NUM_FILES=$(ls | wc -l)
EXCESS=$(( NUM_FILES>KEEP_X_LAST_BACKUPS ? NUM_FILES - KEEP_X_LAST_BACKUPS: 0 ))

# keep removing oldest zip file until number of files = KEEP_X_LAST_BACKUPS
for (( i = ${EXCESS}; i > 0; i-- )); do
    # find oldest file in directory
    #   1. list files in directory
    #   2. order them by modification date
    #   3. keep last line only
    #   4. keep only last 25 chars (zip suffix) and append it to SOURCE_NAME
    #       - this allows us to handle source names containing spaces
    OLDEST="${SOURCE_NAME}$(ls -lt | grep -v '^d' | tail -1 | tail -c 26)"

    # remove oldest file in directory
    rm "${OLDEST}"
    printf "\t\tRemoved zip file '${OLDEST}' (OLD)\n"
done

# write informative .txt file indicating source location
cd "${BACKUPS_PATH}/${SOURCE_NAME}"
echo "source: '${SOURCE_PATH}'" > source.txt

cd "${OWZB_WHERE}"  # TODO: move out of this file
printf "\t\t## SUCCESS ##\n"
