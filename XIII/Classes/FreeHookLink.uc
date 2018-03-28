//-----------------------------------------------------------
// NOY USED ANYMORE
//-----------------------------------------------------------
class FreeHookLink extends Effects;

/*
var int LinkIndex;
var Hook HStart;
var HookProjectile HEnd;
var bool bInitialized;
const LinkLength = 100.0;
var vector vEnd, OldvEnd;
var FreeHookLink NextLink;
var FreeHookLink PrevLink;
var float fAddLinkCounter;

//_____________________________________________________________________________
function Tick(float deltatime)
{
    local vector vDir, vStart, X,Y,Z;

    GetAxes(Pawn(HStart.Owner).Rotation, X, Y, Z);

    // If LinkIndex == 0 else get vEnd from prev link.
    if ( LinkIndex == 0 )
      vStart = HStart.Owner.Location + X*10 + Z*20 - Y*8;
    else
    {
      vStart = PrevLink.vEnd;
      if ( !FastTrace(OldvEnd, vStart) && bInitialized )
      {
        PrevLink.NextLink = none;
        Destroy();
      }
    }

    if ( bInitialized )
    {
      if (LinkIndex == 0)
        vEnd = ( (vStart - vect(0,0,1)*LinkLength) + 2.0*(vStart - normal(HEnd.Location-vStart)*LinkLength) )/3.0 + OldvEnd * 5;
      else
        vEnd = ( (vStart - vect(0,0,1)*LinkLength) + 2.0*(vStart - normal(PrevLink.Location-vStart)*LinkLength) )/3.0 + OldvEnd * 5;
      vEnd /= 6;
      OldvEnd = vEnd;
    }
    else
    {
      vEnd = vStart - vect(0,0,1)*LinkLength;
      OldvEnd = vEnd;
      bInitialized=true;
    }

    vDir = vEnd - vStart;
    vEnd = vStart + normal(vDir) * LinkLength * DrawScale3D.X;

    SetRotation( rotator(vDir) );
    SetLocation( vStart + normal(vDir) * LinkLength * 0.5 * DrawScale3D.X);

    if ( DeltaTime < 1.0/25.0 )
    {
      fAddLinkCounter += DeltaTime;
      if ( (LinkIndex < 40) && (NextLink == none) && (fAddLinkCounter >= 1.0) )
      {
        if ( FastTrace(vEnd - vect(0,0,2)*LinkLength * DrawScale3D.X, vEnd) )
        {
          NextLink = Spawn(class'FreeHookLink',,,Location, rotation);
          NextLink.HStart = HStart;
          NextLink.LinkIndex = LinkIndex + 1;
          NextLink.PrevLink = self;
        }
      }
      if ( fAddLinkCounter >= 1.0 )
        fAddLinkCounter -= 1.0;
    }
    else
    {
      if ( (LinkIndex > 0) && (NextLink == none) )
      {
        PrevLink.NextLink = none;
        Destroy();
      }
    }
}

//_____________________________________________________________________________
event Destroyed()
{
  if (NextLink != none)
    NextLink.Destroy();
}
*/

/*
     Physics=PHYS_None
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'MeshArmesPickup.GrappinCorde'
     DrawScale3D=(X=0.5,Y=1.0,Z=1.0)
*/


defaultproperties
{
}
