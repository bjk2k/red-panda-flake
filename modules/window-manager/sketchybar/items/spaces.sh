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

sid=0
for i in "${!SPACE_ICONS[@]}"; do
  sid=$((i + 1))

  space=(
    associated_space="$sid"
    icon="${SPACE_ICONS[i]}"
    icon.padding_left=10
    icon.padding_right=10
    padding_left=2
    padding_right=2
    label.padding_right=20
    icon.highlight_color="$RED"
    label.color="$SECONTARY_COLOR"
    label.highlight_color="$ACCENT_COLOR"
    label.font="sketchybar-app-font:Regular:16.0"
    label.y_offset=-1
    background.color="$DARK_BG"
    background.border_color="$DARK_BG"
    background.drawing=off
    label.drawing=off
    script="$PLUGIN_DIR/spaces.sh"
  )

  sketchybar --add space space.$sid left \
    --set space.$sid "${space[@]}" \
    --subscribe space.$sid mouse.clicked
done

spaces_bracket=(
  background.color="$BACKGROUND_1"
  background.border_color="$BACKGROUND_2"
)

separator=(
  icon=􀆊
  icon.font="$FONT:Heavy:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  associated_display=active
  click_script='yabai -m space --create && sketchybar --trigger space_change'
  icon.color="$WHITE"
)

sketchybar --add bracket spaces_bracket '/space\..*/' \
  --set spaces_bracket "${spaces_bracket[@]}" \
  \
  --add item separator left \
  --set separator "${separator[@]}"
