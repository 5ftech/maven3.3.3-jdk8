FROM ubuntu:14.04

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ADD local /var/lib/locales/supported.d/local
RUN locale-gen --purge
ADD locale /etc/default/locale


RUN mkdir -p /usr/share/java
WORKDIR /usr/share/java
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN wget http://wufan.oss-cn-qingdao.aliyuncs.com/server/jdk-8u11-linux-x64.tar.gz
RUN tar -zxvf jdk-8u11-linux-x64.tar.gz

ENV JAVA_HOME /usr/share/java/jdk1.8.0_11
ENV JRE_HOME /usr/share/java/jdk1.8.0_11/jre
ENV CLASSPATH .:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV PATH ${JAVA_HOME}/bin:$PATH

ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"


VOLUME "$USER_HOME_DIR/.m2"

CMD ["mvn"]

