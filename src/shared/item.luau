--!strict

local Item = {}

Item.interface = {}
Item.schema = {}
Item.metatable = { __index = Item.schema }

export type item = {
	id: number,
	quantity: number,
	durability: number?,
}

return table.freeze(Item.interface)
