FROM honderdors/opensource

LABEL Java="OpenJDK 11"
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE
# need backports for openjdk 11 package:
RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list && apt-get update
ENV JAVA_VERSION 11.0.1
ENV JAVA_DEBIAN_VERSION 11.0.1+13-2~bpo9+1

RUN apt-get install -y wget unzip openjdk-11-jre postgresql-9.6

RUN groupadd -r hortonworks && useradd --no-log-init -r -g hortonworks hortonworks && \
    mkdir -p /opt/ && wget -O /opt/hortonworks-registry-0.7.0.zip https://github.com/hortonworks/registry/releases/download/v0.7.0/hortonworks-registry-0.7.0.zip && \
    unzip /opt/hortonworks-registry-0.7.0.zip -d /opt && chown -R hortonworks:hortonworks /opt/hortonworks-registry-0.7.0 && rm /opt/hortonworks-registry-0.7.0.zip && ln -s /opt/hortonworks-registry-0.7.0 /opt/hortonworks-registry

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.6/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.6/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.6/main/postgresql.conf

# Expose the PostgreSQL port
#EXPOSE 5432

COPY entrypoint.sh /opt/hortonworks-registry/entrypoint.sh
RUN chmod +x /opt/hortonworks-registry/entrypoint.sh && chown -R hortonworks:hortonworks /opt/hortonworks-registry-0.7.0
ENV DB_DATABASE=schema_registry
ENV DB_USER=postgres
ENV DB_PASS=postgres
ENV DB_HOST=localhost
ENV DB_PORT=5432
EXPOSE 9090
EXPOSE 9091

USER hortonworks
WORKDIR /opt/hortonworks-registry
ENTRYPOINT ["./entrypoint.sh"]
CMD ["./bin/registry-server-start.sh" "./conf/registry.yaml"]