//-----------------------------------------------------------
//
//-----------------------------------------------------------
class LethalVolume extends Volume;

VAR() enum eLVGameOver
{
  GO_Falling,
  GO_Killed,
  GO_GoalIncomplete,
} GameOverType;
VAR() LethalVolPointOfView PointOfViewWhenFalling;

VAR string LethalVolumeGameOverTypes[3];

//_____________________________________________________________________________
auto STATE() WaitForTouch
{
    function Touch (actor Other)
    {
//		Log(self@"touched by"@other);
    if ( (XIIIPlayerPawn(Other) != none) && !XIIIPlayerPawn(Other).bIsDead )
    {
      Level.Game.EndGame( XIIIPlayercontroller(XIIIPlayerPawn(Other).controller).PlayerReplicationInfo, LethalVolumeGameOverTypes[GameOverType] );
      XIIIPlayerPawn(Other).PlayDying(class'DTSuicided', vect(0,0,0));
    }
    }
}

STATE() TriggerTurnOn
{
    EVENT Trigger( actor Other, pawn EventInstigator )
    {
      GotoState('WaitForTouch');
    }
}



defaultproperties
{
     GameOverType=GO_Killed
     LethalVolumeGameOverTypes(0)="PlayerFalling"
     LethalVolumeGameOverTypes(1)="PlayerKilled"
     LethalVolumeGameOverTypes(2)="GoalIncomplete"
     InitialState="WaitForTouch"
}
