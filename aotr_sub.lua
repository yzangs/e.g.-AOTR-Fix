-- Safe Mobile Loader for AOTR Production
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Wait until localplayer is fully loaded in map
repeat task.wait(1) until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

-- Safe delay for Android graphics/RAM stabilization
task.wait(5)

print("[AOTR-Fix] Loading main AOTR production script...")

-- Safely fetch and execute the sub-script
pcall(function()
    local scriptData = game:HttpGet("https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/AOTR/production/main.lua")
    if scriptData then
        local loaded, err = loadstring(scriptData)
        if loaded then
            task.spawn(loaded)
        else
            warn("[AOTR-Fix] Loadstring error:", err)
        end
    end
end)
