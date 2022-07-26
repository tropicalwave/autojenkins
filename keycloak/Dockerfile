FROM quay.io/keycloak/keycloak:18.0.2
USER root
RUN microdnf install unzip -y && \
    microdnf clean all
USER keycloak
RUN mkdir /opt/keycloak/themes/custom/ && \
    mkdir /tmp/tmp && \
    cd /tmp/tmp && \
    unzip /opt/keycloak/lib/lib/main/org.keycloak.keycloak-themes-18.0.2.jar && \
    cp -r /tmp/tmp/theme/keycloak/login/ /opt/keycloak/themes/custom/ && \
    cd .. && \
    rm -rf /tmp/tmp

COPY ci/ci-realm.json /opt/keycloak/data/import/
COPY register.ftl /opt/keycloak/themes/custom/login/
RUN /opt/keycloak/bin/kc.sh build --db=postgres

ENTRYPOINT ["/opt/keycloak/bin/kc.sh","start","--import-realm"]
