//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoThrowBottleImpactEmitter extends BaseDecoEmitters;



defaultproperties
{
     Begin Object Class=MeshEmitter Name=DecoThrowBottleImpactEmitterA
         StaticMesh=StaticMesh'StaticExplosifs.bouteillefragment'
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
         StartLocationOffset=(Z=50.000000)
         StartLocationRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-32767.000000,Max=32767.000000),Y=(Max=512.000000))
         RotationDampingFactorRange=(X=(Min=0.200000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.100000,Max=0.200000))
         StartSizeRange=(X=(Min=0.700000,Max=2.000000),Y=(Min=0.700000,Max=2.000000),Z=(Min=0.700000,Max=2.000000))
         InitialParticlesPerSecond=50000.000000
         DrawStyle=PTDS_AlphaBlend
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=6.000000,Max=6.000000)
         StartVelocityRange=(X=(Min=-20.000000,Max=200.000000),Y=(Min=-100.000000,Max=100.000000))
         Name="DecoThrowBottleImpactEmitterA"
     End Object
     Emitters(0)=MeshEmitter'XIII.DecoThrowBottleImpactEmitter.DecoThrowBottleImpactEmitterA'
     Begin Object Class=SpriteEmitter Name=DecoThrowBottleImpactEmitterB
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         MaxParticles=1
         StartLocationOffset=(Z=10.000000)
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(relativetime=0.250000,RelativeSize=0.800000)
         SizeScale(1)=(relativetime=0.500000,RelativeSize=1.500000)
         SizeScale(2)=(relativetime=0.750000,RelativeSize=1.200000)
         StartSizeRange=(X=(Min=40.000000,Max=40.000000),Y=(Min=40.000000,Max=40.000000),Z=(Min=40.000000,Max=40.000000))
         InitialParticlesPerSecond=5000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XIIICine.effets.cling'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
         Name="DecoThrowBottleImpactEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.DecoThrowBottleImpactEmitter.DecoThrowBottleImpactEmitterB'
     Begin Object Class=SpriteEmitter Name=DecoThrowBottleImpactEmitterC
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         FadeOutStartTime=0.200000
         FadeInEndTime=0.500000
         MaxParticles=1
         StartLocationRange=(Z=(Max=20.000000))
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(relativetime=0.300000,RelativeSize=0.500000)
         SizeScale(2)=(relativetime=0.800000,RelativeSize=0.050000)
         SizeScale(3)=(relativetime=1.000000,RelativeSize=0.010000)
         StartSizeRange=(X=(Max=200.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'XIIICine.effets.eclairblanc'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.800000,Max=0.800000)
         Name="DecoThrowBottleImpactEmitterC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.DecoThrowBottleImpactEmitter.DecoThrowBottleImpactEmitterC'
     bUnlit=True
     RemoteRole=ROLE_None
}
