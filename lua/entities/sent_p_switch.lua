AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "P Switch"

ENT.Editable 			=	true
ENT.Spawnable			=	true
ENT.AdminOnly			=	false
ENT.Category 			=	"Super Garry Maker 2"
ENT.Author				= 	"Dogeiscut"

ENT.IconOverride		=	"materials/entities/p_switch.jpg"

ENT.Flattened = false

PSwitchActive = false
CurrentPSwitch = CurrentPSwitch

sound.Add( {
	name = "pswitch_switch",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {100, 100},
	sound = "switch.wav"
} )
-- todo: make this loop or figure out how to pause when pausing in singleplayer
sound.Add( {
	name = "pswitch_music",
	channel = CHAN_STREAM,
	volume = 1.0,
	level = 0,
	pitch = {100, 100},
	sound = "p_switch.wav"
} )

function ENT:Initialize()

	if ( CLIENT ) then return end

	self:SetModel("models/p_switch.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )

	self:GetPhysicsObject():SetMass(100)


end

function ENT:StopPSwitchMusic()
	self:StopSound("pswitch_music") 
end

function ENT:Touch(ent)

	if ( self.Flattened ) then return end
	
	local modelSizeMin, modelSizeMax = self:GetModelBounds()

	--todo: make this work at any angle
	if ( (not (ent:GetClass()=="sent_p_switch")) and 
	--(ent:GetPos().z > self:GetPos().z+modelSizeMax.z-1) 
	(ent:GetPos().z > self:GetPos().z+16) 
	and (ent:GetPhysicsObject():GetMass()>=85) ) then
		print(ent:GetPhysicsObject():GetMass())
		self:SetModel("models/p_switch2.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:GetPhysicsObject():SetMass(100)
		self:GetPhysicsObject():EnableMotion( false )
		for i, ent in ipairs( ents.FindByClass( "sent_p_switch" ) ) do
			ent:StopPSwitchMusic(false)
		end
		self:EmitSound("pswitch_switch")
		self:EmitSound("pswitch_music")
		PSwitchActive = true
		CurrentPSwitch = self
		timer.Simple( 0.25, function() 
			self:SetNoDraw( true )
			self:SetNotSolid( true )
			self:SetMoveType( MOVETYPE_NONE )
			self:SetParent( self )
		end)
		timer.Simple( 12.7, function()
			if self:IsValid() then
				self:Remove()
			end
		end )
		self.Flattened = true
	end
end

function ENT:OnRemove() 
	self:StopSound("pswitch_music")
	if CurrentPSwitch==self then
		PSwitchActive = false 
	end
end

if ( SERVER ) then return end

function ENT:Draw()
	self:DrawModel()
	self:DrawShadow(true)	
end

function ENT:Think()
end