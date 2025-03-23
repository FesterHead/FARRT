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

function do_update() {
  cd /mnt/projects/FARRT

  echo -e $TEXT_YELLOW
  echo "-----------------------------------------------"
  echo "Starting docker-compose pull for $1 ..."
  echo -e $TEXT_RESET
  docker-compose pull $1

  echo -e $TEXT_YELLOW
  echo "-----------------------------------------------"
  echo "Starting docker-compose up -d for $1 ..."
  echo -e $TEXT_RESET
  docker-compose up -d $1

  echo -e $TEXT_YELLOW
  echo "-----------------------------------------------"
  echo "Starting docker image prune --force ..."
  echo -e $TEXT_RESET
  docker image prune --force

  echo -e $TEXT_GREEN
  echo "Pau."
  echo -e $TEXT_RESET
  echo ""
}

services=("bazarr" \
          "container-mon" \
          "diun" \
          "duckdns" \
          "emby" \
          "flaresolverr" \
          "homepage" \
          "jellyseerr" \
          "prowlarr" \
          "radarr" \
          "sabnzbd" \
          "sonarr" \
          "swag")

for index in "${!services[@]}"; do
  print_array_item "$index" "${services[$index]}"
done

echo "Enter system # to pull and update (or 'all'):"
read index

value="${services[$index]}"

if [[ "$index" == "all" ]]; then
   for index2 in "${!services[@]}"; do
     do_update ${services[$index2]}
   done
elif [[ "$index" -ge 0 && "$index" -lt "${#services[@]}" ]]; then
  do_update ${services[$index]}
else
  echo "Bad input - try again"
  exit 1;
fi
