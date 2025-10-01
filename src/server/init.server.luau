--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local _PlayerData = require(ServerScriptService.Server.playerData)
local item = require(ReplicatedStorage.Shared.item)

--debug
local a = item.new(0)
print(a.info)
