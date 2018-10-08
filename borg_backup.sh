#!/bin/bash

CONFIG=/etc/local/borg_config.sh

if [ ! -f "$CONFIG" ]; then
    echo "Configuration file $CONFIG is missing. Set following env variables in that script:"
    echo "BORG_REPO"
    echo "BORG_PASSPHRASE"
    echo "BACKUP_DIRS"
    echo "EXCLUDE"
    exit 1
fi

chmod 600 "$CONFIG"

. "$CONFIG"

if [ -z "$BORG_REPO" ]; then
    echo "Variable BORG_REPO is missing or unset in $CONFIG. Configure it and rerun this script."
    exit 1
fi

if [ -z "$BORG_PASSPHRASE" ]; then
    echo "Variable BORG_PASSPHRASE is missing or unset in $CONFIG. Configure it and rerun this script."
    exit 1
fi

if [ -z "$BACKUP_DIRS" ]; then
    echo "Variable BACKUP_DIRS (folders to back up) is missing or unset in $CONFIG. Configure it and rerun this script."
    exit 1
fi

export BORG_REPO="$BORG_REPO"
export BORG_PASSPHRASE="$BORG_PASSPHRASE"
export BACKUP_DIRS="$BACKUP_DIRS"

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"


borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression zstd,10           \
    --exclude-caches                \
    --exclude '/home/*/.cache/*'    \
    --exclude '/var/cache/*'        \
    --exclude '/var/tmp/*'          \
    $(echo "$EXCLUDE" | while read x; do echo "--exclude $x   \"; done)
    ::'{hostname}-{now}'            \
    $(echo "$BACKUP_DIRS" | tr -s ' ' '\n')

backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --prefix '{hostname}-'          \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 1 ];
then
    info "Backup and/or Prune finished with a warning"
fi

if [ ${global_exit} -gt 1 ];
then
    info "Backup and/or Prune finished with an error"
fi

exit ${global_exit}