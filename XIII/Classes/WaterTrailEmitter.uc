//-----------------------------------------------------------
//
//-----------------------------------------------------------
class WaterTrailEmitter extends Emitter;



defaultproperties
{
     Begin Object Class=SpriteEmitter Name=WaterTrailEmitterA
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         Initialized=True
         FadeOutFactor=(W=5.000000,X=5.000000,Y=5.000000,Z=5.000000)
         FadeOutStartTime=0.990000
         MaxParticles=50
         StartSizeRange=(X=(Min=2.000000,Max=5.000000),Y=(Min=2.000000,Max=5.000000),Z=(Min=2.000000,Max=5.000000))
         InitialParticlesPerSecond=25.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.bulle'
         StartVelocityRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Max=10.000000))
         Name="WaterTrailEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.WaterTrailEmitter.WaterTrailEmitterA'
}
