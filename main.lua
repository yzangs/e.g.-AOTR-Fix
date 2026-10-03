if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- V2 Double execution check with pcall
do
    local g = (getgenv and getgenv()) or _G or {}
    if g.MahmutHubLoaded then
        warn("Mahmut Hub | already running")
        return
    end
    g.MahmutHubLoaded = true
end

-- Smooth execution delay to prevent mobile crash
task.wait(2)

print("[AOTR-Mobile] Checking game support...")

local HttpService = game:GetService("HttpService")
local placeId = game.PlaceId

-- Safe UniverseID Fetching
local successUniverse, UniverseID = pcall(function()
    local response = game:HttpGet("https://apis.roblox.com/universes/v1/places/" .. placeId .. "/universe")
    return HttpService:JSONDecode(response).universeId
end)

if not successUniverse or not UniverseID then
    warn("[AOTR-Mobile] Failed to fetch UniverseID safely.")
    return
end

-- Supported Games Table
local supportedGames = {
    [9186719164] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/SailorPiece/production/main.lua",
    [1281592938] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/EntrenchedWW1/production/main.lua",
    [7633926880] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/BloxStrike/production/main.lua",
    [10004244222] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/KickALuckyBlock/production/main.lua",
    [9967681734] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/TebakLagu/production/main.lua",
    [6931042565] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/VBL/production/main.lua",
    [4658598196] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/AOTR/production/main.lua",
}

if supportedGames[UniverseID] then 
    print("[AOTR-Mobile] Game supported! Loading script safely...")

    -- Safe execution via pcall and task.spawn
    task.spawn(function()
        local fetchSuccess, scriptContent = pcall(function()
            return game:HttpGet(supportedGames[UniverseID])
        end)

        if fetchSuccess and scriptContent then
            local execSuccess, execError = pcall(function()
                local loadedFunc = loadstring(scriptContent)
                if loadedFunc then
                    loadedFunc()
                end
            end)
            
            if not execSuccess then
                warn("[AOTR-Mobile] Script execution failed:", execError)
            end
        else
            warn("[AOTR-Mobile] Failed to fetch target game script.")
        end
    end)
else
    warn("[AOTR-Mobile] Unsupported game. UniverseID:", UniverseID)
end
