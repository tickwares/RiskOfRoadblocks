local p = game.Players
local lp = p.LocalPlayer
local requests = game.ReplicatedStorage.Requests
local UIS = game:GetService('UserInputService')

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

function getevasive()
    local evasive
    for i,v in pairs(lp.Backpack:GetDescendants()) do
        if (v:IsA("StringValue") and v.Value == "Evasive") then
            evasive = v.Parent
        end
    end
    for i,v in pairs(lp.Character:GetDescendants()) do
        if (v:IsA("StringValue") and v.Value == "Evasive") then
            evasive = v.Parent
        end
    end
    return evasive
end

local oneshottoggle = false
local customdmgtoggle = false
local customdmgval = 0
local noheavy

local hook;hook = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if (self.Name == "Input" and args[1] == "HeavyAttack" and method == "FireServer") then
        if noheavy then
            args[1] = "LightAttack"
        end
    end
    if (self.Name == "Input" and args[1] == "LightAttack" and args[3] ~= "syn" and method == "FireServer") then
        if oneshottoggle then
            args[2] = 99
        end
        if customdmgtoggle then
            args[2] = tonumber(customdmgval)
        end
    end
    return hook(self, unpack(args))
end)

local Updates = [[
    - Added Loadout Editor (Found in Local)
    - Added Weapon/Skills Replacer (Found in Local)
    - Added a toggle for GUI (Press 0 to toggle as right control is broken)
    - Added No Heavy M1 Knockback
]]
local split = Updates:split("\n")
table.remove(split,#split)

local Window

local Iris=loadstring(game:HttpGet("https://raw.githubusercontent.com/x0581/Iris-Exploit-Bundle/2.0.4/bundle.lua"))().Init(game.CoreGui)
Iris:Connect(function()
    Window = Iris.Window({"Risk Of Roadblocks",false,false,true,false,true,false,true},{size=Iris.State(Vector2.new(1032,574)),position = Iris.State(Vector2.new(245,25))})
        Iris.Tree{"Updates (New features added)"}
            table.foreach(split,function(i,v)
                Iris.Text{v}
            end)
        Iris.End()
        Iris.Tree{"Local"}
            Iris.Tree{"Enchant List"}
                for i,v in pairs(game.ReplicatedStorage.Assets.VFX.Enchants:GetChildren()) do
                    Iris.Text{v.Name.." (Rarity: "..v:GetAttribute('Rarity')..")"}
                end
            Iris.End()
            Iris.Tree{"Weapon List"}
                for i,v in pairs(game.ReplicatedStorage.Assets.Weapons:GetChildren()) do
                    Iris.Text{v.Name}
                end
            Iris.End()
            Iris.Tree{"Evasive List"}
                for i,v in pairs(game.ReplicatedStorage.Assets.Tools.Evasive:GetChildren()) do
                    Iris.Text{v.Name}
                end
            Iris.End()
            Iris.Tree{"Skills List"}
                for i,v in pairs(game.ReplicatedStorage.Assets.Tools.Skills:GetChildren()) do
                    Iris.Text{v.Name}
                end
            Iris.End()
            Iris.Tree{"Loadout Editor"}
                Iris.Table({1, [Iris.Args.Table.RowBg] = true})
                    Iris.Text{"Loadout Weapon"}
                    Iris.Text{lp.Data:GetAttribute("LoadoutWeapon")}
                    Iris.SameLine()
                        local val = Iris.InputText{"","Weapon Name"}.text.value
                        if Iris.Button{"Set"}.clicked() then
                            requests.GeneralEvent:FireServer("SaveLoadout",{LoadoutWeapon=val})
                        end
                    Iris.End()
                    Iris.NextColumn()
                    Iris.Text{"Loadout Skill 1"}
                    Iris.Text{lp.Data:GetAttribute("LoadoutSkill1")}
                    Iris.SameLine()
                        local val = Iris.InputText{"","Skill Name"}.text.value
                        if Iris.Button{"Set"}.clicked() then
                            requests.GeneralEvent:FireServer("SaveLoadout",{LoadoutSkill1=val})
                        end
                    Iris.End()
                    Iris.NextColumn()
                    Iris.Text{"Loadout Skill 2"}
                    Iris.Text{lp.Data:GetAttribute("LoadoutSkill2")}
                    Iris.SameLine()
                        local val = Iris.InputText{"","Skill Name"}.text.value
                        if Iris.Button{"Set"}.clicked() then
                            requests.GeneralEvent:FireServer("SaveLoadout",{LoadoutSkill2=val})
                        end
                    Iris.End()
                    Iris.NextColumn()
                    Iris.Text{"Loadout Skill 3"}
                    Iris.Text{lp.Data:GetAttribute("LoadoutSkill3")}
                    Iris.SameLine()
                        local val = Iris.InputText{"","Skill Name"}.text.value
                        if Iris.Button{"Set"}.clicked() then
                            requests.GeneralEvent:FireServer("SaveLoadout",{LoadoutSkill3=val})
                        end
                    Iris.End()
                    Iris.NextColumn()
                    Iris.Text{"Loadout Evasive"}
                    Iris.Text{lp.Data:GetAttribute("LoadoutEvasive")}
                    Iris.SameLine()
                        local val = Iris.InputText{"","Evasive Name"}.text.value
                        if Iris.Button{"Set"}.clicked() then
                            requests.GeneralEvent:FireServer("SaveLoadout",{LoadoutEvasive=val})
                        end
                    Iris.End()
                Iris.End()
                local cost = 0
                local weapon = lp.Data:GetAttribute("LoadoutWeapon")
                local skill = lp.Data:GetAttribute("LoadoutSkill1")
                local skill1 = lp.Data:GetAttribute("LoadoutSkill2")
                local skill2 = lp.Data:GetAttribute("LoadoutSkill2")
                local evasive = lp.Data:GetAttribute("LoadoutEvasive")
                if game.ReplicatedStorage.Assets.Weapons:FindFirstChild(weapon) then
                    local newweap = game.ReplicatedStorage.Assets.Weapons[weapon]
                    cost += newweap:GetAttribute("TokenCost")
                end
                if game.ReplicatedStorage.Assets.Tools.Skills:FindFirstChild(skill) then
                    local newweap = game.ReplicatedStorage.Assets.Tools.Skills[skill]
                    cost += newweap:GetAttribute("TokenCost")
                end
                if game.ReplicatedStorage.Assets.Tools.Skills:FindFirstChild(skill1) then
                    local newweap = game.ReplicatedStorage.Assets.Tools.Skills[skill1]
                    cost += newweap:GetAttribute("TokenCost")
                end
                if game.ReplicatedStorage.Assets.Tools.Skills:FindFirstChild(skill2) then
                    local newweap = game.ReplicatedStorage.Assets.Tools.Skills[skill2]
                    cost += newweap:GetAttribute("TokenCost")
                end
                if game.ReplicatedStorage.Assets.Tools.Evasive:FindFirstChild(evasive) then
                    local newweap = game.ReplicatedStorage.Assets.Tools.Evasive[evasive]
                    cost += newweap:GetAttribute("TokenCost")
                end
                Iris.Text{"Total cost: "..tostring(cost)}
                if Iris.Button{"Buy current loadout with current tokens"}.clicked() then
                    requests.GeneralEvent:FireServer("SummonLoadout")
                end
                if Iris.Button{"Buy current loadout without tokens"}.clicked() then
                    requests.GeneralEvent:FireServer("SaveLoadout",{Tokens=(lp.Data:GetAttribute("Tokens")+cost)})
                    requests.GeneralEvent:FireServer("SummonLoadout")
                end
            Iris.End()
            Iris.Tree{"Weapon/Skill/Enchant Replacer"}
                Iris.SameLine()
                    Iris.Text{"Weapon"}
                    local weapval = Iris.InputText{"","Weapon Name"}.text.value
                    if Iris.Button{"Replace"}.clicked() then
                        if game.ReplicatedStorage.Assets.Weapons:FindFirstChild(weapval) then
                            requests.GeneralEvent:FireServer("SaveLoadout",{
                                Tokens = (lp.Data:GetAttribute("Tokens")+cost),
                                LoadoutWeapon = weapval,
                                LoadoutSkill1 = lp.Data:GetAttribute("LastSkill1"),
                                LoadoutSkill2 = lp.Data:GetAttribute("LastSkill2"),
                                LoadoutSkill3 = lp.Data:GetAttribute("LastSkill3"),
                                LoadoutEvasive = getevasive(),
                            })
                            task.wait()
                            requests.GeneralEvent:FireServer("SummonLoadout")
                        end
                    end
                Iris.End()
                Iris.SameLine()
                    Iris.Text{"Skill 1"}
                    local skillval = Iris.InputText{"","Skill Name"}.text.value
                    if Iris.Button{"Replace"}.clicked() then
                        if game.ReplicatedStorage.Assets.Tools.Skills:FindFirstChild(skillval) then
                            requests.GeneralEvent:FireServer("SaveLoadout",{
                                Tokens = (lp.Data:GetAttribute("Tokens")+cost),
                                LoadoutWeapon = lp.Data:GetAttribute("CurrentWeapon"),
                                LoadoutSkill1 = skillval,
                                LoadoutSkill2 = lp.Data:GetAttribute("LastSkill2"),
                                LoadoutSkill3 = lp.Data:GetAttribute("LastSkill3"),
                                LoadoutEvasive = getevasive(),
                                LastSkill1 = skillval
                            })
                            task.wait()
                            requests.GeneralEvent:FireServer("SummonLoadout")
                        end
                    end
                Iris.End()
                Iris.SameLine()
                    Iris.Text{"Skill 2"}
                    local skillval = Iris.InputText{"","Skill Name"}.text.value
                    if Iris.Button{"Replace"}.clicked() then
                        if game.ReplicatedStorage.Assets.Tools.Skills:FindFirstChild(skillval) then
                            requests.GeneralEvent:FireServer("SaveLoadout",{
                                Tokens = (lp.Data:GetAttribute("Tokens")+cost),
                                LoadoutWeapon = lp.Data:GetAttribute("CurrentWeapon"),
                                LoadoutSkill1 = lp.Data:GetAttribute("LastSkill1"),
                                LoadoutSkill2 = skillval,
                                LoadoutSkill3 = lp.Data:GetAttribute("LastSkill3"),
                                LoadoutEvasive = getevasive(),
                                LastSkill2 = skillval
                            })
                            task.wait()
                            requests.GeneralEvent:FireServer("SummonLoadout")
                        end
                    end
                Iris.End()
                Iris.SameLine()
                    Iris.Text{"Skill 3"}
                    local skillval = Iris.InputText{"","Skill Name"}.text.value
                    if Iris.Button{"Replace"}.clicked() then
                        if game.ReplicatedStorage.Assets.Tools.Skills:FindFirstChild(skillval) then
                            requests.GeneralEvent:FireServer("SaveLoadout",{
                                Tokens = (lp.Data:GetAttribute("Tokens")+cost),
                                LoadoutWeapon = lp.Data:GetAttribute("CurrentWeapon"),
                                LoadoutSkill1 = lp.Data:GetAttribute("LastSkill1"),
                                LoadoutSkill2 = lp.Data:GetAttribute("LastSkill2"),
                                LoadoutSkill3 = skillval,
                                LoadoutEvasive = getevasive(),
                                LastSkill3 = skillval
                            })
                            task.wait()
                            requests.GeneralEvent:FireServer("SummonLoadout")
                        end
                    end
                Iris.End()
                Iris.SameLine()
                    Iris.Text{"Evasive"}
                    local evasiveval = Iris.InputText{"","Evasive Name"}.text.value
                    if Iris.Button{"Replace"}.clicked() then
                        if game.ReplicatedStorage.Assets.Tools.Evasive:FindFirstChild(evasiveval) then
                            requests.GeneralEvent:FireServer("SaveLoadout",{
                                Tokens = (lp.Data:GetAttribute("Tokens")+cost),
                                LoadoutWeapon = lp.Data:GetAttribute("CurrentWeapon"),
                                LoadoutSkill1 = lp.Data:GetAttribute("LastSkill1"),
                                LoadoutSkill2 = lp.Data:GetAttribute("LastSkill2"),
                                LoadoutSkill3 = lp.Data:GetAttribute("LastSkill3"),
                                LoadoutEvasive = evasiveval,
                            })
                            task.wait()
                            requests.GeneralEvent:FireServer("SummonLoadout")
                        end
                    end
                Iris.End()
                Iris.SameLine()
                    Iris.Text{"Enchant"}
                    local enchantval = Iris.InputText{"","Enchant Name"}.text.value
                    if Iris.Button{"Replace"}.clicked() then
                        if game.ReplicatedStorage.Assets.VFX.Enchants:FindFirstChild(enchantval) then
                            requests.GeneralEvent:FireServer("SaveLoadout",{
                                Enchant = enchantval
                            })
                        end
                    end
                Iris.End()
            Iris.End()
            Iris.Tree{"Data Changer"}
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
                local heavyknockback = Iris.Checkbox{"No Heavy M1 Knockback"}.isChecked.value
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
                local customdmg = Iris.InputNum{"Custom M1 Damage"}.number.value
                Iris.Text{"If value is higher than or equal to HP then it wont register as a kill"}
                customdmgtoggle = tcd
                customdmgval = customdmg
                oneshottoggle = oneshot
                noheavy = heavyknockback
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
                            input:FireServer("LightAttack",0)
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

repeat task.wait() until Window
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Zero then
        Window.state.isOpened:set(not Window.state.isOpened.value)
    end
end)
