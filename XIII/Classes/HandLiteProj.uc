//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HandLiteProj extends Projector;

var vector OldLocation;
var rotator OldRotation;
var bool bActive;

//_____________________________________________________________________________
function Tick(float dT)
{
    if ( !bActive )
    {
      DetachProjector(true);
      return;
    }
    if ( (OldLocation != Owner.Location+Pawn(Owner).EyePosition()-vect(0,0,30)) || (OldRotation != Pawn(Owner).controller.Rotation) )
    {
      DetachProjector(true);
      SetLocation(Owner.Location+Pawn(Owner).EyePosition()-vect(0,0,30));
      SetRotation(Pawn(Owner).controller.Rotation);
      AttachProjector();
      OldLocation = Owner.Location+Pawn(Owner).EyePosition()-vect(0,0,30);
      OldRotation = Pawn(Owner).controller.Rotation;
    }
}



defaultproperties
{
     ProjTexture=Texture'XIIICine.effets.eclairblanc'
     FOV=35
     MaxTraceDistance=2048
     bClipBSP=True
     bFade=True
     AttachPriority=3
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
}
