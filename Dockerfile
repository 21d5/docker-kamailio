FROM debian:stretch-slim
LABEL maintainer "Eric Yan <docker@ericyan.me>"

# https://bugs.debian.org/830696 (apt uses gpgv by default in newer releases)
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 dirmngr

RUN set -x \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-key FB40D3E6508EA4C8 \
    && echo "deb http://deb.kamailio.org/kamailio50 stretch main" \
        > /etc/apt/sources.list.d/kamailio.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        kamailio \
        kamailio-tls-modules \
        kamailio-presence-modules \
    && rm -rf /var/lib/apt/lists/*

COPY conf /etc/kamailio/

ENV SHM_MEMORY=64 \
    PKG_MEMORY=8

EXPOSE 5060/tcp 5060/udp

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["kamailio"]
