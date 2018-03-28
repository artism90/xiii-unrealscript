//-----------------------------------------------------------
//
//-----------------------------------------------------------
class UnderWaterBreathEmitter extends TriggerParticleEmitter;

var float fTimer;
var float fBreathTimer;

//_____________________________________________________________________________
function bool TriggerParticle()
{
    fTimer += 0.25;
    if ( fTimer >= fBreathTimer )
    {
      fTimer -= fBreathTimer;
      Emitters[0].RotationOffset = Pawn(Owner).Rotation;
      Emitters[0].SpawnParticle(int(4*fBreathTimer));
      return true;
    }
}



defaultproperties
{
     fBreathTimer=1.500000
     Begin Object Class=SpriteEmitter Name=UnderWaterBreathEmitterA
         Acceleration=(X=3.000000,Z=30.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         DampRotation=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         ColorScale(0)=(relativetime=0.500000,Color=(B=255,G=255,R=255))
         ColorScale(1)=(relativetime=1.000000,Color=(B=255,G=117,R=117))
         FadeOutStartTime=0.900000
         FadeInEndTime=0.100000
         MaxParticles=15
         AutoResetTimeRange=(Min=3.000000,Max=4.000000)
         UseRotationFrom=PTRS_Offset
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=0.100000,Max=0.100000))
         SizeScale(1)=(relativetime=0.300000,RelativeSize=0.200000)
         SizeScale(2)=(relativetime=0.500000,RelativeSize=1.000000)
         SizeScale(3)=(relativetime=1.000000,RelativeSize=1.200000)
         StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
         InitialParticlesPerSecond=4.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'XIIICine.bulle'
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=1.500000,Max=2.000000)
         StartVelocityRange=(X=(Min=5.000000,Max=20.000000),Y=(Min=-8.000000,Max=8.000000),Z=(Min=-10.000000,Max=10.000000))
         Name="UnderWaterBreathEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.UnderWaterBreathEmitter.UnderWaterBreathEmitterA'
     AutoDestroy=False
     bTrailerSameRotation=True
     Physics=PHYS_Trailer
     CollisionRadius=80.000000
     CollisionHeight=80.000000
}
