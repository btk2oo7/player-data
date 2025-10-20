--!strict

local interface = {}
local schema = {}
local metatable = {}

export type itemObject = {
	id: number,
	uniqueId: string,
	quantity: number,
	data: {},
	info: itemInfo?,
}

export type itemInfo = {
	id: number,
	name: string,
	tooltip: string,
	stackSize: number,
	imageId: string,
	data: {}?,
}

export type item = typeof(setmetatable({} :: itemObject, {} :: typeof(metatable)))

---------------------------------

local items: { itemInfo } = {
	{
		id = 0,
		name = "stick",
		tooltip = "hey you be careful with that",
		stackSize = 20,
		imageId = "rbxassetid://18790161811",
	},
	{
		id = 1,
		name = "big stick",
		tooltip = "where did you FIND that",
		stackSize = 1,
		imageId = "rbxassetid://18790161811",
		data = {
			damage = 34,
			attackSpeed = 1, --seconds per swing
			range = 5, --studs
			animations = {},
		},
	},
}

---------------------------------

local HttpService = game:GetService("HttpService")

---------------------------------

function interface.lookup(id): itemInfo?
	for _, item in items do
		if item.id == id then
			return item
		end
	end
	print("item lookup failed, invalid id")
	return
end

function interface.new(itemId: number, list: { [string]: any }?): item
	local self = {
		id = itemId,
		uniqueId = HttpService:GenerateGUID(false),
		quantity = 1,
		data = {},
	}

	-- if list then
	-- 	for key, value in list do
	-- 		if not self[key] then
	-- 			continue
	-- 		end
	-- 		if typeof(self[key]) ~= typeof(value) then
	-- 			continue
	-- 		end
	-- 		self[key] = value
	-- 	end
	-- end

	setmetatable(self, metatable)
	return self
end

---------------------------------

local functions = {
	info = function(self: item): itemInfo?
		return interface.lookup(self.id)
	end,
}

function metatable.__index(self: item, key: string)
	if functions[key] then
		return functions[key](self)
	else
		return schema[key]
	end
end

---------------------------------

return table.freeze(interface)
