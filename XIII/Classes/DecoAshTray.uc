//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoAshTray extends DecoWeapon;

//    hDownSound=Sound'XIIIsound.Items__CendrierFire.CendrierFire__hCendrierFire'

defaultproperties
{
     SFXWhenBroken=Class'XIII.DecoAshtrayImpactEmitter'
     SFXWhenBrokenNotPawn=Class'XIII.DecoAshTrayDamaged'
     SFXWhenBrokenNoTgt=Class'XIII.DecoAshtrayNoImpactEmitter'
     fDelaySFXBroken=0.200000
     hDownUnusedSound=Sound'XIIIsound.Items__AshtrayFire.AshtrayFire__hAshtrayExplo'
     bHaveAltFire=True
     AltAmmoName=Class'XIII.DecoAshTrayAmmo'
     AltPickupAmmoCount=1
     MeshName="XIIIArmes.FpsCendrierM"
     FireOffset=(X=5.000000,Y=22.000000,Z=-5.000000)
     AltFireOffset=(X=5.000000,Y=22.000000,Z=-5.000000)
     LoadedAltFiringAnim="FireLanc"
     EmptyAltFiringAnim="FireLanc"
     hFireSound=Sound'XIIIsound.Items__AshtrayFire.AshtrayFire__hAshtrayFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__AshtrayPick.AshtrayPick__hAshtrayPick'
     hAltFireSound=Sound'XIIIsound.Items__AshtrayFire.AshtrayFire__hAshtrayAltFire'
     PickupClassName="XIII.AshTrayDecoPick"
     PlayerViewOffset=(X=8.000000,Y=6.000000,Z=-7.000000)
     AttachmentClass=Class'XIII.AshTrayAttach'
     ItemName="Ash Tray"
}
