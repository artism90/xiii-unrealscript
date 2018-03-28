//-----------------------------------------------------------
// Specific item for Plage01 map (First map)
//-----------------------------------------------------------
class Plage01MedKit extends FullMedKit;

//_____________________________________________________________________________
// ELR CauseEvent
simulated function UseMe()
{
    XIIIPawn(Owner).SpeedFactorLimit = XIIIPawn(Owner).Default.SpeedFactorLimit;
    XIIIPawn(Owner).SetGroundSpeed(1.0);
    Super.UseMe();
}



defaultproperties
{
     InventoryGroup=2
}
