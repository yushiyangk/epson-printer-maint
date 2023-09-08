# epson-printer-maint

Maintenance print job for Epson printers

## Install

Using Docker Compose:

1. Create the working directory at `/srv/docker/epson-printer-maint`.

2. Copy the contents of `compose` from this repository to the working directory, either manually or by running

	```
	sudo curl -L https://codeload.github.com/yushiyangk/epson-printer-maint/zip/refs/heads/main -o epson-printer-maint.zip && sudo unzip -t epson-printer-maint.zip
	sudo unzip epson-printer-maint.zip epson-printer-maint-main/compose/*
	sudo find epson-printer-maint-main/compose -mindepth 1 -maxdepth 1 -exec mv -n "{}" . \; && sudo rm -r epson-printer-maint-main epson-printer-maint.zip
	```

### Configure

1. Edit `env` to set the following values:

	- **EPSON_PRINTER_URL**
	- **EPSON_PRINTER_PPD_DRIVER**

	For EPSON_PRINTER_URL, refer to the printer's documentation, or its web management interface if it has one. Alternatively, if the printer has already been installed on a user's PC, examine its configuration on that PC to get its URL.

	For EPSON_PRINTER_PPD_DRIVER, run `sudo docker compose run cups list` to show the available drivers, and choose the apprioriate file ending in `.ppd` that matches the printer.

	Optionally, set the following values as well (for informative purposes only):

	- **EPSON_PRINTER_NAME**: Printer destination name used internally by CUPS
	- **EPSON_PRINTER_DESCRIPTION**: Human-readable name
	- **EPSON_PRINTER_LOCATION**: Human-readable label for the printer's location

2. Set the following values in `env` as well:

	- **EPSON_PRINTER_MAINT_INTERVAL_WEEKS**: How frequently the maintenance print should be run, in weeks
	- **EPSON_PRINTER_MAINT_DAY_OF_WEEK**: Day of the week on which the maintenance print should be run, in cron format
	- **EPSON_PRINTER_MAINT_HOUR**: Hour at which the maintenance print should be run, in cron format

3. If email notifications are required, edit `cron/ssmtp.conf` to point it to the mail server with [the appropriate settings](https://wiki.archlinux.org/title/SSMTP), then set the following values in `env`:

	- **MAIL_DOMAIN**: The fully-qualified domain name that mail should be sent from (not including username)
	- **MAIL_TO**: The recepient address (including username)

4. Set the cron time zone by editing `timezone` to the appropriate [tz identifier](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones), or set it to be the same as the host by running `sudo rm timezone && sudo ln -s /etc/timezone timezone`.

5. Optionally, replace `cups/testpage-template.pdf` with a different PDF file.

### Run

```
sudo docker compose up
```

## Start as service on boot

Install the Systemd unit file and enable the service:

```
sudo ln -s /srv/docker/epson-printer-maint/epson-printer-maint.service /etc/systemd/system/epson-printer-maint.service && sudo systemctl daemon-reload
sudo systemctl enable epson-printer-maint && sudo service epson-printer-maint start
```

Check the status of the service:

```
sudo service epson-printer-maint status
```
