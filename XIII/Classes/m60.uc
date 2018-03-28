//-----------------------------------------------------------
//
//-----------------------------------------------------------
class M60 extends XIIIWeapon;

//var M60AmmoAttachment AmmoRibbon;   // ribbon of ammo.

//_____________________________________________________________________________
simulated function bool HasAltAmmo()
{
    return false;
}

//_____________________________________________________________________________
function CauseAltFire()
{
    Global.AltFire(0);
}

//_____________________________________________________________________________
simulated function AltFire( float Value )
{
    if ( Level.NetMode == NM_Client )
    {
      if ( WeaponMode == WM_Auto )
      {
        TraceAccuracy = default.TraceAccuracy / 2.0;
        WeaponMode = WM_Burst;
      }
      else if ( WeaponMode == WM_Burst )
      {
        TraceAccuracy = default.TraceAccuracy;
        WeaponMode = WM_Auto;
      }
    }
    if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
      Instigator.PlayRolloffSound(hAltFireSound, self);
    ServerAltFire();
}

//_____________________________________________________________________________
function ServerAltFire()
{
    if ( WeaponMode == WM_Auto )
    {
      TraceAccuracy = default.TraceAccuracy / 2.0;
      WeaponMode = WM_Burst;
    }
    else if ( WeaponMode == WM_Burst )
    {
      TraceAccuracy = default.TraceAccuracy;
      WeaponMode = WM_Auto;
    }
}


//_____________________________________________________________________________
simulated function UnFire( float Value )
{
    iBurstCount = 0;
}

//_____________________________________________________________________________
// ELR Text to be displayed in HUD
simulated function string GetAmmoText(out int bDrawbulletIcon)
{
    local string AmmoText,AltAmmoText;

    bDrawbulletIcon = 1;

    // Setup ammotext
    AmmoText = ReLoadCount@"|"@(Ammotype.AmmoAmount-ReLoadCount);
    Switch(WeaponMode)
    {
      Case WM_Auto:
        AmmoText = Ammotext@"("$sWeaponModeAuto$")";
        break;
      Case WM_Burst:
        AmmoText = Ammotext@"("$sWeaponModeBurst$")";
        break;
      Case WM_SemiAuto:
        AmmoText = Ammotext@"("$sWeaponModeSemiAuto$")";
        break;
    }
    return AmmoText;
}

//_____________________________________________________________________________
simulated function Name GetBaseWeaponBone()
{
    return 'M60';
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
      if (distance>2300)
        return 0.7;
    }
    return AIRating;
}



defaultproperties
{
     bSpecialAltFire=True
     WeaponOnoClass=Class'XIDSpec.M60WeaponOno'
     bRapidFire=True
     bHaveAltFire=True
     bShouldGoThroughTraversable=True
     bHeavyWeapon=True
     bDrawMuzzleFlash=True
     WHand=WHA_2HShot
     AmmoName=Class'XIII.M60Ammo'
     PickupAmmoCount=50
     ReloadCount=200
     MeshName="XIIIArmes.FpsM60M"
     FireOffset=(Y=5.000000,Z=-2.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireM60'
     TraceAccuracy=7.000000
     ShotTime=0.166000
     FiringMode="FM_2HHeavy"
     ViewFeedBack=(X=4.000000,Y=4.000000)
     RumbleFXNum=15
     FirstPersonMFClass=Class'XIII.StarFPMF'
     FPMFRelativeLoc=(Y=54.000000,Z=5.000000)
     ShakeMag=700.000000
     shaketime=2.000000
     ShakeVert=(Y=7.000000,Z=7.000000)
     ShakeSpeed=(Y=500.000000,Z=-500.000000)
     ShakeCycles=2.000000
     AIRating=0.850000
     TraceDist=300.000000
     hFireSound=Sound'XIIIsound.Guns__M60Fire.M60Fire__hM60Fire'
     hReloadSound=Sound'XIIIsound.Guns__M60Rel.M60Rel__hM60Rel'
     hNoAmmoSound=Sound'XIIIsound.Guns__M60DryFire.M60DryFire__hM60Dry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__M60SelWp.M60SelWp__hM60SelWp'
     hAltFireSound=Sound'XIIIsound.Interface.SwitchFireType1'
     hActWaitSound=Sound'XIIIsound.Guns__M60Wait.M60Wait__hM60Wait'
     MuzzleScale=3.500000
     FlashOffsetY=0.185000
     FlashOffsetX=0.130000
     InventoryGroup=16
     PickupClassName="XIII.m60pick"
     PlayerViewOffset=(X=9.000000,Y=9.000000,Z=-8.000000)
     ThirdPersonRelativeLocation=(X=29.000000,Y=-5.000000,Z=6.000000)
     AttachmentClass=Class'XIII.M60Attach'
     ItemName="SMG"
     DrawScale=0.300000
}
