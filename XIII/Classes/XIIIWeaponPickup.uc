//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIWeaponPickup extends WeaponPickup
     abstract;

//_____________________________________________________________________________
function float BotDesireability(Pawn Bot)
{
    local Weapon AlreadyHas;
    local float desire;

    // bots adjust their desire for their favorite weapons
    desire = MaxDesireability; //+ Bot.Controller.AdjustDesireFor(self);

    // see if bot already has a weapon of this type
    AlreadyHas = Weapon(Bot.FindInventoryType(InventoryType));
    if ( AlreadyHas != None )
    {
      // can't pick it up if weapon stay is on
      if ( bWeaponStay && ((Inventory == None) || Inventory.bTossedOut) )
        return 0;
      if ( AlreadyHas.AmmoType == None )
        return 0.25 * desire;

      // bot wants this weapon for the ammo it holds
      if ( AlreadyHas.AmmoType.AmmoAmount > 0 )
        return FMax( 0.25 * desire,
          AlreadyHas.AmmoType.PickupClass.Default.MaxDesireability
          * FMin(1, 0.15 * AlreadyHas.AmmoType.MaxAmmo/AlreadyHas.AmmoType.AmmoAmount) );
      else
        return 0.05;
    }

    // incentivize bot to get this weapon if it doesn't have a good weapon already
    if ( (Bot.Weapon == None) || (Bot.Weapon.AIRating <= 0.4) )
      return 2*desire;

    return desire;
}



defaultproperties
{
     RespawnTime=12.000000
     hRespawnSound=Sound'XIIIsound.Multi__SFXMulti.SFXMulti__hRespawnGun'
     DrawType=DT_StaticMesh
     CollisionRadius=34.000000
     CollisionHeight=10.000000
     MessageClass=Class'XIII.XIIIPickupMessage'
}
