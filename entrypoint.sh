#!/bin/sh

ROOT_DIR=/opt/cronicle
CONF_DIR=$ROOT_DIR/conf
BIN_DIR=$ROOT_DIR/bin
LIB_DIR=$ROOT_DIR/lib
# DATA_DIR needs to be the same as the exposed Docker volume in Dockerfile
DATA_DIR=$ROOT_DIR/data
# PLUGINS_DIR needs to be the same as the exposed Docker volume in Dockerfile
PLUGINS_DIR=$ROOT_DIR/plugins

# The env variables below are needed for Docker and cannot be overwritten
export CRONICLE_Storage__Filesystem__base_dir=${DATA_DIR}
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
export CRONICLE_echo=1
export CRONICLE_foreground=1

# Only run setup when setup needs to be done
if [ ! -f $DATA_DIR/.setup_done ]
then

  chown -R cronicle:cronicle /opt/cronicle/

  $BIN_DIR/control.sh setup

  cp $CONF_DIR/config.json $CONF_DIR/config.json.origin

  mkdir -p $PLUGINS_DIR

  touch $DATA_DIR/.setup_done

fi

if [ -f $DATA_DIR/config.json.import ]
then

  chown -R cronicle:cronicle $CONF_DIR

  # Move in custom configuration
  cp $DATA_DIR/config.json.import $CONF_DIR/config.json
fi

# Run cronicle
exec "$@"