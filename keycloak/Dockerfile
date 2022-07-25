FROM quay.io/keycloak/keycloak:16.1.0
COPY ci/ /opt/ci
RUN mkdir /opt/jboss/keycloak/themes/custom/ && \
    cp -r /opt/jboss/keycloak/themes/keycloak/login/ /opt/jboss/keycloak/themes/custom/
COPY register.ftl /opt/jboss/keycloak/themes/custom/login/

ENTRYPOINT ["/opt/ci/startup.sh"]
