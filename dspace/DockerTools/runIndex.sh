#!/bin/sh
# Once this file has been saved to a docker volume, the ingest step will not be re-run
#CHECKFILE=/dspace/assetstore/ingest.hasrun.flag

# The following variable allows a default memory allocation to be set independently of other
# JAVA_OPT Options
JAVA_MEM=${JAVA_MEM:--Xmx2500m}
export JAVA_OPTS="${JAVA_OPTS} ${JAVA_MEM} -Dupload.temp.dir=/dspace/upload -Djava.io.tmpdir=/tmp"

# Overwrite local.cfg for DSpace 6
# __D__ -> -
# __P__ -> .
###env | egrep "__.*=" | egrep -v "=.*__" | sed -e s/__P__/\./g | sed -e s/__D__/-/g > /dspace/config/local.cfg
### we have the local.cfg copyed over from dspace/src/main/docker/local.cfg; we don't have to overwrite it FROM
### compose file
# run index
#/dspace/bin/dspace index-discovery -fb
touch /dspace/solr/search/conf/reindex.flag

sleep ${DBWAIT:-0}
catalina.sh run
