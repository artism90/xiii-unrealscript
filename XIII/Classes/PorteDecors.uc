//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PorteDecors extends XIIIMover;

//____________________________________________________________________
// To be sure no one has left another initial state for this ?
function PostBeginPlay()
{
    Super.PostBeginPlay();
    gotostate('ForeverLocked');
}

//____________________________________________________________________
simulated event SetInitialState()
{
     bScriptInitialized = true;
     GotoState('ForeverLocked');
}

//____________________________________________________________________
auto state ForeverLocked
{
    ignores Touch, Bump, Trigger, TakeDamage;

    function PlayerTrigger( actor Other, pawn EventInstigator )
    {
      PlaySound(OpeningSound);
    }
}



defaultproperties
{
     bAcceptsProjectors=True
     bInteractive=False
     Physics=PHYS_None
     bPathColliding=True
}
