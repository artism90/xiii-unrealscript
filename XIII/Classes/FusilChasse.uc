//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FusilChasse extends XIIIWeapon;

//_____________________________________________________________________________
simulated function bool HasAltAmmo()
{ // because we can stun only if we have ammo (bAllowEmptyShot=false, must down weapon after last fire)
    return true;
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
    return 'FChasse';
}

//_____________________________________________________________________________
simulated function RumbleFX()
{
    if( XIIIPlayerController(Instigator.Controller) == none )
        return;

    if ( (Instigator != none) && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled() )
    {
      if ( ReloadCount == 1 )
        XIIIPlayerController(Instigator.Controller).RumbleFX(RumbleFXNum);
      else
        XIIIPlayerController(Instigator.Controller).RumbleFX(RumbleFXNum+1);
    }
}

//_____________________________________________________________________________
function TraceFire( float Accuracy, float YOffset, float ZOffset )
{
    local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
    local actor Other;
    local int I;
    local Material HitMat;
    local Vector vWaterDir;

    MakeNoise(FireNoise);
    GetAxes(Instigator.GetViewRotation(),X,Y,Z);
    StartTrace = GetFireStart(X,Y,Z);
    AdjustedAim = Instigator.AdjustAim(AmmoType, StartTrace, 0);

    // the one that uses ammo.
    EndTrace = StartTrace + (TraceDist * vector(AdjustedAim));
    EndTrace += vRand() * fRand() * (TraceAccuracy/100.0) * TraceDist;
    Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon|TRACETYPE_RequestBones);
    if ( XIIIPawn(Other) != none )
      XIIIPawn(Other).LastBoneHit = GetLastTraceBone();
    if ( HitMat != none )
      AmmoType.PlayImpactSound(HitMat.HitSound);
    AmmoType.ProcessTraceHit(self, Other, HitLocation, HitNormal, X,Y,Z);

    // 4 shots AFTER because ony the 1rst one update the impact visual type
    // then 4 shots w/out ammo
    AmmoType.Ammoamount ++;
    for (i=0;i<4;i++)
    { // to make multiple shots without using ammo
      EndTrace = StartTrace + (TraceDist * vector(AdjustedAim));
      EndTrace += vRand() * fRand() * (TraceAccuracy/100.0) * TraceDist;
      Other = IntersectWaterPlane(StartTrace, EndTrace, HitLocation);
      if ( Other != none )
      {
        vWaterDir = HitLocation - StartTrace;
        vWaterDir.Z = abs(vWaterDir.z) * 8.0;
        WRE = PhysicsVolume(Other).BeingHitByBullets(HitLocation+vect(0,0,1), rotator(vWaterDir cross Y), AmmoType.HitSoundType);
      }
      Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon|TRACETYPE_RequestBones);
      if ( XIIIPawn(Other) != none )
        XIIIPawn(Other).LastBoneHit = GetLastTraceBone();
      if ( HitMat != none )
        AmmoType.PlayImpactSound(HitMat.HitSound);
      if ( i>0 )
        AmmoType.bPlayHitSound = false;
      AmmoType.ProcessTraceHitNoAmmo(self, Other, HitLocation, HitNormal, X,Y,Z);
    }
    AmmoType.Ammoamount --;

    FeedBack();
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
      if (distance>1110)
        return 0.4;
    }
    return AIRating;
}

//_____________________________________________________________________________
simulated function PlayIdleAnim()
{
    if ( bHaveBoredSfx && Pawn(Owner).IsPlayerPawn() && (iBoredCount > BOREDSFXTHRESHOLD) )
    {
      iBoredCount = 0;
      if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
        Instigator.PlayRolloffSound(hActWaitSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
      if ( ReloadCount == 2 )
        PlayAnim('WaitAct1', 1.0, 0.3);
      else if ( ReloadCount == 1 )
        PlayAnim('WaitAct2', 1.0, 0.3);
      else
        PlayAnim('WaitAct3', 1.0, 0.3);
    }
    else
    {
      if ( ReloadCount == 2 )
        PlayAnim('Wait1', 1.0, 0.3);
      else if ( ReloadCount == 1 )
        PlayAnim('Wait2', 1.0, 0.3);
      else
        PlayAnim('Wait3', 1.0, 0.3);
    }
}

//_____________________________________________________________________________
simulated function PlayFiring()
{
    if ( HasAmmo() )
    {
      if ( ReloadCount == 1 )
        PlayAnim('Fire1', 1.0);
      else
        PlayAnim('Fire2', 1.0);
    }
    else
      PlayAnim('FireVide', 1.0);
    if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
      PlayFiringSound();

    if ( !HasAmmo() )
      return;

    IncrementFlashCount();
    if ( bDrawMuzzleflash )
      SetUpMuzzleFlash();
}

//_____________________________________________________________________________
simulated function PlayAltFiring()
{
//    Log("PlayFiring call for"@self@"w/FiringMode="$FiringMode);
    if ( ReloadCount == 2 )
      PlayAnim('FireAlt1', 1.0);
    else if ( ReloadCount == 1 )
      PlayAnim('FireAlt2', 1.0);
    else
      PlayAnim('FireAlt3', 1.0);

    IncrementAltFlashCount();
    if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
      PlayAltFiringSound();
}

//_____________________________________________________________________________
simulated function PlaySelect()
{
//    log("#"@DBUGFrameCount@" PlaySelect call for"@self@"w/ mesh="$Mesh);
    bForceFire = false;
    bForceAltFire = false;
    if ( !IsAnimating() || !AnimIsInGroup(0,'Select') )
    {
      if ( ReloadCount == 2)
        PlayAnim('Select1',1.0);
      else if ( ReloadCount == 1)
        PlayAnim('Select2',1.0);
      else
        PlayAnim('Select3',1.0);
    }
    if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
      Instigator.PlayRolloffSound(hSelectWeaponSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
}

//_____________________________________________________________________________
simulated function TweenDown()
{
//    log("#"@DBUGFrameCount@" TweenDown call for"@self);
    if ( ReloadCount == 2)
      PlayAnim('Down1',1.0);
    else if ( ReloadCount == 1)
      PlayAnim('Down2',1.0);
    else
      PlayAnim('Down3',1.0);
}

//    Icon=texture'XIIIMenu.FChasseIcon'


defaultproperties
{
     WeaponOnoClass=Class'XIDSpec.RifleWeaponOno'
     bHaveAltFire=True
     bHaveBoredSfx=True
     bDrawMuzzleFlash=True
     WHand=WHA_2HShot
     AmmoName=Class'XIII.PompeAmmo'
     AltAmmoName=Class'XIII.HuntGunAltAmmo'
     PickupAmmoCount=2
     ReloadCount=2
     MeshName="XIIIArmes.FpsFChasseM"
     FireOffset=(Y=5.000000,Z=-2.000000)
     AltFireOffset=(X=7.000000,Y=4.000000,Z=-6.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireFusil'
     TraceAccuracy=8.000000
     ShotTime=0.200000
     FiringMode="FM_2H"
     AltFireNoise=0.000000
     LoadedAltFiringAnim="FireAlt"
     ViewFeedBack=(X=3.000000,Y=15.000000)
     RumbleFXNum=2
     FPMFRelativeLoc=(X=0.500000,Y=85.000000,Z=7.500000)
     ShakeMag=900.000000
     shaketime=7.000000
     ShakeVert=(X=5.000000,Y=10.000000,Z=-25.000000)
     ShakeCycles=2.000000
     AIRating=0.560000
     TraceDist=180.000000
     hFireSound=Sound'XIIIsound.Guns__GunFire.GunFire__hGunFire'
     hReloadSound=Sound'XIIIsound.Guns__GunRel.GunRel__hGunRel'
     hNoAmmoSound=Sound'XIIIsound.Guns__GunDryFire.GunDryFire__hGunDry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__GunSelWp.GunSelWp__hGunSelWp'
     hAltFireSound=Sound'XIIIsound.Guns__ShotFireAlt.ShotFireAlt__hShotFireAlt'
     hActWaitSound=Sound'XIIIsound.Guns__ShotWait.ShotWait__hShotWait'
     MuzzleScale=0.800000
     FlashOffsetY=0.070000
     FlashOffsetX=0.090000
     InventoryGroup=10
     PickupClassName="XIII.FusilChassePick"
     PlayerViewOffset=(X=4.000000,Y=6.500000)
     ThirdPersonRelativeLocation=(X=29.000000,Y=-4.500000,Z=14.500000)
     ThirdPersonRelativeRotation=(Pitch=7000)
     AttachmentClass=Class'XIII.FusilChasseAttach'
     ItemName="HUNTING GUN"
     DrawScale=0.300000
}
