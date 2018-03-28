//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BulletDustEmitter extends ImpactEmitter;

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
//    Log(self@"PostBeginPlay");
    Super.PostBeginPlay();
    SpriteEmitter(Emitters[0]).ProjectionNormal = vRand();
}


defaultproperties
{
     ClientImpactSound=Sound'XIIIsound.Impacts__ImpBetonExt.ImpBetonExt__hPlayImpBtE'
     Begin Object Class=SpriteEmitter Name=BulletDustEmitterA
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
         Name="BulletDustEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.BulletDustEmitter.BulletDustEmitterA'
     Begin Object Class=SpriteEmitter Name=BulletDustEmitterB
         Acceleration=(Z=10.000000)
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
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(relativetime=1.000000,Color=(B=48,G=92,R=103))
         FadeOutStartTime=2.000000
         FadeInEndTime=1.200000
         MaxParticles=2
         StartLocationRange=(Z=(Min=-3.000000,Max=3.000000))
         SpinsPerSecondRange=(X=(Min=-0.300000,Max=0.300000),Y=(Min=-0.300000,Max=0.300000))
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
         LifetimeRange=(Min=2.500000,Max=3.000000)
         StartVelocityRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=-10.000000))
         Name="BulletDustEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.BulletDustEmitter.BulletDustEmitterB'
     Begin Object Class=SpriteEmitter Name=BulletDustEmitterC
         UseDirectionAs=PTDU_MoveAndViewUp
         Acceleration=(X=-10.000000,Y=-20.000000,Z=-400.000000)
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
         ColorScale(0)=(Color=(B=128,G=128,R=128))
         ColorScale(1)=(relativetime=1.000000,Color=(B=112,G=112,R=112))
         MaxParticles=3
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-2.000000,Max=2.000000))
         StartSizeRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000))
         CenterU=0.200000
         CenterV=0.200000
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.etincelle'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=2.000000,Max=2.500000)
         StartVelocityRange=(X=(Min=100.000000,Max=400.000000),Y=(Min=-100.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         Name="BulletDustEmitterC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.BulletDustEmitter.BulletDustEmitterC'
     bUseCylinderCollision=True
}
