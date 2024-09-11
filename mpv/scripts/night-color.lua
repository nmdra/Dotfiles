-- mpv script to manage the state of night color
-- Based On following gist
-- https://gist.github.com/Zharkan/5f65ff9b1da85b2a2c79b777ed9e6199

-- Global variable to store the initial state of night color
local night_color_was_enabled = false

-- Function to execute shell commands and capture output
function execute_command(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	return result
end

-- Function to check the current state of night color
function is_night_color_enabled()
	local cmd_get_state = "qdbus org.kde.KWin /org/kde/KWin/NightLight org.kde.KWin.NightLight.running"
	local state = execute_command(cmd_get_state):gsub("%s+", "") -- Remove any extra whitespace
	mp.osd_message("Night color is " .. state)
	return state == "true"
end

-- Function to toggle night color state
function toggle_night_color()
	local cmd_toggle =
		'qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "Toggle Night Color"'
	os.execute(cmd_toggle)
end

-- Check and manage night color state when mpv starts
function manage_night_color_on_start()
	if is_night_color_enabled() then
		night_color_was_enabled = true
		toggle_night_color()
		mp.osd_message("Night color disabled")
	else
		night_color_was_enabled = false
	end
end

-- Restore night color state when mpv ends
function restore_night_color_on_end()
	if night_color_was_enabled then
		toggle_night_color()
		mp.osd_message("Night color enabled")
	end
end

-- Bind functions to appropriate mpv events
mp.register_event("start-file", manage_night_color_on_start)
mp.register_event("end-file", restore_night_color_on_end)
mp.register_event("idle", restore_night_color_on_end)
