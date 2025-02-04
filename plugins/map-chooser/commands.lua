commands:Register("vote", function (playerid, args, argsCount, silent, prefix)
    local player = GetPlayer(playerid)
    if not player or not player:IsValid() then return end

    if not isvoteactive then
        return ReplyToCommand(playerid, config:Fetch("map-chooser.prefix"), FetchTranslation("map-chooser.cannotvote"))
    end

    if player:GetVar("voted") ~= nil then
        return ReplyToCommand(playerid, config:Fetch("map-chooser.prefix"), FetchTranslation("map-chooser.alreadyvoted"))
    end

    local option = args[1]
    local mplist = config:Fetch("map-chooser.maplist")

    if not mplist or type(mplist) ~= "table" then
        print("Error: Map List is not valid")
        return
    end

    if mplist[option] then
        if not mapVotes[option] then
            mapVotes[option] = 0
        end
        ReplyToCommand(playerid, config:Fetch("map-chooser.prefix"), FetchTranslation("map-chooser.voted"):gsub("{MAP}", mplist[option]))
        player:SetVar("voted", true)
        mapVotes[option] = mapVotes[option] + 1
        player:HideMenu()
    end
end)

commands:Register("nextmap", function (playerid, args, argsCount, silent, prefix)
    local player = GetPlayer(playerid)
    if not player or not player:IsValid() then return end

    player:SendMsg(MessageType.Console, "Next map: "..(nextMapName == "" and "None" or nextMapName))
    if playerid ~= -1 then
        ReplyToCommand(playerid, config:Fetch("map-chooser.prefix"), FetchTranslation("map-chooser.checkconsole"))
    end
end)
commands:RegisterRawAlias("nextmap", "nextmap")

commands:Register("rtv", function (playerid, args, argsCount, silent, prefix)
    local player = GetPlayer(playerid)
    if not player or not player:IsValid() then return end

    if wasRTV then return ReplyToCommand(playerid, config:Fetch("map-chooser.prefix"), FetchTranslation("map-chooser.alreadyrtv")) end

    rtvCount = rtvCount + 1
    local requiredPlayers = math.ceil(playermanager:GetPlayerCount() / 2)

    if rtvCount >= requiredPlayers then
        StartPlayersVote()
        wasRTV = true
    else
        return ReplyToCommand(playerid, config:Fetch("map-chooser.prefix"), FetchTranslation("map-chooser.rtv"):gsub("{COUNT}", rtvCount):gsub("{REQUIRED}", requiredPlayers))
    end
end)