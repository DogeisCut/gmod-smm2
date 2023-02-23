AddCSLuaFile()

-- set up the On/Off Switch SENT
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

-- give the On/Off Switch a name
ENT.PrintName = "Coin"

-- other junk lmaoooo
ENT.Editable 			=	true
ENT.Spawnable			=	true
ENT.AdminOnly			=	false
ENT.Category 			=	"Super Garry Maker 2"
ENT.Author				= 	"Dogeiscut"

ENT.IconOverride		=	"materials/supergarrysmaker/vgui/coin.vmt"


function ENT:Initialize()

	if ( CLIENT ) then return end

	self:SetModel("models/supergarrysmaker/coin.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:ResetSequenceInfo()
	self:SetSequence("spin")

	self:SnapToGrid()
end

function ENT:Think()
    for _, ply in pairs(player.GetAll()) do
        local plyPos = ply:GetPos()
        local plyFeet = plyPos + ply:OBBCenter() * ply:GetModelScale()
        local plyMiddle = plyPos + Vector(0, 0, ply:OBBMaxs().z * ply:GetModelScale() * 0.5)
        local plyHead = plyPos + Vector(0, 0, ply:OBBMaxs().z * ply:GetModelScale())

        if plyFeet:Distance(self:GetPos()) <= 64 or plyMiddle:Distance(self:GetPos()) <= 64 or plyHead:Distance(self:GetPos()) <= 64 then
            ply:SetNWInt("mariocoins", ply:GetNWInt("mariocoins") + 1)
			RunConsoleCommand("coincounter_popin")
            self:Remove()
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

hook.Add("PhysgunDrop", "CoinStop", function(ply, ent)
	if ent:GetClass()=="sent_coin" then
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