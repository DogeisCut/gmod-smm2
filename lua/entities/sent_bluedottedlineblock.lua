AddCSLuaFile()

-- set up the On/Off Switch SENT
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

-- give the On/Off Switch a name
ENT.PrintName = "Blue Dotted-Line Block"

-- other junk lmaoooo
ENT.Editable 			=	true
ENT.Spawnable			=	true
ENT.AdminOnly			=	false
ENT.Category 			=	"Super Garry Maker 2"
ENT.Author				= 	"Dogeiscut"

ENT.IconOverride		=	"materials/entities/bluedottedlineblock.jpg"

-- set up the On/Off Switch's default state
ENT.Channel = 0
OnOffState = {}
OnOffState[ENT.Channel] = true
OnOffBlocks = {}

ENT.DataTables = { "Channel" }

-- define a table of colors for each channel
ENT.CHANNEL_MATERIALS = {
	[0] = {
		on = "models/dottedlineblock_on.vmt",
		off = "models/dottedlineblock_off.vmt"
	},
}

function ENT:Initialize()

	if ( CLIENT ) then return end

	self:SetMaterial(self.CHANNEL_MATERIALS[self.Channel].off)
	self:SetModel("models/dottedlineblock.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SnapToGrid()
	if OnOffState[self.Channel] == true then
		self:TurnOn(false)
	else
		self:TurnOff(false)
	end
end

-- set up the On/Off Switch's state change functions
function ENT:TurnOn(itself)

	self:SetModel("models/dottedlineblock2.mdl")
	self:GetPhysicsObject():AddGameFlag(FVPHYSICS_NO_SELF_COLLISIONS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:GetPhysicsObject():EnableCollisions(false)
	self:RemoveAllDecals()

end

function ENT:TurnOff(itself)

	self:SetModel("models/dottedlineblock.mdl")
	self:GetPhysicsObject():ClearGameFlag(FVPHYSICS_NO_SELF_COLLISIONS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:GetPhysicsObject():EnableCollisions(true)
	self:RemoveAllDecals()

end

function ENT:SnapToGrid() 

	if ( CLIENT ) then return end

	-- get the model size of the On/Off Block
	local modelSize = self:GetModelBounds()
	
	-- calculate the grid size based on the model size
	local gridSize = 32 -- math.max(modelSize.x, modelSize.y, modelSize.z)*2
	
	-- snap the position of the On/Off Block to the grid
	local pos = self:GetPos()
	pos.x = math.Round(pos.x / gridSize) * gridSize
	pos.y = math.Round(pos.y / gridSize) * gridSize
	pos.z = math.Round(pos.z / gridSize) * gridSize
	self:SetPos(pos)
	
	-- snap the angle of the On/Off Block to a multiple of 90 degrees
	local ang = self:GetAngles()
	ang.pitch = math.Round(ang.pitch / 90) * 90
	ang.yaw = math.Round(ang.yaw / 90) * 90
	ang.roll = math.Round(ang.roll / 90) * 90
	self:SetAngles(ang)

	self:GetPhysicsObject():EnableMotion( false )
end

hook.Add("PhysgunDrop", "BluedottedlineblockStop", function(ply, ent)
	if ent:GetClass()=="sent_bluedottedlineblock" then
		ent:SnapToGrid()
	end
end )

if ( SERVER ) then return end

function ENT:Draw()
	self:DrawModel()
	self:DrawShadow(true)	
end

function ENT:Think()
end