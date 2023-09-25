#!/bin/bash

FILE=$(find ~/Wallpaper -follow -type f | shuf -n 1)
QUOTE=$(find ~/Quotes -follow -type f | shuf -n 1 | xargs cat)

FONT="Z003-MediumItalic"

#convert "$FILE" -resize 1920x1080! -blur 0x8 /tmp/temp_resized.png 2>/dev/null
convert "$FILE" -resize 1920x1080! /tmp/temp_resized.png 2>/dev/null
convert /tmp/temp_resized.png -font "$FONT" -fill white -pointsize 50 -gravity center -annotate +0+0 "$QUOTE" /tmp/current_wallpaper.png 2>/dev/null

swaybg -m fill -i /tmp/current_wallpaper.png

rm /tmp/current_wallpaper.png
rm /tmp/temp_resized.png
