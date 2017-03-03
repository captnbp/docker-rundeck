This image on the [Docker Hub](https://registry.hub.docker.com/u/x110dc/rundeck/) so running it can be as
simple as:
```
docker run --detach=true --publish=4440:4440 --name=rundeck \
  --env MYHOST=foo.com \
  --env RDPASS=mypassword \
  --env MAILFROM=foo@bar.baz \
  --env SECRET=MegaEncryptionSecretToChange \
  --env MYSQL_HOST=rundeck-mysql \
  --env MYSQL_USER=rundeck \
  --env MYSQL_PASS=rundeck_pass \
  docker-registry.sandbdigital.com/docker-rundeck
```

## Configuration

* Use LDAP for authentication: `-v /path/to/jaas-ldap.conf:/etc/rundeck/jaas-ldap.conf -e LDAP_CONFIG_PATH=/etc/rundeck/jaas-ldap.conf`
* Supply a custom `admin.aclpolicy`: `-v /path/to/policy/on/host.aclpolicy:/etc/rundeck/admin.aclpolicy`
* Setup DatadogHQ notifications: https://github.com/inokappa/rundeck-datadog_event-notification-plugin

### Rundeck Datadog Notification Plugin

#### Configuration

The plugin requires one configuration entry.

* subject: This string will be set as the description for the generated incident.
* api_key: This is the API Key to your Datadog API.

Configure the api_key in your project configuration by
adding an entry like so: $RDECK_BASE/projects/{project}/etc/project.properties

```sh
project.plugin.Notification.DatadogEventNotification.api_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Or configure it at the instance level: $RDECK_BASE/etc/framework.properties

```sh
framework.plugin.Notification.DatadogEventNotification.api_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
