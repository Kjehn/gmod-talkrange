/*
    Addon Creator: K3hn <https://steamcommunity.com/profiles/76561198133952329>
*/

concommand.Add("talkmode_change",function(ply,cmd,args)
    if (LocalPlayer().LastTalkModeChange or 0) + .55 > CurTime() then chat.AddText("Sprachreichweite änderung fehlgeschlagen!") return end
    LocalPlayer().LastTalkModeChange = CurTime()
    --  Prevent spaming
    local mode = ""
    if args[1] == "whisper" then
        LocalPlayer():SetTalkRange(K3hn.RadioSystem.WhisperRange)
        mode = K3hn.RadioSystem.WhisperRangeText
    elseif args[1] == "talk" then
        LocalPlayer():SetTalkRange(K3hn.RadioSystem.TalkRange)
        mode = K3hn.RadioSystem.TalkRangeText
    elseif args[1] == "yell" then
        LocalPlayer():SetTalkRange(K3hn.RadioSystem.YellRange)
        mode = K3hn.RadioSystem.YellRangeText
    else
        local range = LocalPlayer():GetTalkRange()
        if range == K3hn.RadioSystem.WhisperRange then
            LocalPlayer():SetTalkRange(K3hn.RadioSystem.TalkRange)
            mode = K3hn.RadioSystem.TalkRangeText
        elseif range == K3hn.RadioSystem.TalkRange then
            LocalPlayer():SetTalkRange(K3hn.RadioSystem.YellRange)
            mode = K3hn.RadioSystem.YellRangeText
        elseif range == K3hn.RadioSystem.YellRange then
            LocalPlayer():SetTalkRange(K3hn.RadioSystem.WhisperRange)
            mode = K3hn.RadioSystem.WhisperRangeText
        end
    end
    local chatmsg = K3hn.RadioSystem.TalkModeChange
    chatmsg = string.Replace(chatmsg,"%mode%",mode)

    chat.AddText(K3hn.RadioSystem.TalkModePrefixclr,K3hn.RadioSystem.TalkModePrefix,Color(255,255,255)," ",chatmsg)
end)

net.Receive("Funk.SendMessage", function(len, sender)
        if sender then return end
        local msg = net.ReadTable()

        local chatmsg = K3hn.RadioSystem.ChatMessage
        chatmsg = string.Replace(chatmsg,"%sender%",msg[1]:Name())
        chatmsg = string.Replace(chatmsg,"%target%",msg[2])
        chatmsg = string.Replace(chatmsg,"%msg%",msg[3])

        chat.AddText(K3hn.RadioSystem.prefixclr,K3hn.RadioSystem.prefixmsg,K3hn.RadioSystem.chatclr," ",chatmsg)
end)

hook.Add("HUDPaint","DrawTalkRange", function()
    surface.SetDrawColor(44,44,44,200)
    surface.DrawRect(ScrW()*.5-20, ScrH()-40,85,40)
    
    surface.SetDrawColor(22,22,22,255)
    surface.DrawRect(ScrW()*.5-15,ScrH()-35, 10,30)

    surface.DrawRect(ScrW()*.5,ScrH()-35, 10,30)
    
    surface.DrawRect(ScrW()*.5+15,ScrH()-35, 10,30)
end)