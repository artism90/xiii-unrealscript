//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoAmmo extends XIIIH2HAmmo;

var bool bUnused;
var int bBrokenOnTgt;
var DecoWeapon DW;

//_____________________________________________________________________________
// ELR No Ammo used by fists
function ProcessTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    Super.ProcessTraceHit( W, Other, HitLocation, HitNormal, X, Y, Z);
    bUnused = false;
    DW = DecoWeapon(W);
//    Log("DecoWeapon using");
//    Spawn(class'DecoImpactEmitter',self,,HitLocation, rotator(X));
    if ( DW.fDelaySFXBroken > 0.0 )
    {
      SetTimer2(DW.fDelaySFXBroken, false);
      if ( Pawn(Other) != none )
        bBrokenOnTgt = 2;
      else if ( Other != none )
        bBrokenOnTgt = 1;
      else
        bBrokenOnTgt = 0;
    }
    else
    {
      if ( Pawn(Other) != none )
        Spawn(DW.SFXWhenBroken,self,,DW.Location+vector(DW.owner.rotation)*120.0, DW.owner.rotation);
      else if ( other != none )
        Spawn(DW.SFXWhenBrokenNotPawn,self,,DW.Location+vector(DW.owner.rotation)*120.0, DW.owner.rotation);
      else
        Spawn(DW.SFXWhenBrokenNoTgt,self,,DW.Location+vector(DW.owner.rotation)*120.0, DW.owner.rotation);
    }
}

//_____________________________________________________________________________
event Timer2()
{
    if ( bBrokenOnTgt == 2 )
      Spawn(DW.SFXWhenBroken,self,,DW.Location+vector(DW.owner.rotation)*120.0, DW.owner.rotation);
    else if ( bBrokenOnTgt == 1 )
      Spawn(DW.SFXWhenBrokenNotPawn,self,,DW.Location+vector(DW.owner.rotation)*120.0, DW.owner.rotation);
    else
      Spawn(DW.SFXWhenBrokenNoTgt,self,,DW.Location+vector(DW.owner.rotation)*120.0, DW.owner.rotation);
    DW.DetachFromPawn(DW.Instigator);
}


defaultproperties
{
     bUnused=True
     H2HDamages=20
     MyDamageType=Class'XIII.DTSureStunned'
     ImpactNoise=0.420000
     SoftImpactNoise=0.420000
     fFireDelay=0.200000
     bTravel=False
}
