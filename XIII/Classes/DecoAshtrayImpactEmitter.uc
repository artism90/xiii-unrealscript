//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoAshTrayImpactEmitter extends BaseDecoEmitters;


defaultproperties
{
     Begin Object Class=SpriteEmitter Name=DecoAshTrayImpactEmitterB
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
         Name="DecoAshTrayImpactEmitterB"
     End Object
     Emitters(0)=SpriteEmitter'XIII.DecoAshtrayImpactEmitter.DecoAshTrayImpactEmitterB'
     Begin Object Class=SpriteEmitter Name=DecoAshTrayImpactEmitterC
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
         Name="DecoAshTrayImpactEmitterC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.DecoAshtrayImpactEmitter.DecoAshTrayImpactEmitterC'
     bIgnoreVignetteAlpha=True
     bUnlit=True
     RemoteRole=ROLE_None
}
