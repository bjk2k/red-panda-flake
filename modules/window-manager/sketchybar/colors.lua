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

local rose_pine = {
  base = 0xff191724,
  surface = 0xff1f1d2e,
  overlay = 0xff26233a,
  muted = 0xff6e6a86,
  subtle = 0xff908caa,
  text = 0xffe0def4,
  love = 0xffeb6f92,
  gold = 0xfff6c177,
  rose = 0xffebbcba,
  pine = 0xff31748f,
  foam = 0xff9ccfd8,
  iris = 0xffc4a7e7,
  highlightlow = 0xff21202e,
  highlightmed = 0xff403d52,
  highlighthigh = 0xff524f67
}



return {
  -- black = 0xff181819, kanagawa
  black = rose_pine.base,
  -- white = 0xffe2e2e3,
  -- white = 0xffdcd7ba, kanagawa
  white = rose_pine.text,

  -- red = 0xfffc5d7c, Kanagawa
  red = rose_pine.love,
  -- green = 0xff9ed072,
  green = rose_pine.pine,
  -- blue = 0xff76cce0, kanagawa
  blue = rose_pine.foam,
  yellow = rose_pine.gold,
  -- orange = 0xffff9d3a, kanagawa
  orange = rose_pine.gold,
  -- magenta = 0xffb39df3, kanagawa
  magenta = rose_pine.love,
  -- grey = 0xff7f8490, kanagawa
  grey = rose_pine.muted,
  transparent = 0x00000000,

  bar = {
    -- bg = 0xf02c2e34,
    -- border = 0xff2c2e34,
    bg = rose_pine.base,
    border = rose_pine.highlightmed,
  },
  popup = {
    bg = rose_pine.base,
    border = rose_pine.highlightmed,
  },
  -- bg1 = 0xff363944,
  -- bg1 = 0xff181715,
  bg1 = rose_pine.surface,
  bg2 = rose_pine.overlay,
  -- bg2 = 0xff414550,
  -- bg2 = 0Xff8da4a2,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
