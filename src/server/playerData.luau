--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local PlayerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

local Item = require(ReplicatedStorage.Shared.item)
type item = Item.item

--events--------------------------------------------------------------------------------------------

local events = Instance.new("Folder")
events.Name = "Events"

local sendEvent = Instance.new("RemoteEvent")
sendEvent.Name = "dataChanged"
sendEvent.Parent = events

events.Parent = ReplicatedStorage

----------------------------------------------------------------------------------------------------

local store = {}
local interface = {}
local schema = {}
local metatable = {}

type PlayerDataObject = {
	inventory: { item }?,
	stats: { [string]: number? }?,
	experience: number,
	equipped: {}?,
	settings: { [string]: any }?,
	Level: number?,
}

export type PlayerData = typeof(setmetatable({} :: PlayerDataObject, {} :: typeof(metatable)))

--interface-----------------------------------------------------------------------------------------

function interface.new(player: Player, ...): PlayerData
	local self = {
		inventory = {},
		stats = {},
		experience = 0,
		equipped = {},
		settings = {},
	}

	setmetatable(self, metatable)
	return self
end

function interface:Init(player: Player)
	local playerData = PlayerDataStore:GetAsync(player.UserId)

	if not playerData then
		playerData = interface.new(player)
	else
		setmetatable(playerData, metatable)
	end

	store[player.UserId] = playerData :: PlayerData
	sendEvent:FireClient(player, playerData)
end

function interface:Save(player: Player)
	local playerData = store[player.UserId]
	PlayerDataStore:SetAsync(player.UserId, playerData)
end

--local---------------------------------------------------------------------------------------------

local function change(t: {}, changed: {}, func: ((... any)->any)?)
	for key, value in changed do
		if typeof(value) == "table" then
			change(t[key], value :: {})
		else
			if func then
				t[key] = func(t[key], value)
				continue
			end
			t[key] = value
		end
	end
end

--schema--------------------------------------------------------------------------------------------

function schema.getPlayer(self: PlayerData): Player
	return Players:GetPlayerByUserId(table.find(store, self))
end

function schema:add(...: PlayerDataObject)
	for _, t in table.pack(...) do
		change(self, t)
	end
end

--metatable-----------------------------------------------------------------------------------------

local functions = {
	Level = function(self: PlayerData): number
		print(self.experience)
		return math.floor(self.experience / 100)
	end,
}

function metatable.__index(self: PlayerData, key: string)
	if functions[key] then
		return functions[key](self)
	else
		return schema[key]
	end
end
----------------------------------------------------------------------------------------------------

for _, player in Players:GetPlayers() do
	interface:Init(player)
end

Players.PlayerAdded:Connect(function(player)
	interface:Init(player)
end)

return table.freeze(interface)
