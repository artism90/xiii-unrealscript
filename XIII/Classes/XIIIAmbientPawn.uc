//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIAmbientPawn extends Pawn
     abstract;

//_____________________________________________________________________________
function PlayCall();

//_____________________________________________________________________________
function bool IsWalking()
{
    return (base!=none);
}

//_____________________________________________________________________________
/* PickSize() Choose random size variation for this ambientpawn */
function PickSize(int NumKids, int NumMoms, int NumDads);

//_____________________________________________________________________________
function bool IsFemale()
{
    return false;
}

//_____________________________________________________________________________
function bool IsInfant()
{
    return false;
}

//_____________________________________________________________________________
event Trigger( Actor Other, Pawn EventInstigator )
{
//    Log(self@"triggered");
    Controller.Trigger(Other, EventInstigator);
}



defaultproperties
{
     bAmbientCreature=True
}
