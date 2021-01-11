Config = {}

Config.Enabled          = true      -- Enable / disable

-- Text Options
Config.Font             = 4         -- Font family (https://gtaforums.com/topic/794014-fonts-list/)
Config.Scale            = 0.38      -- Font size

-- Box Dimensions
Config.Width            = 0.145     -- Box width
Config.Spacing          = 0.005     -- Box margin / seperation
Config.Padding          = 0.006

Config.Queue            = 5         -- Message queue limit
Config.FilterDuplicates = true      -- Enable / disable filtering of duplicate notifications
Config.Animation        = true      -- Enable / disable animation

Config.Sound            = { -1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1 }

Config.Position         = "bottomLeft"      -- Position

-- Message Positions
Config.Positions = { -- https://github.com/Mobius1/FeedM#positioning
    bottomLeft      = { x = 0.115,  y = 0.65 },
    bottomRight     = { x = 0.815,  y = 0.68 },
    topLeft         = { x = 0.085,  y = 0.02 },
    topRight        = { x = 0.915,  y = 0.02 },
    bottomCenter    = { x = 0.500,  y = 0.98 }    
}

-- Message Types
Config.Types = {
    primary = { r = 0,      g = 0,      b = 0,      a = 180 },
    success = { r = 100,    g = 221,    b = 23,     a = 180 },
    warning = { r = 255,    g = 196,    b = 0,      a = 180 },
    danger  = { r = 211,    g = 47,     b = 47,     a = 180 },
    info  = { r = 3,    g = 248,     b = 252,     a = 180 },
}