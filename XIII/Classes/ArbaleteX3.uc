//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ArbaleteX3 extends XIIIWeapon;

//_____________________________________________________________________________
simulated function bool ShouldDrawCrosshair(Canvas C)
{
    return false;
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
        PlayAnim('WaitAct', 1.0);
      }
      else
        PlayAnim('Wait', 1.0);
    }
    else
    {
      if ( bHaveBoredSfx && Pawn(Owner).IsPlayerPawn() && (iBoredCount > BOREDSFXTHRESHOLD) )
      {
        iBoredCount = 0;
        if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
          Instigator.PlayRolloffSound(hActWaitSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
        PlayAnim('WaitActVide', 1.0);
      }
      else
        PlayAnim('WaitVide', 1.0);
    }
}
//_____________________________________________________________________________
simulated function TweenDown()
{
    if ( ReLoadCount > 0 )
      PlayAnim('Down', 1.0);
    else
      PlayAnim('DownVide', 1.0);
}

//_____________________________________________________________________________
simulated function PlaySelect()
{
    if ( DBWeap )
      log("PlaySelect call for"@self@"w/ mesh="$Mesh);
    if (ReLoadCount > 0)
      PlayAnim('Select', 1.0);
    else
      PlayAnim('SelectVide', 1.0);
    Instigator.PlaySound(hSelectWeaponSound, 0, int(Pawn(Owner).IsPlayerPawn()) );
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
     if (distance>1666)
       return 0.29;
    }
    return AIRating;
}

//    PickupClass=Class'XIII.ArbaleteX3Pick'
//    Icon=texture'XIIIMenu.Arbalete3CIcon'

defaultproperties
{
     WeaponOnoClass=Class'XIDSpec.CrossBowWeaponOno'
     bHaveScope=True
     bAutoReload=True
     bHaveBoredSfx=True
     WHand=WHA_2HShot
     WeaponMode=WM_SemiAuto
     AmmoName=Class'XIII.BoltAmmo'
     PickupAmmoCount=3
     ReloadCount=3
     MeshName="XIIIArmes.FpsArbalete3cM"
     FireOffset=(Y=10.000000,Z=-6.000000)
     ShotTime=0.300000
     FiringMode="FM_2H"
     FireNoise=0.104000
     ReLoadNoise=0.000000
     ZCrosshair=Texture'XIIIMenu.HUD.ZMireSniperA'
     ZCrosshairDot=Texture'XIIIMenu.HUD.miresnipeM'
     LoadedFiringAnim="Firevide"
     EmptyFiringAnim="firevide_b"
     fAltZoomValue(1)=0.902000
     RumbleFXNum=14
     AIRating=0.392000
     hFireSound=Sound'XIIIsound.Guns__Arba3Fire.Arba3Fire__hArba3Fire'
     hReloadSound=Sound'XIIIsound.Guns__Arba3Rel.Arba3Rel__hArba3Rel'
     hNoAmmoSound=Sound'XIIIsound.Guns__Arba3DryFire.Arba3DryFire__hArba3Dry'
     hSelectWeaponSound=Sound'XIIIsound.Guns__Arba3SelWp.Arba3SelWp__hArba3SelWp'
     hZoomSound=Sound'XIIIsound.Guns__Zoom.Zoom__hZoom'
     hActWaitSound=Sound'XIIIsound.Guns__ArbaWait.ArbaWait__hArbaWait'
     InventoryGroup=7
     PickupClassName="XIII.ArbaleteX3Pick"
     PlayerViewOffset=(X=8.000000,Y=10.000000,Z=-6.000000)
     ThirdPersonRelativeLocation=(X=21.000000,Y=-3.000000,Z=14.000000)
     ThirdPersonRelativeRotation=(Pitch=7000)
     AttachmentClass=Class'XIII.ArbaleteX3Attach'
     ItemName="Crossbow X3"
     DrawScale=0.300000
}
