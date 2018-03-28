//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoBarSit extends DecoWeapon;

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
     hDownSound=Sound'XIIIsound.Items__StoolFire.StoolFire__hStoolDown'
     hDownUnusedSound=Sound'XIIIsound.Items__StoolFire.StoolFire__hStoolExplo'
     MeshName="XIIIArmes.FpsBarTabouretM"
     hFireSound=Sound'XIIIsound.Items__StoolFire.StoolFire__hStoolFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__StoolPick.StoolPick__hStoolPick'
     PickupClassName="XIII.BarSitDecoPick"
     ThirdPersonRelativeLocation=(X=25.000000,Y=16.000000,Z=20.000000)
     ThirdPersonRelativeRotation=(Pitch=32768)
     AttachmentClass=Class'XIII.BarSitAttach'
     ItemName="BarSit"
}
