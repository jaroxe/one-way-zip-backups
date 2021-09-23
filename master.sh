#!/bin/bash
#
# back up source directories and replicate backups in target directories
#   sources: 'sources.txt'
#   targets: 'targets.txt'

# move to directory that contains the current script (env. variable)
cd "${OWZB_WHERE}"

sh validate_config.sh && (

    sh back_up_all_sources.sh
    sh replicate_backups_in_all_targets.sh

)
