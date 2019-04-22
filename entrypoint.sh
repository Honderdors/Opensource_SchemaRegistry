#!/usr/bin/env bash
/usr/lib/postgresql/9.6/bin/pg_ctl -w start -D /var/lib/postgresql/9.6/main -c config_file=/etc/postgresql/9.6/main/postgresql.conf 
mv /opt/hortonworks-registry/conf/registry-postgres-example.yaml /opt/hortonworks-registry/conf/registry.yaml
/opt/hortonworks-registry/bootstrap/bootstrap-storage.sh drop 
/opt/hortonworks-registry/bootstrap/bootstrap-storage.sh create 
exec "$@"
