FROM fedora:34

RUN dnf install -y openssh-server \
    java-1.8.0-openjdk-headless \
    procps-ng \
    findutils \
    git-core \
    gcc && \
    dnf clean all && \
    ssh-keygen -A && \
    useradd jenkins
COPY ssh/test-key.pub /home/jenkins/.ssh/authorized_keys
RUN chown jenkins:jenkins /home/jenkins/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
