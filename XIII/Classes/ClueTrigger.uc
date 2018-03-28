//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ClueTrigger extends Triggers;

var() float TriggerDistance;
var() pickup MyPickup;

//____________________________________________________________________
auto state WaitForBeingSeen
{
    event BeginState()
    {
      SetTimer(1.0, false);
    }

    event Timer()
    { // Only called in solo mode
      local float fTime, fDist;
      local XIIIPlayerPawn XPP;

      if ( (Level.Game == none) || (XIIIGameInfo(Level.Game).MapInfo == none) || (XIIIGameInfo(Level.Game).MapInfo.XIIIPawn == none) )
      {
        SetTimer(2.0, false);
        return;
      }
      XPP = XIIIPlayerPawn(XIIIGameInfo(Level.Game).MapInfo.XIIIPawn);
      if ( (XPP == none) || (XPP.Controller == none) || (XPP.SSSk == none) || !XPP.SSSk.bImOn )
      {
        SetTimer(2.0, false);
        return;
      }

      fDist = vSize(XPP.Location - Location);

      if ( (fDist < TriggerDistance) && FastTrace(Location, XPP.Location) && ((Location - XPP.Location) dot vector(XPP.Controller.Rotation) > 0.707) )
      { // if player see me send clue
        bHidden = false;
        bDelayDisplay = true;
        LifeSpan = 2.5;
        SetTimer(0.1, true);
        if ( MyPickup != none )
          GotoState('CheckForPickup');
      }
      else
      { // still wait w/ eval of how long it will take for the player to come
        fTime = (fDist-TriggerDistance) / XPP.GroundSpeed;
        fTime *= 0.666; // security factor
        fTime = fMax(0.5, fTime); // wait a min time
        SetTimer(fTime, false);
      }
    }
}

//____________________________________________________________________
state CheckForPickup
{
    event Timer()
    {
      if ( (MyPickup == none) || MyPickup.bDeleteMe )
        Destroy();
    }
}


defaultproperties
{
     TriggerDistance=800.000000
     bCollideActors=False
     Texture=Texture'XIIICine.effets.indice'
}
