//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoCue extends DecoWeapon;

//_____________________________________________________________________________
simulated function PlayFiring()
{
//    Log("#"$DBUGFrameCount@" PlayFiring call for"@self@"w/FiringMode="$FiringMode);
    PlayAnim('Fire', 1.0);

    PlayFiringSound();
    if ( !HasAmmo() )
      return;

    IncrementFlashCount();
    if ( bDrawMuzzleflash )
      SetUpMuzzleFlash();
}

//_____________________________________________________________________________
simulated function PlaySelect()
{
//    log("#"@DBUGFrameCount@" PlaySelect call for"@self@"w/ mesh="$Mesh);
    bForceFire = false;
    bForceAltFire = false;
    if ( !IsAnimating() || !AnimIsInGroup(0,'Select') )
    {
      PlayAnim('Select',1.0);
    }
    Instigator.PlayRolloffSound(hSelectWeaponSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
}


defaultproperties
{
     SFXWhenBroken=Class'XIII.DecoBarSitImpactEmitter'
     SFXWhenBrokenNotPawn=Class'XIII.DecoBarSitDamaged'
     SFXWhenBrokenNoTgt=Class'XIII.DecoBarSitNoImpactEmitter'
     fDelaySFXBroken=0.050000
     fDelayShake=0.350000
     hDownSound=Sound'XIIIsound.Items__BilliardsCaneFire.BilliardsCaneFire__hCaneDown'
     hDownUnusedSound=Sound'XIIIsound.Items__BilliardsCaneFire.BilliardsCaneFire__hCaneExplo'
     AmmoName=Class'XIII.DecoCueAmmo'
     MeshName="XIIIArmes.FpsCanneM"
     hFireSound=Sound'XIIIsound.Items__BilliardsCaneFire.BilliardsCaneFire__hCaneFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__BilliardsCanePick.BilliardsCanePick__hCanePick'
     PickupClassName="XIII.CueDecoPick"
     ThirdPersonRelativeLocation=(X=25.000000,Y=16.000000,Z=20.000000)
     ThirdPersonRelativeRotation=(Pitch=32768)
     AttachmentClass=Class'XIII.CueAttach'
     ItemName="Cue"
}
