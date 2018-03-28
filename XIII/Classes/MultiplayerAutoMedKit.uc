//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MultiplayerAutoMedKit extends Med;

//_____________________________________________________________________________
// This is called when a usable inventory item has used up it's charge.
simulated function UsedUp()
{
//    Log("@@@ UsedUp for "$self);
    if ( Pawn(Owner) != None )
    {
      bActivatable = false;
/*      XIIIPlayercontroller(XIIIPawn(Owner).controller).cNextItem();
//      Log("  @ UsedUp Next Item="$XIIIPawn(Owner).PendingItem);
      if ( (XIIIPawn(Owner).PendingItem == None) || (XIIIPawn(Owner).PendingItem == self) )
        XIIIPlayercontroller(XIIIPawn(Owner).controller).NextWeapon();

      XIIIPawn(Owner).ChangedWeapon();
*/
      if (Level.Game.StatLog != None)
        Level.Game.StatLog.LogItemDeactivate(Self, XIIIPawn(Owner));
//      Instigator.ReceiveLocalizedMessage( MessageClass, 0, None, None, Self.Class );
    }
    Owner.PlaySound(DeactivateSound);
    Destroy();
}

//_____________________________________________________________________________
// ELR
function PickupFunction(Pawn Other)
{
//    Log("CALL to PickupFunction for "$other);
/*
    if (bActivatable && Other.SelectedItem==None)
      Other.SelectedItem=self;
    if (bActivatable && bAutoActivate && Other.bAutoActivate)
      Activate();
*/
    UseMe();
    UsedUp();
}

//    ItemName="MED KIT"


defaultproperties
{
     iHeal=50
     MeshName="XIIIDeco.FPSMedikitMedM"
     hSelectItemSound=Sound'XIIIsound.Items.MedSel1'
     ExpireMessage="MedKit was used."
     ActivateSound=Sound'XIIIsound.Items.MedFire1'
     PickupClassName="XIII.MedPick"
     ThirdPersonRelativeLocation=(X=22.000000,Y=-3.000000,Z=1.000000)
     ThirdPersonRelativeRotation=(Yaw=32768,Roll=16380)
     AttachmentClass=Class'XIII.MedKitAttach'
}
