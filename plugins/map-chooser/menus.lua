function RegisterMenus()
    local mplist = config:Fetch("map-chooser.maplist")
    
    if not mplist or type(mplist) ~= "table" then
        print("Error: maplist is not valid")
        return
    end

    local options = {}

    for mapid, mapname in next,mplist,nil do
        if mapname and mapname ~= "" and mapid and mapid ~= "" then
            table.insert(options, { mapname, "sw_vote ".. mapid})
        else
            print(string.format("Map \"%s\" (%s) is not valid", mapname or "", mapid or ""))
        end
    end

    menus:Register("chooser_menu", FetchTranslation("map-chooser.vote_title"), tostring(config:Fetch("map-chooser.color")), options)
end