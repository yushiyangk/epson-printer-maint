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

RUN mv /etc/crontabs /etc/default-crontabs && mkdir -m 755 /etc/crontabs && \
	mv /var/spool/cron /var/spool/default-cron && mkdir -m 755 /var/spool/cron

# tmpfs for crond
VOLUME /etc/crontabs
VOLUME /etc/ssmtp
VOLUME /var/spool/cron

# bind
VOLUME /etc/ssmtp/ssmtp.conf
VOLUME /etc/timezone

ENTRYPOINT ["./entrypoint.sh"]
