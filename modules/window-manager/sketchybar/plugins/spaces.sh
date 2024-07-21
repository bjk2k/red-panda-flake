#!/usr/local/bin/bash

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

#sketchybar --set "$NAME" background.drawing="$SELECTED"

# source "$HOME/.config/sketchybar/colors.sh"

if [ $SELECTED = 'true' ]; then
	sketchybar --set "$NAME" background.color=0xffff9e3b
else
	sketchybar --set "$NAME" background.color=0xff9cabca
fi
