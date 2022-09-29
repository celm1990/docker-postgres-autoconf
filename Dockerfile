ARG BASE_TAG
FROM docker.io/postgres:${BASE_TAG}
ARG BASE_TAG
ENTRYPOINT [ "/autoconf-entrypoint" ]
CMD []
ENV CERTS="{}" \
    CONF_EXTRA="" \
    LAN_AUTH_METHOD=md5 \
    LAN_CONNECTION=host \
    LAN_DATABASES='["all"]' \
    LAN_HBA_TPL="{connection} {db} {user} {cidr} {meth}" \
    LAN_TLS=0 \
    LAN_USERS='["all"]' \
    WAN_AUTH_METHOD=cert \
    WAN_CONNECTION=hostssl \
    WAN_DATABASES='["all"]' \
    WAN_HBA_TPL="{connection} {db} {user} {cidr} {meth}" \
    WAN_TLS=1 \
    WAN_USERS='["all"]'
RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends python3 \
    && mkdir -p /etc/postgres \
    && chmod a=rwx /etc/postgres
RUN apt-get install -y --no-install-recommends \
        python3-dev \
        postgresql-${BASE_TAG}-pldebugger \
        python3-pip \
    && pip3 install --no-cache-dir \
        netifaces
COPY autoconf-entrypoint /

# Metadata
ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.vendor=Tecnativa \
      org.label-schema.license=Apache-2.0 \
      org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.vcs-url="https://github.com/celm1990/docker-postgres-autoconf"
