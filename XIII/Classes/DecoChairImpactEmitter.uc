//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoChairImpactEmitter extends BaseDecoEmitters;




defaultproperties
{
     Begin Object Class=SpriteEmitter Name=DecoChairImpactEmitterA
         Acceleration=(Z=10.000000)
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         SymmetryU=True
         SymmetryV=True
         RandomSymmetryU=True
         RandomSymmetryV=True
         Initialized=True
         ColorScale(1)=(relativetime=0.500000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(relativetime=1.000000,Color=(R=128))
         FadeOutFactor=(W=2.000000)
         FadeOutStartTime=0.300000
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(relativetime=0.080000,RelativeSize=6.000000)
         SizeScale(2)=(relativetime=0.200000,RelativeSize=2.000000)
         SizeScale(3)=(relativetime=0.300000,RelativeSize=2.000000)
         SizeScale(4)=(relativetime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=10.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.eclairblanc2'
         SecondsBeforeInactive=1000.000000
         LifetimeRange=(Min=0.400000,Max=0.400000)
         Name="DecoChairImpactEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.DecoChairImpactEmitter.DecoChairImpactEmitterA'
     Begin Object Class=SpriteEmitter Name=DecoChairImpactEmitterB
         Acceleration=(Z=-100.000000)
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         FadeOutStartTime=0.800000
         MaxParticles=1
         StartLocationOffset=(Z=10.000000)
         SizeScale(0)=(RelativeSize=1.500000)
         SizeScale(1)=(relativetime=0.300000,RelativeSize=1.500000)
         SizeScale(2)=(relativetime=0.500000,RelativeSize=1.000000)
         SizeScale(3)=(relativetime=0.600000,RelativeSize=1.100000)
         SizeScale(4)=(relativetime=0.700000,RelativeSize=1.000000)
         SizeScale(5)=(relativetime=0.800000,RelativeSize=1.100000)
         SizeScale(6)=(relativetime=0.900000,RelativeSize=1.000000)
         SizeScale(7)=(relativetime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=20.000000,Max=20.000000),Z=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=10.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XIIICine.effets.death2'
         SecondsBeforeInactive=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
         InitialDelayRange=(Min=0.100000,Max=0.100000)
         StartVelocityRange=(Z=(Min=90.000000,Max=90.000000))
         VelocityLossRange=(Z=(Min=1.000000,Max=1.000000))
         Name="DecoChairImpactEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.DecoChairImpactEmitter.DecoChairImpactEmitterB'
     Begin Object Class=SpriteEmitter Name=DecoChairImpactEmitterC
         Acceleration=(X=5.000000,Y=5.000000,Z=-500.000000)
         RespawnDeadParticles=False
         SpinParticles=True
         AutomaticInitialSpawning=False
         SymmetryU=True
         SymmetryV=True
         RandomSymmetryU=True
         RandomSymmetryV=True
         Initialized=True
         MaxParticles=8
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=1.000000,Max=5.000000),Y=(Min=1.000000,Max=5.000000),Z=(Min=1.000000,Max=5.000000))
         InitialParticlesPerSecond=50.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.glassSSH1'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         SecondsBeforeInactive=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-80.000000,Max=80.000000),Y=(Min=-80.000000,Max=80.000000),Z=(Min=100.000000,Max=300.000000))
         VelocityLossRange=(Z=(Min=1.000000,Max=1.000000))
         Name="DecoChairImpactEmitterC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.DecoChairImpactEmitter.DecoChairImpactEmitterC'
     Begin Object Class=SpriteEmitter Name=DecoChairImpactEmitterD
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         AutomaticInitialSpawning=False
         Initialized=True
         FadeOutStartTime=0.300000
         FadeInEndTime=0.100000
         MaxParticles=10
         StartLocationRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Max=10.000000))
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000),Y=(Min=-0.100000,Max=0.100000))
         SizeScale(0)=(relativetime=0.100000,RelativeSize=0.100000)
         SizeScale(1)=(relativetime=0.200000,RelativeSize=1.000000)
         SizeScale(2)=(relativetime=1.000000)
         StartSizeRange=(X=(Min=2.000000,Max=5.000000),Y=(Min=2.000000,Max=5.000000),Z=(Min=2.000000,Max=5.000000))
         InitialParticlesPerSecond=10.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.effets.eclairblanc'
         SecondsBeforeInactive=1000.000000
         LifetimeRange=(Min=0.500000,Max=0.800000)
         InitialDelayRange=(Min=0.100000,Max=0.100000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
         Name="DecoChairImpactEmitterD"
     End Object
     Emitters(3)=SpriteEmitter'XIII.DecoChairImpactEmitter.DecoChairImpactEmitterD'
     bIgnoreVignetteAlpha=True
     bUnlit=True
     RemoteRole=ROLE_None
}
