//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BloodShotEmitter extends ImpactEmitter;

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
    if ( Level.bLonePlayer && Level.Game.bAlternateMode )
    {
      Emitters[0].Texture = texture'XIIICine.effets.jikleblood_2';
      Emitters[0].ColorScale[1].Color.R=0;
      Emitters[0].ColorScale[1].Color.G=255;
      Emitters[1].Texture = texture'XIIICine.effets.jikleblood_2';
      Emitters[2].Texture = texture'XIIICine.effets.jikleblood_2';
      Emitters[2].ColorScale[1].Color.B=255;
      Emitters[2].ColorScale[1].Color.G=255;
    }
}


defaultproperties
{
     Begin Object Class=SpriteEmitter Name=BloodShotEmitterA
         Acceleration=(Z=-150.000000)
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
         ColorScale(1)=(relativetime=0.500000,Color=(R=255))
         ColorScale(2)=(relativetime=1.000000,Color=(B=255,G=255,R=255))
         FadeOutStartTime=0.250000
         MaxParticles=1
         StartLocationOffset=(X=10.000000)
         SpinCCWorCW=(X=1.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=0.200000,Max=0.500000),Y=(Min=0.200000,Max=0.500000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(relativetime=0.080000,RelativeSize=6.000000)
         SizeScale(2)=(relativetime=0.150000,RelativeSize=3.000000)
         SizeScale(3)=(relativetime=0.220000,RelativeSize=6.000000)
         SizeScale(4)=(relativetime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=5.000000,Max=5.000000))
         InitialParticlesPerSecond=20.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XIIICine.effets.jikleblood'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(Z=(Min=30.000000,Max=30.000000))
         VelocityLossRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=3.000000))
         Name="BloodShotEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.BloodShotEmitter.BloodShotEmitterA'
     Begin Object Class=SpriteEmitter Name=BloodShotEmitterB
         Acceleration=(Z=-50.000000)
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
         FadeOutStartTime=0.100000
         MaxParticles=1
         StartLocationOffset=(X=5.000000)
         SpinCCWorCW=(X=0.000000,Y=1.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=0.200000,Max=0.500000),Y=(Min=0.200000,Max=0.500000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(relativetime=0.800000,RelativeSize=6.000000)
         SizeScale(2)=(relativetime=0.150000,RelativeSize=3.000000)
         SizeScale(3)=(relativetime=0.220000,RelativeSize=6.000000)
         SizeScale(4)=(relativetime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=3.000000,Max=3.000000))
         InitialParticlesPerSecond=20.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XIIICine.effets.jikleblood'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRange=(Z=(Min=25.000000,Max=25.000000))
         Name="BloodShotEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.BloodShotEmitter.BloodShotEmitterB'
     Begin Object Class=SpriteEmitter Name=BloodShotEmitterC
         Acceleration=(Z=-150.000000)
         UseColorScale=True
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
         ColorScale(1)=(relativetime=0.200000,Color=(R=255))
         ColorScale(2)=(relativetime=1.000000,Color=(B=192,G=192,R=192))
         FadeOutStartTime=0.800000
         FadeInFactor=(W=0.000000,Y=0.000000,Z=10.000000)
         FadeInEndTime=0.100000
         MaxParticles=10
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=3.000000)
         SizeScale(1)=(relativetime=0.100000,RelativeSize=1.000000)
         SizeScale(2)=(relativetime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XIIICine.effets.goutteblood'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Max=100.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=50.000000,Max=120.000000))
         VelocityLossRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=1.000000,Max=1.000000))
         Name="BloodShotEmitterC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.BloodShotEmitter.BloodShotEmitterC'
     bUseCylinderCollision=True
}
