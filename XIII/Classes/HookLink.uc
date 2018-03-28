//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HookLink extends Effects;

var Hook HStart;
var HookProjectile HEnd;
var int LinkIndex;
var HookLink NextLink;
var HookLink PrevLink;
const LinkLength = 100.0;
var bool bDestroyWhenDown;
var bool bForceDestroy;

//_____________________________________________________________________________
function Tick(float deltatime)
{
    local vector vDir, vStart, vEnd, X,Y,Z, U,V,W, tV, HitLoc, HitNorm;
    Local material HitMat;
    local vector CamLoc;
    local rotator CamRot;
    local actor A;

    // Just release if obstacle.
    if ( HStart.bHooked )
    {
      A = Trace(HitLoc, HitNorm,
        HEnd.Location,
        HStart.Owner.Location + Pawn(HStart.Owner).EyeHeight * vect(0,0,1),
        false,
        vect(0,0,0),
        HitMat,
        TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon);
  //    if ( !FastTrace(HEnd.Location, HStart.Owner.Location + Pawn(HStart.Owner).EyeHeight * vect(0,0,1)) )
      if ( A != none )
      {
        Log("Releasing hook because obstacle"@A);
        HStart.Release();
      }
    }

    XIIIPlayerController(Pawn(HStart.Owner).Controller).PlayerCalcView(A, CamLoc, CamRot);
    GetAxes(CamRot, X, Y, Z);
    if ( PrevLink == none )
    { // Update HookSpring
      if ( HStart.bGoUp )
      {
        HStart.HookSpring = fMin(1.0, HStart.HookSpring + DeltaTime*4.0);
        HStart.HookMecRot += DeltaTime*4.0;
//        Log("GOUP HookSpring"@HStart.HookSpring);
      }
      else if ( HStart.bGodown )
      {
        HStart.HookSpring = fMax(-1.0, HStart.HookSpring - DeltaTime*6.0);
        HStart.HookMecRot -= DeltaTime*5.5;
//        Log("GODOWN HookSpring"@HStart.HookSpring);
      }
      else if ( HStart.HookSpring > 0 )
      {
        HStart.HookSpring = fMax(0.0, HStart.HookSpring - DeltaTime*3.0);
//        Log("RELUP HookSpring"@HStart.HookSpring);
      }
      else if ( HStart.HookSpring < 0 )
      {
        HStart.HookSpring = fMin(0.0, HStart.HookSpring + DeltaTime*3.0);
//        Log("RELDOWN HookSpring"@HStart.HookSpring);
      }
    }
    if ( bDestroyWhenDown )
    {
      HStart.HookMecPrep = fMax(0.0, HStart.HookMecPrep - DeltaTime*8.0);
      if ( HStart.HookMecPrep <= 0.0 )
      {
        if ( HStart.HookMec != none )
        {
          HStart.HookMec.bHidden = true;
          HStart.HookMec.RefreshDisplaying();
        }
        if ( HStart.HookHarn != none )
        {
          HStart.HookHarn.bHidden = true;
          HStart.HookHarn.RefreshDisplaying();
        }
        Destroy();
      }
    }
    else
      HStart.HookMecPrep = fMin(1.0, HStart.HookMecPrep + DeltaTime*8.0);

    vStart = CamLoc + X*10 - Y*(6.0-2*X.z) - Z*(8.5 - HStart.HookMecPrep * 4.0 - Sin((X.z+1)*(pi/2.0))) + vect(0,0,0.85)*HStart.HookSpring;
    vEnd = HEnd.Location;
    vDir = vEnd - vStart;
    SetRotation( rotator(vDir) );
    if ( NextLink == none )
    {
      SetLocation( vStart + Normal(vDir) * (LinkLength * 0.5) );
      // update hook mecanism pos/rot.
      // First Transformation, put along axis (rotate around X)
      V = Z*cos(pi/2.0*0.08) - Y*sin(pi/2.0*0.08);
      W = Y*cos(pi/2.0*0.08) + Z*sin(pi/2.0*0.08);
      CamRot = Orthorotation(X,W,V);
      GetAxes( CamRot, U,V,W);
      HStart.HookMec.SetLocation(vStart + V*1.15 + (vect(0,0,1) cross V)*0.85);
      HStart.HookHarn.SetLocation(vStart + V*1.15 + (vect(0,0,1) cross V)*0.85);
      HStart.HookHarn.SetRotation( CamRot );
      // second transformation, rotate according to up/down (should be U & W rotating around Y)
      tV = W*cos(pi/2.0*HStart.HookMecRot) + U*sin(pi/2.0*HStart.HookMecRot);
      U = U*cos(pi/2.0*HStart.HookMecRot) - W*sin(pi/2.0*HStart.HookMecRot);
      W = tV;
      HStart.HookMec.SetRotation( OrthoRotation(U,V,W) );
    }
    else
    {
      SetLocation( vEnd - Normal(vDir) * LinkLength * (LinkIndex+0.5) );
    }

    if ( bDestroyWhenDown )
      return;

    if ( (vSize(vDir) > (LinkLength*(LinkIndex+1))) && (NextLink == none) )
    {
      NextLink=Spawn(class'HookLink',,, Location,Rotation);
      if (NextLink != none)
      {
        NextLink.HStart=HStart;
        NextLink.HEnd=HEnd;
        NextLink.LinkIndex = LinkIndex + 1;
        NextLink.PrevLink = self;
      }
    }
    if ( vSize(vDir) < (LinkLength*(LinkIndex)) )
    {
      PrevLink.NextLink = none;
      Destroy();
    }
}

//_____________________________________________________________________________
function ShouldDestroy()
{ // Link destroyed, still handle hookmec position until down then destroy
//    Log(self@"ShouldDestroy, PrevLink="@PrevLink@"NextLink="@NextLink);
    if ( NextLink == none )
    {
      bDestroyWhenDown = true;
      bHidden = true;
      RefreshDisplaying();
    }
    else
    {
      NextLink.ShouldDestroy();
      Destroy();
    }
}

//_____________________________________________________________________________
function ForceDestroy()
{
    bDestroyWhenDown = false;
    if ( NextLink != none )
    {
      NextLink.bDestroyWhenDown = false;
      NextLink.ForceDestroy();
    }
    Destroy();
}

//_____________________________________________________________________________
event Destroyed()
{
/*  if ( PrevLink != none )
    PrevLink.NextLink = none; */
  if ( (NextLink != none) && !NextLink.bDestroyWhenDown )
    NextLink.Destroy();
}

//     DrawType=DT_Mesh
//     Mesh=VertMesh'XIIIArmes.GrappinCordeM'


defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'MeshArmesPickup.grappincorde'
     DrawScale3D=(Y=0.350000,Z=0.350000)
}
