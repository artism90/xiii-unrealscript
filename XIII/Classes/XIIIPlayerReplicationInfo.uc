//=============================================================================
// PlayerReplicationInfo.
//=============================================================================
class XIIIPlayerReplicationInfo extends PlayerReplicationInfo;

var bool bHasTheBomb;
var int MyDeathScore;
var sound hLastFragLimit;
var GameReplicationInfo MemGRI;

//_____________________________________________________________________________
replication
{
  reliable if ( bNetDirty && (Role == Role_Authority) )
    bHasTheBomb,MyDeathScore;
}

//_____________________________________________________________________________
simulated event SkinUpdated()
{
    local Pawn P;

    if ( PlayerController(Owner) != none )
      Log("SKIN "$self$" Updated New code '"$SkinCodeName$"' Own"@Owner@"OwnPawn"@PlayerController(Owner).Pawn);
    else
      Log("SKIN "$self$" Updated New code '"$SkinCodeName$"' Own"@Owner);

    if ( (Owner == none) || (PlayerController(Owner).Pawn == none) )
    {
      foreach DynamicActors(class'pawn', P)
      {
        if ( P.PlayerReplicationInfo == self )
          break;
      }
    }
    else
    {
      P = PlayerController(Owner).Pawn;
      P.PlayerReplicationInfo = self; // weird but we may have pawn and PRI but Pawn.Pri = none
    }

    if ( P != none )
      P.ChangeSkin();
    else
      Settimer2(2.0, false);
//      Warn("!@! No pawn who owns me so no changeskin possible");
}

//_____________________________________________________________________________
Simulated Event Timer2()
{
    local Pawn P;

    if ( PlayerController(Owner) != none )
      Log("SKIN "$self$" Timer New code '"$SkinCodeName$"' Own"@Owner@"OwnPawn"@PlayerController(Owner).Pawn);
    else
      Log("SKIN "$self$" Timer New code '"$SkinCodeName$"' Own"@Owner);

    if ( (Owner == none) || (PlayerController(Owner).Pawn == none) )
    {
      foreach DynamicActors(class'pawn', P)
      {
        if ( P.PlayerReplicationInfo == self )
          break;
      }
    }
    else
    {
      P = PlayerController(Owner).Pawn;
      P.PlayerReplicationInfo = self; // weird but we may have pawn and PRI but Pawn.Pri = none
    }

    if ( P != none )
      P.ChangeSkin();
    else
      Warn("!@! No pawn who owns me so no changeskin possible");
}

//_____________________________________________________________________________
function PostBeginPlay()
{
//    Super.PostBeginPlay();
    StartTime = Level.TimeSeconds;
    if ( !Level.bLonePlayer )
    {
      Timer();
      SetTimer(2.0, true);
    }
    PreviousName = PlayerName;
    // ELR Too early to send this...
//    BroadCastLocalizedMessage( class'XIII.XIIIMultiMessage', 1, self );
}

//_____________________________________________________________________________
// ELR if set as true reset bReadyToPlay
function SetWaitingPlayer(bool B)
{
//    Log("MP-] SetWaitingPlayer call w/ B="$B);

    bIsSpectator = B;
    bWaitingPlayer = B;
//    if ( B )
//      bReadyToPlay = false;
}

//_____________________________________________________________________________
function Timer()
{
    UpdatePlayerLocation();

    if ( FRand() < 0.65 )
      return;

    if (PlayerController(Owner) != None)
      Ping = int(Controller(Owner).ConsoleCommand("GETPING"));

/*
    // ELR Send name update messages
    if ( !Level.bLonePlayer && (PlayerName != PreviousName) )
    {
      if ( PreviousName == "" )
      {
        PreviousName = PlayerName;
        BroadCastLocalizedMessage( class'XIII.XIIIMultiMessage', 1, self );
        return;
      }
      PreviousName = PlayerName;
      BroadCastLocalizedMessage( class'XIII.XIIIMultiMessage', 2, self );
    }
*/
}

//_____________________________________________________________________________
simulated event ScoreUpdated() // ELR Used to update score sorting only when receiving score replication
{
    local ScoreBoard S;

    if ( Level.NetMode == NM_StandAlone )
      return;

    if ( Level.NetMode == NM_Client )
    {
      if ( MemGRI == none )
      {
        foreach allactors(class'GameReplicationInfo', MemGRI)
          break;
      }
      if ( (MemGRI.GoalScore > 0) && (Score == MemGRI.GoalScore - 1) )
      {
//        Log("NEAR FRAGLIMIT");
        PlayMenu(hLastFragLimit);
      }
    }

		foreach allactors(class'ScoreBoard', S)
      S.UpdateScores();
}



defaultproperties
{
     hLastFragLimit=Sound'XIIIsound.Multi__SFXMulti.SFXMulti__hTimeLimit'
}
