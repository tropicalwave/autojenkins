#!/bin/sh
set -e

sed "s/\$KEYCLOAK_JENKINS_SECRET/$KEYCLOAK_JENKINS_SECRET/;s/\$KEYCLOAK_GITEA_SECRET/$KEYCLOAK_GITEA_SECRET/;s/\$LDAP_BIND_CREDENTIAL/$LDAP_BIND_CREDENTIAL/" /opt/ci/ci-realm.json >/tmp/ci-realm.json
exec /opt/keycloak/bin/kc.sh
