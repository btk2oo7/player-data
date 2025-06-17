local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Item = require(ReplicatedStorage.Shared.item)
type item = Item.item

--events--------------------------------------------------------------------------------------------

local events = ReplicatedStorage:WaitForChild("Events")

local sendEvent: RemoteEvent = events:FindFirstChild("send") or error("no event found")

----------------------------------------------------------------------------------------------------

local PlayerData = {}

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



----------------------------------------------------------------------------------------------------

sendEvent.OnClientEvent:Connect()

return PlayerData.interface