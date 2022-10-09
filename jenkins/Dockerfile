FROM jenkins/jenkins:2.361.2-lts-alpine

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

COPY jcasc/ /var/jenkins_home/casc_configs

ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc_configs
CMD ["--httpPort=4040"]
