//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Magnum extends XIIIWeapon;

var bool bAltFiring;  // to play altfiring anim whule using fire behaviour

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
    AmmoText = ReLoadCount@"|"@(Ammotype.AmmoAmount-ReLoadCount);
    return AmmoText;
}

//_____________________________________________________________________________
simulated function Name GetBaseWeaponBone()
{
    return 'Magnum';
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
      if (distance>1766)
        return 0.31;
    }
    return AIRating;
}

//_____________________________________________________________________________
simulated function Fire( float Value )
{
    bAltFiring = false;
    Super.Fire(0.0);
}

//_____________________________________________________________________________
simulated function AltFire( float Value )
{
    if ( (XIIIPawn(Owner).LHand != none) && XIIIPawn(Owner).LHand.bActive )
      return;
    bAltFiring = true;
    Super.Fire(4.0);
}

//_____________________________________________________________________________
function ServerFire()
{
    bAltFiring = false;
    Super.ServerFire();
}

//_____________________________________________________________________________
function ServerAltFire()
{
    bAltFiring = true;
    Super.ServerFire();
}

//_____________________________________________________________________________
// Finish a sequence
function Finish()
{
    local bool bForce, bForceAlt;
    if ( DBWeap ) Log("> Finish called w/ bForceFire="$bForceFire@"& bForceReLoad="$bForceReLoad@"in state"@GetStateName());

    if ( HasAmmo() && (bAutoReload || !Level.bLonePlayer) && NeedsToReload() )
    {
      GotoState('Reloading');
      return;
    }

    bForce = bForceFire;
    bForceAlt = bForceAltFire;
    bForceFire = false;
    bForceAltFire = false;

    if ( bChangeWeapon )
    {
      GotoState('DownWeapon');
      return;
    }

    if ( (Instigator == None) || (Instigator.Controller == None) )
    {
      GotoState('');
      return;
    }

    if ( !Instigator.IsHumanControlled() )
    {
      if ( !HasAmmo() )
      {
        Instigator.Controller.SwitchToBestWeapon();
        if ( bChangeWeapon )
          GotoState('DownWeapon');
        else
          GotoState('Idle');
        return;
      }
      if ( NeedsToReload() )
      {
        GotoState('Reloading');
        return;
      }
      if ( Instigator.PressingFire() && (bUnderWaterWork || !Pawn(Owner).HeadVolume.bWaterVolume) )
      {
        if ( Level.bLonePlayer )
          Global.LoneFire(0.0);
        else
          Global.ServerFire();
      }
      else if ( bAltFiring && Instigator.PressingAltFire() && (bUnderWaterWork || !Pawn(Owner).HeadVolume.bWaterVolume) )
      {
        if ( Level.bLonePlayer )
          Global.LoneAltFire();
        else
          Global.ServerAltFire();
      }
      else
      {
        Instigator.Controller.StopFiring();
        GotoState('Idle');
      }
      return;
    }

    if ( !HasAmmo() && !HasAltAmmo() )
    {
//      Log("Finish, bAllowEmptyShot="$bAllowEmptyShot@"bLonePlayer=$"$Level.bLonePlayer);
      if ( !bAllowEmptyShot || !Level.bLonePlayer )
      {
        // if local player, switch weapon
        Instigator.Controller.SwitchToBestWeapon();
        if ( bChangeWeapon )
        {
          GotoState('DownWeapon');
          return;
        }
        else
          GotoState('Idle');
          return;
      }
    }
    if ( (Instigator.Weapon != self) || (!bUnderWaterWork && Pawn(Owner).HeadVolume.bWaterVolume)  )
      GotoState('Idle');
    else if ( (((StopFiringTime > Level.TimeSeconds) || Instigator.PressingFire()) && bAllowShot) || bForce )
    {
      if ( HasAmmo() && NeedsToReLoad() && CanReLoad() )
      {
//        Log("  in Finish Should send everybody to ReLoading there");
        GotoState('Reloading');
        ClientReLoad();
        return;
      }
      else if ( !CanReLoad() )
      {
        gotoState('Idle');
        return;
      }
      Global.ServerFire();
    }
    else if ( bAltFiring && bHaveAltFire && (bForceAlt || Instigator.PressingAltFire()) && bAllowShot )
    {
      if ( HasAmmo() && NeedsToReLoad() && CanReLoad() )
      {
//        Log("  in Finish Should send everybody to ReLoading there");
        GotoState('Reloading');
        ClientReLoad();
        return;
      }
      else if ( !CanReLoad() )
      {
        gotoState('Idle');
        return;
      }
      Global.ServerAltFire();
    }
    else
      GotoState('Idle');
}

//_____________________________________________________________________________
simulated state NormalFire
{
Begin:
  bAllowShot = bAltfiring;
  if ( DBWeap ) Log("  NormalFire Setting bAllowShot to"@bAllowShot);
}

//_____________________________________________________________________________
//Fire on the client side. This state is only entered on the network client of the player that is firing this weapon.
simulated state ClientFiring
{
Begin:
  bAllowShot = bAltfiring;
  if ( DBWeap ) Log("  ClientFiring Setting bAllowShot to"@bAllowShot);
}

//_____________________________________________________________________________
simulated function PlayFiring()
{
    if ( bAltFiring )
    {
      if ( HasAmmo() )
        PlayAnim(LoadedAltFiringAnim, 1.0);
      else
        PlayAnim(EmptyAltFiringAnim, 1.0);
      if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
        PlayFiringSound();

      if ( !HasAmmo() )
        return;

      IncrementFlashCount();
      if ( bDrawMuzzleflash )
        SetUpMuzzleFlash();
      return;
    }
//    Log("PlayFiring call for"@self@"w/FiringMode="$FiringMode);
    if ( HasAmmo() )
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

//    PickupClass=Class'XIII.magnumpick'
//    Icon=texture'XIIIMenu.MagnumIcon'


defaultproperties
{
     WeaponOnoClass=Class'XIDSpec.MagnumWeaponOno'
     bHaveAltFire=True
     bShouldGoThroughTraversable=True
     bHaveBoredSfx=True
     bDrawMuzzleFlash=True
     WHand=WHA_1HShot
     WeaponMode=WM_SemiAuto
     AmmoName=Class'XIII.c44Ammo'
     AltAmmoName=Class'XIII.c44Ammo'
     PickupAmmoCount=6
     ReloadCount=6
     MeshName="XIIIArmes.FpsMagnumM"
     FireOffset=(X=10.000000,Y=5.000000,Z=-3.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireBeretta'
     TraceAccuracy=1.500000
     ShotTime=0.700000
     FiringMode="FM_1H"
     ReLoadNoise=0.000000
     LoadedAltFiringAnim="FireAlt"
     ViewFeedBack=(X=4.000000,Y=13.000000)
     RumbleFXNum=5
     FPMFRelativeLoc=(Y=18.000000,Z=6.000000)
     shaketime=4.000000
     ShakeVert=(Z=15.000000)
     ShakeSpeed=(X=500.000000,Y=500.000000,Z=500.000000)
     ShakeCycles=3.000000
     AIRating=0.550000
     TraceDist=100.000000
     hFireSound=Sound'XIIIsound.Guns__MagFire.MagFire__hMagFire'
     hReloadSound=Sound'XIIIsound.Guns__MagRel.MagRel__hMagRel'
     hNoAmmoSound=Sound'XIIIsound.Guns__MagDryFire.MagDryFire__hMagDry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__MagSelWp.MagSelWp__hMagSelWp'
     hAltFireSound=Sound'XIIIsound.Guns__MagFire.MagFire__hMagFire'
     hActWaitSound=Sound'XIIIsound.Guns__MagWait.MagWait__hMagWait'
     MuzzleScale=0.750000
     FlashOffsetY=0.150000
     FlashOffsetX=0.150000
     InventoryGroup=3
     PickupClassName="XIII.magnumpick"
     PlayerViewOffset=(X=5.000000,Y=3.500000,Z=-4.000000)
     ThirdPersonRelativeLocation=(X=17.000000,Y=-2.500000,Z=5.000000)
     AttachmentClass=Class'XIII.MagnumAttach'
     ItemName="44 SPECIAL"
     DrawScale=0.300000
}
