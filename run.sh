#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail
set -o xtrace
set -o allexport

# Set URL
sed -i "s/MYHOST/$MYHOST/g" /etc/rundeck/rundeck-config.properties

# Set admin settings
sed -i "s/RDPASS/$RDPASS/g" /etc/rundeck/realm.properties

# Email settings
sed -i "s/MAILFROM/$MAILFROM/g" /etc/rundeck/rundeck-config.properties
#sed -i "s/SMTP_HOST/$SMTP_HOST/g" /etc/rundeck/rundeck-config.properties
#sed -i "s/SMTP_PORT/$SMTP_PORT/g" /etc/rundeck/rundeck-config.properties
#sed -i "s/SMTP_USERNAME/$SMTP_USERNAME/g" /etc/rundeck/rundeck-config.properties
#sed -i "s/SMTP_PASSWORD/$SMTP_PASSWORD/g" /etc/rundeck/rundeck-config.properties
#sed -i "s/SMTP_PROPS/$SMTP_PROPS/g" /etc/rundeck/rundeck-config.properties

# Set LDAP or normal auth
if [ -n "${LDAP_CONFIG_PATH+1}" ]; then
  export JAAS_CONF=$LDAP_CONFIG_PATH
  export LOGIN_MODULE=ldap
fi

# Setup MySQL backend
sed -i "s/^dataSource.url = .*$/dataSource.url = jdbc:mysql:\/\/$MYSQL_HOST\/$MYSQL_DB?autoReconnect=true/g" /etc/rundeck/rundeck-config.properties
echo "
dataSource.username=$MYSQL_USER
dataSource.password=$MYSQL_PASS
dataSource.driverClassName=com.mysql.jdbc.Driver

# Enables DB for Project configuration storage
rundeck.projectsStorageType=db

# Encryption for project config storage
rundeck.config.storage.converter.1.type=jasypt-encryption
rundeck.config.storage.converter.1.path=projects
rundeck.config.storage.converter.1.config.password=$SECRET

# Enable DB for Key Storage
rundeck.storage.provider.1.type=db
rundeck.storage.provider.1.path=keys

# Encryption for Key Storage
rundeck.storage.converter.1.type=jasypt-encryption
rundeck.storage.converter.1.path=keys
rundeck.storage.converter.1.config.password=$SECRET
" >> /etc/rundeck/rundeck-config.properties

chown -R rundeck /etc/rundeck
chown -R rundeck /var/lib/rundeck
chown -R rundeck /var/log/rundeck
chown -R rundeck /var/lib/rundeck/.ssh
chmod 700 /var/lib/rundeck/.ssh
chown -R rundeck /var/rundeck/projects
/etc/init.d/rundeckd start
