FROM jenkins/jenkins:2.289.1-lts-alpine

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

COPY jcasc/ /var/jenkins_home/casc_configs

ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc_configs
CMD ["--httpPort=4040"]
