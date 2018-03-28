//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EventItemPick extends XIIIPickup;

var() mesh FpsMeshToUse;
//var() texture IconToUse;
var() sound InvSelectItemSound;
var() sound InvActivateSound;

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
    Copy.Mesh = FpsMeshToUse;
    Copy.event = event;
    if ( ((XIIIItems(Copy) == none) || (XIIIItems(Copy).sItemName == "")) && (InvItemName != "")  )
      Copy.ItemName = InvItemName;
//    Copy.Icon = IconToUse;
    PowerUps(Copy).ActivateSound = InvActivateSound;
    XIIIItems(Copy).hSelectItemSound = InvSelectItemSound;

    if( Level.Game.ShouldRespawn(self) )
      StartSleeping();
    else
      Destroy();
    return Copy;
}

//    Mesh=VertMesh'XIIIDeco.ClefM'


defaultproperties
{
     FpsMeshToUse=SkeletalMesh'XIIIArmes.fpsM'
     InventoryType=Class'XIII.EventItem'
     RespawnTime=0.000000
     StaticMesh=StaticMesh'MeshObjetsPickup.clef'
     MessageClass=Class'XIII.XIIIImportantItemMessage'
}
