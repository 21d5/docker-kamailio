FROM debian:stretch-slim
LABEL maintainer "Eric Yan <docker@ericyan.me>"

# https://bugs.debian.org/830696 (apt uses gpgv by default in newer releases)
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 dirmngr

RUN set -x \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-key FB40D3E6508EA4C8 \
    && echo "deb http://deb.kamailio.org/kamailio50 stretch main" \
        > /etc/apt/sources.list.d/kamailio.list \
    && apt-get update \
    && mkdir -p /usr/share/man/man1/ /usr/share/man/man7/ \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        kamailio \
        kamailio-tls-modules \
        kamailio-postgres-modules \
        kamailio-presence-modules \
    && rm -rf /var/lib/apt/lists/* /usr/share/man/*

COPY conf /etc/kamailio/

ENV SHM_MEMORY=64 \
    PKG_MEMORY=8 \
    DEF_PSTN_GW_IP="" \
    DEF_PSTN_GW_PORT=5060 \
    DEF_PSTN_REGEX="^(\+|00)[1-9][0-9]{3,20}$" \
    DEF_VOICEMAIL_SRV_IP="" \
    DEF_VOICEMAIL_SRV_PORT=5060

EXPOSE 5060/tcp 5060/udp

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["kamailio"]
