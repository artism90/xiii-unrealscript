//-----------------------------------------------------------
//
//-----------------------------------------------------------
class TyrolTrigger extends XIIITriggers;

var(TyrolPath) XIIITyrolNavPoint StartPoint, EndPoint;
var(TyrolPath) float fTyrolSpeed;

//____________________________________________________________________
function PlayerTrigger( actor Other, pawn EventInstigator )
{
//    Log("---- "$self$" triggered");
    if ( XIIIPlayerController(Other).TryTyroling() )
    {
      XIIIPlayerController(Other).GoTyroling(StartPoint, EndPoint, fTyrolSpeed);
    }
}



defaultproperties
{
     fTyrolSpeed=629.000000
     bCanBeLocked=True
     bInteractive=True
}
