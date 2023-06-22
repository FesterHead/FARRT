# FARRT
## FesterHead's ARR Toolset

Some guides I used to determine this setup:
- https://trash-guides.info/Hardlinks/Hardlinks-and-Instant-Moves/
- https://trash-guides.info/Hardlinks/How-to-setup-for/Docker/

This is what I use for a folder strategy.  Your mileage may vary.
Synology NAS data mount:
```shell
data
├───media
│   ├───books
│   ├───movies
│   ├───music
│   ├───rush-bootlegs
│   └───tv
├───torrents-rush
│   ├───complete
│   ├───incomplete
│   └───torrents   # torrent backup, reload later to re-seed
├───torrents-vpn
│   ├───complete
│   └───incomplete
└───usenet
    ├───complete
    └───incomplete
```
Folder structure on the host computer for service data and this Github repo.
```shell
/mnt
├── docker
│   └── services
│       ├── bazarr
│       ├── diun
│       ├── duckdns
│       ├── emby
│       ├── homepage
│       ├── jellyseerr
│       ├── plex
│       ├── prowlarr
│       ├── radarr
│       ├── sabnzbd
│       ├── sonarr
│       ├── swag
│       ├── transmission-openvpn
│       └── transmission-rush
└── projects
    └── farrt     # This project, other repos go the projects folder
```

# Install
See [install.md](install.md)

# Services
Read the docs!

## diun:
- https://github.com/crazy-max/diun
- https://crazymax.dev/diun/

## container-mon:
- https://github.com/RafhaanShah/Container-Mon

## transmission-openvpn:
- https://hub.docker.com/r/haugene/transmission-openvpn
- http://haugene.github.io/docker-transmission-openvpn/
- https://github.com/haugene/docker-transmission-openvpn

4.1 is the only version I could get PIA to port forward; please don't break it upstream PIA!

## transmission-rush:
- https://hub.docker.com/r/linuxserver/transmission
- https://docs.linuxserver.io/images/docker-transmission
- https://github.com/linuxserver/docker-transmission

Used for Rush torrenting from http://www.dimeadozen.org/. Port forward 51413 from router to docker machine for non-firewalled best seeding results.

## sabnzbd:
- https://hub.docker.com/r/linuxserver/sabnzbd
- https://docs.linuxserver.io/images/docker-sabnzbd
- https://github.com/linuxserver/docker-sabnzbd
- https://trash-guides.info/Downloaders/SABnzbd/Basic-Setup/

## flaresolverr:
- https://hub.docker.com/r/flaresolverr/flaresolverr
- https://github.com/FlareSolverr/FlareSolverr
- https://trash-guides.info/Prowlarr/prowlarr-setup-flaresolverr/

## prowlarr:
- https://hub.docker.com/r/linuxserver/prowlarr
- https://docs.linuxserver.io/images/docker-prowlarr
- https://github.com/linuxserver/docker-prowlarr

## emby:
- https://hub.docker.com/r/linuxserver/emby
- https://docs.linuxserver.io/images/docker-emby
- https://github.com/linuxserver/docker-emby

SSL is managed by the swag container.

## plex:
- https://hub.docker.com/r/linuxserver/plex
- https://docs.linuxserver.io/images/docker-plex
- https://github.com/linuxserver/docker-plex
- https://trash-guides.info/Plex/

Including here but not planning on loading it up, maybe later.

## bazarr:
- https://hub.docker.com/r/linuxserver/bazarr
- https://docs.linuxserver.io/images/docker-bazarr
- https://github.com/linuxserver/docker-bazarr
- https://trash-guides.info/Bazarr/

## radarr:
- https://hub.docker.com/r/linuxserver/radarr
- https://docs.linuxserver.io/images/docker-radarr
- https://github.com/linuxserver/docker-radarr
- https://trash-guides.info/Radarr/

## sonarr:
- https://hub.docker.com/r/linuxserver/sonarr
- https://docs.linuxserver.io/images/docker-sonarr
- https://github.com/linuxserver/docker-sonarr
- https://trash-guides.info/Sonarr/

## jellyseerr:
- https://hub.docker.com/r/fallenbagel/jellyseerr
- https://github.com/Fallenbagel/jellyseerr

## heimdall:
https://hub.docker.com/r/linuxserver/heimdall/
https://docs.linuxserver.io/images/docker-heimdall
https://github.com/linuxserver/Heimdall

## duckdns:
https://hub.docker.com/r/linuxserver/duckdns
https://docs.linuxserver.io/images/docker-duckdns
https://github.com/linuxserver/docker-duckdns

## swag:
- https://hub.docker.com/r/linuxserver/swag
- https://docs.linuxserver.io/images/docker-swag
- https://github.com/linuxserver/docker-swag

This container includes auto-generated pfx and private-fullchain-bundle pem certs that are needed by other apps like Emby. Mount the SWAG folder etc that resides under /config in other containers
```shell
  For example -v /path-to-swag-config/etc:/swag-ssl
  In the other containers, use the cert location /swag-ssl/letsencrypt/live/<your.domain.url>/
```
