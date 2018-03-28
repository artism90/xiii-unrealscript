//-----------------------------------------------------------
//
//-----------------------------------------------------------
class M16GrenadAmmo extends XIIIProjectilesAmmo;

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

//    PickupClass=class'M16GrenadPick'


defaultproperties
{
     fThrowDelay=0.100000
     bDisplayNameInHUD=True
     MaxAmmo=15
     ProjectileClass=Class'XIII.M16GrenadFlying'
     ImpactNoise=5.000000
     SoftImpactNoise=5.000000
     PickupClassName="XIII.M16GrenadPick"
     ItemName="GRENAD"
}
