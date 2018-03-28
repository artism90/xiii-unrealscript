//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FullMedKit extends Med;

//     Icon=texture'XIIISounds.Icons.IIFullMedKit'

simulated function PlayUsing()
{
//    local XIIIPawn P;

    DebugLog("@@@"@self@"PlayUsing");
//    P = XIIIPawn(Owner);
//
//    if (P != none )
//    {
//        if ( P.IsWounded() )
//        {
            PlayAnim('Fire', 1.5);
            Instigator.PlayRolloffSound(ActivateSound, self);
//        }
//    }
}



defaultproperties
{
     iHeal=75
     EffectiveSound=Sound'XIIIsound.Items__FMedKitFire.FMedKitFire__hFMedKitFire'
     MeshName="XIIIDeco.FPSMedikitFullM"
     hSelectItemSound=Sound'XIIIsound.Items.FMedSel1'
     IconNumber=19
     sItemName="Full Med Kit"
     ExpireMessage="FullMedKit was used."
     InventoryGroup=1
     PickupClassName="XIII.FullMedPick"
     ThirdPersonRelativeLocation=(X=22.000000,Y=-3.000000,Z=1.000000)
     ThirdPersonRelativeRotation=(Yaw=32768,Roll=16380)
     AttachmentClass=Class'XIII.FullMedKitAttach'
     ItemName="FULL MED KIT"
}
