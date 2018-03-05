#
# Scala and sbt Dockerfile 
#
# Pull base image 

FROM ubuntu:16.04 

RUN apt-get update

RUN apt-get -y install openjdk-8-jdk


RUN apt-get update
RUN apt-get -y install curl

# Env variables 

ENV SCALA_VERSION 2.12.4 
ENV SBT_VERSION 1.1.1 

# Scala expects this file 
# RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala 
## Piping curl directly in tar 
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc
# Install sbt 
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

ENV PROJECT_HOME /root
ENV PROJECT_NAME play-scala-seed

COPY ${PROJECT_NAME} ${PROJECT_HOME}/${PROJECT_NAME}
RUN \
  cd $PROJECT_HOME/$PROJECT_NAME && \
  sbt compile

# Define working directory
WORKDIR /root
