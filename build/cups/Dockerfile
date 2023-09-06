# syntax=docker/dockerfile:1.4

FROM alpine:3

ARG cache_date
RUN apk update && \
	apk upgrade --no-cache --no-interactive && \
	apk add --no-cache --no-interactive cups cups-filters epson-inkjet-printer-escpr

RUN adduser root lpadmin

COPY --link --chown=root:lp --chmod=640 cupsd.conf /etc/cups/cupsd.conf
COPY --link --chmod=550 entrypoint.sh entrypoint.sh

RUN touch /testpage-template.pdf && chmod 644 /testpage-template.pdf && \
	touch /etc/cups/printcap && ln -s /etc/cups/printcap /etc/printcap && \
	mv /etc/cups /etc/default-cups && mkdir -m 755 /etc/cups && \
	mv /run/cups /run/default-cups && mkdir -m 755 /run/cups && \
	mv /var/cache/cups /var/cache/default-cups && mkdir -m 770 /var/cache/cups && chown :lp /var/cache/cups && \
	mv /var/spool/cups /var/spool/default-cups && mkdir -m 710 /var/spool/cups && chown :lp /var/cache/cups

# tmpfs
VOLUME /testpage-template.pdf
VOLUME /etc/cups
VOLUME /run/cups
VOLUME /var/cache/cups
VOLUME /var/log/cups
VOLUME /var/spool/cups

EXPOSE 631

ENTRYPOINT ["./entrypoint.sh"]
