//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIGameReplicationInfo extends GameReplicationInfo;

var string EndGameMessage;    // Here because Level.Game not relevant to clients (?)
var int iGameState;           // to know client side in what state is the gameinfo
// == 1 if map just launched (to display startup screen).
// == 2 if match running
// == 3 if match ended
var int XIIIRemainingTime;    // Set there because remaining time is not replicated the right way (only bNetInitial) :(

// Below array replication don't work, replaced by separate vars, works ?!?
//var int SoundFlagState[2];    // 1=FlagReturn 2=FlagDrop 3=FlagScore 4=FlagPick
var int SoundFlagState0;    // 1=FlagReturn 2=FlagDrop 3=FlagScore 4=FlagPick
var int SoundFlagState1;    // 1=FlagReturn 2=FlagDrop 3=FlagScore 4=FlagPick
var sound hLastMinute, hTimeLimit;
var bool bPlayedLastMinute, bPlayedTimeLimit;

//_____________________________________________________________________________
replication
{
    reliable if ( Role == ROLE_Authority )
      EndGameMessage, iGameState, XIIIRemainingTime, SoundFlagState0, SoundFlagState1;
}

//_____________________________________________________________________________
simulated function Timer()
{
    Super.Timer();

    if ( TimeLimit == 0 )
      return;

//    Log("RT="$XIIIRemainingTime);
    if ( bPlayedLastMinute && (XIIIRemainingTime > 60) )
    {
//      Log("GRI Reset LM & TL");
      bPlayedLastMinute = false;
      bPlayedTimeLimit = false;
      return;
    }
    else if ( bPlayedTimeLimit && (XIIIRemainingTime > 0) )
    {
//      Log("GRI Reset TL");
      bPlayedTimeLimit = false;
    }
    if ( !bPlayedLastMinute && (XIIIRemainingTime <= 60) )
    {
//      Log("GRI LastMinute");
      bPlayedLastMinute = true;
      PlayMenu(hLastMinute);
      if ( Level.NetMode != NM_Client )
        BroadCastLocalizedMessage(class'XIIIMultiMessage',6);
    }
    if ( !bPlayedTimeLimit && (XIIIRemainingTime <= 0) )
    {
//      Log("GRI TimeLimit");
      bPlayedTimeLimit = true;
      PlayMenu(hTimeLimit);
    }
}



defaultproperties
{
     XIIIRemainingTime=120
     SoundFlagState0=3
     SoundFlagState1=3
     hLastMinute=Sound'XIIIsound.Multi__SFXMulti.SFXMulti__hTime1Mn'
     hTimeLimit=Sound'XIIIsound.Multi__SFXMulti.SFXMulti__hTimeLimit'
}
