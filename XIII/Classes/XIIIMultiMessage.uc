//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIMultiMessage extends GameMessage;

var localized string WelcomeMessage;
var localized string GlobalNameChange;
var localized string LeftMessage;
var localized string sOverTimeMessage;
var localized string sOneFragLeft, sOneMinuteLeft;

//_____________________________________________________________________________
static function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    switch (Switch)
    {
      case 0:
        return Default.sOverTimeMessage;
        break;
      case 1: // Welcome Message
        if (RelatedPRI_1 == None)
          return "";
        return RelatedPRI_1.playername@default.WelcomeMessage;
        break;
      case 2: // Changing Name Message
        if (RelatedPRI_1 == None)
          return "";
        return RelatedPRI_1.OldName@Default.GlobalNameChange@RelatedPRI_1.PlayerName;
        break;
      case 4: // Leaving game Message
        if (RelatedPRI_1 == None)
          return "";
        return RelatedPRI_1.playername@Default.LeftMessage;
        break;
      case 5: // 1 frag left
        if (RelatedPRI_1 == None)
          return "";
        return RelatedPRI_1.playername@Default.sOneFragLeft;
        break;
      case 6: // 1 minute left
        return Default.sOneMinuteLeft;
        break;
    }
    return default.class$" ERR::RECEIVED GetString with wrong or undefined Params "$switch;
}



defaultproperties
{
     WelcomeMessage="Entered the game"
     GlobalNameChange="changed name to"
     LeftMessage="left the game."
     sOverTimeMessage="Tie, Sudden Death !"
     sOneFragLeft=": One frag left"
     sOneMinuteLeft="One minute left"
     Lifetime=6
     DrawColor=(B=210,G=252,A=230)
}
