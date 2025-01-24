-- Define the path to the file where the volume will be saved
-- This file is stored in the user's home directory under `.config/mpv/`
local settings_file = os.getenv("HOME") .. "/.config/mpv/settings/volume.txt"

-- Set a default volume in case no saved volume is found
local volume = 100 -- Default is 100% volume

-- Function to read the saved volume from the file
local function load_volume()
    -- Open the settings file in read mode
    local file = io.open(settings_file, "r")
    if file then
        -- Read the entire content of the file
        local saved_volume = tonumber(file:read("*all"))
        -- Close the file after reading
        file:close()
        -- If the file contains a valid number, set it as the volume
        if saved_volume then
            volume = saved_volume
        end
    end
end

-- Function to save the current volume to the file
local function save_volume()
    -- Open the settings file in write mode (overwrites the file)
    local file = io.open(settings_file, "w")
    if file then
        -- Write the current volume (retrieved from MPV) to the file
        file:write(tostring(mp.get_property("volume")))
        -- Close the file after writing
        file:close()
    end
end

-- Load the saved volume from the file when MPV starts
load_volume()
-- Apply the loaded volume to the MPV player
mp.set_property("volume", volume)

-- Set up a listener for volume changes
-- This triggers whenever the volume property changes
mp.observe_property("volume", "native", function(_, value)
    -- Save the updated volume to the file
    save_volume()
end)
