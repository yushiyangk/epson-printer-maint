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

## Configure

1. Edit `env`

	1. Set **EPSON_PRINTER_NAME**

		This is the printer identifier used internally by CUPS.

	2. Set **EPSON_PRINTER_URL**

		Refer to the printer's documentation for its network printing URI, or refer to its web management interface if it has one.

		This is most likely in the form of one of the following:

		<pre><code>ipps://<var>ip_address_or_domain</var>/ipp/print
		https://<var>ip_address_or_domain</var>:631/ipp/print</pre></code>

		The two forms are equivalent, but note the port 631 which must be specified for `https`. If IPPS/HTTPS is not supported, replace `ipps` with `ipp` or `https` with `http` instead.

	3. Leave **EPSON_PRINTER_PPD_DRIVER** as the default value of `everywhere` for now.

		If this does not work, see below on how to [Specify printer driver](#specify-printer-driver).

	4. Optionally, set the following values as well (for informative purposes only):

		- **EPSON_PRINTER_DESCRIPTION**: Human-readable name
		- **EPSON_PRINTER_LOCATION**: Human-readable label for the printer's location

	5. Set the folowing values to determine when the maintenance print will be run:

		- **EPSON_PRINTER_MAINT_INTERVAL_WEEKS**: Frequency in weeks of maintenance print
		- **EPSON_PRINTER_MAINT_DAY_OF_WEEK**: Day of the week on which the maintenance print should be run, in cron format (`0` for Sunday, `6` for Saturday)
		- **EPSON_PRINTER_MAINT_HOUR**: Hour at which the maintenance print should be run, in cron format (`0` for midnight, `13` for 1 p.m.)

		For example, to run it every single day at noon, set EPSON_PRINTER_MAINT_INTERVAL_WEEKS to `1`, EPSON_PRINTER_MAINT_DAY_OF_WEEK to `*`, and EPSON_PRINTER_MAINT_HOUR to `12`.

2. If email notifications are required,

	1. Edit `cron/ssmtp.conf` to point it to the mail server with [the appropriate settings](https://wiki.archlinux.org/title/SSMTP).

		The provided default settings are reasonable, except that **mailhub** must be configured to the mail submission server's network address

	2. Edit `env` and set the following values:

		- **MAIL_DOMAIN**: The fully-qualified domain name to be used as the sender domain (not including username), e.g. <code><var>myhost</var>.<var>mydomain</var>.net</code>
		- **MAIL_TO**: The recepient email address (including username), e.g. <code><var>user</var>@<var>email_service</var>.com</code>

3. Set the time zone by editing `timezone` to the appropriate [tz identifier](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones), or set it to be the same as the host by running `sudo rm timezone && sudo ln -s /etc/timezone timezone`.

4. Optionally, replace `cups/testpage-template.pdf` with a different PDF file.

### Specify printer driver

If the default printer driver of `everywhere` does not work, it may be necessary to specify a specific driver for the printer.

Run <code>sudo docker compose run cups <b>list</b></code> to show a list of available drivers, and choose the appropriate file ending in `.ppd` that matches the printer. Edit `env` and set **EPSON_PRINTER_PPD_DRIVER** to this value.

Note that this functionality is deprecated by CUPS, and may not be supported in the future.

## Run

```
sudo docker compose up
```

### Show printer status

<pre><code>sudo docker compose exec cups ./entrypoint.sh <b>status</b></code></pre>

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
