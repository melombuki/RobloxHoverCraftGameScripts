local RunService = game:GetService('RunService')
local hoverCraft = script.Parent
local bp = Instance.new("BodyPosition")
local vs = hoverCraft.VehicleSeat
local bf = vs.BodyForce
local t = hoverCraft.Torque
local maxTrouqe = 4
local maxForceXZ = 25
local maxForceY = 50000
local airFriction = 0.025
local zeroVector = Vector3.new(0, 0, 0)
local thrustSpeed = 10000
local turnSpeed =  10000
local steerSpeed = 10000000

bav.AngularVelocity = zeroVector
hoverCraft.Velocity = zeroVector
bf.Force = zeroVector
t.Torque = zeroVector

local decay = coroutine.wrap(function()
	while wait() do
		if hoverCraft.Velocity.Magnitude <= 1 and (vs.Throttle == 0 and vs.Steer == 0) then
			hoverCraft.Velocity = zeroVector
		else
			hoverCraft.Velocity = hoverCraft.Velocity:Lerp(zeroVector, airFriction)
		end
	end	
end)
decay()

local function levatate()
	bp.position = Vector3.new(0, 5, 0)
	bp.maxForce = Vector3.new(maxForceXZ, maxForceY, maxForceXZ)
	bp.Parent = hoverCraft
end
levatate()

local function throttle(value)
	bf.Force = Vector3.new(thrustSpeed * vs.Throttle, 0, thrustSpeed * vs.Throttle) * hoverCraft.CFrame.lookVector
end

local function steer(value)
	t.Torque = Vector3.new(0, -turnSpeed * vs.Steer, 0)
end

local function onChange(prop)
	if (prop == "Throttle") then
		throttle(vs.Throttle)
	elseif (prop == "Steer") then
		steer(vs.Steer)
		throttle(vs.Throttle)
	end
end
vs.Changed:connect(onChange)

local function clampRotVelocity(currentRotMag)
	if (currentRotMag >= maxTrouqe) then
		return (hoverCraft.RotVelocity * maxTrouqe) / currentRotMag
	else
		return hoverCraft.RotVelocity
	end
end

RunService.Heartbeat:connect(function(step)
	-- Prevent the hovercraft from turning too fast
	hoverCraft.RotVelocity = clampRotVelocity(hoverCraft.RotVelocity.Magnitude)
end)
