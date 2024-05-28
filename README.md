# Pwrstat Exporter

[![Build](https://github.com/Corundex/pwrstat-exporter/actions/workflows/go.yml/badge.svg)](https://github.com/Corundex/pwrstat-exporter/actions/workflows/go.yml)
[![Go Report Card](https://goreportcard.com/badge/github.com/corundex/pwrstat-exporter)](https://goreportcard.com/report/github.com/corundex/pwrstat-exporter)
[![GoDoc](https://godoc.org/github.com/corundex/pwrstat-exporter?status.svg)](https://godoc.org/github.com/corundex/pwrstat-exporter)
[![Docker Pulls](https://img.shields.io/docker/pulls/corundex/pwrstat-exporter.svg?maxAge=0)](https://hub.docker.com/repository/docker/corundex/pwrstat-exporter/general)

A Prometheus exporter for CyberPower UPS Linux daemon (pwrstat).

## Overview
The Pwrstat Exporter enables Prometheus to monitor data from CyberPower Uninterruptible Power Supply (UPS) systems running on Linux. It uses the pwrstat Linux daemon for data acquisition.

## Docker Deployment
Prerequisites
Docker installed on your system.
### Installation
Run the following command to install the Pwrstat Exporter using Docker:

```bash
docker run \
  --name pwrstat-exporter \
  --device /dev/bus/usb:/dev/bus/usb \
  --device /dev/usb/hiddev0:/dev/usb/hiddev0 \
  --privileged \
  --restart unless-stopped \
  -p 8088:8088 \
  -d cardif99/pwrstat-exporter:latest
```

### Docker compose

This use case demonstrates how to handle multiple UPS devices connected to the same machine.

- privilege must be set to false.
- Map only one device to each container; there is no need to rename them.
- Remap port 8088 for each container to avoid conflicts.
- Use the ALARM variable to mute the alarm beeper.

```yaml
services:

  pwrstat_exporter_dev0:
    image: corundex/pwrstat-exporter:latest
    container_name: pwrstat-exporter-dev0
    devices:
      - /dev/bus/usb:/dev/bus/usb 
      - /dev/usb/hiddev0:/dev/usb/hiddev0
    privileged: false
    environment:
      - ALARM=off
    restart: unless-stopped
    ports:
      - 8088:8088

  pwrstat_exporter_dev1:
    image: corundex/pwrstat-exporter:latest
    container_name: pwrstat-exporter-dev1
    devices:
      - /dev/bus/usb:/dev/bus/usb 
      - /dev/usb/hiddev1:/dev/usb/hiddev1
    privileged: false
    environment:
      - ALARM=on
    restart: unless-stopped
    ports:
      - 8089:8088
```

## Building from Source
Prerequisites
* Golang version 1.16 or higher.
### Installation
Clone the repository and build the executable:

```bash
git clone https://github.com/corundex/pwrstat-exporter.git
cd pwrstat-exporter
go build && mv pwrstat-exporter /usr/local/bin/
```

## Usage
The ``pwrstat`` command requires sudo privileges:

```bash
sudo pwrstat-exporter 
```
To specify arguments:
```bash
sudo pwrstat-exporter --web.listen-address 8088 --web.telemetry-path /metrics
```

## Systemd Service Integration
Configuration
Create a systemd service configuration file at `/etc/systemd/system/pwrstat-exporter.service`:

```
[Unit]
Description=pwrstat-exporter

[Service]
TimeoutStartSec=0
ExecStart=/usr/local/bin/pwrstat-exporter

[Install]
WantedBy=multi-user.target
```

Reload the systemd daemon, enable the service at startup, and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable pwrstat-exporter
sudo service pwrstat-exporter start
```

## Grafana Integration

A custom Grafana dashboard is available for visualizing the data. Import the dashboard using the [grafana-dashboard.json](https://github.com/corundex/pwrstat-exporter/blob/main/grafana-dashboard.json) file.
![grafana](/image/grafana.png)

## Docker container's log

Sample docker log on exporter's start.

![pwrstat log](/image/container_log.png)
