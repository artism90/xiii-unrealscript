//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DrowningEmitter extends Emitter;

/*
    Begin Object Class=SpriteEmitter Name=DrowningEmitterA
        Acceleration=(X=-3.000000,Y=20.000000,Z=20.000000)
        MaxParticles=70
        SecondsBeforeInactive=10000.0
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
        InitialParticlesPerSecond=70.000000
        AutomaticInitialSpawning=False
        Texture=Texture'XIIICine.Bulle'
        LifetimeRange=(Min=1.000000,Max=1.500000)
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-10.000000,Max=50.000000),Z=(Min=30.000000,Max=50.000000))
    End Object
    Emitters(0)=SpriteEmitter'DrowningEmitterA'
    Begin Object Class=SpriteEmitter Name=DrowningEmitterB
        Acceleration=(X=0.000000,Y=0.000000,Z=10.000000)
        FadeOutStartTime=3.000000
        FadeOut=True
        MaxParticles=2
        SecondsBeforeInactive=10000.0
        RespawnDeadParticles=False
        StartLocationRange=(Z=(Max=5.000000))
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-1.000000,Max=0.500000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeTime=0.000000,RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.200000,RelativeSize=4.000000)
        SizeScale(2)=(RelativeTime=0.400000,RelativeSize=8.000000)
        SizeScale(3)=(RelativeTime=0.600000,RelativeSize=4.000000)
        SizeScale(4)=(RelativeTime=0.900000,RelativeSize=10.000000)
        StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
        InitialParticlesPerSecond=1000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'XIIICine.Bulle'
        StartVelocityRange=(Z=(Min=-1.000000,Max=1.000000))
        LifetimeRange=(Min=3.000000,Max=4.000000)
    End Object
    Emitters(1)=SpriteEmitter'DrowningEmitterB'
*/

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=DrowningEmitterA
         Acceleration=(X=-3.000000,Y=20.000000,Z=20.000000)
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         Initialized=True
         MaxParticles=70
         AutoResetTimeRange=(Min=1.000000,Max=1.000000)
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
         InitialParticlesPerSecond=150.000000
         Texture=Texture'XIIICine.bulle'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=2.000000,Max=2.500000)
         StartVelocityRange=(X=(Min=-40.000000,Max=40.000000),Y=(Min=-10.000000,Max=50.000000),Z=(Min=10.000000,Max=40.000000))
         VelocityLossRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=1.000000))
         Name="DrowningEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.DrowningEmitter.DrowningEmitterA'
     Begin Object Class=SpriteEmitter Name=DrowningEmitterB
         Acceleration=(Z=50.000000)
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         FadeOutStartTime=3.000000
         FadeInEndTime=0.200000
         MaxParticles=20
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Max=50.000000),Z=(Max=32.000000))
         SphereRadiusRange=(Min=32.000000,Max=32.000000)
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=0.500000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(relativetime=0.200000,RelativeSize=4.000000)
         SizeScale(2)=(relativetime=0.400000,RelativeSize=8.000000)
         SizeScale(3)=(relativetime=0.600000,RelativeSize=15.000000)
         SizeScale(4)=(relativetime=1.000000,RelativeSize=20.000000)
         StartSizeRange=(X=(Min=1.000000,Max=4.000000),Y=(Min=1.000000,Max=4.000000),Z=(Min=1.000000,Max=2.000000))
         CenterU=0.100000
         CenterV=0.100000
         InitialParticlesPerSecond=20.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.bulle'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Max=5.000000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-50.000000,Max=-50.000000),Z=(Min=-50.000000,Max=-80.000000))
         VelocityLossRange=(Z=(Max=1.000000))
         Name="DrowningEmitterB"
     End Object
     Emitters(1)=SpriteEmitter'XIII.DrowningEmitter.DrowningEmitterB'
     Begin Object Class=SpriteEmitter Name=DrowningEmitterC
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
         MaxParticles=40
         StartLocationOffset=(Z=32.000000)
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=64.000000,Max=64.000000)
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(relativetime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(relativetime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'XIIICine.effets.DonutsA'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         SubdivisionEnd=6
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
         InitialDelayRange=(Min=1.000000,Max=1.000000)
         Name="DrowningEmitterC"
     End Object
     Emitters(2)=SpriteEmitter'XIII.DrowningEmitter.DrowningEmitterC'
     AutoDestroy=False
     CollisionRadius=80.000000
     CollisionHeight=80.000000
}