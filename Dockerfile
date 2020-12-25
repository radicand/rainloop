FROM alpine:latest

LABEL description "Rainloop is a simple, modern & fast web-based client" \
	maintainer="Sarek <sarek@uliweb.de>"

ARG GPG_FINGERPRINT="3B79 7ECE 694F 3B7B 70F3  11A4 ED7C 49D9 87DA 4591"
ARG UPLOAD_MAX_SIZE=25M
ARG MEMORY_LIMIT=128M

RUN echo "@community https://nl.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories \
	&& apk -U upgrade \
	&& apk add -t build-dependencies \
	gnupg \
	openssl \
	wget \
	&& apk add \
	ca-certificates \
	nginx \
	php7-fpm@community \
	php7-curl@community \
	php7-iconv@community \
	php7-xml@community \
	php7-dom@community \
	php7-openssl@community \
	php7-json@community \
	&& cd /tmp \
	&& wget -q https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip \
	&& wget -q https://www.rainloop.net/repository/webmail/rainloop-community-latest.zip.asc \
	&& wget -q https://www.rainloop.net/repository/RainLoop.asc \
	&& gpg --import RainLoop.asc \
	&& FINGERPRINT="$(LANG=C gpg --verify rainloop-community-latest.zip.asc rainloop-community-latest.zip 2>&1 \
	| sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
	&& if [ -z "${FINGERPRINT}" ]; then echo "ERROR: Invalid GPG signature!" && exit 1; fi \
	&& if [ "${FINGERPRINT}" != "${GPG_FINGERPRINT}" ]; then echo "ERROR: Wrong GPG fingerprint!" && exit 1; fi \
	&& mkdir /rainloop && unzip -q /tmp/rainloop-community-latest.zip -d /rainloop \
	&& find /rainloop -type d -exec chmod 755 {} \; \
	&& find /rainloop -type f -exec chmod 644 {} \; \
	&& apk del build-dependencies \
	&& rm -rf /tmp/* /var/cache/apk/* /root/.gnupg \
	&& chmod o+w /dev/stdout

COPY rootfs /
RUN chmod +x /run.sh /services/*/run /services/.s6-svscan/* \
	&& sed -i "s/<UPLOAD_MAX_SIZE>/${UPLOAD_MAX_SIZE}/" /etc/nginx/nginx.conf \
	&& sed -i "s/<UPLOAD_MAX_SIZE>/${UPLOAD_MAX_SIZE}/" /etc/php7/php-fpm.conf \
	&& sed -i "s/<MEMORY_LIMIT>/${MEMORY_LIMIT}/" /etc/php7/php-fpm.conf
RUN chown nginx:nginx /rainloop/data
VOLUME /rainloop/data
EXPOSE 8888

USER nginx
ENTRYPOINT ["/run.sh"]
