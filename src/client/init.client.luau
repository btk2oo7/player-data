--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local CommandBar = require(ReplicatedStorage.Shared.commandBar)

local debounce = false

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.Quote then
		if debounce then
			return
		end
        debounce = true
		CommandBar:Toggle()
		task.wait(0.6)
		debounce = false
	end
end)
