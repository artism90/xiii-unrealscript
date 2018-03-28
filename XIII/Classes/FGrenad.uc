//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FGrenad extends Grenad;

//    Icon=texture'XIIIMenu.FGrenadIcon'


defaultproperties
{
     AmmoName=Class'XIII.FGrenadAmmo'
     MeshName="XIIIArmes.FpsGrenade_FragM"
     hFireSound=Sound'XIIIsound.Guns__PGrenFire.PGrenFire__hPGrenFire'
     InventoryGroup=5
     PickupClassName="XIII.FGrenadPick"
     PlayerTransferClassName="XIII.FGrenadB"
     AttachmentClass=Class'XIII.FGrenadAttach'
     ItemName="FRAG. GRENADE"
}
