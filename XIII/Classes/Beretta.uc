//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Beretta extends XIIIWeapon;

var class<DamageType> DTSilencer;

//_____________________________________________________________________________
simulated function Name GetBaseWeaponBone()
{
    return 'Berretta';
}

//_____________________________________________________________________________
function TraceFire( float Accuracy, float YOffset, float ZOffset )
{
    if ( HasSilencer() )
      AmmoType.MyDamageType = DTSilencer;
    else
      AmmoType.MyDamageType = AmmoType.Default.MyDamageType;

    Super.TraceFire(Accuracy, YOffset, ZOffset);
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
        return 0.291;
     }
    return AIRating;
}

//_____________________________________________________________________________
simulated function PlayIdleAnim()
{
    if ( !bIsSlave && !bHaveSlave )
    {
      if ( ReloadCount == 0 )
      {
        if ( bHaveBoredSfx && Pawn(Owner).IsPlayerPawn() && (iBoredCount > BOREDSFXTHRESHOLD) )
        {
          iBoredCount = 0;
          if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
            Instigator.PlayRolloffSound(hActWaitSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
          PlayAnim('WaitActVide', 1.0, 0.3);
        }
        else
          PlayAnim('WaitVide', 1.0, 0.3);
      }
      else
      {
        if ( bHaveBoredSfx && Pawn(Owner).IsPlayerPawn() && (iBoredCount > BOREDSFXTHRESHOLD) )
        {
          iBoredCount = 0;
          if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
            Instigator.PlayRolloffSound(hActWaitSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
          PlayAnim('WaitAct', 1.0, 0.3);
        }
        else
          PlayAnim('Wait', 1.0, 0.3);
      }
    }
    else
    {
      if ( ReloadCount == 0 )
      {
        if ( bHaveBoredSfx && Pawn(Owner).IsPlayerPawn() && (iBoredCount > BOREDSFXTHRESHOLD) )
        {
          iBoredCount = 0;
          if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
            Instigator.PlayRolloffSound(hActWaitSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
          PlayAnim('WaitActVide', 0.80+fRand()*0.40, 0.3);
        }
        else
          PlayAnim('WaitVide', 0.80+fRand()*0.40, 0.3);
      }
      else
      {
        if ( bHaveBoredSfx && Pawn(Owner).IsPlayerPawn() && (iBoredCount > BOREDSFXTHRESHOLD) )
        {
          iBoredCount = 0;
          if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
            Instigator.PlayRolloffSound(hActWaitSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
          PlayAnim('WaitAct', 1.0, 0.3);
        }
        else
          PlayAnim('Wait', 1.0, 0.3);
      }
    }
}

//_____________________________________________________________________________
simulated function TweenDown()
{
//    log("#"@DBUGFrameCount@" TweenDown call for"@self);
    if ( ReloadCount == 0 )
      PlayAnim('DownVide', 1.0);
    else
      PlayAnim('Down', 1.0);
}

//_____________________________________________________________________________
simulated function PlayFiring()
{
//    Log("#"$DBUGFrameCount@" PlayFiring call for"@self@"w/FiringMode="$FiringMode);
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
      PlayFiringSound(HasSilencer());

    if ( !HasAmmo() )
      return;

    IncrementFlashCount();
    if ( bDrawMuzzleflash )
      SetUpMuzzleFlash();
}

//_____________________________________________________________________________
simulated function PlaySelect()
{
//    log("#"@DBUGFrameCount@" PlaySelect call for"@self@"w/ mesh="$Mesh);
    bForceFire = false;
    bForceAltFire = false;
    if ( !IsAnimating() || !AnimIsInGroup(0,'Select') )
    {
      if ( ReloadCount == 0 )
        PlayAnim('SelectVide',1.0);
      else
        PlayAnim('Select',1.0);
    }
    if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
      Instigator.PlayRolloffSound(hSelectWeaponSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
}

//    Mesh=SkeletalMesh'XIIIArmes.FpsBerrettaM'
//    PickupClass=Class'XIII.BerettaPick'
//    Icon=texture'XIIIMenu.BerettaIcon'

defaultproperties
{
     DTSilencer=Class'XIII.DTGunnedSilenced'
     WeaponOnoClass=Class'XIDSpec.GunWeaponOno'
     bUseSilencer=True
     bShouldGoThroughTraversable=True
     bHaveBoredSfx=True
     bCanHaveSlave=True
     bDrawMuzzleFlash=True
     WHand=WHA_1HShot
     WeaponMode=WM_SemiAuto
     AmmoName=Class'XIII.c9mmAmmo'
     PickupAmmoCount=13
     ReloadCount=13
     MeshName="XIIIArmes.FpsBerrettaM"
     FireOffset=(X=9.000000,Y=5.000000,Z=-4.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireBeretta'
     TraceAccuracy=1.500000
     ShotTime=0.500000
     FiringMode="FM_1H"
     FireNoise=1.312000
     ReLoadNoise=0.000000
     AltFireNoise=0.000000
     ViewFeedBack=(X=1.500000,Y=3.000000)
     RumbleFXNum=1
     FPMFRelativeLoc=(Y=13.000000,Z=6.000000)
     ShakeMag=200.000000
     ShakeVert=(Z=8.000000)
     ShakeCycles=3.000000
     TraceDist=100.000000
     hFireSound=Sound'XIIIsound.Guns__9mmFire.9mmFire__h9mmFire'
     hReloadSound=Sound'XIIIsound.Guns__9mmRel.9mmRel__h9mmRel'
     hNoAmmoSound=Sound'XIIIsound.Guns__9mmDryFire.9mmDryFire__h9mmDry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__9mmSelWp.9mmSelWp__h9mmSelWp'
     hActWaitSound=Sound'XIIIsound.Guns__9mmWait.9mmWait__h9mmWait'
     MuzzleScale=0.600000
     FlashOffsetY=0.160000
     FlashOffsetX=0.185000
     InventoryGroup=2
     PickupClassName="XIII.BerettaPick"
     PlayerViewOffset=(X=5.000000,Y=3.500000,Z=-4.000000)
     ThirdPersonRelativeLocation=(X=13.000000,Y=-2.500000,Z=4.500000)
     AttachmentClass=Class'XIII.BerettaAttach'
     ItemName="9 MM"
     DrawScale=0.300000
}
