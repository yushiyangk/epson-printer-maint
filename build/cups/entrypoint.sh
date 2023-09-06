#!/bin/sh

# Restore writeable volumes
cp -a /etc/default-cups/* /etc/cups
cp -a /run/default-cups/* /run/cups
cp -a /var/cache/default-cups/* /var/cache/cups
cp -a /var/spool/default-cups/* /var/spool/cups

cupsd  # Start daemon

case "$1" in
	list|drivers)
		lpinfo -m | grep escpr
		exit 0
		;;
	search)
		lpinfo -v
		exit 0
		;;
	*) ;;
esac

lpadmin -p "$EPSON_PRINTER_NAME" -E -D "$EPSON_PRINTER_DESCRIPTION" -L "$EPSON_PRINTER_LOCATION" -v "$EPSON_PRINTER_URL" -m "$EPSON_PRINTER_PPD_DRIVER"
lpstat -l -t

cupsd -f  # Restart daemon in foreground
