# checkov:skip=CKV_DOCKER_2:healthcheck not enabled
# checkov:skip=CKV_DOCKER_3:no user necessary
ARG VERSION
FROM registry.access.redhat.com/ubi9:9.5 AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
RUN dnf install --installroot /mnt/rootfs unzip --releasever 9 --setopt install_weak_deps=false --nodocs -y && \
    dnf --installroot /mnt/rootfs clean all

ARG VERSION
FROM quay.io/keycloak/keycloak:$VERSION
COPY --from=ubi-micro-build /mnt/rootfs/usr /usr
ARG VERSION
RUN mkdir /opt/keycloak/themes/custom/ && \
    mkdir /tmp/tmp && \
    cd /tmp/tmp && \
    unzip "/opt/keycloak/lib/lib/main/org.keycloak.keycloak-themes-$VERSION.jar" && \
    cp -r /tmp/tmp/theme/keycloak/login/ /opt/keycloak/themes/custom/ && \
    cd .. && \
    rm -rf /tmp/tmp

COPY ci/ci-realm.json /opt/keycloak/data/import/
COPY register.ftl /opt/keycloak/themes/custom/login/
RUN /opt/keycloak/bin/kc.sh build --db=postgres

ENTRYPOINT ["/opt/keycloak/bin/kc.sh","start-dev","--import-realm","--http-enabled=true","--hostname-strict=false"]
