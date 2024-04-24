# checkov:skip=CKV_DOCKER_2:healthcheck not enabled
# checkov:skip=CKV_DOCKER_3:no user necessary
ARG VERSION
FROM jenkins/jenkins:$VERSION

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

COPY jcasc/ /var/jenkins_home/casc_configs

ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc_configs
CMD ["--httpPort=4040"]
