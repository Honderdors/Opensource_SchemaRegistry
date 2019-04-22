FROM honderdors/opensource

LABEL Java="OpenJDK 11"
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE
# need backports for openjdk 11 package:
RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list && apt-get update
ENV JAVA_VERSION 11.0.1
ENV JAVA_DEBIAN_VERSION 11.0.1+13-2~bpo9+1

RUN apt-get install -y wget unzip openjdk-11-jre

RUN groupadd -r hortonworks && useradd --no-log-init -r -g hortonworks hortonworks && \
    mkdir -p /opt/ && wget -O /opt/hortonworks-registry-0.7.0.zip https://github.com/hortonworks/registry/releases/download/v0.7.0/hortonworks-registry-0.7.0.zip && \
    unzip /opt/hortonworks-registry-0.7.0.zip -d /opt && chown -R hortonworks:hortonworks /opt/hortonworks-registry-0.7.0 && rm /opt/hortonworks-registry-0.7.0.zip && ln -s /opt/hortonworks-registry-0.7.0 /opt/hortonworks-registry


COPY entrypoint.sh /opt/hortonworks-registry/entrypoint.sh
RUN chmod +x /opt/hortonworks-registry/entrypoint.sh && chown -R hortonworks:hortonworks /opt/hortonworks-registry-0.7.0
ENV DB_DATABASE=schema_registry
ENV DB_USER=registry_user
ENV DB_PASS=registry_password
ENV DB_HOST=localhost
ENV DB_PORT=3306
EXPOSE 9090
EXPOSE 9091



#RUN  mv /opt/hortonworks-registry/conf/registry.yaml.template  /opt/hortonworks-registry/conf/registry.yaml
#RUN /opt/hortonworks-registry/bootstrap/bootstrap-storage.sh drop && /opt/hortonworks-registry/bootstrap/bootstrap-storage.sh create

WORKDIR /opt/hortonworks-registry
USER hortonworks
ENTRYPOINT ["./entrypoint.sh"]
CMD ["./bin/registry-server-start.sh" "./conf/registry.yaml"]