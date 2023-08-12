FILE=$(find ~/wallpaper -type f | shuf -n 1)
if [ -f ~/quotes/override.txt ]; then
  QUOTE=$(cat ~/quotes/override.txt)
else
  QUOTE=$(find ~/quotes -type f | grep -v "override.txt" | shuf -n 1 | xargs cat)
fi
convert "$FILE" -blur 0x8 -font "Z003-MediumItalic" -fill white -pointsize 50 -gravity center -annotate +0+0 "$QUOTE" ~/current_wallpaper.png 2>/dev/null
feh --bg-fill ~/current_wallpaper.png
