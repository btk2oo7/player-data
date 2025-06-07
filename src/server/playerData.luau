--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local PlayerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

local Item = require(ReplicatedStorage.Shared.item)
type item = Item.item

----------------------------------------------------------------------------------------------------

local PlayerData = {}

PlayerData.store = {}
PlayerData.interface = {}
PlayerData.schema = {}
PlayerData.metatable = {__index = function(t, k)
		return PlayerData.schema[k](t)
	end
}

type PlayerDataObject = {
	inventory: { item },
	stats: {},
	experience: number,
	userId: number,
	equipped: {},
	settings: {},
	Level: number?,
}
export type PlayerData = typeof(setmetatable({} :: PlayerDataObject, {} :: typeof(PlayerData.metatable)))

--interface-----------------------------------------------------------------------------------------

function PlayerData.interface.new(player: Player): PlayerData
	local self = {
		inventory = {},
		stats = {},
		experience = 0,
		equipped = {},
		settings = {},
	}

	setmetatable(self, PlayerData.metatable)
	return self
end

function PlayerData.interface:Init(player: Player)
	local playerData = PlayerDataStore:GetAsync(player.UserId)

	if not playerData then
		playerData = PlayerData.interface.new(player)
	else
		setmetatable(playerData, PlayerData.metatable)
	end

	PlayerData.store[player.UserId] = playerData
	print(PlayerData.store[player.UserId].Level)
end

--schema--------------------------------------------------------------------------------------------

function PlayerData.schema.__index(t, k)
	if PlayerData.schema[k] then
		return PlayerData.schema[k]
	end
end

function PlayerData.schema.Level(self: PlayerData): number
	print(self.experience)
	return math.floor(self.experience / 100)
end

function PlayerData.schema.getPlayer(self: PlayerData): Player
	return Players:GetPlayerByUserId(self.userId)
end

--metatable-----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

Players.PlayerAdded:Connect(function(player)
	PlayerData.interface:Init(player)
end)

return table.freeze(PlayerData.interface)
