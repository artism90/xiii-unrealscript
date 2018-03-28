//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FGrenadAmmo extends XIIIProjectilesAmmo;

//_____________________________________________________________________________
// Executed on server, need ProjectileLifeTime from client
function SpawnProjectile(vector Start, rotator Dir)
{
    local XIIIProjectile XP;

    if (AmmoAmount > 0)
      AmmoAmount -= 1;  // Fire
    else
      return;  // Empty Shot
    XP = XIIIProjectile(Spawn(ProjectileClass,owner,,Start,Dir));

    if ( XP != none )
    {
      XP.SetImpactNoise(SoftImpactNoise, ImpactNoise);
      if ( Pawn(Owner).IsPlayerPawn() )
        FGrenadFlying(XP).fLifeTime = FGrenadB(Pawn(Owner).Weapon).ProjectileLifeTime - Level.TimeSeconds;

      //SOUTHEND Set the projectile so it will spawn a viewport just before the explosion
      if (FGrenadFlying(XP).fLifeTime>0.5)
        FGrenadFlying(XP).SetPreExplosion(FGrenadFlying(XP).fLifeTime-0.5);
    }
}

//    PickupClass=class'FGrenadPick'


defaultproperties
{
     fThrowDelay=0.130000
     MaxAmmo=15
     AmmoAmount=1
     ProjectileClass=Class'XIII.FGrenadFlying'
     ImpactNoise=6.300000
     SoftImpactNoise=6.300000
     PickupClassName="XIII.FGrenadPick"
     ItemName="FRAG. GRENADE"
}
