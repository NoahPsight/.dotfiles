#!/bin/bash

FILE=$(find ~/Wallpaper -follow -type f | shuf -n 1)
QUOTE=$(find ~/Quotes -follow -type f | shuf -n 1 | xargs cat)
FONT="Z003-Medium-Italic"

convert "$FILE" \
    -resize 1920x1080! \
    -blur 0x0 \
    /tmp/temp_resized.png
convert /tmp/temp_resized.png \
    -font "$FONT" \
    -fill white \
    -pointsize 50 -gravity center \
    -annotate +0+0 "$QUOTE" \
    /tmp/current_wallpaper.png

rm /tmp/temp_resized.png
pkill swaybg
swaybg -i /tmp/current_wallpaper.png &
