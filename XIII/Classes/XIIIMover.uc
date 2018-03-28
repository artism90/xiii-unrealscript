//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIMover extends Mover;

var() bool bTraversable;
var() bool bTraversableBySmallWeapons;
var bool bWarnSoldiers;                               // do we warn soldier if we are opened
var(Display) bool bNoInteractionIcon;
var bool bOpened;
var() bool bAlertIfSeenOpen;                          // Set true to warn enemies if seen opened

enum eBloquagePorte
{
    Aucun,
    SensPositif,
    SensNegatif,
    Les2Sens
};
var(Porte) eBloquagePorte BloqueePourLeJoueur;
var() PathNode AlertPathNodeKey1, AlertPathNodeKey2;  // the possible points to target when seen

var PathNode PointArrivee;                            // Location to target when detected opened by a enemy pawn (he will get this by himself)
VAR(Message) localized string LockedMessage;
VAR(BreakableMover) int Health; // Damage to take before exploding

//____________________________________________________________________
function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (DrawType==DT_Mesh)
      LoopAnim(AnimSequence);
    // In solo mode, timer is used for doors that can alert enemies if being seen opened
//    if ( ( bAlertIfSeenOpen ) && (Level.NetMode == NM_Standalone) )
    if ( (AlertPathNodeKey1 == none) || (AlertPathNodeKey2 == none) )
    {
      bAlertIfSeenOpen = false;
      bWarnSoldiers = false;
    }

    if ( ( bAlertIfSeenOpen ) && (Level.bLonePlayer) )
    {
      bWarnSoldiers = true;
      SetTimer(2.0,true);
    }
}

//____________________________________________________________________
function bool IsBreakableByPlayer()
{
    return false;
}

//____________________________________________________________________
simulated function Timer()
{
    local XIIIPawn P;
    local float DotP;

    if ( !bOpened || !bWarnSoldiers )
      return;

    foreach CollidingActors( class'XIIIPawn', P,2000)
    {
      if ( !P.bIsDead && P.IsA('BaseSoldier')
//        && !P.bWarnedByDoor
        && (P.controller.IsInState('Patrouille') || P.controller.IsInState('Errance') || P.controller.IsInState('Tenir')) )
      {
        PointArrivee = none;
        DotP = (P.Location - Location) dot (AlertPathNodeKey1.Location - AlertPathNodeKey2.Location);
        if ( (DotP>0)
        && vsize(p.location-self.Location)<p.sightradius
        && FastTrace(AlertPathNodeKey1.Location, P.Location)
        && (vector(P.Rotation) dot normal(AlertPathNodeKey1.location - P.Location) > P.PeripheralVision) )
          PointArrivee = AlertPathNodeKey2;
        else if (vsize(p.location-self.Location)<p.sightradius
        && FastTrace(AlertPathNodeKey2.Location, P.Location)
        && (vector(P.Rotation) dot normal(AlertPathNodeKey2.location - P.Location) > P.PeripheralVision) )
          PointArrivee = AlertPathNodeKey1;
        if ( PointArrivee != none )
        {
          P.Trigger(self, none);
//          P.bWarnedByDoor = true;
          bWarnSoldiers = false;
        }
      }
    }
}

//____________________________________________________________________
function PlayerTrigger( actor Other, pawn EventInstigator );

//____________________________________________________________________
// Handle when the mover finishes opening.
function FinishedOpening()
{
    // Update sound effects.
    PlaySound( OpenedSound );
    if ( !bMusicOnlyOnce || !bAlreadyOpened )
    {
      bAlreadyOpened = true;
      PlayMusic( OpenedMusic );
    }
    // Trigger any chained movers.
    TriggerEvent(Event, Self, Instigator);

    bOpened=true;
    If ( MyMarker != None )
      MyMarker.MoverOpened();
    FinishNotify();
}

//____________________________________________________________________
// Open the mover.
/*function DoOpen()
{
    bOpening = true;
    bDelaying = false;
    InterpolateTo( 1, MoveTime );
    PlaySound( OpeningSound );
    if ( !bMusicOnlyOnce || !bAlreadyOpening )
    {
      bAlreadyOpening = true;
      PlayMusic( OpeningMusic );
    }
    TriggerEvent(Event, self, Instigator);
    PlaySound(MoveAmbientSound);
}*/

//____________________________________________________________________
// Close the mover.
function DoClose()
{
    bOpening = false;
    bOpened = false;
    bDelaying = false;
    InterpolateTo( Max(0,KeyNum-1), MoveTime );
    PlaySound( ClosingSound );
    if ( !bMusicOnlyOnce || !bAlreadyClosing )
    {
      bAlreadyClosing = true;
      PlayMusic( ClosingMusic );
    }
    UntriggerEvent(Event, self, Instigator);
    PlaySound(MoveAmbientSound);
}

//____________________________________________________________________
// Add PlayerTrigger
state() PlayerTriggerToggle extends TriggerToggle
{
    ignores bump;

    function PlayerTrigger( actor Other, pawn EventInstigator )
    {
      if (bOpened || bClosed)
      {
        SavedTrigger = Other;
        Instigator = EventInstigator;
        if ( SavedTrigger != None )
          SavedTrigger.BeginEvent();
        if( KeyNum==0 || KeyNum<PrevKeyNum )
        {
          if ( bAlertIfSeenOpen && EventInstigator.IsPlayerPawn())
            bWarnSoldiers = true;
          GotoState( 'PlayerTriggerToggle', 'Open' );
        }
        else
        {
          if ( bAlertIfSeenOpen && EventInstigator.IsPlayerPawn() )
            bWarnSoldiers = true;
          GotoState( 'PlayerTriggerToggle', 'Close' );
        }
      }
    }
Open:
  bClosed = false;
  if ( DelayTime > 0 )
  {
    bDelaying = true;
    Sleep(DelayTime);
  }
  DoOpen();
  FinishInterpolation();
  FinishedOpening();
  if ( SavedTrigger != None )
    SavedTrigger.EndEvent();
  if( bTriggerOnceOnly )
  {
    bInteractive = false;
    GotoState('');
  }
  Stop;
Close:
  DoClose();
  FinishInterpolation();
  FinishedClosing();
  if( bTriggerOnceOnly )
  {
    bInteractive = false;
    GotoState('');
  }
}

//____________________________________________________________________
state() CyclingMover
{
    event KeyFrameReached()
    {
      local int NextKey;

      if (KeyNum==NumKeys-1)
        NextKey=0;
      else
        NextKey=KeyNum+1;
      KeyRot[NextKey]-=KeyRot[KeyNum];
      KeyRot[NextKey].Yaw=((KeyRot[NextKey].Yaw+32768)&65535)-32768;
      KeyRot[NextKey].Roll=((KeyRot[NextKey].Roll+32768)&65535)-32768;
      KeyRot[NextKey].Pitch=((KeyRot[NextKey].Pitch+32768)&65535)-32768;
      KeyRot[NextKey]+=KeyRot[KeyNum];
      InterpolateTo(NextKey,MoveTime);
    }
Begin:
     DoOpen();
     FinishInterpolation();
Open:
Close:
     Stop;
}

state() TriggerToggleCyclingMover extends CyclingMover
{
    EVENT Trigger( actor Other, pawn EventInstigator )
    {
		if (!bOpening)
		{
			/*Debug*/Log("Declenchement CyclingMover"@name);
			GotoState( ,'Go' );
		}
		else
		{
//			/*Debug*/Log("Arret CyclingMover"@name);
			if ( bInterpolating )
			{
				bInterpolating = false;
				StopSound(MoveAmbientSound);
			}
		}
	}
	FUNCTION bool EncroachingOn( actor Other )
	{
		MakeGroupStop();
		if ( TimerRate==0 )
			SetTimer(2.0, false);
		return true;
	}
	EVENT Timer( )
	{
//		if ( bOpening )
//		{
		bInterpolating=true;
//			SetTimer( 0.0, false );
//			GotoState( ,'Go' );
//		}
//		else
//		{
//			if ( bInterpolating )
//			{
//				bInterpolating = false;
//				StopSound(MoveAmbientSound);
//			}
//		}
	}
Begin:
	Stop;
Go:
	DoOpen();
	FinishInterpolation();
Open:
Close:
     Stop;
}

state() TriggerControlCyclingMover extends CyclingMover
{
    EVENT Trigger( actor Other, pawn EventInstigator )
    {
		if (!bOpening)
		{
//			/*DebugLog("Declenchement CyclingMover"@name);*/
			GotoState( ,'Go' );
		}
		else
		{
//			/*Debug*/Log("Arret CyclingMover"@name);
//			if ( bInterpolating )
//			{
			bInterpolating = true;
			PlaySound( OpeningSound );
//			StopSound(MoveAmbientSound);
//			}
		}
	}

    EVENT Untrigger( actor Other, pawn EventInstigator )
    {
		/*Debug*/Log("Arret CyclingMover"@name);
		if ( bInterpolating )
		{
			bInterpolating = false;
			StopSound(MoveAmbientSound);
		}
	}
Begin:
	Stop;
Go:
	DoOpen();
     FinishInterpolation();
Open:
Close:
     Stop;
}




defaultproperties
{
     LockedMessage="This door is locked."
     bPathColliding=False
}
