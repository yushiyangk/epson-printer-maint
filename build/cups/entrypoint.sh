#!/bin/sh

# Restore writeable files
cp -a /defaults/* /container


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
