#!/bin/bash
# Script for backup folder and file

# Parent backup directory
BACKUP_PARENT_DIR=""

# Backup settings
SOURCE=""

# Create backup directory and set permissions
DATE=`date +%Y_%m_%d`
NOW=`date +%Y-%m-%d_%H-%M-%S`
BACKUP_DIR="${BACKUP_PARENT_DIR}/${DATE}"
echo "Backup directory: ${BACKUP_DIR}"
mkdir -p "${BACKUP_DIR}"
chmod 700 "${BACKUP_DIR}"

# Get list script then backup and compress
GET_SCRIPT=`ls $SOURCE`
for SCRIPT in $GET_SCRIPT
do
	cd $SOURCE
	echo "Creating backup of \"${SCRIPT}\" script"
	tar czf ${BACKUP_DIR}/${SCRIPT}.${NOW}.tar.gz $SCRIPT
	chmod 600 "${BACKUP_DIR}/${SCRIPT}.${NOW}.tar.gz"
done
