//-----------------------------------------------------------
//
//-----------------------------------------------------------
class UnBreakable extends XIIIMover;

//____________________________________________________________________
// To be sure no one has left another initial state for this ?
function PostBeginPlay()
{
    Super.PostBeginPlay();
    gotostate('UnBreakable');
}

//____________________________________________________________________
simulated event SetInitialState()
{
     bScriptInitialized = true;
     GotoState('UnBreakable');
}

//____________________________________________________________________
auto state UnBreakable
{
    ignores Touch, Bump, Trigger, PlayerTrigger, TakeDamage;
}



defaultproperties
{
     Physics=PHYS_None
     bPathColliding=True
}
