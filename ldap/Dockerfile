# checkov:skip=CKV_DOCKER_2:healthcheck not enabled
# checkov:skip=CKV_DOCKER_3:no user necessary
FROM osixia/openldap:1.5.0
COPY init/ /tmp/ldifs/
COPY *.ldif /tmp/
