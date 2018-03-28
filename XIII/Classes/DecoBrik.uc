//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoBrik extends DecoWeapon;

//    hDownSound=Sound'XIIIsound.Items__BriqueFire.BriqueFire__hBriqueFire'


defaultproperties
{
     SFXWhenBroken=Class'XIII.DecoBrikImpactEmitter'
     SFXWhenBrokenNotPawn=Class'XIII.DecoBrikDamaged'
     SFXWhenBrokenNoTgt=Class'XIII.DecoBrikNoImpactEmitter'
     hDownUnusedSound=Sound'XIIIsound.Items__BrickFire.BrickFire__hBrickExplo'
     bHaveAltFire=True
     AltAmmoName=Class'XIII.DecoBrikAmmo'
     AltPickupAmmoCount=1
     MeshName="XIIIArmes.FpsBrikM"
     FireOffset=(X=5.000000,Y=22.000000,Z=-5.000000)
     AltFireOffset=(X=5.000000,Y=22.000000,Z=-5.000000)
     LoadedAltFiringAnim="FireLanc"
     EmptyAltFiringAnim="FireLanc"
     hFireSound=Sound'XIIIsound.Items__BrickFire.BrickFire__hBrickFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__BrickPick.BrickPick__hBrickPick'
     hAltFireSound=Sound'XIIIsound.Items__BrickFire.BrickFire__hBrickAltFire'
     PickupClassName="XIII.BrikDecoPick"
     PlayerViewOffset=(X=8.000000,Y=6.000000,Z=-7.000000)
     AttachmentClass=Class'XIII.BrikAttach'
     ItemName="Brik"
}
