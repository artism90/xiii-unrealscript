//-----------------------------------------------------------
//
//-----------------------------------------------------------
class WoodDustEmitter extends ImpactEmitter;

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
    Super.PostBeginPlay();
    SpriteEmitter(Emitters[0]).ProjectionNormal = vRand();
}



defaultproperties
{
     ClientImpactSound=Sound'XIIIsound.Impacts__ImpBoisPlein.ImpBoisPlein__hPlayImpBoiP'
     Begin Object Class=SpriteEmitter Name=WoodDustEmitterA
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
         Name="WoodDustEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.WoodDustEmitter.WoodDustEmitterA'
     Begin Object Class=SpriteEmitter Name=WoodDustEmitterB
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
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(relativetime=0.500000,Color=(B=63,G=119,R=133))
         ColorScale(2)=(Color=(B=104,G=131,R=132))
         FadeOutStartTime=2.000000
         FadeInEndTime=1.200000
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000),Y=(Min=-0.300000,Max=0.300000))
         SizeScale(1)=(relativetime=0.100000,RelativeSize=2.000000)
         SizeScale(2)=(relativetime=0.500000,RelativeSize=1.000000)
         SizeScale(3)=(relativetime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=7.000000,Max=10.000000),Y=(Min=7.000000,Max=10.000000),Z=(Min=7.000000,Max=10.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.mist2'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=2.500000,Max=3.000000)
         StartVelocityRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=-10.000000))
         Name="WoodDustEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.WoodDustEmitter.WoodDustEmitterB'
     Begin Object Class=SpriteEmitter Name=WoodDustEmitterC
         Acceleration=(X=-5.000000,Y=-5.000000,Z=-500.000000)
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
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000))
         StartSizeRange=(X=(Min=0.300000,Max=1.500000),Y=(Min=3.000000,Max=5.000000))
         CenterU=0.200000
         CenterV=0.200000
         InitialParticlesPerSecond=50.000000
         DrawStyle=PTDS_Masked
         Texture=Texture'XIIICine.effets.impactboisM'
         TextureUSubdivisions=1
         TextureVSubdivisions=2
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=2.000000,Max=2.500000)
         StartVelocityRange=(Y=(Min=-100.000000,Max=100.000000),Z=(Min=200.000000,Max=300.000000))
         VelocityLossRange=(Z=(Min=1.000000,Max=2.000000))
         Name="WoodDustEmitterC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.WoodDustEmitter.WoodDustEmitterC'
     Begin Object Class=SpriteEmitter Name=WoodDustEmitterD
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         NoSynchroAnim=True
         SymmetryU=True
         SymmetryV=True
         RandomSymmetryU=True
         RandomSymmetryV=True
         Initialized=True
         FadeOutStartTime=0.500000
         FadeInEndTime=0.500000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(relativetime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(relativetime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=100.000000
         Texture=Texture'XIIICine.effets.DonutsA'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         SubdivisionEnd=6
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
         Name="WoodDustEmitterD"
     End Object
     Emitters(3)=SpriteEmitter'XIII.WoodDustEmitter.WoodDustEmitterD'
     bUseCylinderCollision=True
}
