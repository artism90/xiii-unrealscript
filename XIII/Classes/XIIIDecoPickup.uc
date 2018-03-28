//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIDecoPickup extends Pickup
  abstract;

var class<Emitter> DestroyedSFX;
var sound hExplo;

//_____________________________________________________________________________
event ParseDynamicLoading(LevelInfo MyLI)
{
    Log("ParseDynamicLoading Actor="$self);
    class<Weapon>(default.InventoryType).Static.StaticParseDynamicLoading(MyLI);
//    MyLI.ForcedMeshes[MyLI.ForcedMeshes.Length] = mesh(DynamicLoadObject(class<XIIIWeapon>(default.InventoryType).default.MeshName, class'mesh'));
}

//_____________________________________________________________________________
event Landed(Vector HitNormal)
{
    Setcollision(true,true,true);
    GotoState('Pickup');
}

//_____________________________________________________________________________
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
//    Log("Spawning "$DestroyedSFX);
    if ( DestroyedSFX != none )
      Spawn(DestroyedSFX, self,,location);
    PlaySound(hExplo,0,1,0);
    Destroy();
}

//_____________________________________________________________________________
// ELR don't pick upon touch any of these (sub) classes
auto state Pickup
{
    /* ValidTouch()
    Validate touch (if valid return true to let other pick me up and trigger event).
    */
    function bool ValidTouch( actor Other )
    {
      // make sure its a live player
      if ( (Pawn(Other) == None) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).Health <= 0) )
        return false;

      // make sure not touching through wall
      // ELR take EyeHeight into account
      if ( !FastTrace(Other.Location+Pawn(Other).EyeHeight*vect(0,0,1), Location) )
        return false;

      // Only pick this if controller is picking up
      if ( !XIIIPlayerController(Pawn(Other).Controller).bPickingUp || (XIIIPlayerController(Pawn(Other).Controller).MyInteraction.TargetActor != self) )
        return false;

      // make sure game will let player pick me up
      if( Level.Game.PickupQuery(Pawn(Other), self) )
      {
        TriggerEvent(Event, self, Pawn(Other));
        return true;
      }
      return false;
    }
}


defaultproperties
{
     DestroyedSFX=Class'XIII.DecoThrowShardImpactEmitter'
     PickupMessage=""
     bBlockActors=True
     bBlockPlayers=True
     bCanShootThroughWithRayCastingWeapon=False
     bCanShootThroughWithProjectileWeapon=False
     DrawType=DT_StaticMesh
     MessageClass=Class'XIII.XIIIPickupMessage'
}
