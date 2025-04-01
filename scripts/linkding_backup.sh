#!/bin/bash

# Script Configuration
SHELL=/bin/bash
HOME=/home/nime
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

LOG_FILE="/home/nime/backup_log.txt"
DOCKER_CONTAINER="miniflux-db-1"
DB_NAME="linkding"
MINIFLUX_DB_NAME="miniflux"
DB_USER="miniflux"
PSQL_BACKUP_FILE="/home/nime/psql_backup.sql"
MINIFLUX_BACKUP_FILE="/home/nime/miniflux_psql_backup.sql"
LINKDING_BACKUP_FILE="/home/nime/linkding_backup.zip"
COMBINED_ARCHIVE="/home/nime/linkding_backup.tar.gz"
RCLONE_CONFIG_PATH="/home/nime/.config/rclone/rclone.conf"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] $2" | tee -a "$LOG_FILE"
}

# Cleanup function
cleanup() {
  if rm -f "$PSQL_BACKUP_FILE" "$LINKDING_BACKUP_FILE"; then
    log "SUCCESS" "Temporary backup files deleted successfully."
  else
    log "ERROR" "Failed to delete temporary backup files."
  fi
}

# Trap for cleanup
trap cleanup EXIT

log "INFO" "Starting backup process..."

# PostgreSQL Backup
log "INFO" "Starting PostgreSQL backup for database '$DB_NAME'..."
if docker exec -t "$DOCKER_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" >"$PSQL_BACKUP_FILE"; then
  log "SUCCESS" "PostgreSQL backup completed: $PSQL_BACKUP_FILE"
else
  log "ERROR" "PostgreSQL backup failed."
  exit 1
fi

log "INFO" "Starting PostgreSQL backup for database '$DB_NAME'..."
if docker exec -t "$DOCKER_CONTAINER" pg_dump -U "$DB_USER" -d "$MINIFLUX_DB_NAME" >"$MINIFLUX_BACKUP_FILE"; then
  log "SUCCESS" "PostgreSQL backup completed: $MINIFLUX_BACKUP_FILE"
else
  log "ERROR" "PostgreSQL backup failed."
  exit 1
fi

# Linkding Backup (inside Docker)
log "INFO" "Starting Docker container backup for Linkding..."
if docker exec linkding python manage.py full_backup /etc/linkding/data/backup.zip; then
  log "SUCCESS" "Linkding backup created in container."
  if docker cp linkding:/etc/linkding/data/backup.zip "$LINKDING_BACKUP_FILE"; then
    log "SUCCESS" "Linkding backup copied locally: $LINKDING_BACKUP_FILE"
  else
    log "ERROR" "Failed to copy Linkding backup from container."
    exit 1
  fi
else
  log "ERROR" "Docker container backup for Linkding failed."
  exit 1
fi

# Compress backups together
log "INFO" "Compressing backups into a single archive..."
if tar -czf "$COMBINED_ARCHIVE" -C "$(dirname "$PSQL_BACKUP_FILE")" "$(basename "$PSQL_BACKUP_FILE")" "$(basename "$LINKDING_BACKUP_FILE")"; then
  log "SUCCESS" "Backups compressed successfully: $COMBINED_ARCHIVE"
else
  log "ERROR" "Failed to compress backups."
  exit 1
fi

# Sync compressed backup to cloud storage with rclone
log "INFO" "Syncing compressed backup to cloud storage..."
if rclone --config="$RCLONE_CONFIG_PATH" copy "$COMBINED_ARCHIVE" Personal:Backup/linkding; then
  log "SUCCESS" "Backup synced successfully to cloud storage."
else
  log "ERROR" "Failed to sync backup with rclone."
  exit 1
fi

log "INFO" "Backup process completed successfully."
exit 0
