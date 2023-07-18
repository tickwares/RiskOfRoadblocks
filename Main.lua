local p = game.Players
local lp = p.LocalPlayer
local requests = game.ReplicatedStorage.Requests

function getplayer(name)
    local plrs = {}
    if name == "" then return {} end
    if name == "all" then
        for i,v in pairs(p:GetPlayers()) do
            table.insert(plrs,v)
        end
    elseif name == "others" then
        for i,v in pairs(p:GetPlayers()) do
            if v.Name ~= lp.Name then
                table.insert(plrs,v)
            end
        end
    elseif name == "me" then
        return {lp}
    else
        for i,v in pairs(p:GetPlayers()) do
            if (v.Name:lower():match(name:lower()) or v.DisplayName:lower():match(name:lower())) then
                table.insert(plrs,v)
            end
        end
    end
    return plrs
end

function getinput(plr)
    return plr.Backpack:FindFirstChild("Input")
end

local oneshottoggle = false
local customdmgtoggle = false
local customdmgval = 0

local hook;hook = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if (self.Name == "Input" and args[1] == "LightAttack" and args[3] ~= "syn" and method == "FireServer") then
        if oneshottoggle then
            args[2] = 99
        end
        if customdmgtoggle then
            args[2] = customdmgval
        end
    end
    return hook(self, unpack(args))
end)

local Iris=loadstring(game:HttpGet("https://raw.githubusercontent.com/x0581/Iris-Exploit-Bundle/2.0.4/bundle.lua"))().Init(game.CoreGui)
Iris:Connect(function()
    local Window = Iris.Window({"Risk Of Roadblocks",false,false,true,false,true,false,true},{size=Iris.State(Vector2.new(1032,574)),position = Iris.State(Vector2.new(245,25))})
        Iris.Tree{"Local"}
            Iris.Tree{"Data Changer"}
                Iris.Tree{"Enchant List"}
                    for i,v in pairs(game.ReplicatedStorage.Assets.VFX.Enchants:GetChildren()) do
                        Iris.Text{v.Name.." - "..v:GetAttribute('Rarity')}
                    end
                Iris.End()
                Iris.Tree{"Weapon List"}
                    for i,v in pairs(game.ReplicatedStorage.Assets.Weapons:GetChildren()) do
                        Iris.Text{v.Name.." - "..v:GetAttribute('WeaponCategory')}
                    end
                Iris.End()
                local Attributes = lp.Data:GetAttributes()
                for i,v in pairs(Attributes) do
                    Iris.SameLine()
                        Iris.Text{tostring(i)}
                        Iris.Text{tostring(v)}
                        local value
                        if typeof(v) == "boolean" then
                            value = Iris.Checkbox{""}.isChecked.value
                        elseif typeof(v) == "number" then
                            value = Iris.InputNum{""}.number.value
                            if Iris.Button{"Add"}.clicked() then
                                requests.GeneralEvent:FireServer("SaveLoadout",{[tostring(i)] = tonumber(v+value)})
                            end
                            if Iris.Button{"Subtract"}.clicked() then
                                requests.GeneralEvent:FireServer("SaveLoadout",{[tostring(i)] = tonumber(v-value)})
                            end
                        else
                            value = Iris.InputText{"","Value"}.text.value
                        end
                        if Iris.Button{"Set Value"}.clicked() then
                            if typeof(v) == "number" then
                                requests.GeneralEvent:FireServer("SaveLoadout",{[tostring(i)] = tonumber(value)})
                            elseif typeof(v) == "string" then
                                requests.GeneralEvent:FireServer("SaveLoadout",{[tostring(i)] = tostring(value)})
                            end
                        end
                    Iris.End()
                end
            Iris.End()
            Iris.Tree{"Main"}
                local input = getinput(lp)
                local oneshot = Iris.Checkbox{"Oneshot M1s (Can be twoshot at some point)"}.isChecked.value
                local nocd = Iris.Checkbox{"No M1s Cooldown"}.isChecked.value
                local noccd = Iris.Checkbox{"No Critical Cooldown"}.isChecked.value
                local nosc = Iris.Checkbox{"No Speed Controller"}.isChecked.value
                local cad = Iris.Checkbox{"Can Always Dash"}.isChecked.value
                local cas = Iris.Checkbox{"Can Always Slide"}.isChecked.value
                local caj = Iris.Checkbox{"Can Always Jump"}.isChecked.value
                local nos = Iris.Checkbox{"No Stun"}.isChecked.value
                local acis = Iris.Checkbox{"Allow Combat In Shrine"}.isChecked.value
                local aoc = Iris.Checkbox{"Always Out Of Combat"}.isChecked.value
                local tcd = Iris.Checkbox{"Custom M1 Damage Toggle"}.isChecked.value
                local customdmg = Iris.InputNum{"Custom M1 Damage"}
                Iris.Text{"If value is higher than or equal to HP then it wont register as a kill"}
                customdmgtoggle = tcd
                customdmgval = customdmg
                oneshottoggle = oneshot
                if oneshot then
                    if (lp.Character and lp.Character:FindFirstChild("StatusFolder")) then
                        if lp.Character.StatusFolder:FindFirstChild("Attacking") then
                            input:FireServer("LightAttack",1,"syn")
                            lp.Character.StatusFolder.Attacking:Destroy()
                        end
                    end
                end
                if nocd then
                    if (lp.Character and lp.Character:FindFirstChild("StatusFolder")) then
                        if lp.Character.StatusFolder:FindFirstChild("AttackingCD") then
                            lp.Character.StatusFolder.AttackingCD:Destroy()
                        end
                    end
                end
                if noccd then
                    if (lp.Character and lp.Character:FindFirstChild("StatusFolder")) then
                        if lp.Character.StatusFolder:FindFirstChild("CriticalCD") then
                            lp.Character.StatusFolder.CriticalCD:Destroy()
                        end
                    end
                end
                if nosc then
                    if (lp.Character and lp.Character:FindFirstChild("StatusFolder")) then
                        if lp.Character.StatusFolder:FindFirstChild("AdjustSpeed") then
                            lp.Character.StatusFolder.AdjustSpeed:Destroy()
                        end
                    end
                end
                if cad then
                    if (lp.Character and lp.Character:FindFirstChild("StatusFolder")) then
                        if lp.Character.StatusFolder:FindFirstChild("DashCD") then
                            lp.Character.StatusFolder.DashCD:Destroy()
                        end
                        if lp.Character.StatusFolder:FindFirstChild("NoDash") then
                            lp.Character.StatusFolder.NoDash:Destroy()
                        end
                    end
                end
                if cas then
                    if (lp.Character and lp.Character:FindFirstChild("StatusFolder")) then
                        if lp.Character.StatusFolder:FindFirstChild("SlidingCD") then
                            lp.Character.StatusFolder.SlidingCD:Destroy()
                        end
                    end
                end
                if caj then
                    if (lp.Character and lp.Character:FindFirstChild("StatusFolder")) then
                        if lp.Character.StatusFolder:FindFirstChild("NoJump") then
                            lp.Character.StatusFolder.NoJump:Destroy()
                        end
                    end
                end
                if aoc then
                    if (lp.Character and lp.Character:FindFirstChild("StatusFolder")) then
                        if lp.Character.StatusFolder:FindFirstChild("InCombat") then
                            lp.Character.StatusFolder.InCombat:Destroy()
                        end
                    end
                end
                if nos then
                    if (lp.Character and lp.Character:FindFirstChild("StatusFolder")) then
                        if lp.Character.StatusFolder:FindFirstChild("Stunned") then
                            lp.Character.StatusFolder.Stunned:Destroy()
                        end
                        if lp.Character.StatusFolder:FindFirstChild("Ragdolled") then
                            lp.Character.StatusFolder.Ragdolled:Destroy()
                        end
                    end
                end
                lp:SetAttribute("InShrine",acis)
            Iris.End()
        Iris.End()
        Iris.Tree{"Players"}
            local value = Iris.InputText{"","User/all/others/me"}.text.value
            if Iris.Button{"Kill"}.clicked() then
                local plr = getplayer(value)
                for i,v in pairs(plr) do
                    local input = getinput(v)
                    input:FireServer("MusashiRush",workspace.Map.Perm.ReturnBrick.Position)
                end
            end
            local xyzval = Iris.InputVector3{"XYZ"}.number.value
            if Iris.Button{"Teleport"}.clicked() then
                local plr = getplayer(value)
                for i,v in pairs(plr) do
                    local input = getinput(v)
                    input:FireServer("MusashiRush",xyzval)
                end
            end
            Iris.SameLine()
                if Iris.Button{"Punish (May not work sometimes)"}.clicked() then
                    local plr = getplayer(value)
                    for i,v in pairs(plr) do
                        local input = getinput(v)
                        input:FireServer("MusashiRush",Vector3.new(500,-10000,500))
                    end
                end
                if Iris.Button{"Self Unpunish"}.clicked() then
                    requests.GeneralFunction:InvokeServer("LoadCharacter")
                end
            Iris.End()
            Iris.SameLine()
                if Iris.Button{"Give Musashi Blade"}.clicked() then
                    local plr = getplayer(value)
                    for i,v in pairs(plr) do
                        local input = getinput(v)
                        input:FireServer("Musashi","Blade")
                    end
                end
                if Iris.Button{"Give Musashi Arm"}.clicked() then
                    local plr = getplayer(value)
                    for i,v in pairs(plr) do
                        local input = getinput(v)
                        input:FireServer("Musashi","Arm")
                    end
                end
            Iris.End()
        Iris.End()
    Iris.End()
    if Window.isOpened.value == false then
        Iris.Checkbox({"Open"}, {isChecked = Window.isOpened})
    end
end)
