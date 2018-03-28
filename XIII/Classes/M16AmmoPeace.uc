//-----------------------------------------------------------
//
//-----------------------------------------------------------
class M16AmmoPeace extends M16Ammo;

//_____________________________________________________________________________
function ProcessTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    Local int ActualDamages;
    local int Loc;
    local ImpactEmitter B;

    if (AmmoAmount > 0)
      AmmoAmount -= 1; // Fire
    else
      return; // EmptyShot.

    if ( Other == None )
      return;

    ActualDamages = 0;
//    log(self@"shot for"@ActualDamages@"range"@VSize(HitLocation - W.Location)); // ::DBUG::

    if ( Other.bWorldGeometry )
    {
      B = Spawn(class'BulletDustEmitter',,, HitLocation+HitNormal, Rotator(HitNormal));
      if (B!=none)
      {
        B.NoiseMake(XIIIPawn(Owner), ImpactNoise);
        if ( bPlayHitSound )
        {
          bPlayHitSound = false;
          B.PlaySound(HitSoundMem, HitSoundType);
        }
      }
      if ( (DecalProjectorClass != None) && (!Other.bNoImpact) )
        SpawnDecal(HitLocation, HitNormal);
    }
    else if ( (Other != self) && (Other != Owner) )
    {
      if ( XIIIPawn(Other) != none )
        Loc = XIIIPawn(Other).GetDamageLocation( HitLocation, Other.Location - Instigator.Location );
      if ( Loc <= 1 )
      {
        Other.TakeDamage(ActualDamages, Pawn(Owner), HitLocation, 30000.0*X, MyDamageType);
        if ( Pawn(Other)!=none )
        {
          if ( (Level.Game != none) && (Level.Game.GoreLevel == 0) )
            Spawn(class'XIIIDamageType'.default.BloodShotEmitterClass,Other,, HitLocation+HitNormal, Rotator(-X));

          if (B != none)
            B.NoiseMake(XIIIPawn(Owner), SoftImpactNoise);
        }
      }
      else
      {
        B = Spawn(class'BulletDustEmitter',,, HitLocation+HitNormal, Rotator(HitNormal));
        if (B != none)
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
     bInfiniteAmmo=True
     MaxAmmo=999
     PlayerTransferClassName="XIII.M16Ammo"
     ItemName="5.56 Peace&Love Model"
}
