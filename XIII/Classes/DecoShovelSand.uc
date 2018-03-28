//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoShovelSand extends DecoWeapon;

//    hFireSound=Sound'XIIIsound.Items__ChaiseFire.ChaiseFire__hChaiseFire'
//    hSelectWeaponSound=Sound'XIIIsound.Items__ChaisePick.ChaisePick__hChaisePick'
//    Mesh=SkeletalMesh'XIIIArmes.FpsPelleSandM'
//    PickupClass=Class'XIII.ShovelSandDeco'


defaultproperties
{
     SFXWhenBroken=Class'XIII.DecoShovelSandImpactEmitter'
     SFXWhenBrokenNotPawn=Class'XIII.DecoShovelSandNoImpactEmitter'
     SFXWhenBrokenNoTgt=Class'XIII.DecoShovelSandNoImpactEmitter'
     fDelaySFXBroken=0.500000
     hDownSound=Sound'XIIIsound.Items__ShovelSandFire.ShovelSandFire__hShovelSandDown'
     hDownUnusedSound=Sound'XIIIsound.Items__ShovelSandFire.ShovelSandFire__hShovelSandExplo'
     MeshName="XIIIArmes.FpsPelleSandM"
     hFireSound=Sound'XIIIsound.Items__ShovelSandFire.ShovelSandFire__hShovelSandFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__ShovelSandPick.ShovelSandPick__hShovelSandPick'
     PickupClassName="XIII.ShovelSandDeco"
     ThirdPersonRelativeLocation=(X=8.000000,Y=-2.000000)
     ThirdPersonRelativeRotation=(Pitch=32768)
     AttachmentClass=Class'XIII.ShovelSandAttach'
     ItemName="Shovel"
}
