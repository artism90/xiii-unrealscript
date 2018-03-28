//=============================================================================
// XIIIscorch
// base class of XIII damage decals
//=============================================================================
class XIIIScorch extends Projector;

var float Lifetime;
var bool bUseRandRot;

//____________________________________________________________________
simulated function PostBeginPlay()
{
    local rotator R;

    if ( bUseRandRot )
    {
      R = rotation;
      R.Roll = randrange(0, 32767);
      SetRotation(R);
    }

    AttachProjector();
    AbandonProjector(Lifetime);
//    Destroy();
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
     bUseRandRot=True
     FOV=10
     MaxTraceDistance=32
     bProjectTerrain=False
     bProjectActor=False
     bClipBSP=True
     bFade=True
     AttachPriority=0
     bNetOptional=True
     bAlwaysRelevant=True
     bMovable=False
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     LifeSpan=1.000000
}
