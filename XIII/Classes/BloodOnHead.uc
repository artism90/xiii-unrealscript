//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BloodOnHead extends Projector;

//_____________________________________________________________________________
event PostBeginPlay()
{
    if ( Level.bLonePlayer && Level.Game.bAlternateMode )
      ProjTexture=Material'XIIICine.ProjectionBlood_2';
}

//_____________________________________________________________________________
event Tick(float dT)
{
    if ( Owner.IsAnimating() )
    {
      DetachProjector(true);
      AttachProjector();
    }
    else
    {
      AbandonProjector(5.0);
      Destroy();
    }
}


defaultproperties
{
     ProjTexture=FinalBlend'XIIICine.effets.projectionblood'
     FOV=5
     MaxTraceDistance=68
     bProjectBSP=False
     bProjectTerrain=False
     bProjectStaticMesh=False
     bClipBSP=True
     AttachPriority=3
     Texture=None
     DrawScale=0.200000
}
