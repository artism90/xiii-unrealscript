//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SnowDustEmitter extends ImpactEmitter;



defaultproperties
{
     ClientImpactSound=Sound'XIIIsound.Impacts__ImpNeige.ImpNeige__hPlayImpNei'
     Begin Object Class=SpriteEmitter Name=SnowDustEmitterA
         UseDirectionAs=PTDU_Normal
         Acceleration=(Z=0.100000)
         UseColorScale=True
         RespawnDeadParticles=False
         UseRegularSizeScale=False
         UniformSize=False
         AutomaticInitialSpawning=False
         Initialized=True
         ColorScale(0)=(Color=(B=95,G=95,R=95))
         ColorScale(1)=(relativetime=1.000000)
         MaxParticles=1
         StartSizeRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=5.000000,Max=5.000000))
         InitialParticlesPerSecond=3000.000000
         DrawStyle=PTDS_Darken
         Texture=Texture'XIIICine.effets.BlobA'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=2.000000,Max=2.000000)
         Name="SnowDustEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.SnowDustEmitter.SnowDustEmitterA'
     Begin Object Class=SpriteEmitter Name=SnowDustEmitterB
         UseDirectionAs=PTDU_ViewAndNormalUp
         Acceleration=(Y=-10.000000,Z=-300.000000)
         FadeOut=True
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
         FadeOutStartTime=0.900000
         FadeInEndTime=0.700000
         MaxParticles=15
         StartLocationRange=(Z=(Min=-10.000000))
         SpinsPerSecondRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=2.000000,Max=6.000000),Y=(Min=2.000000,Max=6.000000),Z=(Min=5.000000,Max=6.000000))
         CenterU=0.100000
         CenterV=-0.100000
         InitialParticlesPerSecond=200.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.extinct_fumeeAD'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=1.000000,Max=1.100000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=250.000000,Max=300.000000))
         VelocityLossRange=(Z=(Min=1.000000,Max=5.000000))
         Name="SnowDustEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.SnowDustEmitter.SnowDustEmitterB'
     Begin Object Class=SpriteEmitter Name=SnowDustEmitterC
         Acceleration=(Z=-200.000000)
         FadeOut=True
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
         MaxParticles=2
         StartLocationRange=(Z=(Max=10.000000))
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(relativetime=0.100000,RelativeSize=1.500000)
         SizeScale(2)=(relativetime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000))
         CenterU=0.050000
         CenterV=0.050000
         InitialParticlesPerSecond=10.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.mist2'
         SecondsBeforeInactive=1000.000000
         LifetimeRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(Z=(Min=100.000000,Max=200.000000))
         VelocityLossRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=20.000000,Max=20.000000))
         Name="SnowDustEmitterC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.SnowDustEmitter.SnowDustEmitterC'
     bUseCylinderCollision=True
}
