FROM honderdors/opensource
LABEL Java="OpenJDK 11"
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE
# need backports for openjdk 11 package:
RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list && apt-get update
ENV JAVA_VERSION 11.0.1
ENV JAVA_DEBIAN_VERSION 11.0.1+13-2~bpo9+1

RUN apt-get install -y wget unzip openjdk-11-jre
