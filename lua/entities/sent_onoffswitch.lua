AddCSLuaFile()

-- set up the On/Off Switch SENT
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

-- give the On/Off Switch a name
ENT.PrintName = "On/Off Switch"

-- other junk lmaoooo
ENT.Editable 			=	true
ENT.Spawnable			=	true
ENT.AdminOnly			=	false
ENT.Category 			=	"Super Garry Maker 2"
ENT.Author				= 	"Dogeiscut"

ENT.IconOverride		=	"materials/entities/onoffswitch.jpg"

-- set up the On/Off Switch's default state
ENT.Channel = 0
OnOffState = {}
OnOffState[ENT.Channel] = true

ENT.DataTables = { "Channel" }

OnOffHitCooldown = CurTime()

-- define a table of colors for each channel
ENT.CHANNEL_MATERIALS = {
	[0] = {
		on = "models/onoffswitch_on.vmt",
		off = "models/onoffswitch_off.vmt"
	},
}

sound.Add( {
	name = "onoffswitch_switch",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {100, 100},
	sound = "switch.wav"
} )

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "State", { KeyName = "state", Edit = { type = "Bool", order = 1 } } )
	
end

function ENT:Initialize()

	if ( CLIENT ) then return end

	self:SetModel("models/onoffswitch.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )

	self:SetPlaybackRate( 2 )
	self:ResetSequenceInfo()
	self:SetSequence("Bump")

	if OnOffState[self.Channel] == true then
		self:TurnOn(false)
	else
		self:TurnOff(false)
	end
	self:SnapToGrid()
end

-- set up the On/Off Switch's interaction functions
function ENT:Touch(ent)
	if (ent:IsPlayer() and ent:GetVelocity().z > 0 and ent:EyePos().z < self:GetPos().z) or (ent:GetClass()=="prop_combine_ball") then
		if OnOffState[self.Channel] then
			self:TurnOff(true)
		else
			self:TurnOn(true)
		end
	end
end

function ENT:OnTakeDamage(dmg)
	if dmg:GetDamage() >= 0 then
		if OnOffState[self.Channel] then
			self:TurnOff(true)
		else
			self:TurnOn(true)
		end
	end
end

-- set up the On/Off Switch's state change functions
function ENT:TurnOn(itself)

	self:RemoveAllDecals()
	if itself and ((CurTime()-OnOffHitCooldown)<0.25) then return end

	self:SetMaterial(self.CHANNEL_MATERIALS[self.Channel].on)

	if itself then

		OnOffHitCooldown = CurTime()

		-- if not self:IsSequenceFinished() then return end

		self:ResetSequenceInfo()
		self:SetPlaybackRate( 2 )
		self:SetSequence("Bump")
		self:EmitSound("onoffswitch_switch")
		OnOffState[self.Channel] = true
	
		for i, ent in ipairs( ents.FindByClass( "sent_onoffswitch" ) ) do
			ent:TurnOn(false)
		end
		for i, ent in ipairs( ents.FindByClass( "sent_reddottedlineblock" ) ) do
			ent:TurnOn(false)
		end
		for i, ent in ipairs( ents.FindByClass( "sent_bluedottedlineblock" ) ) do
			ent:TurnOn(false)
		end
	end
end

function ENT:TurnOff(itself)

	self:RemoveAllDecals()
	if itself and ((CurTime()-OnOffHitCooldown)<0.25) then return end
	
	self:SetMaterial(self.CHANNEL_MATERIALS[self.Channel].off)

	if itself then

		OnOffHitCooldown = CurTime()

		-- if not self:IsSequenceFinished() then return end

		self:ResetSequenceInfo()
		self:SetPlaybackRate( 2 )
		self:SetSequence("Bump")
		self:EmitSound("onoffswitch_switch")
		OnOffState[self.Channel] = false

		for i, ent in ipairs( ents.FindByClass( "sent_onoffswitch" ) ) do
			ent:TurnOff(false)
		end
		for i, ent in ipairs( ents.FindByClass( "sent_reddottedlineblock" ) ) do
			ent:TurnOff(false)
		end
		for i, ent in ipairs( ents.FindByClass( "sent_bluedottedlineblock" ) ) do
			ent:TurnOff(false)
		end
	end
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

hook.Add("PhysgunDrop", "OnoffswitchStop", function(ply, ent)
	if ent:GetClass()=="sent_onoffswitch" then
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