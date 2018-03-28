//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GrenadAmmo extends XIIIProjectilesAmmo;

//_____________________________________________________________________________
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
        GrenadFlying(XP).fLifeTime = GrenadB(Pawn(Owner).Weapon).ProjectileLifeTime - Level.TimeSeconds;
      //SOUTHEND Set the projectile so it will spawn a viewport just before the explosion
      if (GrenadFlying(XP).fLifeTime>0.5)
        GrenadFlying(XP).SetPreExplosion(GrenadFlying(XP).fLifeTime-0.5);
    }
}

//    PickupClass=class'GrenadPick'


defaultproperties
{
     fThrowDelay=0.090000
     MaxAmmo=15
     AmmoAmount=1
     ProjectileClass=Class'XIII.GrenadFlying'
     ImpactNoise=6.300000
     SoftImpactNoise=6.300000
     PickupClassName="XIII.GrenadPick"
     ItemName="Grenade"
}
