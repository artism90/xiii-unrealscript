//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIDeathMessage extends XIIILocalMessage;

var localized string KilledBy, Suicided, SuicidedMalus, KilledByKKK;

//_____________________________________________________________________________
static function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    switch (Switch)
    {
      case 3: // KKK
        return RelatedPRI_2.PlayerName@Default.KilledByKKK; break;
      case 2: // Suicide KKK
        return RelatedPRI_2.PlayerName@Default.SuicidedMalus; break;
      case 1: // Suicide
        return RelatedPRI_2.PlayerName@Default.Suicided; break;
      case 0: // Killed
        return RelatedPRI_2.PlayerName@Default.KilledBy@RelatedPRI_1.PlayerName; break;
    }
    return default.class$" ERR::RECEIVED GetString with wrong or undefined Params";
}



defaultproperties
{
     KilledBy="Was killed by"
     Suicided="had a sudden heart attack"
     SuicidedMalus="had a sudden heart attack ! Malus -50"
     KilledByKKK="was killed by The Death ! Malus -10"
     DrawColor=(B=210,G=252,R=255,A=230)
}
