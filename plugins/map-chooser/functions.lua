--- @param player Player
function StartVote(player)
    isvoteactive = true
    player:ShowMenu("chooser_menu")
    ReplyToCommand(player:GetSlot(), config:Fetch("map-chooser.prefix"), FetchTranslation("map-chooser.votemap"))
    ReplyToCommand(player:GetSlot(), config:Fetch("map-chooser.prefix"), FetchTranslation("map-chooser.votemap"))
    ReplyToCommand(player:GetSlot(), config:Fetch("map-chooser.prefix"), FetchTranslation("map-chooser.votemap"))

    SetTimeout(10000, function ()
        player:HideMenu()
    end)
end

function StopVote()
    isvoteactive = false

    local mostvotes, totalVotes = GetMapWinner()

    for i = 1, playermanager:GetPlayerCap() do
        local player = GetPlayer(i-1)
        if player and player:IsValid() then
            player:HideMenu()
            player:SetVar("voted", true)
            ReplyToCommand(i-1, config:Fetch("map-chooser.prefix"), FetchTranslation("map-chooser.mapwon"):gsub("{MAP_NAME}", nextMapName):gsub("{VOTES}", mostvotes):gsub("{PRECENTAGE}", (mostvotes * 100) / totalVotes))
        end
    end

    if not wasVote then
        SetTimeout(15000, function ()
            if nextMapID == "" then return end
            server:ChangeMap(nextMapID, tostring(tonumber(nextMapID)) == nextMapID)
        end)
    end
end

function GetMapWinner()
    local mplist = config:Fetch("map-chooser.maplist")
    if not mplist or type(mplist) ~= "table" then
        print("Error: maplist is not valid")
        return
    end

    local mostvotes = 0
    local totalVotes = 0

    for mapid, mapname in next,mplist,nil do
        local votes = mapVotes[mapid] or 0
        totalVotes = totalVotes + votes
        if votes > mostvotes then
            nextMapID = mapid
            nextMapName = mapname
            mostvotes = votes
        end
    end

    if nextMapID == "" then
        nextMapID, nextMapName = next(mplist, nil)
    end

    return mostvotes, totalVotes

end

function StartPlayersVote()
    rtvCount = 0

    for i = 1, playermanager:GetPlayerCap() do
        local player = GetPlayer(i-1)
        if player and player:IsValid() then
            StartVote(player)
        end
    end

    SetTimeout(10000, function ()
        StopVote()
    end)
end
