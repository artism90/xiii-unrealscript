//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIISoloMessage extends XIIILocalMessage;

var localized string PickingLock, PickingInterrupt, UnlockedDoor, TimeLeft, LockedDoor, WrongKey, NoLockPick;
var localized string NothingOnThisCorpse, NeedTwoHands;
var localized string PrepareSaving, Saving, FinishedSaving;

static function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    switch (Switch)
    {
      case 1: // picking lock
        return default.PickingLock; break;
      case 2: // Picked Lock
        return default.UnlockedDoor; break;
      case 3: // Chronometer request to display time
        return Default.TimeLeft;
      case 4: // Searching for an empty inventory corpse
        return Default.NothingOnThisCorpse;
      case 5: // Trying to activate Locked door
        return Default.LockedDoor;
      case 6: // Using the wrong key/item on a door
        return Default.WrongKey;
      case 7: // Picking interruption
        return Default.PickingInterrupt;
      case 8: // Need 2 hands to perform action
        return Default.NeedTwoHands;

      case 9: // Prepare Saving
        return Default.PrepareSaving;
      case 10: // Saving
        return Default.Saving;
      case 11: // Finished Saving
        return Default.FinishedSaving;
      case 12: // Using the wrong key/item on a door
        return Default.NoLockPick;
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



defaultproperties
{
     PickingLock="Picking the lock"
     PickingInterrupt="Picking Interrupted !!"
     UnlockedDoor="You unlocked the door"
     TimeLeft="Time Left : "
     LockedDoor="This door is locked !"
     WrongKey="This is not the right key"
     NoLockPick="This door can't be lockpicked"
     NothingOnThisCorpse="NOTHING FOUND"
     NeedTwoHands="Need 2 hands free to perform action !!"
     PrepareSaving="Preparing to Save, do not remove Saving Device or turn off system"
     Saving="Saving the game..."
     FinishedSaving="Finished Saving, you can go back to normal activity."
     DrawColor=(B=180,G=180,R=180)
}
