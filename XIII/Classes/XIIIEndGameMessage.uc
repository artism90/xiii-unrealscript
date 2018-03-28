//
//-----------------------------------------------------------
class XIIIEndGameMessage extends XIIILocalMessage;

var localized string PlayerKilledMsg;
//var localized string GoalCompleteMsg, GoalInCompleteMsg;
var localized string GoalInCompleteMsg;
var localized string PlayerFallingMsg;

//_____________________________________________________________________________
static function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    switch (Switch)
    {
      case 1: // PlayerKilled
        return default.PlayerKilledMsg; break;
//      case 2: // Goals completed
//        return default.GoalCompleteMsg; break;
      case 3: // Goals cannont be completed
        return default.GoalInCompleteMsg; break;
      case 4: // Player Is falling down
        return default.PlayerFallingMsg; break;
    }
    return default.class$" ERR::RECEIVED GetString with wrong or undefined Params";
}

//    LifeTime=4000000.0


defaultproperties
{
     PlayerKilledMsg="XIII Has been killed... RIP"
     GoalInCompleteMsg="You failed to complete your objectives..."
     PlayerFallingMsg="You break your bones..."
     bIsSpecial=True
     DrawColor=(B=80,G=80,R=255)
     bCenter=True
}
