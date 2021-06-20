#!/bin/sh
set -e

# Check that the base register.ftl did not change; otherwise
# we might break the registration form
if [ ! "$(md5sum /opt/jboss/keycloak/themes/base/login/register.ftl | awk '{ print $1 }')" = "8b033ba7b85d7f89293579f54bb40e73" ]; then
    echo 'Provided register.ftl changed.'
    exit 1
fi

sed "s/\$KEYCLOAK_JENKINS_SECRET/$KEYCLOAK_JENKINS_SECRET/;s/\$KEYCLOAK_GITEA_SECRET/$KEYCLOAK_GITEA_SECRET/;s/\$LDAP_BIND_CREDENTIAL/$LDAP_BIND_CREDENTIAL/" /opt/ci/ci-realm.json >/tmp/ci-realm.json
exec /opt/jboss/tools/docker-entrypoint.sh -b 0.0.0.0
