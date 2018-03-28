//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FusilSnipe extends XIIIWeapon;

//_____________________________________________________________________________
simulated function Name GetBaseWeaponBone()
{
    return 'Sniper';
}

//_____________________________________________________________________________
// FRD
function float RateSelf()
{
    local float distance;

    if ( !HasAmmo() )
      return -2;
    if (instigator.controller.enemy!=none)
    {
      distance=Vsize(instigator.controller.enemy.location-instigator.location);
      if (distance<820)
        return 0.2;
    }
    return AIRating;
}

//_____________________________________________________________________________
simulated function bool ShouldDrawCrosshair(Canvas C)
{
/*    if ( bZoomed )
      DrawZoomedCrosshair(C);
*/
    return false;
}

/*    CrossHair=Texture'XIIIMenu.MireSniper'
    LCrossHair=Texture'XIIIMenu.LMireSniper'
*/
//    ZCrosshairReflet=texture'XIIIMenu.ZMireSniperRefletA'
//    Mesh=SkeletalMesh'XIIIArmes.FpsSniperM'
//    PickupClass=Class'XIII.FusilSnipePick'
//    Icon=texture'XIIIMenu.SniperIcon'


defaultproperties
{
     WeaponOnoClass=Class'XIDSpec.RifleWeaponOno'
     bHaveScope=True
     bShouldGoThroughTraversable=True
     bHaveBoredSfx=True
     bDrawMuzzleFlash=True
     WHand=WHA_2HShot
     WeaponMode=WM_SemiAuto
     AmmoName=Class'XIII.bmg50Ammo'
     PickupAmmoCount=10
     ReloadCount=10
     MeshName="XIIIArmes.FpsSniperM"
     FireOffset=(Y=1.600000,Z=-2.000000)
     ScopeFOV=7.000000
     ShotTime=1.200000
     FiringMode="FM_Snipe"
     AltFireNoise=0.000000
     ZCrosshair=Texture'XIIIMenu.HUD.ZMireSniperA'
     ZCrosshairDot=Texture'XIIIMenu.HUD.miresnipeM'
     ViewFeedBack=(X=3.000000,Y=6.000000)
     fAltZoomValue(1)=0.942300
     RumbleFXNum=12
     FPMFRelativeLoc=(Y=60.000000,Z=0.200000)
     ShakeVert=(X=5.000000,Z=-15.000000)
     ShakeSpeed=(Z=-500.000000)
     ShakeCycles=1.500000
     AIRating=0.750000
     TraceDist=1500.000000
     hFireSound=Sound'XIIIsound.Guns__SnipFire.SnipFire__hSnipFire'
     hReloadSound=Sound'XIIIsound.Guns__SnipRel.SnipRel__hSnipRel'
     hNoAmmoSound=Sound'XIIIsound.Guns__SnipDryFire.SnipDryFire__hSnipDry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__SnipSelWp.SnipSelWp__hSnipSelWp'
     hZoomSound=Sound'XIIIsound.Guns__Zoom.Zoom__hZoom'
     MuzzleScale=0.500000
     FlashOffsetY=0.100000
     FlashOffsetX=0.110000
     InventoryGroup=14
     PickupClassName="XIII.FusilSnipePick"
     PlayerViewOffset=(X=5.000000,Y=10.000000)
     ThirdPersonRelativeLocation=(X=35.000000,Y=-4.000000,Z=6.000000)
     AttachmentClass=Class'XIII.FusilSnipeAttach'
     ItemName="SNIPER RIFLE"
     DrawScale=0.300000
}
