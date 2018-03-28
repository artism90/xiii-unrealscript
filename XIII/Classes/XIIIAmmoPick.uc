//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIAmmoPick extends Ammo;

//_____________________________________________________________________________
event ParseDynamicLoading(LevelInfo MyLI)
{
    Log("ParseDynamicLoading Actor="$self);
    if ( class<Ammunition>(default.InventoryType).default.ProjectileClass != none )
      MyLI.ForcedStaticMeshes[MyLI.ForcedStaticMeshes.Length] =
        StaticMesh(DynamicLoadObject(class<XIIIProjectile>(class<Ammunition>(default.InventoryType).default.ProjectileClass).default.StaticMeshName, class'StaticMesh'));
}

//_____________________________________________________________________________
event float BotDesireability(Pawn Bot)
{
    local Ammunition AlreadyHas;

    AlreadyHas = Ammunition(Bot.FindInventoryType(InventoryType));
    if ( AlreadyHas == None )
      //return (0.35 * MaxDesireability);
      return -1;
    if ( AlreadyHas.AmmoAmount == 0 )
      return MaxDesireability;
    if (AlreadyHas.AmmoAmount >= AlreadyHas.MaxAmmo)
      return -1;

    return ( MaxDesireability * FMin(1, 0.15 * AmmoAmount/AlreadyHas.AmmoAmount) );
}

//_____________________________________________________________________________
// Pickup state: this inventory item is sitting on the ground.
auto state Pickup
{
    /* ValidTouch()
    Validate touch (if valid return true to let other pick me up and trigger event).
    */
    function bool ValidTouch( actor Other )
    {
      local Ammunition AlreadyHas;

      // make sure its a live player
      if ( (Pawn(Other) == None) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).Health <= 0) )
        return false;

      // make sure not touching through wall
      // ELR take EyeHeight into account
      if ( !FastTrace(Other.Location+Pawn(Other).EyeHeight*vect(0,0,1), Location) )
        return false;

      // make sure game will let player pick me up
      if( Level.Game.PickupQuery(Pawn(Other), self) )
      {
        AlreadyHas = Ammunition(Pawn(Other).FindInventoryType(InventoryType));
        if ( (AlreadyHas == none) || (AlreadyHas.AmmoAmount < AlreadyHas.MaxAmmo) )
        {
          TriggerEvent(Event, self, Pawn(Other));
          return true;
        }
        else if ( AlreadyHas.AmmoAmount == AlreadyHas.MaxAmmo )
          PlayerController(Pawn(Other).Controller).MyHud.LocalizedMessage(class'XIIIDialogMessage', 4);
      }
      return false;
    }
}


defaultproperties
{
     RespawnTime=5.000000
     hRespawnSound=Sound'XIIIsound.Multi__SFXMulti.SFXMulti__hRespawnGun'
     DrawType=DT_StaticMesh
     MessageClass=Class'XIII.XIIIPickupMessage'
}
