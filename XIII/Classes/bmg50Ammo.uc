//-----------------------------------------------------------
//
//-----------------------------------------------------------
class bmg50Ammo extends XIIIBulletsAmmo;

//_____________________________________________________________________________
function ProcessTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    if ( !Level.bLonePlayer )
      LRDamages = SRDamages;
    Super.ProcessTraceHit(W, Other, HitLocation, HitNormal, X, Y, Z);
}


defaultproperties
{
     ShortRange=500.000000
     LongRange=1500.000000
     SRDamages=85
     LRDamages=40
     MaxAmmo=35
     AmmoAmount=10
     MyDamageType=Class'XIII.DTSniped'
     ImpactNoise=1.049000
     SoftImpactNoise=0.262000
     PickupClassName="XIII.bmg50AmmoClip"
     ItemName="BMG50"
}
