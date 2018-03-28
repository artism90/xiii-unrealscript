//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MessageTrigger extends XIIITriggers;

var() localized string TriggeredMsg;
var() float fMessageDuration;

//_____________________________________________________________________________
function Trigger(actor Other, pawn EventInstigator )
{
    local XIIIPlayerController XPC;

    XPC = FindPlayerController();

    if ( XPC != none )
    {
      XPC.MyHUD.LocalizedMessage( class'XIIIGoalMessage', -1, XPC.PlayerReplicationInfo, none, self, TriggeredMsg );
//      XPC.ClientMessage(TriggeredMsg, 'TriggerMsg');
      Destroy();
    }
}

//_____________________________________________________________________________
function XIIIPlayerController FindPlayerController()
{
    local Controller C;
    for( C=Level.ControllerList; C!=None; C=C.nextController )
      if( C.IsA('XIIIPlayerController') )
      {
        return XIIIPlayerController(C);
      }
    return none;
}



defaultproperties
{
}
