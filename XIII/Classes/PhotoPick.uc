//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PhotoPick extends XIIIPickup;

var() Texture PhotographyMat;

//_____________________________________________________________________________
// Either give this inventory to player Other, or spawn a copy
// and give it to the player Other, setting up original to be respawned.
//
function inventory SpawnCopy( pawn Other )
{
    local inventory Copy;

    if ( Inventory != None )
    {
      Copy = Inventory;
      Inventory = None;
    }
    else
      Copy = spawn(InventoryType,Other,,,rot(0,0,0));

    Copy.GiveTo( Other );
    // ELR for this class modify the copy mesh
//    Copy.Mesh = FpsMeshToUse;

    if( Level.Game.ShouldRespawn(self) )
      StartSleeping();
    else
    {
      Photo(Copy).PhotoMat = PhotographyMat;
      Copy.Event = Event;
      Destroy();
    }
    return Copy;
}

//_____________________________________________________________________________
Auto State Pickup
{
    function bool ValidTouch( actor Other )
    {
      // make sure its a live player
      if ( !Pawn(Other).Controller.bIsPlayer || !Pawn(Other).bCanPickupInventory || (Pawn(Other).Health <= 0) )
        return false;
      // make sure not touching through wall
      if ( !FastTrace(Other.Location+Pawn(Other).EyeHeight*vect(0,0,1), Location) )
        return false;
      if ( bCauseEventOnPick )
        TriggerEvent(Event, self, Pawn(Other));
      return true;
    }
}

//    DrawType=DT_Mesh
//    Mesh=VertMesh'XIIIDeco.photokimM'


defaultproperties
{
     InventoryType=Class'XIII.Photo'
     PickupMessage="PHOTOGRAPH"
     PickupSound=Sound'XIIIsound.Items.GiletPick1'
     StaticMesh=StaticMesh'MeshObjetsPickup.photokim'
     MessageClass=Class'XIII.XIIIImportantItemMessage'
}
