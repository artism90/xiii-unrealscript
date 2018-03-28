//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HarponFlying extends XIIIProjectile;

var WaterTrailEmitter WTE;

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    Velocity = Vector(Rotation) * Speed;
    SetTimer(0.5, false);
    if ( PhysicsVolume.bWaterVolume )
    {
      WTE = Spawn(class'WaterTrailEmitter',self,, Location, Rotation);
      WTE.SetBase(Self);
    }
    bSplashed = false;
}

//_____________________________________________________________________________
simulated function Timer()
{
    SetPhysics(PHYS_Falling);
}

//_____________________________________________________________________________
simulated event Destroyed()
{
    if ( (WTE != none) && (WTE.Emitters.Length > 0) )
    {
      WTE.Emitters[0].InitialParticlesPerSecond = 0;
      WTE.SetBase(none);
    }
//      WTE.Destroy();
    Super.Destroyed();
}

//_____________________________________________________________________________
event PhysicsVolumeChange( PhysicsVolume NewVolume )
{
    if ( NewVolume.bWaterVolume && (WTE == none) )
    {
      WTE = Spawn(class'WaterTrailEmitter',self,, Location, Rotation);
      WTE.SetBase(Self);
    }
    else if ( !NewVolume.bWaterVolume && (WTE != none) && (WTE.Emitters.Length > 0) )
    {
      WTE.Emitters[0].InitialParticlesPerSecond = 0;
      WTE.SetBase(none);
    }
}


// default bSplahed to true to prevent splash playing at underwater spawn


defaultproperties
{
     bSpawnDecal=False
     bSplashed=True
     HitSoundType=3
     aVisualImpact=Class'XIII.HarpoonInWall'
     InHeadClass=Class'XIII.ProjectileInHead'
     StaticMeshName="MeshArmesPickup.HarponIA"
     Speed=2000.000000
     MaxSpeed=4000.000000
     Damage=100.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'XIII.DTPierced'
     DrawType=DT_StaticMesh
     LifeSpan=6.000000
}
