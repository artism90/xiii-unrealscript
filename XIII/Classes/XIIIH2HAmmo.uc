//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIH2HAmmo extends XIIIAmmo;

var int H2HDamages;

//_____________________________________________________________________________
// Fists always have ammo
simulated function bool HasAmmo()
{
    return true;
}

//_____________________________________________________________________________
// ELR No Ammo used by fists
function ProcessTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    local H2HDustEmitter B;
    local ImpactEmitter C;

    if ( Other == None )
      return;

    if ( Other.bWorldGeometry )
    {
      B = Spawn(class'H2HDustEmitter',,, HitLocation+HitNormal, Rotator(HitNormal));
      if (B!=none)
      {
        B.NoiseMake(XIIIPawn(Owner), ImpactNoise);
        if ( bPlayHitSound )
        {
          bPlayHitSound = false;
          B.PlaySound(HitSoundMem, HitSoundType);
        }
      }
    }
    else if ( (Other != self) && (Other != Owner) )
    {
      Other.TakeDamage(H2HDamages,  Pawn(Owner), HitLocation, 300.0*X, MyDamageType);
      if ( (Pawn(Other) != none) )
      {
        if ( class<XIIIDamageType>(MyDamageType).default.bSpawnBloodFX && (Level.Game != none) && (Level.Game.GoreLevel == 0) )
          C = Spawn(class'XIIIDamageType'.default.BloodShotEmitterClass,,, HitLocation+HitNormal, Rotator(HitNormal));
        else
          C = Spawn(class'H2HDustEmitter',,, HitLocation+HitNormal, Rotator(HitNormal));
        if (C!=none)
          C.NoiseMake(XIIIPawn(Owner), SoftImpactNoise);
      }
      else
      {
        B = Spawn(class'H2HDustEmitter',,, HitLocation+HitNormal, Rotator(HitNormal));
        if (B!=none)
        {
          B.NoiseMake(XIIIPawn(Owner), ImpactNoise);
          if ( bPlayHitSound )
          {
            bPlayHitSound = false;
            B.PlaySound(HitSoundMem, HitSoundType);
          }
        }
      }
    }
}




defaultproperties
{
     bHandToHand=True
     MaxAmmo=1
     AmmoAmount=1
     ImpactNoise=0.100000
     HitSoundType=1
}
