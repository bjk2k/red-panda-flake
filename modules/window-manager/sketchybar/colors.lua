--
--[palettes.rosepine]
-- base = "#191724"
-- surface = "#1f1d2e"
-- overlay = "#26233a"
-- muted = "#6e6a86"
-- subtle = "#908caa"
-- text = "#e0def4"
-- love = "#eb6f92"
-- gold = "#f6c177"
-- rose = "#ebbcba"
-- pine = "#31748f"
-- foam = "#9ccfd8"
-- iris = "#c4a7e7"
-- highlightlow = "#21202e"
-- highlightmed = "#403d52"
-- highlighthigh = "#524f67"



-- # Kanagawa Dragon Colorscheme Palette
-- [palette]
-- # Background colors
-- background = "#1a1a22"
-- dimmer_background = "#16161d"
-- lighter_background = "#2b2a33"
--
-- # Foreground colors
-- foreground = "#dcd7ba"
-- dim_foreground = "#6f7577"
-- accent_foreground = "#c8c093"
--
-- # Primary accent colors
-- red = "#c34043"
-- orange = "#ffa066"
-- yellow = "#dca561"
-- green = "#76946a"
-- blue = "#658594"
-- purple = "#938aa9"
-- teal = "#6a9589"
--
-- # Neutral colors
-- gray = "#727169"
-- light_gray = "#c0c0c0"
-- dark_gray = "#4e4f67"
--
-- # Additional tones
-- wave_blue = "#223249"
-- storm_gray = "#363646"
-- peach_orange = "#fa9b61"
-- autumn_red = "#e82424"
-- sakura_pink = "#d27e99"
-- samurai_red = "#d93850"
-- bright_orange = "#FF9E3B"
--
-- instantiate the palette as a local variable

local palette_kanagawa = {  
  -- background = 0xff1a1a22,
  background = 0xff181616,
  dimmer_background = 0xff16161d,
  lighter_background = 0xff2b2a33,
  foreground = 0xffdcd7ba,
  dim_foreground = 0xff6f7577,
  accent_foreground = 0xffc8c093,
  red = 0xffc34043,
  orange = 0xffffa066,
  yellow = 0xffdca561,
  green = 0xff76946a,
  blue = 0xff658594,
  purple = 0xff938aa9,
  teal = 0xff6a9589,
  gray = 0xff727169,
  light_gray = 0xffc0c0c0,
  dark_gray = 0xff4e4f67,
  wave_blue = 0xff223249,
  storm_gray = 0xff363646,
  peach_orange = 0xfffa9b61,
  autumn_red = 0xffe82424,
  sakura_pink = 0xffd27e99,
  samurai_red = 0xffd93850,
  bright_orange = 0xffff9e3b,
  transparent = 0x00000000,
}

local palette_github_dark = {
  background = 0xff0d1117,
  dimmer_background = 0xff0b0f16,
  lighter_background = 0xff161b22,
  foreground = 0xffc9d1d9,
  dim_foreground = 0xff8b949e,
  accent_foreground = 0xff58a6ff,
  red = 0xfff85149,
  orange = 0xfffd8c73,
  yellow = 0xfff2cc60,
  green = 0xff56d364,
  blue = 0xff58a6ff,
  purple = 0xffbc8cff,
  teal = 0xff39c5cf,
  gray = 0xff6e7681,
  light_gray = 0xff8b949e,
  dark_gray = 0xff30363d,
  wave_blue = 0xff1f6feb,
  storm_gray = 0xff21262d,
  peach_orange = 0xffffb86c,
  autumn_red = 0xffda3633,
  sakura_pink = 0xffff7b72,
  samurai_red = 0xffff3c38,
  bright_orange = 0xffffab70,
  transparent = 0x00000000,
}

-- local rose_pine = {
--   base = 0xff191724,
--   surface = 0xff1f1d2e,
--   overlay = 0xff26233a,
--   muted = 0xff6e6a86,
--   subtle = 0xff908caa,
--   text = 0xffe0def4,
--   love = 0xffeb6f92,
--   gold = 0xfff6c177,
--   rose = 0xffebbcba,
--   pine = 0xff31748f,
--   foam = 0xff9ccfd8,
--   iris = 0xffc4a7e7,
--   highlightlow = 0xff21202e,
--   highlightmed = 0xff403d52,
--   highlighthigh = 0xff524f67
-- }

local current_palette = palette_github_dark

return {
  black = current_palette.background,
  white = current_palette.foreground,
  red = current_palette.samurai_red,
  green = current_palette.green,
  blue = current_palette.wave_blue,
  yellow = current_palette.yellow,
  orange = current_palette.bright_orange,
  magenta = current_palette.sakura_pink,
  grey = current_palette.storm_gray,
  transparent = 0x00000000,

  bar = {
    bg = current_palette.transparent,
    border = current_palette.dimmer_background,
  },
  popup = {
    bg = current_palette.lighter_background,
    border = current_palette.dimmer_background,
  },
  bg1 = current_palette.dimmer_background,
  bg2 = current_palette.lighter_background,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
