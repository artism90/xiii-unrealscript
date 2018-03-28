//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoChair extends DecoWeapon;

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
     SFXWhenBroken=Class'XIII.DecoChairImpactEmitter'
     SFXWhenBrokenNotPawn=Class'XIII.DecoChairDamaged'
     SFXWhenBrokenNoTgt=Class'XIII.DecoChairNoImpactEmitter'
     fDelaySFXBroken=0.050000
     fDelayShake=0.350000
     hDownSound=Sound'XIIIsound.Items__ChairLightFire.ChairLightFire__hBrushPlainDown'
     hDownUnusedSound=Sound'XIIIsound.Items__ChairLightFire.ChairLightFire__hChairLightExplo'
     MeshName="XIIIDeco.FpsChaiseLightM"
     hFireSound=Sound'XIIIsound.Items__ChairLightFire.ChairLightFire__hChairLightFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__ChairLightPick.ChairLightPick__hChairLightPick'
     PickupClassName="XIII.ChaiseDeco"
     ThirdPersonRelativeLocation=(X=25.000000,Y=16.000000,Z=20.000000)
     ThirdPersonRelativeRotation=(Pitch=32768)
     AttachmentClass=Class'XIII.ChaiseAttach'
     ItemName="Chair"
}
