//-----------------------------------------------------------
//
//-----------------------------------------------------------
class StunningJumpEmitter extends Emitter;



defaultproperties
{
     Begin Object Class=SpriteEmitter Name=StunningJumpEmitterA
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         MaxParticles=1
         StartLocationOffset=(Z=10.000000)
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(relativetime=0.250000,RelativeSize=0.800000)
         SizeScale(1)=(relativetime=0.500000,RelativeSize=1.500000)
         SizeScale(2)=(relativetime=0.750000,RelativeSize=1.200000)
         StartSizeRange=(X=(Min=40.000000,Max=40.000000),Y=(Min=40.000000,Max=40.000000),Z=(Min=40.000000,Max=40.000000))
         InitialParticlesPerSecond=5000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XIIICine.effets.Blam'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
         Name="StunningJumpEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.StunningJumpEmitter.StunningJumpEmitterA'
     bUnlit=True
     RemoteRole=ROLE_None
}
