# checkov:skip=CKV_DOCKER_2:healthcheck not enabled
# checkov:skip=CKV_DOCKER_3:no user necessary
ARG FEDORA_VERSION
FROM fedora:$FEDORA_VERSION

RUN dnf install -y openssh-server \
    java-latest-openjdk-headless \
    procps-ng \
    findutils \
    git-core \
    gcc && \
    dnf clean all && \
    ssh-keygen -A && \
    useradd jenkins
COPY ssh/test-key.pub /home/jenkins/.ssh/authorized_keys
RUN chown jenkins:jenkins /home/jenkins/.ssh/authorized_keys

# checkov:skip=CKV_DOCKER_1:SSH port exposed intentionally
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
