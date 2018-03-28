//-----------------------------------------------------------
//    XIIITriggers
//-----------------------------------------------------------
class XIIITriggers extends Triggers
                    native;

var() bool bCanBeLocked;
var() sound hPlayerTriggeringSound;

//____________________________________________________________________
//
function PlayerTrigger( actor Other, pawn EventInstigator )
{
    PlaySound(hPlayerTriggeringSound);
}



defaultproperties
{
}
