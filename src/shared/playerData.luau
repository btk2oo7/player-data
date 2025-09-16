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
	inventory: { item },
	stats: { [string]: number? },
	experience: number,
	equipped: {},
	settings: { [string]: any },
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

--local---------------------------------------------------------------------------------------------

local function update(t: {}, changed: {})
	for key, value in changed do --loop through table of changes
		if typeof(value) == "table" then --if something is a table,
			update(t[key], value) --call update() on it (recursively)
		else
			t[key] = value --otherwise, just update value
		end
	end
end

local function dataChanged(changed: { [string]: any })
	update(PlayerData.cache, changed)
end

----------------------------------------------------------------------------------------------------

dataChangedEvent.OnClientEvent:Connect(dataChanged)

return PlayerData.interface
