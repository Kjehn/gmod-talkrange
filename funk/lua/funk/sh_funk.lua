/*
    Addon Creator: K3hn <https://steamcommunity.com/profiles/76561198133952329>
*/

local meta = FindMetaTable("Player")
function meta:IsRadioEnabled()
    return self:GetNWBool("K3hn.RadioStatus",false)
end
function meta:RadioChanel()
    return self:GetNWString("K3hn.RadioChanel","")
end
function meta:GetTalkRange()
    return self:GetNWInt("K3hn.TalkRange",K3hn.RadioSystem.TalkRange)
end
function meta:SetTalkRange(n,bool)
    if CLIENT then
        if K3hn.RadioSystem.WhisperRange != n && K3hn.RadioSystem.TalkRange != n && K3hn.RadioSystem.YellRange != n then return end
        net.Start("Funk.ChangeTalkMode")
            net.WriteString(tostring(n))
        net.SendToServer()
    end

    self:SetNWInt("K3hn.TalkRange",n)
end
function meta:SetRadioChanel(chanel)
    self:SetNWString("K3hn.RadioChanel",tostring(chanel))
end
function meta:EnableRadio(bool)
    self:SetNWBool("K3hn.RadioStatus",tobool(bool))
end