//
//-----------------------------------------------------------
class XIIIMissionCompletedMessage extends XIIILocalMessage;

var localized string GoalCompleteMsg;

//_____________________________________________________________________________
static function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    return default.GoalCompleteMsg;
}

//    LifeTime=4000000.0


defaultproperties
{
     GoalCompleteMsg="Well done, Mission complete !"
     bIsSpecial=True
     DrawColor=(R=255)
     bCenter=True
}
