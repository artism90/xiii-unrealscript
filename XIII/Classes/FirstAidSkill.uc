//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FirstAidSkill extends XIIISkill;

//_____________________________________________________________________________
// ELR CauseEvent
Simulated function UseMe()
{
/*
    local XIIIPawn P;

    P = XIIIPawn(Owner);
    if ( (P != none) && P.IsBleeding() )
      P.StopBleedin();
*/
}

//_____________________________________________________________________________
// Activated Item
state Activated
{
Begin:
    Instigator.PlayRolloffSound(ActivateSound, self);
    UseMe();
}



defaultproperties
{
}
