//
//-----------------------------------------------------------
class ProjectileInWall extends Effects
    NotPlaceable;

var string StaticMeshName;  // to dynamicload it

//_____________________________________________________________________________
function PostBeginPlay()
{
    Super.PostBeginplay();
    SetTimer(6.0, false);
    if ( (StaticMesh == none) && (StaticMeshName != "") )
    {
      StaticMesh = StaticMesh(dynamicloadobject(StaticMeshName, class'StaticMesh'));
      default.StaticMesh = StaticMesh;
//      Log("PostBeginPlay DYNAMICLOAD StaticMesh "$StaticMeshName@"result "$StaticMesh);
    }
}

//_____________________________________________________________________________
function Timer()
{
    if ( !PlayerCanSeeMe() )
      Destroy();
    else SetTimer(1.0, false);
}



defaultproperties
{
     bUnlit=False
     DrawType=DT_StaticMesh
     LifeSpan=60.000000
}
