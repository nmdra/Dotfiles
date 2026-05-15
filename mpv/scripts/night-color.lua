-- Global variable to store the initial state of night color
local night_color_was_enabled = false
local was_paused = false

-- Function to execute shell commands and capture output
local function execute_command(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result:match("^%s*(.-)%s*$")  -- Trim whitespace
end

-- Function to check if night color is currently enabled
local function is_night_color_enabled()
    local state = execute_command("qdbus org.kde.KWin /org/kde/KWin/NightLight org.kde.KWin.NightLight.running")
    return state == "true"
end

-- Function to toggle the night color state
local function toggle_night_color()
    os.execute('qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "Toggle Night Color"')
end

-- Function to check if the current file is audio-only (thx to : https://github.com/CogentRedTester/mpv-scripts/blob/05aee333a232e858dc3e54f973edfe392cefe13b/music-mode.lua#L54)
local function is_audio_file()
    local track_list = mp.get_property_native("track-list")
    for _, track in ipairs(track_list) do
        if track.type == "audio" then
            return true
        elseif not track.albumart and (track["demux-fps"] or 2) > 1 then
            return false  -- Contains video track
        end
    end
    return true  -- Default to true if only audio tracks are found
end

-- Function to handle night color state when playback starts
local function handle_night_color_on_start()
    if is_audio_file() then
        mp.osd_message("Audio file detected; night color state will remain unchanged")
        return
    end

    if is_night_color_enabled() then
        night_color_was_enabled = true
        toggle_night_color()
        mp.osd_message("Night color disabled for video playback")
    else
        night_color_was_enabled = false
    end
end

-- Function to restore night color state when playback stops or is paused
local function restore_night_color()
    if night_color_was_enabled and not is_night_color_enabled() then
        toggle_night_color()
        mp.osd_message("Night color restored")
    end
end

-- Function to handle night color when playback is paused or resumed
local function handle_pause_change(_, is_paused)
    if is_paused then
        was_paused = true
        restore_night_color()  -- Restore when paused if necessary
    elseif not is_paused and not is_audio_file() then  -- Playback is resumed and it's a video file
        if was_paused and night_color_was_enabled then
            toggle_night_color()  -- Re-disable night color on resume if it was initially active
            mp.osd_message("Night color disabled again on video resume")
            was_paused = false  -- Reset pause flag after handling resume
        end
    end
end

-- Bind functions to appropriate mpv events
mp.register_event("file-loaded", handle_night_color_on_start)
mp.observe_property("pause", "bool", handle_pause_change)
mp.register_event("end-file", restore_night_color)
mp.register_event("close-window", restore_night_color)
