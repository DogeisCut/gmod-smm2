COINCOUNTER = {}

if CLIENT then
print("coinUI.lua loaded!")

LocalPlayer().CoinCount = 0

surface.CreateFont( "coincounter_64", {
    font = "Roboto",
    size = 64,
    weight = 1000,
    outline = true,
})

local panel_color = Color(0,0,0,128)

function COINCOUNTER.Open()
    local scrw, scrh = ScrW(), ScrH()
    timer.Create( "coincounter_popuptime", 3, 1, COINCOUNTER.Close)
    if IsValid(COINCOUNTER.Menu) then
        return
    end
    COINCOUNTER.Menu = vgui.Create("DPanel")
    COINCOUNTER.Menu:DockPadding(10, 10, 10, 10)
    local coinimage = COINCOUNTER.Menu:Add("DImage")
    coinimage:Dock(LEFT)
    coinimage:SetImage("vgui/coin.vmt", "vgui/avatar_default")
    local label = COINCOUNTER.Menu:Add("DLabel")
    label:Dock(FILL)
    label:SetFont("coincounter_64")
    label:SetText(" ✕ "..tostring(LocalPlayer().CoinCount))
    label:SetTextColor(color_white)
    COINCOUNTER.Menu:SetBackgroundColor(color_transparent)
    COINCOUNTER.Menu:Show(true)
    COINCOUNTER.Menu:SetSize(scrw, 74)
    COINCOUNTER.Menu:SetPos(0,-74)
    COINCOUNTER.Menu:MoveTo(0,0,1,0,0.5,function()end)
end

function COINCOUNTER.Close()
    if IsValid(COINCOUNTER.Menu) then
        COINCOUNTER.Menu:SetPos(0,0)
        COINCOUNTER.Menu:MoveTo(0,-74,1,0,2,function()
            COINCOUNTER.Menu:Remove()
        end) 
    end
end

concommand.Add("coincounter_popin", COINCOUNTER.Open)
concommand.Add("coincounter_popout", COINCOUNTER.Close)
end
if SERVER then
    

end

