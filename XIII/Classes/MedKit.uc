//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MedKit extends Med;

//     Icon=texture'XIIISounds.Icons.IIMedKit'

simulated function PlayUsing()
{
//    local XIIIPawn P;

    DebugLog("@@@"@self@"PlayUsing");
//    P = XIIIPawn(Owner);

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
     iHeal=25
     EffectiveSound=Sound'XIIIsound.Items__MedKitFire.MedKitFire__MedKitFire'
     MeshName="XIIIDeco.FPSMedikitMedM"
     hSelectItemSound=Sound'XIIIsound.Items.MedSel1'
     IconNumber=18
     sItemName="Med Kit"
     ExpireMessage="MedKit was used."
     PickupClassName="XIII.MedPick"
     ThirdPersonRelativeLocation=(X=22.000000,Y=-3.000000,Z=1.000000)
     ThirdPersonRelativeRotation=(Yaw=32768,Roll=16380)
     AttachmentClass=Class'XIII.MedKitAttach'
     ItemName="MED KIT"
}
