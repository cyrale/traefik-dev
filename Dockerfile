FROM alpine:3.6

# Set environment
ENV SERVICE_NAME=traefik \
    SERVICE_HOME=/opt/traefik \
    SERVICE_VERSION=v1.3.2 \
    SERVICE_URL=https://github.com/containous/traefik/releases/download
ENV SERVICE_RELEASE=${SERVICE_URL}/${SERVICE_VERSION}/traefik_linux-amd64 \
    PATH=${PATH}:${SERVICE_HOME}/bin

ADD ./root/etc/supervisor.d/* /etc/supervisor.d/
ADD ./root/opt/traefik/etc/* /opt/traefik/etc/

RUN mkdir -p ${SERVICE_HOME}/bin ${SERVICE_HOME}/etc ${SERVICE_HOME}/log ${SERVICE_HOME}/certs ${SERVICE_HOME}/acme && \
    apk update && \
    apk --no-cache add bash curl dnsmasq supervisor && \
    cd ${SERVICE_HOME}/bin && \
    curl -jksSL "${SERVICE_RELEASE}" -O && \
    mv traefik_linux-amd64 traefik && \
    touch ${SERVICE_HOME}/etc/rules.toml && \
    chmod +x ${SERVICE_HOME}/bin/traefik && \
    apk del curl

EXPOSE 53 53/udp 80 443 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
