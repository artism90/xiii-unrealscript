//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIISaveMessage extends XIIILocalMessage;

var localized string CheckpointReached;
//var localized string PrepareSaving, Saving, FinishedSaving;
//var localized string NoMoreSlots, ErrorWhileSaving;

static function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    switch (Switch)
    {
      case 1: // Prepare Saving
        return Default.CheckpointReached;
        /*
      case 2: // Saving
        return Default.Saving;
      case 3: // Finished Saving
        return Default.FinishedSaving;
      case 4: // no more slots
        return Default.NoMoreSlots;
      case 4: // Error while saving (WriteSlot returned false)
        return Default.ErrorWhileSaving;
        */
    }
    return default.class$" ERR::RECEIVED GetString with wrong or undefined Params Switch="$Switch;
}

/*
//_____________________________________________________________________________
static function texture GetIcon( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    return none;
}
*/

/*
    PrepareSaving="Preparing to Save, do not remove Saving Device or turn off system"
    Saving="Saving the game..."
    FinishedSaving="Finished Saving, you can go back to normal activity."
    NoMoreSlots="WARNING : No more slots for Saving, only Quick Save slot saved"
    ErrorWhileSaving="ERROR while saving"
*/



defaultproperties
{
     CheckpointReached="Checkpoint reached"
     Lifetime=3
     DrawColor=(B=180,G=220,R=220)
}
