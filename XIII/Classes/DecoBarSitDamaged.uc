//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoBarSitDamaged extends BaseDecoEmitters;


defaultproperties
{
     Begin Object Class=MeshEmitter Name=DecoBarSitDamagedA
         StaticMesh=StaticMesh'StaticExplosifs.chaiselightfragment'
         UseMeshBlendMode=False
         Acceleration=(Z=-950.000000)
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         DampRotation=True
         AutomaticInitialSpawning=False
         Initialized=True
         DampingFactorRange=(X=(Min=0.800000,Max=0.900000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.100000,Max=0.200000))
         FadeOutStartTime=5.000000
         MaxParticles=10
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-50.000000,Max=50.000000))
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-32767.000000,Max=32767.000000),Y=(Max=512.000000))
         RotationDampingFactorRange=(X=(Min=0.200000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.100000,Max=0.200000))
         StartSizeRange=(X=(Min=0.300000,Max=1.000000),Y=(Min=0.300000,Max=1.000000),Z=(Min=0.300000,Max=1.000000))
         InitialParticlesPerSecond=50000.000000
         DrawStyle=PTDS_AlphaBlend
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=6.000000,Max=6.000000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=300.000000,Max=500.000000))
         Name="DecoBarSitDamagedA"
     End Object
     Emitters(0)=MeshEmitter'XIII.DecoBarSitDamaged.DecoBarSitDamagedA'
     Begin Object Class=SpriteEmitter Name=DecoBarSitDamagedB
         Acceleration=(Z=30.000000)
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         FadeOutStartTime=1.500000
         FadeInEndTime=0.300000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(relativetime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(relativetime=1.000000,RelativeSize=0.800000)
         StartSizeRange=(X=(Min=20.000000,Max=50.000000),Y=(Min=20.000000,Max=50.000000),Z=(Min=20.000000,Max=50.000000))
         InitialParticlesPerSecond=20.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.mist2'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Z=(Min=-10.000000,Max=-10.000000))
         Name="DecoBarSitDamagedB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.DecoBarSitDamaged.DecoBarSitDamagedB'
     Begin Object Class=SpriteEmitter Name=DecoBarSitDamagedC
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(relativetime=1.000000)
         FadeOutStartTime=0.250000
         FadeInEndTime=0.100000
         MaxParticles=2
         StartLocationOffset=(Z=25.000000)
         SizeScale(0)=(RelativeSize=0.900000)
         SizeScale(1)=(relativetime=1.000000,RelativeSize=1.000000)
         SizeScaleRepeats=2.000000
         StartSizeRange=(X=(Min=15.000000,Max=20.000000),Y=(Min=15.000000,Max=20.000000),Z=(Min=15.000000,Max=20.000000))
         InitialParticlesPerSecond=10.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XIIICine.effets.crac'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(Z=(Min=2.000000,Max=10.000000))
         Name="DecoBarSitDamagedC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.DecoBarSitDamaged.DecoBarSitDamagedC'
     bUnlit=True
     RemoteRole=ROLE_None
}
