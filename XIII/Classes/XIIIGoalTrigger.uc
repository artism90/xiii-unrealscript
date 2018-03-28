//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIGoalTrigger extends XIIITriggers;

var() int GoalNumber;
var() float TimeBeforeTrigger;

//____________________________________________________________________
// If triggered then my goal is ok
function Trigger( actor Other, pawn EventInstigator )
{
    Log(self$" trigger w/ other="$Other$" EventInstigator="$EventInstigator$" GoalNumber="$GoalNumber);
    Instigator = EventInstigator;
    // EventInstigator should be player
    if ( XIIIGameInfo(Level.Game).MapInfo != none )
    {
      if ( (EventInstigator != none) && EventInstigator.bIsDead )
      {
        //Log("Can't trigger a goal when touched by a dead");
        return;
      }
//      Log(self$" other.IsDead="$XIIIPawn(Other).bIsDead$" Other.HitDamageType="$Pawn(Other).HitDamageType);
      if ( (XIIIPawn(Other) == none) || ( !XIIIPawn(Other).bIsDead || ((XIIIPawn(Other).HitDamageType != class'DTStunned') && (XIIIPawn(Other).HitDamageType != class'DTSureStunned'))) )
      {
        if ( TimeBeforeTrigger > 0.0 )
        {
          SetTimer(TimeBeforeTrigger, false);
          return;
        }
        else
          CauseGoal();
      }
    }
    else
    {
      //Log("PB on "$self$", can't trigger my goal, setting a wait of 0.2 to check again if the mapinfo was not initialized");
      SetTimer2(0.2, false);
    }
}

//____________________________________________________________________
event Timer2()
{
    if ( XIIIGameInfo(Level.Game).MapInfo != none )
      CauseGoal();
//    else
      //Log("PB on "$self$" GOAL "$GoalNumber$" CAN'T BE TRIGGERED BECAUSE NO MAPINFO");
}

//____________________________________________________________________
event Timer()
{
    CauseGoal();
}

//____________________________________________________________________
function CauseGoal()
{
    if ( Level.Game.bGameEnded )
    {
      log("Goal number "$GoalNumber$" not validated, Game Ended.");
      return;
    }

    TriggerEvent(event, self, Instigator);
    if (GoalNumber>=90)
    { // Cheat to activate event that's not in the objectives [used for chronometre && nust-not-kill people]
      log("Goal number "$GoalNumber$" validated.");
      XIIIGameInfo(Level.Game).MapInfo.SetGoalComplete(GoalNumber);
    }
    else if ( XIIIGameInfo(Level.Game).MapInfo.Objectif[GoalNumber].bPrimary )
    {
      log("Goal number "$GoalNumber$" validated.");
      XIIIGameInfo(Level.Game).MapInfo.SetGoalComplete(GoalNumber);
      destroy();
    }
    else
    {
      log("Goal number "$GoalNumber$" could not be validated, it's not primary.");
    }
}



defaultproperties
{
     bInteractive=True
}
