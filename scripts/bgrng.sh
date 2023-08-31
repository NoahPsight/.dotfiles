if [ -f ~/wallpaper/override.jpg ]; then
  echo "Using override wallpaper"
  FILE="/home/fib/wallpaper/override.jpg"
else
  FILE=$(find ~/wallpaper -type f | shuf -n 1)
fi
if [ -f ~/quotes/override.txt ]; then
  echo "Using override quote"
  QUOTE=$(cat ~/quotes/override.txt)
else
  QUOTE=$(find ~/quotes -type f | grep -v "override.txt" | shuf -n 1 | xargs cat)
fi
convert "$FILE" -resize 1920x1080! -blur 0x8 ~/temp_resized.png 2>/dev/null
convert ~/temp_resized.png -font "Z003-MediumItalic" -fill white -pointsize 50 -gravity center -annotate +0+0 "$QUOTE" ~/current_wallpaper.png 2>/dev/null
feh --bg-fill ~/current_wallpaper.png
