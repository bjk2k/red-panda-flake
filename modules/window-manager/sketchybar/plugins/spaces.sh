#!/bin/bash

update() {
  UPDATED_COLOR=0xffdcd7ba  
  if [ "$SELECTED" = "true" ]; then
    UPDATED_COLOR=0xffff9e3b
  fi
  sketchybar --set "$NAME" icon.highlight="$SELECTED" \
    label.highlight="$SELECTED" \
    background.border_color="$UPDATED_COLOR"
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    yabai -m space --destroy "$SID"
    sketchybar --trigger windows_on_spaces --trigger space_change
  else
    yabai -m space --focus "$SID" 2>/dev/null
  fi
}

case "$SENDER" in
"mouse.clicked")
  mouse_clicked
  ;;
*)
  update
  ;;
esac
