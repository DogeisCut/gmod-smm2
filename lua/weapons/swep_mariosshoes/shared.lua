if SERVER then
    AddCSLuaFile()
  end
  
  SWEP.PrintName = "Mario's Shoes"
  
  SWEP.Slot = 1
  SWEP.SlotPos = 1
  
  SWEP.DrawAmmo = false
  SWEP.DrawCrosshair = true
  
  SWEP.Author = "DogeisCut"
  SWEP.Instructions = "Tap to do a small jump or hold it for a big jump! Overrides fall damage and makes you slightly smaller."
  
  SWEP.Spawnable = true
  SWEP.AdminOnly = false
  
  SWEP.ViewModel = "models/hunter/blocks/cube8x8x8.mdl"
  SWEP.WorldModel = "models/props_junk/Shoe001a.mdl"
  SWEP.Category =	"Super Garry Maker 2"
  SWEP.UseHands = true

  SWEP.IconOverride = "weapons/mariosboots.jpg"
  
  SWEP.Primary.ClipSize = -1
  SWEP.Primary.DefaultClip = -1
  SWEP.Primary.Automatic = false
  SWEP.Primary.Ammo = "none"
  
  SWEP.Secondary.ClipSize = -1
  SWEP.Secondary.DefaultClip = -1
  SWEP.Secondary.Automatic = false
  SWEP.Secondary.Ammo = "none"
  
  SWEP.OwnerGravityBeforeUpdate = 1
  
  sound.Add( {
    name = "mario_jump",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 80,
    pitch = {100, 100},
    sound = "jump.wav"
  } )

  function SWEP:Initialize()

    self:SetHoldType("normal")
  end

  function SWEP:Initialize()
    self:SetHoldType("normal")
    
  end
  
  function SWEP:Deploy()
    local ply = self:GetOwner()
    local bottom, top = ply:GetHull()

    self.OwnerGravityBeforeUpdate = ply:GetGravity()
    
    ply:SetJumpPower(ply:GetJumpPower() * 1.2)
    ply:SetMaxSpeed(ply:GetMaxSpeed() * 1.2)
    ply:SetRunSpeed(ply:GetRunSpeed() * 1.2)
    ply:SetWalkSpeed(ply:GetWalkSpeed() * 1.2)
    ply:SetHull( bottom * 0.9, top * 0.9 )

    hook.Add("GetFallDamage", ply, function(ply, speed)
      if ply == self:GetOwner() then
        return 0
      end
    end)
    
    return true
  end

  function SWEP:Holster()
    if SERVER then
      local ply = self:GetOwner()
      local bottom, top = ply:GetHull()

      
      ply:SetGravity(self.OwnerGravityBeforeUpdate*1)
      
      ply:SetJumpPower(ply:GetJumpPower() / 1.2)
      ply:SetMaxSpeed(ply:GetMaxSpeed() / 1.2)
      ply:SetRunSpeed(ply:GetRunSpeed() / 1.2)
      ply:SetWalkSpeed(ply:GetWalkSpeed() / 1.2)
      ply:SetHull( bottom / 0.9, top / 0.9  )

      hook.Remove("GetFallDamage", ply)
      
      return true
    end
  end

  function SWEP:PrimaryAttack()
    return false
  end

  function SWEP:SecondaryAttack()
    return false
  end

  function SWEP:Think()
    if SERVER then
      local ply = self:GetOwner()
      if ply:KeyDown(IN_JUMP) and ply:GetVelocity().z>0 then
        if not (ply:GetGravity() == self.OwnerGravityBeforeUpdate*0.25) then
          ply:EmitSound("mario_jump")
        end
        ply:SetGravity(self.OwnerGravityBeforeUpdate*0.25)
        
      end
      if ply:KeyReleased(IN_JUMP) or (ply:KeyDown(IN_JUMP) and not (ply:GetVelocity().z>0)) then
        ply:SetGravity(self.OwnerGravityBeforeUpdate*1)
      end
    end
  end