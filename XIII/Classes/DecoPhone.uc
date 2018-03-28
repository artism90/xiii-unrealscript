//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoPhone extends DecoWeapon;

//_____________________________________________________________________________
simulated function TweenDown()
{
//    Log("TWEENDOWN for"@self@"bProjectileThrown="$bProjectileThrown);
//    log("#"@DBUGFrameCount@" TweenDown call for"@self);
    if ( bProjectileThrown )
      PlayAnim('DownLanc', 1.0);
    else
      PlayAnim('Down', 1.0);
}


defaultproperties
{
     SFXWhenBroken=Class'XIII.DecoBottleImpactEmitter'
     SFXWhenBrokenNotPawn=Class'XIII.DecoBottleDamaged'
     SFXWhenBrokenNoTgt=Class'XIII.DecoBottleNoImpactEmitter'
     fDelaySFXBroken=0.050000
     fDelayShake=0.350000
     hDownSound=Sound'XIIIsound.Items__BottleFire.BottleFire__hBottleFire'
     bHaveAltFire=True
     AltAmmoName=Class'XIII.DecoPhoneAmmo'
     AltPickupAmmoCount=1
     MeshName="XIIIArmes.FPSPhoneM"
     AltFireOffset=(X=5.000000,Y=17.000000,Z=-5.000000)
     LoadedAltFiringAnim="FireLanc"
     EmptyAltFiringAnim="FireLanc"
     hFireSound=Sound'XIIIsound.Items__BottleFire.BottleFire__hBottleFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__BottlePick.BottlePick__hBottlePick'
     PickupClassName="XIII.PhoneDecoPick"
     PlayerViewOffset=(Z=-6.500000)
     ThirdPersonRelativeLocation=(X=8.000000,Y=-2.500000,Z=23.000000)
     ThirdPersonRelativeRotation=(Pitch=32768)
     AttachmentClass=Class'XIII.PhoneAttach'
     ItemName="Phone"
}
