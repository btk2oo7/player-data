--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--local _PlayerData = require(ServerScriptService.Server.playerData)
local Vecta3 = require(ReplicatedStorage.Shared.vecta3)

local a = Vecta3.one
print(a.Unit)

print(a:Lerp(Vecta3.zero, 0.5))