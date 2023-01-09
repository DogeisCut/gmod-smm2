function EFFECT:Init( data )

	local vOffset = data:GetOrigin()

	local NumParticles = 16

	local emitter = ParticleEmitter( vOffset, false )

	for i = 0, NumParticles do

		local Pos = Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) )

		local particle = emitter:Add( "sprites/ppoof.vmt", vOffset + Pos * 8 )
		if ( particle ) then

			particle:SetVelocity( Pos * 100 )

			particle:SetLifeTime( 0 )
			particle:SetDieTime(  math.Rand( 0.25, 0.6 ) )

			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 255 )

			local Size = math.Rand( 15, 20 )
			particle:SetStartSize( Size )
			particle:SetEndSize( 0 )

			particle:SetAirResistance( 100 )
			particle:SetGravity( Vector( 0, 0, 150 ) )

			particle:SetColor( 255, 255, 255 )

			particle:SetCollide( true )

			particle:SetBounce( 1 )
			particle:SetLighting( false )

		end

	end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
