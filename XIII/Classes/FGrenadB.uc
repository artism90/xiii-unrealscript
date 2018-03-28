//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FGrenadB extends GrenadB;

//    Icon=texture'XIIIMenu.FGrenadIcon'


defaultproperties
{
     hStopFireSound=Sound'XIIIsound.Guns__PGrenFire.PGrenFire__hGrenStop'
     AmmoName=Class'XIII.FGrenadAmmo'
     MeshName="XIIIArmes.FpsGrenade_FragM"
     hFireSound=Sound'XIIIsound.Guns__PGrenFire.PGrenFire__hPGrenFire'
     hAltFireSound=Sound'XIIIsound.Guns__PGrenFire.PGrenFire__hPGrenFire'
     InventoryGroup=5
     PickupClassName="XIII.FGrenadPick"
     NonPlayerTransferClassName="XIII.FGrenad"
     AttachmentClass=Class'XIII.FGrenadAttach'
     ItemName="FRAG. GRENADE"
}
