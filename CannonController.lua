local fireEvent = script.Parent.FireEvent
local cannonBall = script.Parent.CannonBall
local fireSpeed = 200
local pitch = math.pi/16

local function fire(forward) 
	game:GetService("Debris"):AddItem(cannonBall, 2)
	cannonBall:BreakJoints()
	cannonBall.Velocity = Vector3.new(forward.x, pitch, forward.z) * fireSpeed
end

fireEvent.Event:connect(fire)