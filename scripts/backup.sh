#!/bin/sh

HOME="/home/zeroring"
ARCHIVE_DIR="${HOME}/backup"
HOMELAB_DIR="${HOME}/HomeLab"
WARDEN_DATA="${HOMELAB_DIR}/bw-data"
WARDEN_TMP="${WARDEN_DATA}/tmp"

RCLONE_CONF="${HOMELAB_DIR}/configs/rclone.conf"
BACKUP_FILE="bitwarden_$(date "+%F-%H%M%S")"

mkdir -p "${ARCHIVE_DIR}"
rm -rf "${WARDEN_TMP}"
mkdir -p "${WARDEN_TMP}"

sqlite3 "${WARDEN_DATA}/db.sqlite3" ".backup '${WARDEN_TMP}/db.sqlite3'"
cp -r "${WARDEN_DATA}/attachments" "${WARDEN_TMP}/attachments"

tar -czf "${ARCHIVE_DIR}/${BACKUP_FILE}.tar.gz" "${WARDEN_TMP}"
# | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:${BACKUP_ENCRYPTION_KEY} -out /tmp/${BACKUP_FILE}.tar.gz
rm -rf "${WARDEN_TMP}"
find "${ARCHIVE_DIR}" -name 'bitwarden-*.tar.*' -mtime +14 -delete
#
rclone --config "${RCLONE_CONF}" sync "${ARCHIVE_DIR}" dr:/Apps/LSync/backups/homelab
