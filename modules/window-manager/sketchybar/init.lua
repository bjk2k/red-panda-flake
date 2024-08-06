-- Require the sketchybar module
--

-- Write to logfile /tmp/ketchybar_lua_bjk2k_.log
os.execute("echo 'sketchybar [in]' >> /tmp/sketchybar_lua_bjk2k_.log")

sbar = require("sketchybar")


-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
require("bar")
require("default")
require("items")
sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
