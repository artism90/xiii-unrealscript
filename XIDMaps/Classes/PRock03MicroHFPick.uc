//___________________________________________________________
//
//___________________________________________________________
class PRock03MicroHFPick extends EventItemPick;


//___________________________________________________________
auto state Pickup
{
	function bool ValidTouch( actor Other )
	{

		local Inventory Copy;

		// make sure its a live player
		if ( (Pawn(Other)==none) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).Health <= 0) )
			return false;
		// make sure not touching through wall
		if ( !FastTrace(Other.Location+Pawn(Other).EyeHeight*vect(0,0,1), Location) )
			return false;
		// make sure game will let player pick me up
		if( Level.Game.PickupQuery(Pawn(Other), self) )
		{
			if ( bCauseEventOnPick )
			{
				TriggerEvent(Event, self, Pawn(Other));
			}
			return true;
		}
		return false;
	}
}



//___________________________________________________________


defaultproperties
{
     InvSelectItemSound=Sound'XIIIsound.Items.PassSel1'
     InvActivateSound=Sound'XIIIsound.Items.PassFire1'
     InvItemName="HF Micro"
     bCauseEventOnPick=True
     InventoryType=None
     PickupMessage="HF Micro"
     PickupSound=Sound'XIIIsound.Items.PassPick1'
     StaticMesh=StaticMesh'MeshObjetsPickup.HF'
}
