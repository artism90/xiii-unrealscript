//-----------------------------------------------------------
// Docs on the Twenties.
//-----------------------------------------------------------
class XIIIDocuments extends Powerups;

var name EventCausedOnPick;

//_____________________________________________________________________________
// documents don't go into selected slot
function PickupFunction(Pawn Other)
{
    Super.PickupFunction(Other);
}

//_____________________________________________________________________________
// Give this inventory item to a pawn.
function GiveTo( pawn Other )
{
//    Log("GIVETO (inventory)"@self@"to"@Other);

	// cause event on pick
	if (EventCausedOnPick != 'none' )
        TriggerEvent(EventCausedOnPick,none,none );

	Super.GiveTo( Other );
}

//_____________________________________________________________________________
// Transfer this inventory to Player (for SearchCorpse)
function Transfer( pawn Other )
{

//    Log("TRANSFER (inventory)"@self@"to"@Other);
	if ( Instigator != none )
	{
		DetachFromPawn(Instigator);
		Instigator.DeleteInventory(self);
	}

	if ( PickupClass != none )
	{
		Other.PlaySound(PickupClass.default.PickupSound);
		Other.ReceiveLocalizedMessage( PickupClass.default.MessageClass, 0, None, None, PickupClass );
	}

	GiveTo(Other);

}




defaultproperties
{
     PickupClassName="XIII.XIIIDocumentPick"
     Charge=1
     ItemName="DOCUMENT"
     bTravel=False
}
