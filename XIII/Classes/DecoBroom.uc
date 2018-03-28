//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoBroom extends DecoWeapon;


defaultproperties
{
     SFXWhenBroken=Class'XIII.DecoBroomImpactEmitter'
     SFXWhenBrokenNotPawn=Class'XIII.DecoBroomNoImpactEmitter'
     SFXWhenBrokenNoTgt=Class'XIII.DecoBroomNoImpactEmitter'
     fDelaySFXBroken=0.500000
     hDownSound=Sound'XIIIsound.Items__BrushPalaceFire.BrushPalaceFire__hBrushPalaceDown'
     hDownUnusedSound=Sound'XIIIsound.Items__BrushPalaceFire.BrushPalaceFire__hBrushPalaceExplo'
     AmmoName=Class'XIII.DecoBroomAmmo'
     MeshName="XIIIArmes.FpsBalaiPalaceM"
     hFireSound=Sound'XIIIsound.Items__BrushPalaceFire.BrushPalaceFire__hBrushPalaceFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__BrushPalacePick.BrushPalacePick__hBrushPalacePick'
     PickupClassName="XIII.BroomDecoPick"
     ThirdPersonRelativeLocation=(X=8.000000,Y=-2.000000)
     ThirdPersonRelativeRotation=(Pitch=32768)
     AttachmentClass=Class'XIII.BroomAttach'
     ItemName="Broom"
}
