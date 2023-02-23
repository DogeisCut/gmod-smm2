AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "! Switch"

ENT.Editable 			=	true
ENT.Spawnable			=	true
ENT.AdminOnly			=	false
ENT.Category 			=	"Super Garry Maker 2"
ENT.Author				= 	"Dogeiscut"

ENT.IconOverride		=	"materials/supergarrysmaker/entities/bang_switch.jpg"

ENT.Flattened = false
ENT.HadMotionBefore = true

PSwitchActive = false
CurrentPSwitch = CurrentPSwitch

function ENT:Initialize()

	if ( CLIENT ) then return end

	self:SetModel("models/p_switch.mdl")
	self:SetMaterial("models/bang_switch.vmt")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )

	self:GetPhysicsObject():SetMass(30)


end

function ENT:StopPSwitchMusic()
	self:StopSound("pswitch_music") 
end

function ENT:Touch(ent)

	if ( self.Flattened ) then return end
	
	local modelSizeMin, modelSizeMax = self:GetModelBounds()

	local tr = self:GetTouchTrace()
	local hitNormal = tr.HitNormal

	local pNormal = (self:GetAngles()):Up()
	local dotProduct = pNormal:Dot(hitNormal)

	local diff = math.deg(math.acos(dotProduct))

	if (( (not (ent:GetClass()=="sent_p_switch")) and 
	--(ent:GetPos().z > self:GetPos().z+modelSizeMax.z-1) 
	(diff<15) 
	and (ent:GetPhysicsObject():GetMass()>=85) ) or (ent:GetClass()=="prop_combine_ball")) then
		self.HadMotionBefore = self:GetPhysicsObject():IsMotionEnabled()
		self:SetModel("models/p_switch2.mdl")
		self:SetMaterial("models/bang_switch.vmt")
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:GetPhysicsObject():SetMass(30)
		self:GetPhysicsObject():EnableMotion( self.HadMotionBefore )
		for i, ent in ipairs( ents.FindByClass( "sent_p_switch" ) ) do
			if (ent == CurrentPSwitch) then 
			ent:StopPSwitchMusic(false)
			end
		end
		for i, ent in ipairs( ents.FindByClass( "sent_bang_switch" ) ) do
			if (ent == CurrentPSwitch) then 
			ent:StopPSwitchMusic(false)
			end
		end
		self:EmitSound("pswitch_switch")
		self:EmitSound("pswitch_music")
		ent:DropToFloor()
		PSwitchActive = true
		for i, ent in ipairs( ents.FindByClass( "sent_p_block*" ) ) do
			ent:TurnOn(false)
		end
		CurrentPSwitch = self
		timer.Simple( 12.7, function()
			if self:IsValid() then
				self.HadMotionBefore = self:GetPhysicsObject():IsMotionEnabled()
				self:SetModel("models/p_switch.mdl")
				self:SetMaterial("models/bang_switch.vmt")
				self:SetSolid(SOLID_VPHYSICS)
				self:SetMoveType( MOVETYPE_VPHYSICS )
				self:PhysicsInit( SOLID_VPHYSICS )
				self:StopSound("pswitch_music")
				self:ResetP()
				self:GetPhysicsObject():SetMass(30)
				self:GetPhysicsObject():EnableMotion( self.HadMotionBefore )
			end
		end )
		self.Flattened = true
	end
end

function ENT:ResetP() 	
	self.Flattened = false
	if CurrentPSwitch==self then
		PSwitchActive = false 
		for i, ent in ipairs( ents.FindByClass( "sent_p_block*" ) ) do
			ent:TurnOff(false)
		end
	end
end

function ENT:OnRemove() 
	self:ResetP()
end

if ( SERVER ) then return end

function ENT:Draw()
	self:DrawModel()
	self:DrawShadow(true)	
end

function ENT:Think()
end