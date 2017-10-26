#!/bin/bash
# Script for backup MySQL databases

# Parent backup directory
BACKUP_PARENT_DIR=""

# MySQL settings
MyHOST=""
MyPORT=""
MyUSER=""
MyPASS=""	# use space " " if no password

# MySQL password if empty
if [ -z "${MyPASS}" ]; then
	echo -n "Enter MySQL ${MyUSER} password: "
	read -s MyPASS
	echo
fi

# Check MySQL password
echo exit | mysql --host=${MyHOST} --port=${MyPORT} --user=${MyUSER} --password=${MyPASS} -B 2>/dev/null
if [ "$?" -gt 0 ]; then
	echo "MySQL ${MyUSER} password incorrect"
	exit 1
else
	echo "MySQL ${MyUSER} password correct."
fi

# Create backup directory and set permissions
DATE=`date +%Y_%m_%d`
NOW=`date +%Y-%m-%d_%H-%M-%S`
BACKUP_DIR="${BACKUP_PARENT_DIR}/${DATE}"
echo "Backup directory: ${BACKUP_DIR}"
mkdir -p "${BACKUP_DIR}"
chmod 700 "${BACKUP_DIR}"

# Get list database then backup and compress
MYSQL_DATABASES=`echo 'show databases' | mysql --host=${MyHOST} --port=${MyPORT} --user=${MyUSER} --password=${MyPASS} -B | sed /^Database$/d`
for DATABASE in $MYSQL_DATABASES
do
	if [ "${DATABASE}" == "information_schema" ] || [ "${DATABASE}" == "performance_schema" ]; then
		ADDITIONAL_MYSQLDUMP_PARAMS="--skip-lock-tables"
	else
        ADDITIONAL_MYSQLDUMP_PARAMS=""
	fi
	echo "Creating backup of \"${DATABASE}\" database"
	mysqldump ${ADDITIONAL_MYSQLDUMP_PARAMS} --host=${MyHOST} --port=${MyPORT} --user=${MyUSER} --password=${MyPASS} ${DATABASE} | gzip > "${BACKUP_DIR}/${DATABASE}.${NOW}.gz"
	chmod 600 "${BACKUP_DIR}/${DATABASE}.${NOW}.gz"
done
