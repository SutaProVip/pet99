-- Auto Fishing and Upgrade to Amethyst Fishing Rod 
-- By Umi (Umi Hub)

getgenv().Start = not getgenv().Start
getgenv().Username = "ShopRobloxVN1033"

local plr = game.Players.LocalPlayer

local FishingPos = {
    ["Fishing"] = Vector3.new(1165.414794921875, 75.91423034667969, -3447.029296875),
    ["AdvancedFishing"] = Vector3.new(1477.0692138671875, 61.62500762939453, -4447.19189453125)
}
local Instances = workspace.__THINGS.Instances

local Library = require(game:GetService("ReplicatedStorage").Library)

local Directory = Library.Directory
local Network = Library.Network
local Functions = Library.Functions

local SavedData;
repeat wait()
    pcall(function()
        SavedData = Library.Save.Get()
    end);
until type(SavedData) == "table";

function IsHasGoldRod()
    for i,v in pairs(Functions.DeepCopy(SavedData["Inventory"]["Misc"])) do
        if v.id == "Golden Fishing Rod" then
            return i, v
        end
    end
    return false
end

function GetGifts()
    for i,v in pairs(getgc()) do
        if typeof(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.GUIs["Mailbox"] then
            local info = getinfo(v)
            local upvalues = getupvalues(v)
            if info.name and info.name == "Update" and upvalues[4] and upvalues[4].Name == "ClaimAll" then
                return upvalues[1].Inbox
            end
        end
    end
    return {}
end

function InInstance(Name)
    local Instance = Library["InstancingCmds"].GetModel()

    if not Instance then return false end
    if Name and Library["InstancingCmds"].GetInstanceID() == Name then return Instance end
    return Instance
end

function Fishing()
    local InstanceId = Library["InstancingCmds"].GetInstanceID()

    Network.Fire("Instancing_FireCustomFromClient", InstanceId, "RequestCast", FishingPos[InstanceId])
    wait(4)
    Network.Fire("Instancing_FireCustomFromClient", InstanceId, "RequestReel")
    wait(1)
    while plr.PlayerGui._INSTANCES.FishingGame.Enabled and Library["InstancingCmds"].GetInstanceID() == InstanceId do task.wait()
        Network.Fire("Instancing_FireCustomFromClient", InstanceId, "RequestReel")
        Network.Fire("Instancing_FireCustomFromClient", InstanceId, "Clicked")
    end
    wait(1)
end

function BuyRod(Name)
    return Network.Invoke("FishingMerchant_PurchaseRod", Name)
end

task.spawn(function()
    while true and getgenv().Start and not SavedData["ItemIndex"]["Misc"]["{\"id\":\"Amethyst Fishing Rod\"}"] do
        pcall(function()
            for i, v in pairs(GetGifts()) do
                Network.Invoke("Mailbox: Claim", { v.uuid });
                wait(1)
            end
        end)
        wait(20)
    end
end)

task.spawn(function()
    while getgenv().Start and not SavedData["ItemIndex"]["Misc"]["{\"id\":\"Amethyst Fishing Rod\"}"] do wait(1)
        pcall(function()
            for i, v in pairs(Directory.FishingRods) do
                if v.MerchantSalePrice and not SavedData["ItemIndex"]["Misc"][("{\"id\":\"%s\"}"):format(i)] and Library["CurrencyCmds"].Get("Fishing") >= v.MerchantSalePrice then
                    BuyRod(i)
                end
            end
        end)
    end
end)

task.spawn(function()
    while getgenv().Start do wait(1)
        pcall(function()
            local ID, Info = IsHasGoldRod()
            if ID and Info then
                if SavedData["ItemIndex"]["Misc"]["{\"id\":\"Platinum Fishing Rod\"}"] and Library["CurrencyCmds"].Get("Diamonds") >= 10000 then
                    Network.Invoke("Mailbox: Send", getgenv().Username, "Golden Fishing Rod", "Misc", ID, 1)
                end
            end
        end)
    end
end)

task.spawn(function()
    while getgenv().Start do wait(1)
        pcall(function()
            if SavedData["ItemIndex"]["Misc"]["{\"id\":\"Amethyst Fishing Rod\"}"] then
                if not game:GetService("CoreGui"):FindFirstChild("Auto Fishing By Quartyz") then
                    local ScreenGui = Instance.new("ScreenGui")
                    ScreenGui.Name = "Auto Fishing By Quartyz"
                    ScreenGui.Parent = game.CoreGui
                    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
                    
                    local Frame = Instance.new("Frame");
                    Frame.Size = UDim2.new(1.1,0,1.1,0)
                    Frame.Position = UDim2.new(0.5,0,0.5,0)
                    Frame.AnchorPoint = Vector2.new(0.5,0.5) 
                    Frame.Parent = ScreenGui
                    Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
                    Frame.BackgroundTransparency = 0.25
                    
                    local Text = Instance.new("TextLabel");
                    Text.Size = UDim2.new(0.5,0,0.25,0)
                    Text.Position = UDim2.new(0.5,0,0.5,0)
                    Text.AnchorPoint = Vector2.new(0.5,0.5) 
                    Text.Parent = Frame
                    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Text.BackgroundTransparency = 1
                    Text.Text = "Successfully! got Amethyst Fishing Rod"
                end
            end
        end)
    end
end)

task.spawn(function()
    while getgenv().Start do wait()
        local Instance = InInstance()
        if not SavedData["ItemIndex"]["Misc"]["{\"id\":\"Wooden Fishing Rod\"}"] then
            repeat wait()
                if not Library["InstancingCmds"].GetInstanceID() then
                    firetouchinterest(plr.Character.HumanoidRootPart, Instances.Fishing.Teleports.Enter, 0)
                    firetouchinterest(plr.Character.HumanoidRootPart, Instances.Fishing.Teleports.Enter, 1)
                elseif Library["InstancingCmds"].GetInstanceID() ~= "Fishing" then
                    Library["InstancingCmds"].Leave()
                elseif Library["InstancingCmds"].GetInstanceID() == "Fishing" then
                    Network.Fire("Instancing_FireCustomFromClient", "Fishing", "ClaimRod")
                end
            until SavedData["ItemIndex"]["Misc"]["{\"id\":\"Wooden Fishing Rod\"}"]
        end
        if SavedData["ItemIndex"]["Misc"]["{\"id\":\"Platinum Fishing Rod\"}"] or IsHasGoldRod() then
            local InstanceId = Library["InstancingCmds"].GetInstanceID()
            if InstanceId ~= "AdvancedFishing" then
                Library["InstancingCmds"].Leave()
                wait(1)
                firetouchinterest(plr.Character.HumanoidRootPart, Instances.AdvancedFishing.Teleports.Enter, 0)
                firetouchinterest(plr.Character.HumanoidRootPart, Instances.AdvancedFishing.Teleports.Enter, 1)
            elseif InstanceId == "AdvancedFishing" then
                Fishing()
            end
        else
            local InstanceId = Library["InstancingCmds"].GetInstanceID()
            if InstanceId ~= "Fishing" then
                Library["InstancingCmds"].Leave()
                wait(1)
                firetouchinterest(plr.Character.HumanoidRootPart, Instances.Fishing.Teleports.Enter, 0)
                firetouchinterest(plr.Character.HumanoidRootPart, Instances.Fishing.Teleports.Enter, 1)
            elseif InstanceId == "Fishing" then
                Fishing()
            end
        end
    end
end)

warn("Disabled AFK Kick")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
