FROM jenkins/jenkins:lts-jdk17

USER root

# Instalar Maven
ARG MAVEN_VERSION=3.9.6
ARG MAVEN_HOME=/opt/maven

RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | tar -xz -C /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION} ${MAVEN_HOME} && \
    ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME=${MAVEN_HOME}
ENV PATH=${MAVEN_HOME}/bin:${PATH}

USER jenkins