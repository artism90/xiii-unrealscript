//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Grenad extends XIIIWeapon;

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
      if (distance>1170)
        return 0.16;
      else if (distance<500)
        return 0.16;
      if (PositionRelative.z>400) // enemy au dessus donc pas prendre
        return (AIRating-2);
     }
     return 0.24;
//     return AIRating;
}

//_____________________________________________________________________________
simulated function PlayIdleAnim()
{
    if ( HasAmmo() )
      PlayAnim('Wait', 1.0, 0.3);
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

//    Icon=texture'XIIIMenu.GrenadIcon'


defaultproperties
{
     bAllowEmptyShot=False
     WHand=WHA_Throw
     WeaponMode=WM_SemiAuto
     AmmoName=Class'XIII.GrenadAmmo'
     PickupAmmoCount=1
     MeshName="XIIIArmes.FpsGrenade_ExploM"
     FireOffset=(Y=7.000000,Z=-1.000000)
     CrossHair=Texture'XIIIMenu.HUD.MireCouteau'
     ShotTime=2.000000
     FiringMode="FM_Throw"
     FireNoise=0.000000
     AIRating=0.450000
     TraceDist=15.000000
     hFireSound=Sound'XIIIsound.Guns__GrenFire.GrenFire__hGrenFire'
     hSelectWeaponSound=Sound'XIIIsound.Guns__GrenSelWp.GrenSelWp__hGrenSelWp'
     InventoryGroup=4
     PickupClassName="XIII.GrenadPick"
     PlayerTransferClassName="XIII.GrenadB"
     PlayerViewOffset=(X=5.000000,Y=4.000000,Z=-4.200000)
     ThirdPersonRelativeLocation=(X=7.000000,Y=-5.000000,Z=2.000000)
     ThirdPersonRelativeRotation=(Yaw=16384)
     AttachmentClass=Class'XIII.GrenadAttach'
     ItemName="GRENADE"
     DrawScale=0.300000
}
