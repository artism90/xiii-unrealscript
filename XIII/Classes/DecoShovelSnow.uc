//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoShovelSnow extends DecoWeapon;

//    hFireSound=Sound'XIIIsound.Items__ChaiseFire.ChaiseFire__hChaiseFire'
//    hSelectWeaponSound=Sound'XIIIsound.Items__ChaisePick.ChaisePick__hChaisePick'
//    Mesh=SkeletalMesh'XIIIArmes.FpsPelleSnowM'
//    PickupClass=Class'XIII.ShovelSnowDeco'


defaultproperties
{
     SFXWhenBroken=Class'XIII.DecoShovelSnowImpactEmitter'
     SFXWhenBrokenNotPawn=Class'XIII.DecoShovelSnowNoImpactEmitter'
     SFXWhenBrokenNoTgt=Class'XIII.DecoShovelSnowNoImpactEmitter'
     fDelaySFXBroken=0.500000
     hDownSound=Sound'XIIIsound.Items__ShovelSnowFire.ShovelSnowFire__hShovelSnowDown'
     hDownUnusedSound=Sound'XIIIsound.Items__ShovelSnowFire.ShovelSnowFire__hShovelSnowExplo'
     MeshName="XIIIArmes.FpsPelleSnowM"
     hFireSound=Sound'XIIIsound.Items__ShovelSnowFire.ShovelSnowFire__hShovelSnowFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__ShovelSnowPick.ShovelSnowPick__hShovelSnowPick'
     PickupClassName="XIII.ShovelSnowDeco"
     ThirdPersonRelativeLocation=(X=8.000000,Y=-2.000000)
     ThirdPersonRelativeRotation=(Pitch=32768)
     AttachmentClass=Class'XIII.ShovelSnowAttach'
     ItemName="Shovel"
}
