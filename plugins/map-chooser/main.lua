AddEventHandler("OnMapLoad", function (event)
    isvoteactive = false
    nextMapID = ""
    nextMapName = ""
    wasRTV = false
    wasVote = false
    return EventResult.Continue
end)

AddEventHandler("OnPluginStart", function (event)
    RegisterMenus()
    return EventResult.Continue
end)

AddEventHandler("OnRoundPrestart", function (event)
    local gamerules = GetCCSGameRules()
    if gamerules.TotalRoundsPlayed == config:Fetch("map-chooser.VoteAfterRound") then
        wasVote = true
        StartPlayersVote()
    end

    return EventResult.Continue
end)

AddEventHandler("OnCsWinPanelMatch", function(event)
    SetTimeout(2000, function ()
        if nextMapID == "" then return end
        server:ChangeMap(nextMapID, tostring(tonumber(nextMapID)) == nextMapID)
    end)
    return EventResult.Continue
end)