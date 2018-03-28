//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Bazook extends XIIIWeapon;

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
state Idle
{
    simulated function ForceReload()
    { // ELR check here that we have enough ammo to reload

      Log("  ForceReload Call in Idle");
      if ( ReLoadCount == 0 )
      {
        ServerForceReload();
        if ( HasAmmo() )
          GotoState('Reloading');
      }
    }
}

//_____________________________________________________________________________
simulated function PlayIdleAnim()
{
    if ( ReLoadCount > 0 )
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
    else
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
}

//_____________________________________________________________________________
simulated function TweenDown()
{
    if ( ReLoadCount > 0 )
      PlayAnim('Down', 1.1);
    else
      PlayAnim('DownVide', 1.0);
}

//_____________________________________________________________________________
simulated function PlaySelect()
{
    if (ReLoadCount > 0)
      PlayAnim('Select', 1.0);
    else
      PlayAnim('SelectVide', 1.0);
    if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
      Instigator.PlayRolloffSound(hSelectWeaponSound, self, 0, int(Pawn(Owner).IsPlayerPawn()) );
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
      if (distance<733)
        return 0.26;
    }
    return AIRating;
}

//    Icon=texture'XIIIMenu.BazookaIcon'

defaultproperties
{
     WeaponOnoClass=Class'XIDSpec.BazookWeaponOno'
     bHaveAltFire=True
     bAllowEmptyShot=False
     bAutoReload=True
     bHeavyWeapon=True
     bHaveBoredSfx=True
     WHand=WHA_2HShot
     WeaponMode=WM_SemiAuto
     AmmoName=Class'XIII.BazookAmmo'
     AltAmmoName=Class'XIII.BazookRocketAltAmmo'
     PickupAmmoCount=1
     ReloadCount=1
     MeshName="XIIIArmes.FpsBazookaM"
     FireOffset=(X=9.000000,Y=15.000000,Z=1.000000)
     AltFireOffset=(X=7.000000,Y=-1.000000,Z=-6.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireBazooka'
     ShotTime=1.000000
     FiringMode="FM_Bazook"
     FireNoise=0.787000
     ReLoadNoise=0.000000
     AltFireNoise=0.000000
     LoadedFiringAnim="Firevide"
     EmptyFiringAnim="firevide_b"
     LoadedAltFiringAnim="FireAlt"
     ViewFeedBack=(X=5.000000,Y=12.000000)
     RumbleFXNum=13
     ShakeMag=900.000000
     shaketime=7.000000
     ShakeVert=(X=5.000000,Y=10.000000,Z=-25.000000)
     ShakeCycles=2.000000
     AIRating=0.800000
     TraceDist=150.000000
     hFireSound=Sound'XIIIsound.Guns__BazFire.BazFire__hBazFire'
     hReloadSound=Sound'XIIIsound.Guns__BazRel.BazRel__hBazRel'
     hNoAmmoSound=Sound'XIIIsound.Guns__BazDryFire.BazDryFire__hBazDry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__BazSelWp.BazSelWp__hBazSelWp'
     hAltFireSound=Sound'XIIIsound.Guns__BazFireAlt.BazFireAlt__hBazFireAlt'
     hActWaitSound=Sound'XIIIsound.Guns__BazWait.BazWait__hBazWait'
     InventoryGroup=15
     PickupClassName="XIII.BazookPick"
     PlayerViewOffset=(X=3.000000,Y=7.000000,Z=-4.500000)
     ThirdPersonRelativeLocation=(X=11.000000,Y=-3.000000,Z=7.000000)
     AttachmentClass=Class'XIII.BazookAttach'
     ItemName="Bazooka"
     DrawScale=0.300000
}
