//-----------------------------------------------------------
//
//-----------------------------------------------------------
class M16 extends XIIIWeapon;

//_____________________________________________________________________________
simulated function Name GetBaseWeaponBone()
{
    return 'M16';
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
    if ( !HasAmmo() )
      return -2;
    return AIRating;
}

//    Icon=texture'XIIIMenu.M16Icon'


defaultproperties
{
     WeaponOnoClass=Class'XIDSpec.M16WeaponOno'
     bRapidFire=True
     bHaveAltFire=True
     bHaveBoredSfx=True
     bDrawMuzzleFlash=True
     WHand=WHA_2HShot
     AmmoName=Class'XIII.M16Ammo'
     AltAmmoName=Class'XIII.M16GrenadAmmo'
     PickupAmmoCount=30
     ReloadCount=30
     MeshName="XIIIArmes.FpsM16M"
     FireOffset=(X=7.000000,Y=5.000000,Z=-2.000000)
     AltFireOffset=(X=7.000000,Y=6.000000,Z=-6.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireKalash'
     TraceAccuracy=6.000000
     ShotTime=0.084400
     FiringMode="FM_M16"
     LoadedAltFiringAnim="FireGrenad"
     ViewFeedBack=(X=2.500000,Y=2.500000)
     RumbleFXNum=6
     FirstPersonMFClass=Class'XIII.M16FPMF'
     FPMFRelativeLoc=(X=-1.000000,Y=51.000000,Z=3.000000)
     shaketime=3.000000
     ShakeSpeed=(Z=-300.000000)
     AIRating=0.700000
     TraceDist=240.000000
     hFireSound=Sound'XIIIsound.Guns__M16Fire.M16Fire__hM16Fire'
     hReloadSound=Sound'XIIIsound.Guns__M16Rel.M16Rel__hM16Rel'
     hNoAmmoSound=Sound'XIIIsound.Guns__M16DryFire.M16DryFire__hM16Dry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__M16SelWp.M16SelWp__hM16SelWp'
     hAltFireSound=Sound'XIIIsound.Guns__M16Fire.M16Fire__hM16GrenadeFire'
     hActWaitSound=Sound'XIIIsound.Guns__M16Wait.M16Wait__hM16Wait'
     MuzzleScale=2.250000
     FlashOffsetY=0.125000
     FlashOffsetX=0.155000
     InventoryGroup=11
     PickupClassName="XIII.m16pick"
     PlayerViewOffset=(X=6.000000,Y=10.000000,Z=-6.000000)
     ThirdPersonRelativeLocation=(X=20.000000,Y=-4.000000,Z=16.000000)
     ThirdPersonRelativeRotation=(Pitch=7000)
     AttachmentClass=Class'XIII.M16Attach'
     ItemName="ASSAULT RIFLE"
     DrawScale=0.300000
}
