//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BloodSplash extends Projector;

var float Lifetime;

//____________________________________________________________________
function PostBeginPlay()
{
    Local rotator R;

    if ( Level.bLonePlayer && Level.Game.bAlternateMode )
      ProjTexture=Material'XIIICine.ProjectionBlood_2';
    R = rotation;
    R.Roll = randrange(0, 32767);
    SetRotation(R);
//    Log("####"@self@"PostBeginPlay w/ ProjTexture="$ProjTexture);
    AttachProjector();
    AbandonProjector(Lifetime);
    Destroy();
}

//____________________________________________________________________
// reset actor to initial state - used when restarting level without reloading.
function Reset()
{
    Destroy();
}


defaultproperties
{
     Lifetime=6.000000
     ProjTexture=FinalBlend'XIIICine.effets.projectionblood'
     MaxTraceDistance=256
     bProjectTerrain=False
     bProjectStaticMesh=False
     bProjectActor=False
     bClipBSP=True
     AttachPriority=3
     bMovable=False
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     DrawScale=1.150000
}
