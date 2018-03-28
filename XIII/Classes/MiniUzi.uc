//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MiniUzi extends XIIIWeapon;

//_____________________________________________________________________________
simulated function Name GetBaseWeaponBone()
{
    return 'Uzi';
}

//_____________________________________________________________________________
simulated function RumbleFX()
{
    if( XIIIPlayerController(Instigator.Controller) == none )
        return;

    if ( (Instigator != none) && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled() )
    {
      if ( ReloadCount%1 == 0 )
        XIIIPlayerController(Instigator.Controller).RumbleFX(RumbleFXNum);
      else
        XIIIPlayerController(Instigator.Controller).RumbleFX(RumbleFXNum+1);
    }
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
      if (distance>1410)
        return 0.295;
    }
    return AIRating;
}

//    Icon=texture'XIIIMenu.UziIcon'


defaultproperties
{
     WeaponOnoClass=Class'XIDSpec.M16WeaponOno'
     bRapidFire=True
     bHaveBoredSfx=True
     bCanHaveSlave=True
     bDrawMuzzleFlash=True
     WHand=WHA_1HShot
     AmmoName=Class'XIII.MiniUziAmmo'
     PickupAmmoCount=32
     ReloadCount=32
     MeshName="XIIIArmes.FpsUziM"
     FireOffset=(X=20.000000,Y=8.000000,Z=-2.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireUzi'
     TraceAccuracy=12.000000
     ShotTime=0.084400
     FiringMode="FM_1H"
     AltFireNoise=0.000000
     ViewFeedBack=(X=2.500000,Y=2.500000)
     RumbleFXNum=10
     FirstPersonMFClass=Class'XIII.StarFPMF'
     FPMFRelativeLoc=(X=0.500000,Y=15.000000,Z=3.500000)
     AIRating=0.610000
     TraceDist=200.000000
     hFireSound=Sound'XIIIsound.Guns__UziFire.UziFire__hUziFire'
     hReloadSound=Sound'XIIIsound.Guns__UziRel.UziRel__hUziRel'
     hNoAmmoSound=Sound'XIIIsound.Guns__UziDryFire.UziDryFire__hUziDry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__UziSelWp.UziSelWp__hUziSelWp'
     hActWaitSound=Sound'XIIIsound.Guns__UziWait.UziWait__hUziWait'
     MuzzleScale=1.500000
     FlashOffsetY=0.180000
     FlashOffsetX=0.170000
     MFTexture=Texture'XIIIMenu.SFX.MuzzleFlash2'
     InventoryGroup=13
     PickupClassName="XIII.MiniUziPick"
     PlayerViewOffset=(X=5.000000,Y=4.000000,Z=-4.500000)
     ThirdPersonRelativeLocation=(X=11.000000,Y=-3.000000,Z=2.000000)
     AttachmentClass=Class'XIII.MiniUziAttach'
     ItemName="MINIGUN"
     DrawScale=0.300000
}
