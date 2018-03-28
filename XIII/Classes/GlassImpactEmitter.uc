//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GlassImpactEmitter extends ImpactEmitter;

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
    Super.PostBeginPlay();
    SpriteEmitter(Emitters[0]).ProjectionNormal = vRand();
}



defaultproperties
{
     ClientImpactSound=Sound'XIIIsound.Impacts__ImpVerre.ImpVerre__hPlayImpVer'
     Begin Object Class=SpriteEmitter Name=GlassImpactEmitterA
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Y=1.000000,Z=0.000000)
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         FadeOutStartTime=0.150000
         FadeInEndTime=0.100000
         MaxParticles=1
         StartSpinRange=(X=(Max=50.000000),Y=(Max=50.000000),Z=(Max=50.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(relativetime=0.150000,RelativeSize=2.000000)
         SizeScale(2)=(relativetime=0.230000,RelativeSize=0.500000)
         SizeScale(3)=(relativetime=0.500000)
         SizeScale(4)=(relativetime=1.000000)
         StartSizeRange=(X=(Min=14.400000,Max=18.000000),Y=(Min=14.400000,Max=18.000000),Z=(Min=14.400000,Max=18.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XIIICine.effets.impactpoing2A'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.300000,Max=0.300000)
         Name="GlassImpactEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.GlassImpactEmitter.GlassImpactEmitterA'
     Begin Object Class=SpriteEmitter Name=GlassImpactEmitterB
         UseColorScale=True
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
         ColorScale(0)=(Color=(B=64,G=64,R=64))
         ColorScale(1)=(relativetime=1.000000)
         FadeOutStartTime=2.000000
         FadeInEndTime=2.000000
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=-0.300000,Max=0.300000),Y=(Min=-0.300000,Max=0.300000))
         SizeScale(1)=(relativetime=0.100000,RelativeSize=1.000000)
         SizeScale(2)=(relativetime=0.500000,RelativeSize=2.000000)
         SizeScale(3)=(relativetime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=0.000000,Max=0.000000))
         InitialParticlesPerSecond=8.000000
         Texture=Texture'XIIICine.effets.rondenlo'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.200000,Max=0.500000)
         Name="GlassImpactEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.GlassImpactEmitter.GlassImpactEmitterB'
     Begin Object Class=SpriteEmitter Name=GlassImpactEmitterC
         Acceleration=(X=-10.000000,Y=-20.000000,Z=-400.000000)
         RespawnDeadParticles=False
         SpinParticles=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         SymmetryU=True
         SymmetryV=True
         RandomSymmetryU=True
         RandomSymmetryV=True
         Initialized=True
         FadeOutStartTime=2.500000
         MaxParticles=5
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-2.000000,Max=2.000000))
         StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000))
         CenterU=0.200000
         CenterV=0.200000
         InitialParticlesPerSecond=100.000000
         Texture=Texture'XIIICine.effets.glass13'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=2.000000,Max=2.500000)
         StartVelocityRange=(X=(Min=-80.000000,Max=80.000000),Y=(Min=-100.000000,Max=50.000000),Z=(Min=100.000000,Max=200.000000))
         VelocityLossRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=2.000000))
         Name="GlassImpactEmitterC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.GlassImpactEmitter.GlassImpactEmitterC'
     bUseCylinderCollision=True
}
