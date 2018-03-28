//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIISoloGameRules extends GameRules;

//_____________________________________________________________________________
// ELR If Killed=Player then GameOver
function ScoreKill(Controller Killer, Controller Other)
{
//    Log(self@"ScoreKill received");

    if ( XIIIPlayerController(Other) != none )
    { // Mean the player is dead, in solo mode this mean EndGame.
      Level.Game.EndGame(Other.PlayerReplicationInfo,"PlayerKilled");
    }
}

//_____________________________________________________________________________
// ELR Allow pickup only if the player click on the object.
function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup)
{
    if ( ( XIIIPlayerController(Other.Controller)!=none )
      && ( XIIIPlayerController(Other.Controller).bAutoPickup
      || (
        ( XIIIPlayerController(Other.Controller).MyInteraction.TargetActor == item )
        && ( XIIIPlayerController(Other.Controller).bPickingUp ))
       ) )
      {
        bAllowPickup = 1;
        return true;
      }
    if ( Other.IsA('BaseSoldier') )
      return false;
    return true;
}

//_____________________________________________________________________________
// ELR Return True to cancel the GameRestart and force the player to go into the menu to Reload
function bool HandleRestartGame()
{
    return true;
}



defaultproperties
{
}
