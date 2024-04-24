# checkov:skip=CKV_DOCKER_2:healthcheck not enabled
# checkov:skip=CKV_DOCKER_3:no user necessary
ARG VERSION
FROM gitea/gitea:$VERSION

COPY userinit/finish.sh /etc/s6/userinit/finish
COPY userinit/run.sh /etc/s6/userinit/run
COPY userinit/setup.sh /etc/s6/userinit/setup
