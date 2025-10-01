local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Item = require(ReplicatedStorage.Shared.item)
type item = Item.item

--events--------------------------------------------------------------------------------------------

local events = ReplicatedStorage:WaitForChild("Events")

local dataChangedEvent: RemoteEvent = events:FindFirstChild("dataChanged") or error("no event found")

----------------------------------------------------------------------------------------------------

local PlayerData = {}
PlayerData.cache = {}
PlayerData.interface = {}
PlayerData.schema = {}
PlayerData.metatable = {}

type PlayerDataObject = {
	inventory: { item }?,
	stats: { [string]: number? }?,
	experience: number,
	equipped: {}?,
	settings: { [string]: any }?,
	Level: number?,
}

export type PlayerData = typeof(setmetatable({} :: PlayerDataObject, {} :: typeof(PlayerData.metatable)))

--interface-----------------------------------------------------------------------------------------

function PlayerData.interface.new(...): PlayerData
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

function PlayerData.interface.fromStats(...): PlayerData
	local self = PlayerData.interface.new()

	for stat, value in table.pack(...) do
		if self.stats[stat] then
			self.stats[stat] = value
		end
	end

	return self
end

function PlayerData.interface.fromInventory(...: item): PlayerData --i think i'll do inventory weight-based like deepwoken
	local self = PlayerData.interface.new()

	for _, item: item in table.pack(...) do
		table.insert(self.inventory, item)
	end

	return self
end

--local---------------------------------------------------------------------------------------------

local function update(t: PlayerDataObject, changed: PlayerDataObject)
	for key, value in changed do --loop through table of changes
		if typeof(value) == "table" then --if something is a table,
			update(t[key], value) --call update() on it (recursively)
		else
			t[key] = value --otherwise, just update value
		end
	end
end

local function dataChanged(changed: { [string]: any })
	update(PlayerData.cache, changed :: PlayerDataObject)
end

----------------------------------------------------------------------------------------------------

dataChangedEvent.OnClientEvent:Connect(dataChanged)

return PlayerData.interface
