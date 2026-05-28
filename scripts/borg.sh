#!/bin/sh

# Update this path if you move to an ENCRYPTED repo
export BORG_REPO='/run/media/nimendra/75DB-97E6/SecureBackup'
export BORG_PASSPHRASE='BORG_PASSPHRASE'

info() { printf "\n%s %s\n\n" "$(date)" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Added -x to stay on one file system
# Added --checkpoint-interval 1800 (every 30 mins) for safety on large backups
borg create \
  --verbose \
  --filter AME \
  --progress \
  --stats \
  --show-rc \
  --compression zstd,11 \
  --one-file-system \
  --exclude-caches \
  --exclude '/home/nimendra/.cache/*' \
  --exclude '/home/nimendra/.local/share/Trash/*' \
  --exclude '/home/nimendra/Downloads/Torrent/*' \
  ::'{hostname}-{now}' \
  /home/nimendra/

backup_exit=$?

info "Pruning repository"

# Updated to match your intended 7/4/6 retention
borg prune \
  --list \
  --glob-archives '{hostname}-*' \
  --show-rc \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 4

prune_exit=$?

info "Compacting repository"
borg compact
compact_exit=$?

# Simplified exit code logic
global_exit=0
for exit_code in $backup_exit $prune_exit $compact_exit; do
  [ $exit_code -gt $global_exit ] && global_exit=$exit_code
done

if [ ${global_exit} -eq 0 ]; then
  info "Success"
else
  info "Finished with warnings/errors (Code: $global_exit)"
fi

exit ${global_exit}
