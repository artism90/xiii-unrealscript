//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Kalash extends XIIIWeapon;

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
    return 'Kalach'; // Graphists have strange habits for naming bones :)
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
    return AIRating;
}

//    Icon=texture'XIIIMenu.KalashIcon'


defaultproperties
{
     bSpecialAltFire=True
     WeaponOnoClass=Class'XIDSpec.M16WeaponOno'
     bRapidFire=True
     bHaveAltFire=True
     bHaveBoredSfx=True
     bDrawMuzzleFlash=True
     WHand=WHA_2HShot
     AmmoName=Class'XIII.KalashAmmo'
     PickupAmmoCount=30
     ReloadCount=30
     MeshName="XIIIArmes.FpsKalashM"
     FireOffset=(X=12.000000,Y=5.000000,Z=-4.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireKalash'
     TraceAccuracy=9.000000
     FiringMode="FM_M16"
     ViewFeedBack=(X=3.200000,Y=3.200000)
     RumbleFXNum=8
     FirstPersonMFClass=Class'XIII.KalachFPMF'
     FPMFRelativeLoc=(Y=39.000000,Z=4.000000)
     ShakeMag=200.000000
     ShakeVert=(Y=5.000000,Z=10.000000)
     ShakeSpeed=(Y=500.000000,Z=-500.000000)
     ShakeCycles=2.000000
     AIRating=0.650000
     TraceDist=240.000000
     hFireSound=Sound'XIIIsound.Guns__KalFire.KalFire__hKalFire'
     hReloadSound=Sound'XIIIsound.Guns__KalRel.KalRel__hKalRel'
     hNoAmmoSound=Sound'XIIIsound.Guns__KalDryFire.KalDryFire__hKalDry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__KalSelWp.KalSelWp__hKalSelWp'
     hAltFireSound=Sound'XIIIsound.Interface.SwitchFireType1'
     hActWaitSound=Sound'XIIIsound.Guns__KalashWait.KalashWait__hKalWait'
     MuzzleScale=2.250000
     FlashOffsetY=0.175000
     FlashOffsetX=0.190000
     InventoryGroup=12
     PickupClassName="XIII.kalashpick"
     PlayerViewOffset=(X=5.000000,Y=8.000000,Z=-6.500000)
     ThirdPersonRelativeLocation=(X=18.000000,Y=-3.500000,Z=9.000000)
     ThirdPersonRelativeRotation=(Pitch=7000)
     AttachmentClass=Class'XIII.KalashAttach'
     ItemName="KALASH"
     DrawScale=0.300000
}
