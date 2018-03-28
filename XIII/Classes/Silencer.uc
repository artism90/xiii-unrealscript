//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Silencer extends XIIIItems;

//_____________________________________________________________________________
function PickupFunction(Pawn Other)
{
    Super.PickupFunction(Other);
    if ( Level.Game.bInventorySetup )
      XIIIWeapon(Other.Weapon).UpdateSilencer();
}

//_____________________________________________________________________________
function GiveTo( pawn Other )
{
  	Instigator = Other;
  	Other.AddInventory( Self );
  	GotoState('');
    if ( Level.Game.bInventorySetup )
      XIIIWeapon(Other.Weapon).UpdateSilencer();
}



defaultproperties
{
     bCanHaveMultipleCopies=True
     PickupClassName="XIII.SilencerPick"
     ItemName="SILENCER"
}
