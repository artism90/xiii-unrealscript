//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SoldierTouchAndKill extends XIIITriggers;

var() XIIIPawn SoldierToKillIfTouchedBy;

//____________________________________________________________________
function Touch(actor other)
{
    if ( (XIIIPawn(other) != none) && (XIIIPawn(Other) == SoldierToKillIfTouchedBy) )
    {
      Instigator = XIIIPawn(other);
      TriggerEvent(event,self,Instigator);
      Instigator.Destroy();
      destroy();
    }
}



defaultproperties
{
}
