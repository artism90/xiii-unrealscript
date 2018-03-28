//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EarthDustEmitter extends ImpactEmitter;



defaultproperties
{
     ClientImpactSound=Sound'XIIIsound.Impacts__ImpTerre.ImpTerre__hPlayImpTer'
     Begin Object Class=SpriteEmitter Name=EarthDustEmitterA
         Acceleration=(Z=-2.000000)
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
         ColorScale(0)=(Color=(B=238,G=238,R=238))
         ColorScale(1)=(relativetime=1.000000,Color=(B=48,G=92,R=103))
         FadeOutStartTime=2.500000
         FadeInEndTime=0.500000
         MaxParticles=5
         StartLocationRange=(Z=(Max=20.000000))
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000),Y=(Min=-0.200000,Max=0.200000))
         SizeScale(1)=(relativetime=0.100000,RelativeSize=2.000000)
         SizeScale(2)=(relativetime=0.500000,RelativeSize=1.000000)
         SizeScale(3)=(relativetime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=7.000000,Max=10.000000),Y=(Min=7.000000,Max=10.000000),Z=(Min=7.000000,Max=10.000000))
         CenterU=0.200000
         CenterV=0.200000
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.mist2'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=3.000000)
         StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000))
         Name="EarthDustEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.EarthDustEmitter.EarthDustEmitterA'
     Begin Object Class=SpriteEmitter Name=EarthDustEmitterB
         Acceleration=(X=-10.000000,Y=-20.000000,Z=-950.000000)
         RespawnDeadParticles=False
         SpinParticles=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         SymmetryU=True
         SymmetryV=True
         RandomSymmetryU=True
         RandomSymmetryV=True
         Initialized=True
         MaxParticles=10
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-2.000000,Max=2.000000))
         StartSizeRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=1.000000,Max=2.000000))
         CenterU=0.200000
         CenterV=0.200000
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.impactboisM'
         TextureUSubdivisions=1
         TextureVSubdivisions=2
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=2.000000,Max=2.500000)
         InitialDelayRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(X=(Min=-100.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=100.000000,Max=400.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=1.000000,Max=2.000000))
         Name="EarthDustEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.EarthDustEmitter.EarthDustEmitterB'
     bUseCylinderCollision=True
}
