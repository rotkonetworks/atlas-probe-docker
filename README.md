# RIPE Atlas Software Probe Docker Setup

This project provides a Dockerized setup for running a RIPE Atlas software probe.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/ripe-atlas-docker.git
   cd ripe-atlas-docker
   ```

2. Build and start the container:
   ```
   docker-compose up -d
   ```

3. Check the probe status:
   ```
   docker-compose logs
   ```

## Configuration

The probe configuration is stored in `/probe/etc/ripe-atlas/config.txt` inside
the container. You can modify this file by accessing the `ripe_atlas_config` volume.

## Volumes

- `ripe_atlas_config`: Stores probe configuration
- `ripe_atlas_status`: Stores probe status information
- `ripe_atlas_data`: Stores measurement data

## Security

This setup follows security best practices:
- Runs as a non-root user
- Uses a read-only filesystem with exceptions for necessary write access
- Drops all capabilities except NET_RAW
- Prevents privilege escalation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
