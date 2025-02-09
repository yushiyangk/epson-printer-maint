# epson-printer-maint

Maintenance print job for Epson printers

## Install

Using Docker Compose:

1. Download the <code>epson-printer-maint-<var>version</var>-docker-compose.zip</code> file and extract it to `/srv/docker/epson-printer-maint`

	This can be done on the command-line with

	```sh
	curl -s https://api.github.com/repos/yushiyangk/epson-printer-maint/releases/latest | grep -F epson-printer-maint-1. | grep -F docker-compose.zip | grep -F browser_download_url | head -n 1 | cut -d ':' -f 2- | tr -d '"' | sudo wget -q -i - -P /srv/docker/epson-printer-maint/  # Download latest 1.x release
	sudo unzip /srv/docker/epson-printer-maint/epson-printer-maint-*-docker-compose.zip -d /srv/docker/epson-printer-maint/
	sudo rm /srv/docker/epson-printer-maint/epson-printer-maint-*-docker-compose.zip
	```

	If a previous version is already installed, you will be prompted to replace the existing files. Be careful not to clobber the existing `env`.

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

4. Set the time zone by editing `timezone` to the appropriate [tz identifier](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones), or set it to be the same as the host by running `sudo rm timezone && sudo ln -s /etc/timezone timezone`.

5. Optionally, replace `cups/testpage-template.pdf` with a different PDF file.

### Run

```
sudo docker compose up
```

## Start as service on boot

Install the Systemd unit file and enable the service:

```
sudo ln -s /srv/docker/epson-printer-maint/epson-printer-maint.service /etc/systemd/system/epson-printer-maint.service
sudo systemctl daemon-reload
sudo systemctl enable epson-printer-maint
sudo systemctl start epson-printer-maint
```

Check the status of the service:

```
sudo systemctl status epson-printer-maint
```
