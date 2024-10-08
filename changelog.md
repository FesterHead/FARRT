# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.5] 2024.09.14
- Added avi to mp4 in convert script
- Added script to list hevc files, I prefer h.264

## [1.0.5] 2024-01-27
- Added script to convert mkv to mp4
- Can run manually or via crontab e.g. `0 13 * * 0 <directory>/convert-mkv-to-mp4/convert-mkv-to-mp4.sh`
- MP4 is just my personal preference

## [1.0.4] 2023-12-03
- Removed Plex
- Tuned install and README to improve clarity

## [1.0.3] 2023-06-21
- Removed readarr; Mobilsm and Calibre work flow is better
- Remove sudo docker blurb, must have typed it wrong before, non-sudo works
- Removed Adguard Home; using straight-up install for better DHCP IP tracking and reporting
- Replaced heimdall with homepage

## [1.0.2] 2023-06-06
- Added readarr

## [1.0.1] 2023-06-06
- Removed organizr
- Removed embystat
- Commented wget healthchecks; Too many zombies

## [1.0.0] 2023-06-04
- Initial base commit with `hello-world` docker-compose.yaml
- README and install documentation are works in progress
