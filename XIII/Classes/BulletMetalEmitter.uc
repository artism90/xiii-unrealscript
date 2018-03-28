//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BulletMetalEmitter extends ImpactEmitter;

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
//    Log(self@"PostBeginPlay");
    Super.PostBeginPlay();
    SpriteEmitter(Emitters[0]).ProjectionNormal = vRand();
}


defaultproperties
{
     ClientImpactSound=Sound'XIIIsound.Impacts__ImpMetal.ImpMetal__hPlayImpMet'
     Begin Object Class=SpriteEmitter Name=BulletMetalEmitterA
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=1.000000,Y=1.000000,Z=0.000000)
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         SymmetryU=True
         SymmetryV=True
         RandomSymmetryU=True
         RandomSymmetryV=True
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
         Name="BulletMetalEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.BulletMetalEmitter.BulletMetalEmitterA'
     Begin Object Class=SpriteEmitter Name=BulletMetalEmitterB
         UseDirectionAs=PTDU_MoveAndViewUp
         Acceleration=(Z=-80.000000)
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UniformSize=False
         AutomaticInitialSpawning=False
         Initialized=True
         FadeOutStartTime=0.500000
         MaxParticles=10
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=5.000000,Max=20.000000),Z=(Min=0.000000,Max=0.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.hjaunestatic'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.050000,Max=0.300000)
         StartVelocityRange=(X=(Min=100.000000,Max=200.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=100.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=5.000000),Y=(Min=1.000000,Max=1.000000),Z=(Max=1.000000))
         RelativeWarmupTime=1.000000
         Name="BulletMetalEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.BulletMetalEmitter.BulletMetalEmitterB'
     Begin Object Class=SpriteEmitter Name=BulletMetalEmitterC
         Acceleration=(Z=5.000000)
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
         ColorScale(0)=(Color=(B=176,G=176,R=176))
         ColorScale(1)=(relativetime=0.500000,Color=(B=115,G=106,R=55))
         ColorScale(2)=(relativetime=1.000000,Color=(B=158,G=158,R=158))
         FadeOutStartTime=1.500000
         FadeInEndTime=0.100000
         MaxParticles=2
         StartLocationRange=(Z=(Min=-5.000000,Max=5.000000))
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000),Y=(Min=-0.100000,Max=0.100000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(relativetime=0.100000,RelativeSize=1.000000)
         SizeScale(2)=(relativetime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         CenterU=0.200000
         CenterV=0.200000
         InitialParticlesPerSecond=10.000000
         Texture=Texture'XIIICine.effets.mist3'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Z=(Max=-5.000000))
         Name="BulletMetalEmitterC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.BulletMetalEmitter.BulletMetalEmitterC'
     bUseCylinderCollision=True
}
