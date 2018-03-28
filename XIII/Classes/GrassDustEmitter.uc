//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GrassDustEmitter extends ImpactEmitter;



defaultproperties
{
     ClientImpactSound=Sound'XIIIsound.Impacts__ImpHerbe.ImpHerbe__hPlayImpHrb'
     Begin Object Class=SpriteEmitter Name=GrassDustEmitterA
         Acceleration=(Z=2.000000)
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         SymmetryU=True
         SymmetryV=True
         RandomSymmetryU=True
         RandomSymmetryV=True
         Initialized=True
         FadeOutStartTime=2.500000
         FadeInEndTime=0.500000
         MaxParticles=2
         StartLocationRange=(Z=(Max=10.000000))
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000),Y=(Min=-0.200000,Max=0.200000))
         SizeScale(1)=(relativetime=0.100000,RelativeSize=2.000000)
         SizeScale(2)=(relativetime=0.500000,RelativeSize=1.000000)
         SizeScale(3)=(relativetime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=7.000000,Max=10.000000),Y=(Min=7.000000,Max=10.000000),Z=(Min=7.000000,Max=10.000000))
         CenterU=0.200000
         CenterV=0.200000
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.mist2'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=3.000000)
         StartVelocityRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-3.000000,Max=-5.000000))
         Name="GrassDustEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.GrassDustEmitter.GrassDustEmitterA'
     Begin Object Class=SpriteEmitter Name=GrassDustEmitterB
         UseDirectionAs=PTDU_MoveAndViewUp
         Acceleration=(X=-10.000000,Y=-20.000000,Z=-200.000000)
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=False
         AutomaticInitialSpawning=False
         SymmetryU=True
         SymmetryV=True
         RandomSymmetryU=True
         RandomSymmetryV=True
         Initialized=True
         MaxParticles=5
         StartLocationRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000))
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-2.000000,Max=2.000000))
         StartSizeRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=2.500000,Max=5.000000))
         CenterU=0.200000
         CenterV=0.200000
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XIIICine.effets.impactherbeM'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=1.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=80.000000,Max=150.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=0.500000,Max=1.000000),Z=(Max=1.000000))
         Name="GrassDustEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.GrassDustEmitter.GrassDustEmitterB'
     bUseCylinderCollision=True
}
