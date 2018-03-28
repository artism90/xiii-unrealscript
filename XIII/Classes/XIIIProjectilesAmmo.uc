//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIProjectilesAmmo extends XIIIAmmo;

var float fThrowDelay;

//_____________________________________________________________________________
// ELR Default
function PostBeginPlay()
{
    Super.PostBeginPlay();
    // Dynamic load projectile static mesh
    if ( (ProjectileClass != none) && (class<XIIIProjectile>(ProjectileClass).default.StaticMeshName != "") )
    {
      DynamicLoadObject(class<XIIIProjectile>(ProjectileClass).default.StaticMeshName, class'StaticMesh');
    }
}

//_____________________________________________________________________________
function SpawnProjectile(vector Start, rotator Dir)
{
    local XIIIProjectile XP;

    if (AmmoAmount > 0)
      AmmoAmount -= 1;  // Fire
    else
      return;  // Empty Shot
    XP = XIIIProjectile(Spawn(ProjectileClass,,,Start,Dir));

    if ( XP != none )
      XP.SetImpactNoise(SoftImpactNoise, ImpactNoise);
}



defaultproperties
{
     bInstantHit=False
     ImpactNoise=0.157000
     TraceType=32768
}
