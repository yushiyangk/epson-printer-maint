# syntax=docker/dockerfile:1.4

FROM alpine:3

ARG cache_date
RUN apk update && \
	apk upgrade --no-cache --no-interactive && \
	apk add --no-cache --no-interactive tzdata cups cups-filters epson-inkjet-printer-escpr

RUN adduser root lpadmin

COPY --link --chown=root:lp --chmod=640 cupsd.conf /etc/cups/cupsd.conf
COPY --link --chmod=550 entrypoint.sh entrypoint.sh

RUN mkdir -m 755 /default && \
	mkdir -m 755 /default/etc && \
	mkdir -m 755 /default/run && \
	mkdir -m 755 /default/var && \
	mkdir -m 755 /default/var/cache && \
	mkdir -m 755 /default/var/log && \
	mkdir -m 755 /default/var/spool && \
	mkdir -m 755 /container && \
	ln -s /container/etc/printcap /etc/printcap && \
	mv /etc/cups /default/etc/cups && ln -s /container/etc/cups /etc/cups && \
	mv /run/cups /default/run/cups && ln -s /container/run/cups  /run/cups && \
	mv /var/cache/cups /default/var/cache/cups && ln -s /container/var/cache/cups /var/cache/cups && \
	mv /var/log/cups /default/var/log/cups && ln -s /container/var/log/cups /var/log/cups && \
	mv /var/spool/cups /default/var/spool/cups && ln -s /container/var/spool/cups /var/spool/cups && \
	ln -s /container/etc/localtime /etc/localtime && \
	touch /testpage-template.pdf && chmod 644 /testpage-template.pdf && \
	touch /etc/timezone && chmod 644 /etc/timezone

# tmpfs
VOLUME /container

# bind
VOLUME /testpage-template.pdf
VOLUME /etc/timezone

EXPOSE 631

ENTRYPOINT ["entrypoint.sh"]
