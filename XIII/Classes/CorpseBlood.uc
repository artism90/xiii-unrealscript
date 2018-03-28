//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CorpseBlood extends Projector;

//____________________________________________________________________
simulated function PostBeginPlay()
{
    AttachProjector();
//    AbandonProjector(0);
//    Destroy();
}


defaultproperties
{
     ProjTexture=FinalBlend'XIIICine.effets.BloodspotA_alpha'
     MaxTraceDistance=32
     bProjectActor=False
     bClipBSP=True
     AttachPriority=3
     bMovable=False
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     DrawScale=0.200000
}
