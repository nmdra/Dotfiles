#!/bin/sh

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO=/run/media/nimendra/75DB-97E6/Backup

# See the section "Passphrase notes" for more infos.
export BORG_PASSPHRASE='nimendraBackup'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                                 \
    --verbose                               \
    --filter AME                            \
    --progress                              \
    --stats                                 \
    --show-rc                               \
    --compression zstd,11                   \
    --exclude-caches                        \
    --exclude '/home/nimendra/.cache/*'     \
    --exclude '/home/nimendra/Videos/*'       \
    --exclude '/home/nimendra/Downloads/Torrent/*'    \
    --exclude '/home/nimendra/Documents/Y2S1/*' \
    --exclude '/home/nimendra/Desktop/*'    \
    --exclude '/home/nimendra/Music/*'      \
                                            \
    ::'{hostname}-{now}'                    \
    /home/nimendra/

backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-*' matching is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --glob-archives '{hostname}-*'  \
    --show-rc                       \
    --keep-daily    1               \
    --keep-weekly   1               \
    --keep-monthly  1

prune_exit=$?

# actually free repo disk space by compacting segments

info "Compacting repository"

borg compact

compact_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup, Prune, and/or Compact finished with warnings"
else
    info "Backup, Prune, and/or Compact finished with errors"
fi

exit ${global_exit}
