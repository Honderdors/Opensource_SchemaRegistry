#!/usr/bin/env bash 
envsubst < /opt/hortonworks-registry/conf/registry.yaml.template > /opt/hortonworks-registry/conf/registry.yaml 
/opt/hortonworks-registry/bootstrap/bootstrap-storage.sh drop 
/opt/hortonworks-registry/bootstrap/bootstrap-storage.sh create 
exec "$@"
