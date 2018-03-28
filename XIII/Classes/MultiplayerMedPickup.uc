//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MultiplayerMedPickup extends Pickup;

//_____________________________________________________________________________
event ParseDynamicLoading(LevelInfo MyLI)
{
    Log("ParseDynamicLoading Actor="$self);
    (default.InventoryType).Static.StaticParseDynamicLoading(MyLI);
//    MyLI.ForcedMeshes[MyLI.ForcedMeshes.Length] = mesh(DynamicLoadObject(class<Weapon>(default.InventoryType).default.MeshName, class'mesh'));
}

//_____________________________________________________________________________
// ELR Let's override the TriggerEvent.
auto state Pickup
{
    function bool ValidTouch( actor Other )
    {
      // make sure its a live player
      if ( (Pawn(Other)==none) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).Health <= 0) )
        return false;
      // make sure not touching through wall
      if ( !FastTrace(Other.Location+Pawn(Other).EyeHeight*vect(0,0,1), Location) )
        return false;
      // make sure game will let player pick me up
      if( Level.Game.PickupQuery(Pawn(Other), self) )
      {
        TriggerEvent(Event, self, Pawn(Other));
        return true;
      }
      return false;
    }

    // When touched by an actor.
    function Touch( actor Other )
    {
      local Inventory Copy;

      // If touched by a player pawn, let him pick this up.
      if( ValidTouch(Other) )
      {
        Copy = SpawnCopy(Pawn(Other));
        AnnouncePickup(Pawn(Other));
        Copy.PickupFunction(Pawn(Other));
      }
      // don't allow inventory to pile up (frame rate hit)
      else if ( (Inventory != None) && (Pickup(Other) != none)
        && (Pickup(Other).Inventory != None) )
        Destroy();
    }
}



defaultproperties
{
     RespawnTime=5.000000
     PickupMessage="Got a XIII Item ::BUG:: (Message should be defined in sub-classes) !!"
     hRespawnSound=Sound'XIIIsound.Multi__SFXMulti.SFXMulti__hRespawnGun'
     CollisionRadius=34.000000
     CollisionHeight=8.000000
     MessageClass=Class'XIII.XIIIPickupMessage'
}
