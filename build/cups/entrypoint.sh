#!/bin/sh

# Restore writeable files
cp -a --update=none /default/* /container  # Do not overwrite if this script is executed again

# Set time zone
ln -sf /usr/share/zoneinfo/"$(cat /etc/timezone)" /container/etc/localtime  # Okay to overwrite as /etc/timezone is read-only


# Start daemon
cupsd

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

# Restart daemon in foreground
cupsd -f
