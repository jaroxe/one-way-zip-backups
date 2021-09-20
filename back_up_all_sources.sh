#!/bin/bash
#
# create zip backups for all sources in 'sources.txt'

# move to directory that contains the current script (env. variable)
cd "${OWZB_WHERE}"

# read from config (evaluates potential vars in text, e.g.: "${HOME}/backups")
source config.shlib
eval BACKUPS_PATH="$(config_get BACKUPS_PATH)"

# indicate start of back up process in stdout
printf "\nCreating backups in '${BACKUPS_PATH}':\n"

# remove any blank lines in sources.txt
grep "\S" sources.txt > sources_.txt
cat sources_.txt > sources.txt
rm sources_.txt

# count number of sources in sources.txt
NUM_SOURCES=$(wc -l sources.txt | awk '{ print $1 }')

# if 0 sources, skip backups
if [[ $NUM_SOURCES = 0 ]]; then
    printf "\tNOTHING TO BACK UP: file 'sources.txt' is empty\n"
    exit 1
fi

# for each source, run backup
for (( i = 1; i <= ${NUM_SOURCES}; i++ )); do
    SRC=$(sed "${i}q;d" sources.txt)
    sh back_up_one_source.sh "${SRC}"
done
