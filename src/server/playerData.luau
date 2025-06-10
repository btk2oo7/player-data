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
PlayerData.metatable = {}

type PlayerDataObject = {
	inventory: { item },
	stats: {},
	experience: number,
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
	print(PlayerData.store[player.UserId])
end

--schema--------------------------------------------------------------------------------------------

function PlayerData.schema.getPlayer(self: PlayerData): Player
	return Players:GetPlayerByUserId(table.find(PlayerData.store, self))
end

--metatable-----------------------------------------------------------------------------------------

local functions = {
	Level = function(self: PlayerData): number
		print(self.experience)
		return math.floor(self.experience / 100)
	end,
}

function PlayerData.metatable.__index(self: PlayerData, key: string)
	if functions[key] then
		return functions[key](self)
	else
		return PlayerData.schema[key]
	end
end

----------------------------------------------------------------------------------------------------

Players.PlayerAdded:Connect(function(player)
	PlayerData.interface:Init(player)
end)

return table.freeze(PlayerData.interface)
