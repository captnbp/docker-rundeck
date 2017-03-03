#!/bin/bash

dpkg -i /tmp/rundeck.deb
rm -f /tmp/rundeck.deb
chown -R rundeck /etc/rundeck
chmod 4755 /usr/bin/sudo	# no suid bit was set for sudo!?

# Modify init script to force it to run in the foreground (more
# Docker-friendly)
sed -i 's/&>>\/var\/log\/rundeck\/service.log &$//g' /etc/init.d/rundeckd

## remove the grails.serverURL so that absolute URLs aren't generated
# (this is needed for things like sending email:)
#sed -i '/grails.serverURL/d' /etc/rundeck/rundeck-config.properties

sed -i "s/^admin:admin/admin: $RDPASS/g" /etc/rundeck/realm.properties
sed -i "s/http:\/\/localhost:4440/https:\/\/$MYHOST/g" /etc/rundeck/rundeck-config.properties

sed -i "s,/etc/rundeck/jaas-loginmodule.conf,AUTH_LOGIN_CONFIG,g" /etc/rundeck/profile
sed -i "s/RDpropertyfilelogin/LOGINMODULE_NAME/g" /etc/rundeck/profile

echo "grails.mail.default.from=MAILFROM" >> /etc/rundeck/rundeck-config.properties
#echo "grails.mail.host=SMTP_HOST" >> /etc/rundeck/rundeck-config.properties
#echo "grails.mail.port=SMTP_PORT" >> /etc/rundeck/rundeck-config.properties
#echo "grails.mail.username=SMTP_USERNAME" >> /etc/rundeck/rundeck-config.properties
#echo "grails.mail.password=SMTP_PASSWORD" >> /etc/rundeck/rundeck-config.properties
#echo "grails.mail.props=SMTP_PROPS" >> /etc/rundeck/rundeck-config.properties
