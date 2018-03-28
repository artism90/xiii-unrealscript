//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIDocumentPick extends XIIIPickup;

//_____________________________________________________________________________
function inventory SpawnCopy(Pawn Other)
{
    local Controller P;
    local Inventory Copy;

    if ( Inventory != None )
    {
      Copy = Inventory;
      Inventory = None;
    }
    else
      Copy = spawn(InventoryType,Other,,,rot(0,0,0));

    Copy.GiveTo( Other );
    if( Level.Game.ShouldRespawn(self) )
      GotoState('Sleeping');
    else
    {
      Copy.event = event;
      Destroy();
    }
    return Copy;
}



defaultproperties
{
     InventoryType=Class'XIII.XIIIDocuments'
     PickupMessage="DOCUMENT"
     PickupSound=Sound'XIIIsound.Items.DossierPick1'
     StaticMesh=StaticMesh'MeshObjetsPickup.dossierPentagone'
     MessageClass=Class'XIII.XIIIImportantItemMessage'
}
