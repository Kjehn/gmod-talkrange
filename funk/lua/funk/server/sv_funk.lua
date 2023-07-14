/*
    Addon Creator: K3hn <https://steamcommunity.com/profiles/76561198133952329>
*/


/*
FunkTable
1 = Sender als Entity
2 = Empfänger als String
3 = Nachricht als String
*/
util.AddNetworkString("Funk.SendMessage")
util.AddNetworkString("Funk.ChangeTalkMode")

local meta = FindMetaTable("Player")
function meta:SendFunk(tbl)
    if #tbl < 3 or tbl[3] == "" then return end
    net.Start("Funk.SendMessage")
        net.WriteTable(tbl)
    net.Send(self)
end

net.Receive("Funk.ChangeTalkMode", function(len,ply)
    local range = tonumber(net.ReadString())
    if (ply.LastTalkModeChange or 0) + .5 > CurTime() then return end
    ply.LastTalkModeChange = CurTime()
    ply:SetTalkRange(range)
end)

hook.Add("PlayerSay","FunkOnPlayerSay",function (ply, txt)
    local tbl = string.Explode(" ",txt) -- String => Table

    -- Schaut of Funk Befehl genutzt wurde
    if tbl[1] == K3hn.RadioSystem.cmd || tbl[1] == K3hn.RadioSystem.category_cmd then
        local funktbl = {}
        funktbl[1] = ply
        if #tbl <= 1 then return txt end
        
        if tbl[1] == K3hn.RadioSystem.cmd then
            funktbl[2] = tbl[2]
            funktbl[3] = table.concat(tbl, " ", 3,#tbl) -- Nachricht => Funktable
            for _,tar in pairs(player.GetHumans()) do -- Loop von allen Spieler um Distanz zu checken
                if tar != ply then -- Wenn gefundener Spieler mit Absender nicht übereinstimmen
                    if  tar:GetPos():Distance(ply:GetPos()) <= K3hn.RadioSystem.range || tbl[2] == tar:getJobTable().category then -- Schaut nach Distanz
                        tar:SendFunk(funktbl)
                    end
                end
            end
        elseif tbl[1] == K3hn.RadioSystem.category_cmd then
            funktbl[2] = ply:getJobTable().category
            funktbl[3] = table.concat(tbl, " ", 2,#tbl) -- Nachricht => Funktable
            for _,tar in pairs(player.GetHumans()) do -- Loop von allen Spieler um Distanz zu checken
                if tar != ply then -- Wenn gefundener Spieler mit Absender nicht übereinstimmen
                    if  tar:GetPos():Distance(ply:GetPos()) <= K3hn.RadioSystem.range || ply:getJobTable().category == tar:getJobTable().category then -- Schaut nach Distanz
                        tar:SendFunk(funktbl)
                    end
                end
            end

        end

        ply:SendFunk(funktbl)
        return ""
    end
end)

hook.Add("PlayerCanHearPlayersVoice","TalkRanges", function(tar,ply)
    if ply == tar then return end
    if ply:GetPos():Distance(tar:GetPos()) <= ply:GetTalkRange() then
        return true, K3hn.RadioSystem.TalkModeAudio or true
    end
    if ply:IsRadioEnabled() && tar:IsRadioEnabled() then
        if ply:RadioChanel() == tar:RadioChanel() then
            return true, false
        end
    end
end)