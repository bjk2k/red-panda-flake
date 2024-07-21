#!/bin/bash

# sketchybar --add item space_separator left                             \
#            --set space_separator icon="􀆊"                                \
#                                  padding_right=12                        \
#                                  padding_left=8                        \
#                                  icon.color=$WHITE \
#                                  icon.padding_left=4 \
#                                  label.drawing=off                     \
#                                  background.drawing=off                \
#                                  script="$PLUGIN_DIR/space_windows.sh" \
#            --subscribe space_separator space_windows_change
#
SPACE_ICONS=("1" "2" "3" "4" "5" )

for i in "${!SPACE_ICONS[@]}"
do
  sid="$(($i+1))"
  space=(
    space="$sid"
    icon="${SPACE_ICONS[i]}"
    icon.padding_left=12
    icon.padding_right=12
    background.color=0xff9cabca
    background.corner_radius=0
    background.height=32
    background.padding_left=0
    background.padding_right=0
    label.drawing=off
    icon.color=0xff000000
    script="$PLUGIN_DIR/spaces.sh"
    click_script="yabai -m space --focus $sid"
  )
  sketchybar --add space space."$sid" left --set space."$sid" "${space[@]}"
done

