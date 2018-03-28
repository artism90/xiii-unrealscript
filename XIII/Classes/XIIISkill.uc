//-----------------------------------------------------------
// Skills are only there to be detected by the related actions via
// FindInventoryType(class'MySkill');
//-----------------------------------------------------------
class XIIISkill extends Powerups;

//_____________________________________________________________________________
// skills don't go into selected slot
function PickupFunction(Pawn Other)
{
    Super.PickupFunction(Other);

/*    if (bActivatable && Other.SelectedItem==None)
      Other.SelectedItem=self;
    if (bActivatable && bAutoActivate && Other.bAutoActivate)
      Activate(); */
}



defaultproperties
{
}
