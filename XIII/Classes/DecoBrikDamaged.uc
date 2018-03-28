//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoBrikDamaged extends BaseDecoEmitters;



defaultproperties
{
     Begin Object Class=MeshEmitter Name=DecoBrikDamagedA
         StaticMesh=StaticMesh'StaticExplosifs.brikfragment'
         UseMeshBlendMode=False
         Acceleration=(Z=-1800.000000)
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         DampRotation=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         DampingFactorRange=(X=(Min=0.800000,Max=0.900000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.100000,Max=0.200000))
         FadeOutStartTime=5.000000
         MaxParticles=3
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-32767.000000,Max=32767.000000),Y=(Max=512.000000))
         RotationDampingFactorRange=(X=(Min=0.200000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.100000,Max=0.200000))
         StartSizeRange=(X=(Min=0.300000,Max=2.000000),Y=(Min=0.300000,Max=2.000000),Z=(Min=0.300000,Max=2.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=6.000000,Max=6.000000)
         StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=200.000000,Max=300.000000))
         Name="DecoBrikDamagedA"
     End Object
     Emitters(0)=MeshEmitter'XIII.DecoBrikDamaged.DecoBrikDamagedA'
     Begin Object Class=SpriteEmitter Name=DecoBrikDamagedB
         Acceleration=(Z=20.000000)
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         FadeOutStartTime=1.000000
         MaxParticles=1
         SpinCCWorCW=(X=1.000000,Y=1.000000,Z=1.000000)
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000),Y=(Min=0.100000,Max=0.200000),Z=(Min=0.100000,Max=0.200000))
         SizeScale(0)=(relativetime=0.050000,RelativeSize=2.000000)
         SizeScale(1)=(relativetime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=500.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.mist2'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Z=(Min=-5.000000,Max=-5.000000))
         Name="DecoBrikDamagedB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.DecoBrikDamaged.DecoBrikDamagedB'
     Begin Object Class=SpriteEmitter Name=DecoBrikDamagedC
         Acceleration=(Z=-1000.000000)
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         Initialized=True
         ColorScale(0)=(Color=(B=128,G=128,R=128))
         ColorScale(1)=(relativetime=1.000000)
         FadeOutStartTime=0.500000
         MaxParticles=10
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000),Y=(Min=-0.100000,Max=0.100000))
         StartSizeRange=(X=(Min=0.200000,Max=1.000000),Y=(Min=0.200000,Max=1.000000),Z=(Min=0.200000,Max=1.000000))
         InitialParticlesPerSecond=500.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.etincelle'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=250.000000,Max=400.000000))
         Name="DecoBrikDamagedC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.DecoBrikDamaged.DecoBrikDamagedC'
     bUnlit=True
     RemoteRole=ROLE_None
}
