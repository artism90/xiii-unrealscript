//-----------------------------------------------------------
//
//-----------------------------------------------------------
class LHarpon extends XIIIWeapon;

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

    if ( !HasAmmo() )
      return -2;
    if (instigator.controller.enemy!=none)
    {
      distance=Vsize(instigator.controller.enemy.location-instigator.location);
      if (distance>2500)
        return 0.61;
    }
    return AIRating;
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
simulated function PlaySelect()
{
    if (ReLoadCount > 0)
      PlayAnim('Select');
    else
      PlayAnim('SelectVide');
    if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
      Instigator.PlayRolloffSound(hSelectWeaponSound, self, 0, int(Pawn(Owner).IsPlayerPawn()) );
}

//_____________________________________________________________________________
simulated function TweenDown()
{
    if ( ReLoadCount > 0 )
      PlayAnim('Down', 1.0);
    else
      PlayAnim('DownVide', 1.0);
}

//    Mesh=SkeletalMesh'XIIIArmes.FpsLanceHarponM'
//    CrossHair=Texture'XIIIMenu.MireHarpon'
//    PickupClass=Class'XIII.LHarponPick'
//    Icon=texture'XIIIMenu.FHarponIcon'


defaultproperties
{
     WeaponOnoClass=Class'XIDSpec.TKnifeWeaponOno'
     bHaveAltFire=True
     bAllowEmptyShot=False
     bUnderWaterWork=True
     bAutoReload=True
     bHaveBoredSfx=True
     WHand=WHA_2HShot
     AmmoName=Class'XIII.HarponAmmo'
     AltAmmoName=Class'XIII.HarponAltAmmo'
     PickupAmmoCount=1
     ReloadCount=1
     MeshName="XIIIArmes.FpsLanceHarponM"
     FireOffset=(X=5.000000,Y=7.000000,Z=-4.000000)
     AltFireOffset=(X=15.000000,Y=-1.000000,Z=-4.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireCouteau'
     ShotTime=0.300000
     FiringMode="FM_2H"
     FireNoise=0.157000
     ReLoadNoise=0.000000
     AltFireNoise=0.000000
     LoadedFiringAnim="Firevide"
     EmptyFiringAnim="firevide_b"
     LoadedAltFiringAnim="FireAlt"
     RumbleFXNum=17
     AIRating=0.840000
     TraceDist=50.000000
     hFireSound=Sound'XIIIsound.Guns__HarpFire.HarpFire__hHarpFire'
     hReloadSound=Sound'XIIIsound.Guns__HarpRel.HarpRel__hHarpRel'
     hNoAmmoSound=Sound'XIIIsound.Guns__HarpDryFire.HarpDryFire__hHarpDry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__HarpSelWp.HarpSelWp__hHarpSelWp'
     hAltFireSound=Sound'XIIIsound.Guns__HarpFireAlt.HarpFireAlt__hHarpFireAlt'
     hActWaitSound=Sound'XIIIsound.Guns__HarpWait.HarpWait__hHarpWait'
     InventoryGroup=8
     PickupClassName="XIII.LHarponPick"
     PlayerViewOffset=(X=5.000000,Y=9.000000)
     ThirdPersonRelativeLocation=(X=25.000000,Y=-4.000000,Z=16.000000)
     ThirdPersonRelativeRotation=(Pitch=7000)
     AttachmentClass=Class'XIII.LHarponAttach'
     ItemName="HARPOON GUN"
     DrawScale=0.300000
}
