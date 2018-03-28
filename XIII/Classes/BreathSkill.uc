//-----------------------------------------------------------
// Called by XIIIPawn (554:38)
//-----------------------------------------------------------
class BreathSkill extends XIIISkill;

//_____________________________________________________________________________
function PickupFunction(Pawn Other)
{
    log(self@"PickupFunction"@other@"call");

    Super.PickupFunction(Other);
    XIIIPawn(Other).SetBreatheOn();
}

//_____________________________________________________________________________
function GiveTo( pawn Other )
{
    log(self@"GiveTo"@other@"call");

    Super.GiveTo(Other);
    XIIIPawn(Other).SetBreatheOn();
}


defaultproperties
{
     PickupClass=Class'XIII.BreathSkillPick'
}
