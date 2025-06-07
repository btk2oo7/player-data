--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local React = require(ReplicatedStorage.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Packages:FindFirstChild("react-roblox"))

----------------------------------------------------------------------------------------------------

local module = {}

local enabled = false
local frame

----------------------------------------------------------------------------------------------------

local function bar()
	return React.createElement("Frame", {
		Size = UDim2.new(0, 1, 0, 35),
		Position = UDim2.new(1, -10, 0.33, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(44, 44, 50),
		BackgroundTransparency = 0.25,
	}, {
		React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 10),
		}),
		React.createElement("UIStroke", {
			Thickness = 2,
			Color = Color3.fromRGB(35, 35, 40),
		}),
		React.createElement("TextBox", {
			Size = UDim2.new(1, -5, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			TextScaled = true,
			ClearTextOnFocus = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.fromRGB(220, 220, 220),
			Text = "",
		}),
	})
end

local handle = Instance.new("ScreenGui")
handle.Name = "CommandBar"
handle.Parent = Players.LocalPlayer.PlayerGui

local root = ReactRoblox.createRoot(handle)
root:render(React.createElement(bar, {}, {}))

function module:Toggle()
	if enabled then --close
		handle.Frame.Size = UDim2.new(0.4, 1, 0, 35)
		local tween = TweenService:Create(handle.Frame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(0, 1, 0, 35) })
		tween:Play()
		enabled = false
		tween.Completed:Once(function()
			handle.Enabled = false
		end)
	else --open
		handle.Frame.Size = UDim2.new(0, 1, 0, 35)
		handle.Frame["3"]:CaptureFocus()
		local tween = TweenService:Create(handle.Frame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), { Size = UDim2.new(0.4, 1, 0, 35) })
		tween:Play()
		enabled = true
		tween.Completed:Once(function()
			handle.Enabled = true
		end)
	end
end

----------------------------------------------------------------------------------------------------

return module
