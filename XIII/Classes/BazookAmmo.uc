//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BazookAmmo extends XIIIProjectilesAmmo;

// bHandToHand setup for disabling autoaim (but nothing else).



defaultproperties
{
     bHandToHand=True
     MaxAmmo=8
     AmmoAmount=1
     ProjectileClass=Class'XIII.BazookRocket'
     ImpactNoise=6.300000
     SoftImpactNoise=6.300000
     PickupClassName="XIII.BazookAmmoClip"
     ItemName="Rockets"
}
