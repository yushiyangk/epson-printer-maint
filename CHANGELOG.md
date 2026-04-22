## Changelog

This project follows [Semantic Versioning (SemVer)](https://semver.org/spec/v2.0.0.html).

### 1.1.0

#### Added

- Convenience command to check status of printer in `cups` service: `./entrypoint.sh status`

#### Changed

- `entrypoint.sh` in `cups` service can be executed repeatedly without error messages
- Default values in `env`:
	- Use `everywhere` for printer driver by default instead of deprecated PPD files, with updated documentation
	- Use `ipps` URI scheme by default instead of `https` to avoid having to specify port number
	- Changed default maintenance frequency from 2 weeks to 1 week

#### Fixed

- Eliminated unindicative error message during start-up of `cron` service

### 1.0.1

- **Changed**: failure to rebuild the Docker container will no longer cause the systemd service to fail to run

### 1.0

- Initial release
