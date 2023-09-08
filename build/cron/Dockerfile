# syntax=docker/dockerfile:1.4

FROM alpine:3

ARG uid=500
ARG gid=500

RUN addgroup -S -g $gid print && \
	adduser -SD -G print -u $uid print

ARG cache_date
RUN apk update && \
	apk upgrade --no-cache --no-interactive && \
	apk add --no-cache --no-interactive tzdata cups-client ssmtp

COPY --link --chown=print:print --chmod=440 testprint /home/print
COPY --link --chmod=550 entrypoint.sh entrypoint.sh

RUN mkdir -m 755 /default && \
	mkdir -m 755 /default/etc && \
	mkdir -m 755 /default/var && \
	mkdir -m 755 /default/var/spool && \
	mkdir -m 755 /container && \
	mv /etc/crontabs /default/etc/crontabs && ln -s /container/etc/crontabs /etc/crontabs && \
	mv /etc/ssmtp /default/etc/ssmtp && ln -s /container/etc/ssmtp /etc/ssmtp && \
	mv /var/spool/cron /default/var/spool/cron && ln -s /container/var/spool/cron /var/spool/cron && \
	ln -s /container/etc/localtime /etc/localtime && \
	touch /etc/timezone && chmod 644 /etc/timezone

# tmpfs for crond
VOLUME /container

# bind
VOLUME /etc/ssmtp/ssmtp.conf
VOLUME /etc/timezone

ENTRYPOINT ["./entrypoint.sh"]
