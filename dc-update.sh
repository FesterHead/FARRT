#!/bin/bash

TEXT_RESET='\e[0m'
TEXT_YELLOW='\e[0;33m'
TEXT_GREEN='\e[0;32m'
TEXT_RED_B='\e[1;31m'

function print_array_item() {
  local index="$1"
  local value="$2"

  printf "%2d = %s\n" $index $value
}

services=("bazarr" \
          "container-mon" \
          "diun" \
          "duckdns" \
          "emby" \
          "flaresolverr" \
          "homepage" \
          "jellyseerr" \
          "plex" \
          "prowlarr" \
          "radarr" \
          "sabnzbd" \
          "sonarr" \
          "swag" \
          "transmission-openvpn" \
          "transmission-rush")

for index in "${!services[@]}"; do
  print_array_item "$index" "${services[$index]}"
done

echo "Enter system # to pull and update:"
read index

value="${services[$index]}"

if [[ "$index" -ge 0 && "$index" -lt "${#services[@]}" ]]; then
  cd /mnt/projects/FARRT

  echo -e $TEXT_YELLOW
  echo "-----------------------------------------------"
  echo "Starting docker-compose pull for $value ..."
  echo -e $TEXT_RESET
  docker-compose pull $value

  echo -e $TEXT_YELLOW
  echo "-----------------------------------------------"
  echo "Starting docker-compose up -d for $value ..."
  echo -e $TEXT_RESET
  docker-compose up -d $value

  echo -e $TEXT_GREEN
  echo "Pau.  Have a nice day."
  echo -e $TEXT_RESET
else
  echo "Bad input - try again"
  exit 1;
fi
