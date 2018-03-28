//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Fists extends XIIIWeapon;

//_____________________________________________________________________________
simulated function AltFire( float Value )
{
    PlayAnim('FireAlt', 1.0);
}

//_____________________________________________________________________________
simulated function PlayFiring()
{
    if ( Instigator.IsPlayerPawn() && XIIIPlayerController(Instigator.controller).MyInteraction.bCanStun )
      PlayAnim('Manchette', 1.0);
    else if ( (fRand() < 0.5) && (!Instigator.IsPlayerPawn() || !XIIIPawn(Instigator).LHand.bActive) )
      PlayAnim('FireL', 1.0);
    else
      PlayAnim('FireR', 1.0);
    IncrementFlashCount();
    PlayFiringSound();
}

//_____________________________________________________________________________
// FRD
function float RateSelf()
{
    return AIRating;
}

//    Icon=texture'XIIIMenu.FistsIcon'


defaultproperties
{
     bMeleeWeapon=True
     bUnderWaterWork=True
     AmmoName=Class'XIII.FistsAmmo'
     PickupAmmoCount=1
     ShotTime=0.700000
     FiringMode="FM_Fists"
     FireNoise=0.104000
     ReLoadNoise=0.000000
     ShakeMag=100.000000
     ShakeVert=(X=5.000000,Z=2.000000)
     ShakeSpeed=(X=200.000000,Z=-100.000000)
     ShakeCycles=1.500000
     AIRating=0.100000
     hFireSound=Sound'XIIIsound.Guns__NoWpFire.NoWpFire__hNoWpFire'
     hAltFireSound=Sound'XIIIsound.Guns__HandFireAlt.HandFireAlt__hHandFireAlt'
     hActWaitSound=Sound'XIIIsound.Guns__HandsWait.HandsWait__hHandsWait'
     InventoryGroup=0
     PlayerViewOffset=(X=4.000000,Y=4.000000,Z=-9.000000)
     AttachmentClass=Class'XIII.FistsAttach'
     ItemName="FISTS"
     Mesh=SkeletalMesh'XIIIArmes.fpsM'
     DrawScale=0.300000
}
