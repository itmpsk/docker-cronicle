FROM       node:12-alpine
LABEL      maintainer="Martin Paserba <info@itmp.sk>"

ARG        CRONICLE_VERSION='0.8.54'

# Docker defaults
ENV        CRONICLE_base_app_url 'http://localhost:3012'
ENV        CRONICLE_WebServer__http_port 3012
ENV        CRONICLE_WebServer__https_port 443

RUN        apk add --no-cache git curl wget perl bash perl-pathtools tar \
             procps tini

RUN        adduser cronicle -D -h /opt/cronicle

WORKDIR    /opt/cronicle/

RUN        curl -L https://github.com/jhuckaby/Cronicle/archive/v${CRONICLE_VERSION}.tar.gz | tar zxvf - --strip-components 1 && \
             npm install && \
             node bin/build.js dist

EXPOSE     3012

ADD        entrypoint.sh /opt/cronicle/entrypoint.sh

RUN        chmod +x /opt/cronicle/entrypoint.sh

# data volume is also configured in entrypoint.sh
VOLUME     ["/opt/cronicle/data", "/opt/cronicle/logs", "/opt/cronicle/plugins"]

ENTRYPOINT ["/opt/cronicle/entrypoint.sh"]

CMD        ["sh", "-c", "$BIN_DIR/control.sh start"]

