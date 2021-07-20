FROM        node:12-alpine
LABEL       maintainer="Martin Paserba <info@itmp.sk>"

ARG         CRONICLE_VERSION='0.8.54'

# Docker defaults
ENV        CRONICLE_base_app_url 'http://localhost:3012'
ENV        CRONICLE_WebServer__http_port 3012
ENV        CRONICLE_WebServer__https_port 443
ENV        CRONICLE_web_socket_use_hostnames 1
ENV        CRONICLE_server_comm_use_hostnames 1
ENV        CRONICLE_web_direct_connect 0
ENV        CRONICLE_job_data_expire_days 30
#ENV        CRONICLE_socket_io_transports '["polling", "websocket"]'
ENV        TZ Europe/Bratislava

RUN         apk add --no-cache jq git curl wget perl bash perl-pathtools tar procps tzdata

RUN         adduser cronicle -D -h /opt/cronicle

WORKDIR     /opt/cronicle/

RUN         curl -L https://github.com/jhuckaby/Cronicle/archive/v${CRONICLE_VERSION}.tar.gz | tar zxvf - --strip-components 1 && \
             npm install && \
             node bin/build.js dist

EXPOSE      3012

ADD         entrypoint.sh /opt/cronicle/entrypoint.sh

RUN         chmod +x /opt/cronicle/entrypoint.sh

# data volume is also configured in entrypoint.sh
VOLUME      ["/opt/cronicle/data", "/opt/cronicle/logs", "/opt/cronicle/plugins"]

ENTRYPOINT  ["/opt/cronicle/entrypoint.sh"]

CMD         ["sh", "-c", "node /opt/cronicle/lib/main.js"]

