//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoBottle extends DecoWeapon;

//_____________________________________________________________________________
simulated function TweenDown()
{
//    Log("TWEENDOWN for"@self@"bProjectileThrown="$bProjectileThrown);
//    log("#"@DBUGFrameCount@" TweenDown call for"@self);
    if ( bProjectileThrown )
      PlayAnim('DownLanc', 1.0);
    else
      PlayAnim('Down', 1.0);
    Instigator.PlayRolloffSound(hDownSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
    if (!bProjectileThrown && DecoAmmo(AmmoType).bUnused)
      Instigator.PlayRolloffSound(hDownUnusedSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
}


defaultproperties
{
     SFXWhenBroken=Class'XIII.DecoBottleImpactEmitter'
     SFXWhenBrokenNotPawn=Class'XIII.DecoBottleDamaged'
     SFXWhenBrokenNoTgt=Class'XIII.DecoBottleNoImpactEmitter'
     fDelaySFXBroken=0.050000
     fDelayShake=0.350000
     hDownSound=Sound'XIIIsound.Items__BottleFire.BottleFire__hBottleDown'
     hDownUnusedSound=Sound'XIIIsound.Items__BottleFire.BottleFire__hBottleExplo'
     bHaveAltFire=True
     AltAmmoName=Class'XIII.DecoBottleAmmo'
     AltPickupAmmoCount=1
     MeshName="XIIIDeco.FpsBouteilleM"
     AltFireOffset=(X=5.000000,Y=17.000000,Z=-5.000000)
     LoadedAltFiringAnim="FireLanc"
     EmptyAltFiringAnim="FireLanc"
     hFireSound=Sound'XIIIsound.Items__BottleFire.BottleFire__hBottleFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__BottlePick.BottlePick__hBottlePick'
     hAltFireSound=Sound'XIIIsound.Items__BottleFire.BottleFire__hBottleAltFire'
     PickupClassName="XIII.BouteilleDeco"
     ThirdPersonRelativeLocation=(X=8.000000,Y=-2.500000,Z=23.000000)
     ThirdPersonRelativeRotation=(Pitch=32768)
     AttachmentClass=Class'XIII.BouteilleAttach'
     ItemName="Bottle"
}
