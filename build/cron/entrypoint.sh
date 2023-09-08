#!/bin/sh

# Restore writeable files
cp -a /defaults/* /container


echo "print:epson-printer-maint@$MAIL_DOMAIN" > /etc/ssmtp/revaliases

crontab="MAILTO=$MAIL_TO"
crontab="$crontab\n0 $EPSON_PRINTER_MAINT_HOUR * * $EPSON_PRINTER_MAINT_DAY_OF_WEEK "'[ $(expr $(date +%W) \% '"$EPSON_PRINTER_MAINT_INTERVAL_WEEKS"') -eq 0 ]'" && /usr/bin/lp -h epson-printer-maint-cups-1 -d $EPSON_PRINTER_NAME /home/print/testprint > /dev/null && /usr/bin/lpstat -h epson-printer-maint-cups-1 -d $EPSON_PRINTER_NAME -l -t"
echo -e "$crontab" >> /etc/crontabs/print

crond -f -l 4
