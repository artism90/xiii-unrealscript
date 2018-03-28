//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CWndSFXCancelTrigger extends XIIITriggers;

var() bool bTriggerOnTouch;

//____________________________________________________________________
function Touch(actor other)
{
    if ( !bTriggerOnTouch )
      return;
    if ( (Pawn(Other) != none) && Pawn(Other).IsPlayerPawn() )
    {
      bTriggerOnTouch = false;
      Trigger(Other, Pawn(Other));
    }
}

//____________________________________________________________________
function Trigger( actor Other, pawn EventInstigator )
{
    local XIIIBaseHUD H;
    local CWndBase CWndB;

    foreach allactors(class'XIIIBaseHUD', H)
    {
      H.EraseCartoonWindows();
    }
    foreach allactors(class'CWndBase', CWndB)
    {
      CWndB.Destroy();
    }
}


defaultproperties
{
}
