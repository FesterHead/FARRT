#!/bin/bash

find /mnt/data/media/movies -type f -name "*.mkv" -exec sh -c 'ffmpeg -i "$0" -movflags faststart -acodec copy -vcodec copy "${0%.mkv}.mp4" && rm "$0"' {} \;
find /mnt/data/media/movies -type f -name "*.avi" -exec sh -c 'ffmpeg -i "$0" -movflags faststart -acodec copy -vcodec copy "${0%.avi}.mp4" && rm "$0"' {} \;
find /mnt/data/media/tv -type f -name "*.mkv" -exec sh -c 'ffmpeg -i "$0" -movflags faststart -acodec copy -vcodec copy "${0%.mkv}.mp4" && rm "$0"' {} \;
find /mnt/data/media/tv -type f -name "*.avi" -exec sh -c 'ffmpeg -i "$0" -movflags faststart -acodec copy -vcodec copy "${0%.avi}.mp4" && rm "$0"' {} \;
