//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BloodFlow extends Projector
                    native;

var float fDist;

native(604) static final function bool GrowBloodFlow(float dT);

//_____________________________________________________________________________
auto state Flowing
{
    function BeginState()
    {
      local rotator R;

      R = rotation;
      R.Roll = randrange(0, 32767);
      SetRotation(R);
      if ( Level.bLonePlayer && Level.Game.bAlternateMode )
        ProjTexture=Material'XIIICine.bloodspotA_2_alpha';
    }
    function Tick(float dT)
    {
      /*
      fDist += dT*2;
      DetachProjector(true);
      Move( - dT*2 * vector(rotation) );
      AttachProjector();
      if ( fDist > 32 )
      {
//        AbandonProjector(15.0);
        GotoState('');
      }
      */
      if (GrowBloodFlow(dT))
      {
        GotoState('');
      }
    }
}

//    ProjTexture=Material'XIIICine.RoundShadowA_alpha'

defaultproperties
{
     ProjTexture=FinalBlend'XIIICine.effets.BloodspotA_alpha'
     FOV=5
     MaxTraceDistance=16
     bProjectActor=False
     bClipBSP=True
     AttachPriority=3
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     DrawScale=0.050000
}
