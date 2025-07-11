local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local damageFlash = player.PlayerGui:WaitForChild("Uneas"):WaitForChild("Eas") 
local tweenService = game:GetService("TweenService")

local function playDamageEffect(damageAmount, heartbeatInterval, duration)
	local transparency = damageAmount / player.Character.Humanoid.MaxHealth - 0.1
	if transparency < 0 then
		transparency = 0.1
	else
		print("not z")
	end
	damageFlash.BackgroundTransparency = 0.4
	damageFlash.ImageTransparency = transparency
	print(transparency)
	local originalSize = UDim2.new(1, 0, 1, 0)
	local enlargedSize = UDim2.new(1.02, 0, 1.02, 0)

	local tweenUp = tweenService:Create(
		damageFlash,
		TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{Size = enlargedSize}
	)

	local tweenDown = tweenService:Create(
		damageFlash,
		TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{Size = originalSize, BackgroundTransparency = 1}
	)

	workspace.Sounds.heartbeat:Play()
	workspace.Sounds.heartbeat.Volume = 0.4
	workspace.Sounds.heartbeat.Looped = true
	tweenUp:Play()
	tweenUp.Completed:Wait()
	tweenDown:Play()
end

local function endDamageEffect()
	local tweenDown = tweenService:Create(
		damageFlash,
		TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{ImageTransparency = 1, BackgroundTransparency = 1}
	)
	local twen = tweenService:Create(
		workspace.Sounds.heartbeat,
		TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{Volume = 0} 
	)
	tweenDown:Play()
	twen:Play()
	workspace.Sounds.heartbeat:Stop()
end


player.Character:WaitForChild("Humanoid").HealthChanged:Connect(function(health)

	local humanoid = player.Character:FindFirstChild("Humanoid")
	if humanoid and humanoid.Health < humanoid.MaxHealth then
		local damageAmount = humanoid.MaxHealth - humanoid.Health
		if damageAmount > 0 then
			playDamageEffect(damageAmount, 0.2, 0.5) 

			local healthLost = damageAmount
			local startTime = tick()
			while tick() - startTime < 8 do
				if humanoid.Health >= humanoid.MaxHealth - healthLost then
					break
				end
				wait(0.1)
			end
			endDamageEffect()
		end
	end
end)
