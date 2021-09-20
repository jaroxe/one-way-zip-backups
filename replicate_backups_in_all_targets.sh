#!/bin/bash
#
# replicate backups dir (config val) in all targets in 'additional_targets.txt'

# move to directory that contains the current script (env. variable)
cd "${OWZB_WHERE}"

# read from config (evaluates potential vars in text, e.g.: "${HOME}/backups")
source config.shlib
eval BACKUPS_PATH="$(config_get BACKUPS_PATH)"

# indicate start of back up process in stdout
printf "\nReplicating directory '${BACKUPS_PATH}' in:\n"

# remove any blank lines in 'additional_targets.txt'
grep "\S" additional_targets.txt > additional_targets_.txt
cat additional_targets_.txt > additional_targets.txt
rm additional_targets_.txt

# count number of targets in 'additional_targets.txt'
NUM_TARGETS=$(wc -l additional_targets.txt | awk '{ print $1 }')

# if 0 additional targets, skip backups replication
if [[ $NUM_TARGETS = 0 ]]; then
    printf "\tNOWHERE TO REPLICATE: file 'additional_targets.txt' is empty\n\n"
    exit 1
fi

# write newline division and backups source to replications.log (in backups dir)
source config.shlib
eval BACKUPS_PATH="$(config_get BACKUPS_PATH)"
printf "\n\nSOURCE: '${BACKUPS_PATH}'" >> "${BACKUPS_PATH}/replications.log"

# for each target, replicate backups directory
for (( i = 1; i <= ${NUM_TARGETS}; i++ )); do
    TRG=$(sed "${i}q;d" additional_targets.txt)
    sh replicate_backups_in_one_target.sh "${TRG}"
done

printf "\n"
