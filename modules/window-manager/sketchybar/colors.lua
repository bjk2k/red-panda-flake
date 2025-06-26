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
    background = 0xff1a1a22,
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
    transparent = 0x00000000
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



local palette_github_dark = {
    background = 0xff0d1117,
    background_alt = 0xff161b22,
    background_focus = 0xff21262d,
    foreground = 0xffc9d1d9,
    foreground_dim = 0xff8b949e,
    foreground_accent = 0xff58a6ff,

    color_red = 0xfff85149,
    color_orange = 0xffffa657,
    color_yellow = 0xffd29922,
    color_green = 0xff238636,
    color_blue = 0xff58a6ff,
    color_purple = 0xffbc8cff,
    color_cyan = 0xff39c5cf,

    gray = 0xff6e7681,
    gray_light = 0xffb1bac4,
    gray_dark = 0xff30363d,

    link_blue = 0xff1f6feb,
    panel_bg = 0xff2d333b,
    error_bg = 0xffffa198,
    error_fg = 0xffda3633,
    pink = 0xfff778ba,
    alert_red = 0xffcf222e,
    warning_orange = 0xffffc107,

    transparent = 0x00000000
}

return {
    black = palette_github_dark.panel_bg,
    white = palette_github_dark.foreground,
    red = palette_github_dark.color_red,
    green = palette_github_dark.color_green,
    blue = palette_github_dark.color_blue,
    yellow = palette_github_dark.color_yellow,
    orange = palette_github_dark.color_orange,
    magenta = palette_github_dark.pink,
    grey = palette_github_dark.gray,
    transparent = 0x00000000,

    highlight_custom = palette_github_dark.alert_red,

    highlight_border = palette_github_dark.warning_orange,
    space_border_unselected = palette_github_dark.gray_dark,
    space_border_selected = palette_github_dark.warning_orange,

    bar = {
        bg = palette_github_dark.transparent,
        border = palette_github_dark.background_alt,

    },
    popup = {
        bg = palette_github_dark.background_focus,
        border = palette_github_dark.background_alt
    },
    bg1 = palette_github_dark.background_alt,
    bg2 = palette_github_dark.background_focus, -- bg2 = 0xff414550,

    with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then return color end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end,
}
