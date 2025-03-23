#!/bin/bash

find /mnt/data/media/movies -type f -name "*.mp4" | while read file; do
  #echo "$file"
  codec_name=`ffprobe -v quiet -show_entries stream=codec_name -select_streams v:0 -of compact=p=0:nk=1 -v 0 "$file"`
  if [ "$codec_name" == "hevc" ]; then
    echo "$file"
  fi
done
