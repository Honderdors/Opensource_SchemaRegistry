#!/usr/bin/env bash 
mv /opt/hortonworks-registry/conf/registry-postgres-example.yaml /opt/hortonworks-registry/conf/registry.yaml
/opt/hortonworks-registry/bootstrap/bootstrap-storage.sh drop 
/opt/hortonworks-registry/bootstrap/bootstrap-storage.sh create 
exec "$@"
