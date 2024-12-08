--
-- [palettes.nord]
-- nord0 = '#2E3440'
-- nord1 = '#3B4252'
-- nord2 = '#434C5E'
-- nord3 = '#4C566A'
-- nord4 = '#D8DEE9'
-- nord7 = '#8FBCBB'
-- nord8 = '#88C0D0'
-- nord9 = '#81A1C1'
-- nor10 = '#5E81AC'
-- nord11 = '#BF616A'
-- nord13 = '#EBCB8B'
-- nord14 = '#A2BE8A'
-- nord15 = '#B48EAD'
-- bright-white = '#D8DEE9'

return {
  -- black = 0xff181819, kanagawa
  black = 0xff2e3440,
  -- white = 0xffe2e2e3,
  -- white = 0xffdcd7ba, kanagawa
  white = 0xffd8dee9,

  -- red = 0xfffc5d7c, Kanagawa
  red = 0xffbf616a,
  -- green = 0xff9ed072,
  green = 0xffa2be8a,
  -- blue = 0xff76cce0, kanagawa
  blue = 0xff5e81ac,
  yellow = 0xffe7c664,
  -- orange = 0xffff9d3a, kanagawa
  orange = 0xffebcb8b,
  -- magenta = 0xffb39df3, kanagawa
  magenta = 0xffb48ead,
  -- grey = 0xff7f8490, kanagawa
  grey = 0xff4c566a,
  transparent = 0x00000000,

  bar = {
    -- bg = 0xf02c2e34,
    -- border = 0xff2c2e34,
    bg = 0xff2e3440,
    border = 0xff4c566a
  },
  popup = {
    bg = 0xc02c2e34,
    border = 0xff7f8490
  },
  -- bg1 = 0xff363944,
  -- bg1 = 0xff181715,
  bg1 = 0xff2e3440,
  bg2 = 0xff4c566a,
  -- bg2 = 0xff414550,
  -- bg2 = 0Xff8da4a2,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
