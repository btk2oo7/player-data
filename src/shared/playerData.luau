--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Item = require(ReplicatedStorage.Shared.item)
type item = Item.item

--events--------------------------------------------------------------------------------------------

local events = ReplicatedStorage:WaitForChild("Events")

local dataChangedEvent: RemoteEvent = events:FindFirstChild("dataChanged") or error("no event found")

----------------------------------------------------------------------------------------------------

local cache
local interface = {}
local schema = {}
local metatable = {}

type PlayerDataObject = {
	inventory: { item? },
	stats: {
		money: number,
		experience: number,
	},
	attributes: {
		strength: number,
		agility: number,
		willpower: number,
		weapon: number,
	},
	equipped: {}?,
	settings: { [string]: any }?,
	Level: number?,
}

export type PlayerData = typeof(setmetatable({} :: PlayerDataObject, {} :: typeof(metatable)))

--interface-----------------------------------------------------------------------------------------

function interface.new(data: PlayerDataObject?): PlayerData
	local self
	if data then
		self = data
	else
		self = {
			inventory = {},
			stats = {
				money = 0,
				experience = 0,
			},
			attributes = {
				strength = 0,
				agility = 0,
				willpower = 0,
				weapon = 0,
			},
			equipped = {},
			settings = {},
		}
	end

	setmetatable(self, metatable)
	return self
end

cache = interface.new()

function interface.fromStats(list: { [string]: number }): PlayerData
	local self = interface.new()

	for stat, value in list do
		if self.stats[stat] then
			self.stats[stat] = value
		end
	end

	return self
end

function interface.fromAttributes(list: { [string]: number }): PlayerData
	local self = interface.new()

	for attribute, value in list do
		if self.attributes[attribute] then
			self.attributes[attribute] = value
		end
	end

	return self
end

function interface.fromInventory(...: item): PlayerData --i think i'll do inventory weight-based like deepwoken
	local self = interface.new()

	for _, item: item in table.pack(...) do
		table.insert(self.inventory, item)
	end

	return self
end

--local---------------------------------------------------------------------------------------------

local function change(t: {} | PlayerData, changed: {any}, func: ((...string) -> any)?)
	for key, value in changed do
		if typeof(value) == "table" then
			change(t[key], value)
		else
			if func then
				t[key] = func(t[key], value)
				continue
			end
			t[key] = value
		end
	end
end

local function dataChanged(changed)
	change(cache, changed)
end

--metatable-----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

dataChangedEvent.OnClientEvent:Connect(dataChanged)

return interface
