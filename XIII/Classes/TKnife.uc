//-----------------------------------------------------------
//
//-----------------------------------------------------------
class TKnife extends XIIIWeapon;

//_____________________________________________________________________________
simulated function bool HasAltAmmo()
{ // because we can stun only if we have ammo (bAllowEmptyShot=false, must down weapon after last fire)
    return HasAmmo();
}

//_____________________________________________________________________________
// ELR Text to be displayed in HUD
simulated function string GetAmmoText(out int bDrawbulletIcon)
{
    local string AmmoText,AltAmmoText;

    bDrawbulletIcon = 1;

    // Setup ammotext
    AmmoText = string(Ammotype.AmmoAmount);
    return AmmoText;
}

//_____________________________________________________________________________
// FRD
function float RateSelf()
{
    local float distance;
    local vector PositionRelative;

    if ( !HasAmmo() )
      return -2;
    if (instigator.controller.enemy!=none)
    {
      PositionRelative=instigator.controller.enemy.location-instigator.location;
      distance=Vsize(PositionRelative);
      if (distance>1210 || distance<300)
        return 0.21;
      if (PositionRelative.z>400) // enemy au dessus donc pas prendre
        return (AIRating-2);
    }
    return AIRating;
}

//_____________________________________________________________________________
simulated function PlayIdleAnim()
{
    if ( HasAmmo() )
      Super.PlayIdleAnim();
    else
      PlayAnim('WaitVide', 1.0, 0.3);
}

//_____________________________________________________________________________
simulated function TweenDown()
{
    if ( HasAmmo() )
      PlayAnim('Down', 1.0);
    else
      PlayAnim('DownVide', 1.0);
}


//_____________________________________________________________________________
simulated function PlayFiring()
{
//    if ( HasAmmo() ) // ELR Can't use HasAmmo as the ammo will be used after
    if ( AmmoType.Ammoamount > 1 )
      PlayAnim(LoadedFiringAnim, 1.0);
    else
      PlayAnim(EmptyFiringAnim, 1.0);
    if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
      PlayFiringSound();

    if ( !HasAmmo() )
      return;

    IncrementFlashCount();
    if ( bDrawMuzzleflash )
      SetUpMuzzleFlash();
}

//    Icon=texture'XIIIMenu.TKnifeIcon'


defaultproperties
{
     WeaponOnoClass=Class'XIDSpec.TKnifeWeaponOno'
     bHaveAltFire=True
     bAllowEmptyShot=False
     bHaveBoredSfx=True
     WHand=WHA_Throw
     WeaponMode=WM_SemiAuto
     AmmoName=Class'XIII.TKnifeAmmo'
     AltAmmoName=Class'XIII.TKnifeAltAmmo'
     PickupAmmoCount=3
     MeshName="XIIIArmes.FpsCoutoLancM"
     FireOffset=(Y=6.000000)
     AltFireOffset=(X=5.000000,Y=-1.000000,Z=-4.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireCouteau'
     ShotTime=1.000000
     FiringMode="FM_Throw"
     FireNoise=0.000000
     AltFireNoise=0.000000
     LoadedAltFiringAnim="FireAlt"
     AIRating=0.390000
     TraceDist=15.000000
     hFireSound=Sound'XIIIsound.Guns__JetFire.JetFire__hJetFire'
     hSelectWeaponSound=Sound'XIIIsound.Guns__JetSelWp.JetSelWp__hJetSelWp'
     hAltFireSound=Sound'XIIIsound.Guns__JetFireAlt.JetFireAlt__hJetFireAlt'
     hActWaitSound=Sound'XIIIsound.Guns__JetWait.JetWait__hJetWait'
     PickupClassName="XIII.TKnifePick"
     PlayerViewOffset=(X=8.000000,Y=4.000000)
     ThirdPersonRelativeLocation=(X=8.000000,Y=-3.000000,Z=12.000000)
     ThirdPersonRelativeRotation=(Pitch=-16384,Yaw=7000)
     AttachmentClass=Class'XIII.TKnifeAttach'
     ItemName="THROW KNIFE"
     DrawScale=0.300000
}
