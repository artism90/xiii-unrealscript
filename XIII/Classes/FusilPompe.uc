//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FusilPompe extends XIIIWeapon;

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
    return 'Pompe';
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
      if (distance>811)
        return 0.294;
    }
    return AIRating;
}

//_____________________________________________________________________________
simulated function PlayFiring()
{
    if ( HasAmmo() )
    {
      if ( ReloadCount >= 1 )
        PlayAnim('Fire', 1.0);
      else
        PlayAnim('FireLast', 1.0);
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
    // 4 shots w/out ammo
    AmmoType.Ammoamount ++;
    for (i=0;i<4;i++)
    { // to make multiple shots without using ammo, must be played after to use the right HitMat
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

//    Icon=texture'XIIIMenu.FPompeIcon'


defaultproperties
{
     WeaponOnoClass=Class'XIDSpec.RifleWeaponOno'
     bHaveAltFire=True
     bHaveBoredSfx=True
     bDrawMuzzleFlash=True
     WHand=WHA_2HShot
     AmmoName=Class'XIII.PompeAmmo'
     AltAmmoName=Class'XIII.ShotGunAltAmmo'
     PickupAmmoCount=5
     ReloadCount=5
     MeshName="XIIIArmes.FpsPompeM"
     FireOffset=(Y=5.000000,Z=-2.000000)
     AltFireOffset=(X=7.000000,Y=6.000000,Z=-6.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireShotgun'
     TraceAccuracy=10.000000
     ShotTime=1.000000
     FiringMode="FM_2H"
     AltFireNoise=0.000000
     LoadedAltFiringAnim="FireAlt"
     ViewFeedBack=(X=3.000000,Y=15.000000)
     RumbleFXNum=4
     FirstPersonMFClass=Class'XIII.ShotgunFPMF'
     FPMFRelativeLoc=(Y=52.000000,Z=8.500000)
     ShakeVert=(X=5.000000,Z=-15.000000)
     ShakeSpeed=(Z=-300.000000)
     ShakeCycles=2.000000
     AIRating=0.600000
     TraceDist=180.000000
     hFireSound=Sound'XIIIsound.Guns__ShotFire.ShotFire__hShotFire'
     hReloadSound=Sound'XIIIsound.Guns__ShotRel.ShotRel__hShotRel'
     hNoAmmoSound=Sound'XIIIsound.Guns__ShotDryFire.ShotDryFire__hShotDry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__ShotSelWp.ShotSelWp__hShotSelWp'
     hAltFireSound=Sound'XIIIsound.Guns__ShotFireAlt.ShotFireAlt__hShotFireAlt'
     hActWaitSound=Sound'XIIIsound.Guns__ShotWait.ShotWait__hShotWait'
     MuzzleScale=2.250000
     FlashOffsetY=0.170000
     FlashOffsetX=0.125000
     InventoryGroup=9
     PickupClassName="XIII.FusilPompePick"
     PlayerViewOffset=(X=4.000000,Y=7.000000,Z=-7.000000)
     ThirdPersonRelativeLocation=(X=25.000000,Y=-4.000000,Z=13.000000)
     ThirdPersonRelativeRotation=(Pitch=7000)
     AttachmentClass=Class'XIII.FusilPompeAttach'
     ItemName="SHOTGUN"
     DrawScale=0.300000
}
