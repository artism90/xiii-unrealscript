//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIPorte extends XIIIMover
  abstract;

VAR() bool bDansLes2Sens;       // the door can be opened from both side and rotate accordingly
VAR() bool bClimbAble;          // Player can climb on it (yes there are doors he can and other he can't, quite weirdos design but graphists want that :( )
VAR() bool bCloseDoor;          // to force enemies to close door dehind them after opening
VAR() bool AutoCloseMe;
VAR() bool bCheckEncroach;
VAR() int CheckEncroachBack;
VAR ROTATOR RotPositif;
VAR ROTATOR RotNegatif;
VAR VECTOR PosPositif, PosNegatif;
VAR VECTOR DoorDirection;
VAR float fUnlockTimer;
VAR() float fUnlockTime;        // Time to unlock the door if locked (if initial state==locked)
VAR() name UnlockEvent;
VAR() name OpeningEvent;
VAR() string UnLockItemName;  // Item to use for unlocking the door
VAR() string UnlockItemCode;
VAR() sound hUnlocksound;
VAR() sound hLockedSound;
VAR navigationpoint DoorPoint1, DoorPoint2;        //doorpoints utilises pour le recalage des basesoldiers
VAR() float AutoCloseDelay;
VAR Pawn AutoCloseLastEventInstigator;

//____________________________________________________________________
function PostBeginPlay()
{
    local int a1,a2;
    local rotator R1,R2;
    local navigationpoint DP,BestDP1,BestDP2;

    Super.PostBeginPlay();
    if (bDansLes2Sens)
    {
      a1 = ((KeyRot[1].Yaw+32768)&65535)-32768;
      a2 = ((KeyRot[2].Yaw+32768)&65535)-32768;
      if ((a1<0) && (a2>0))
      {
        RotPositif=KeyRot[2];
        RotNegatif=KeyRot[1];
        PosPositif=KeyPos[2];
        PosNegatif=KeyPos[1];
      }
      else if ((a1>0) && (a2<0))
      {
        RotPositif=KeyRot[1];
        RotNegatif=KeyRot[2];
        PosPositif=KeyPos[1];
        PosNegatif=KeyPos[2];
      }
      else
      {
//        PlayerController(Level.ControllerList).MyHud.LocalizedMessage(class'XIIISoloMessage',0, none,none,none,"Probleme sur la Porte '"@Name@"', Passage en mode classique.");
//        Log("Probleme sur la Porte '"@Name@"', Passage en mode classique.");
        bDansLes2Sens=false;
      }
      if ( KeyNum == 2 )
      {
        R1 = KeyRot[2];
        KeyRot[2] = KeyRot[1];
        KeyRot[1] = R1;
        KeyNum = 1;
      }
    }
    if (KeyNum != 0)
    { // ELR Try to make doors able to be initiated at key != 0
      bOpened=true;
      bClosed=false;
    }
    PrevKeyNum = KeyNum;

/*
    if ( KeyNum == 0 )
      vPawnPushdir = normal(vector(rotation) cross vect(0,0,1));
    else
      vPawnPushdir = normal(vector(rotation));
*/

    //cherche doorpoints
     BestDP1=none;
     foreach RadiusActors(class 'NavigationPoint', DP, 350)  // les doorspoints a moins de 4.5 m
     {
        if (DP.IsA('doorpoint'))
        {
             if (BestDP1==none || vsize(BestDP1.location-self.location)>vsize(DP.location-self.location))
             {
                bestdp2=bestDP1;
                BestDP1=DP;
             }
             else if (BestDP2==none || vsize(BestDP2.location-self.location)>vsize(DP.location-self.location))
                 BestDP2=DP;
        }
     }
     if (bestDP1!=none && bestDP2!=none)
     {
         DoorPoint1=bestDP1;
         DoorPoint2=bestDP2;
     }

   //unlock time is 0 if lockpick is not necessary
   if (UnlockItemCode != "LockPick")
     {
       fUnlockTime = 0;
   }
}


// Open the mover.
function DoOpen()
{
  if ( !bOpening )
    TriggerEvent( OpeningEvent, self, none );

  Super.DoOpen();
}

//____________________________________________________________________
event Timer()
{
//    Log(self@"Timer bOpening"@bOpening@"bOpened"@bOpened@"bClosed"@bClosed@"bWarnSoldiers"@bWarnSoldiers@"bAlertIfSeenOpen"@bAlertIfSeenOpen);
    if ( bCheckEncroach && !bOpened && !bClosed )
    {
      CheckEncroachBack ++;
      if ( CheckEncroachBack >= 2 )
      {
        if ( bOpening )
//          DoClose();
          GotoState(GetStateName(), 'Close');
        else
//          DoOpen();
          GotoState(GetStateName(), 'Open');
        bCheckEncroach = false;
        CheckEncroachBack = 0;
        if ( !bWarnSoldiers )
        {
          SetTimer(0.0, false);
          return;
        }
      }
    }
    else
    {
      bCheckEncroach = false;
      CheckEncroachBack = 0;
      if ( !bWarnSoldiers )
      {
        SetTimer(0.0, false);
        return;
      }
    }
    if ( bWarnSoldiers )
      Super.Timer();
}

//____________________________________________________________________
// Handle when the mover finishes opening.
function FinishedOpening()
{
    bCheckEncroach = false;
    Super.FinishedOpening();
}

//____________________________________________________________________
// Handle when the mover finishes opening.
function FinishedClosing()
{
    bCheckEncroach = false;
    Super.FinishedClosing();
}

//____________________________________________________________________
function bool EncroachingOn( actor Other )
{
    if ( !bCheckEncroach )
    {
//      Log(self@"EncroachingOn"@other@"set timer to auto-close");
      bCheckEncroach = true;
      SetTimer(2.0, true);
    }
    if ( Other.IsA('InteractiveCan') )
      Other.TakeDamage(100, AutoCloseLastEventInstigator, Location, 200.0 * (Other.Location - Location + vect(0,0,1)), class'Crushed');
    return true;
}

//____________________________________________________________________
function Bump( actor Other )
{
    if (bDansLes2Sens)
    {
      If (Other.Velocity != vect(0,0,0))
      {
        if ((Other.Velocity cross (BasePos - Other.Location)).z>0)
        {
          KeyRot[1]=RotPositif;
          KeyPos[1]=PosPositif;
        }
        else
        {
          KeyRot[1]=RotNegatif;
          KeyPos[1]=PosNegatif;
        }
      }
      else
      {
        if ((vector(Other.rotation) cross (BasePos - Other.Location)).z>0)
        {
          KeyRot[1]=RotPositif;
          KeyPos[1]=PosPositif;
        }
        else
        {
          KeyRot[1]=RotNegatif;
          KeyPos[1]=PosNegatif;
        }
      }
    }
    super.Bump(other);
}

//____________________________________________________________________
// Close the mover. but don't play closing sound
function DoAutoClose()
{
    bOpening = false;
    bOpened = false;
    bDelaying = false;
    InterpolateTo( Max(0,KeyNum-1), MoveTime );
//    PlaySound( ClosingSound );
    if ( !bMusicOnlyOnce || !bAlreadyClosing )
    {
      bAlreadyClosing = true;
      PlayMusic( ClosingMusic );
    }
    UntriggerEvent(Event, self, Instigator);
    PlaySound(MoveAmbientSound);
}

//____________________________________________________________________
// Used for doors that are openable on one side only
function bool CanBeOperated(Pawn EventInstigator)
{
    return true;
}


//____________________________________________________________________
state() Locked
{
    ignores bump, UnTrigger;

    function Trigger( actor Other, pawn EventInstigator )
    {
//      Log(")))"@self@"Trigger other "$Other$" instigator "$EventInstigator);
      if ( (Other == none) || (Inventory(Other) == none) || (EventInstigator == none) )
        return;
      if ( (Caps(UnLockItemName) == Caps(inventory(Other).ItemName)) || (Caps(UnlockItemCode) == Caps(Keys(Other).KeyCodeName)) )
      {
        if ( (EventInstigator.FindInventorykind('PickLockSkill') == none) || (UnLockItemName!="LockPick") )
          fUnlockTimer = fUnlockTime;
        else
          fUnlockTimer = fUnlockTime/3.0;
        //::DBUG::
//        Log(")))"@self@"Time Before Opening Door="$fUnlockTimer);
        if ( fUnlockTimer > 0 )
          XIIIPlayerController(EventInstigator.controller).MyHud.LocalizedMessage(class'XIIISoloMessage', 1);
        if ( fUnlockTimer > 0.0 )
          GotoState('UnLocking');
        else
        { // instant unlock
          gotostate('PlayerTriggerToggle');
          PlaySound(hUnlockSound);
          if (UnlockEvent!='')
            TriggerEvent(UnlockEvent,self,none);
        }
      }
      else
      {
        //::DBUG::
//        Log(")))"@self@"Trying to be unlocked with "$Caps(Keys(Other).KeyCodeName)$" (should be "$Caps(UnlockItemCode)$")");

        if ( LockPick(Other) != none )
          XIIIPlayerController(EventInstigator.controller).MyHud.LocalizedMessage(class'XIIISoloMessage', 12);
        else
          XIIIPlayerController(EventInstigator.controller).MyHud.LocalizedMessage(class'XIIISoloMessage', 6);
      }
    }

    function PlayerTrigger( actor Other, pawn EventInstigator )
    {
      PlaySound(hLockedSound);
    }
}

//____________________________________________________________________
state UnLocking
{
    ignores Bump, Trigger;

    function UnTrigger( actor Other, pawn EventInstigator )
    {
      fUnlockTimer=0.0;
      XIIIPlayerController(EventInstigator.controller).MyHud.LocalizedMessage(class'XIIISoloMessage', 7);
      GotoState('Locked');
    }

    function Tick( float dT )
    {
      fUnlockTimer -= dT;
      if (fUnlockTimer <= 0.0 )
      {
        gotostate('PlayerTriggerToggle');
        PlaySound(hUnlockSound);
        if (UnlockEvent!='')
          TriggerEvent(UnlockEvent,self,none);
      }
    }

}

//____________________________________________________________________
// ELR Add PlayerTrigger
state() PlayerTriggerToggle
{
    ignores bump;

    FUNCTION BeginState()
    {
      LOCAL BOX BBox;

      Super.BeginState();
      disable('tick');

      BBox = GetBoundingBox();
      DoorDirection = ( 0.5 * ( BBox.Min + BBox.Max ) - Location)<<KeyRot[KeyNum];
      DoorDirection.Z = 0;
    }

    EVENT Trigger( actor Other, pawn EventInstigator )
    {
      PlayerTrigger( Other, EventInstigator );
    }

    function bool CanBeOperated(Pawn EventInstigator)
    {
      local vector vTemp;
      local bool bBlocked;

      if ( (KeyNum != 0) || !bClosed )
        return true;

      if ( bDansLes2Sens )
      {
        vTemp = BasePos - EventInstigator.Location;
        vTemp.Z = 0;
        if ( ( DoorDirection cross vTemp ).Z > 0 )
        {
          KeyRot[1]=RotPositif;
          KeyPos[1]=PosPositif;
          bBlocked= (BloqueePourLeJoueur==SensPositif)||(BloqueePourLeJoueur==Les2Sens);
        }
        else
        {
          KeyRot[1]=RotNegatif;
          KeyPos[1]=PosNegatif;
          bBlocked= (BloqueePourLeJoueur==SensNegatif)||(BloqueePourLeJoueur==Les2Sens) ;
        }
      }
      else
      {
        if ( (vector(EventInstigator.rotation) cross (BasePos - EventInstigator.Location)).z>0 )
        {
          bBlocked= (BloqueePourLeJoueur==SensPositif)||(BloqueePourLeJoueur==Les2Sens) ;
        }
        else
        {
          bBlocked= (BloqueePourLeJoueur==SensNegatif)||(BloqueePourLeJoueur==Les2Sens) ;
        }
      }
      bBlocked = bBlocked && EventInstigator.IsPlayerPawn();
      return !bBlocked;
    }
    FUNCTION PlayerTrigger( actor Other, pawn EventInstigator )
    {
      LOCAL VECTOR vTemp;
      local bool bBlocked;

      if (bOpened || bClosed)
      {
        SavedTrigger = Other;
        Instigator = EventInstigator;
        AutoCloseLastEventInstigator = EventInstigator;
        if ( SavedTrigger != None )
          SavedTrigger.BeginEvent();
        if( KeyNum==0 )
        {
          if ( bDansLes2Sens )
          {
            vTemp = BasePos - EventInstigator.Location;
            vTemp.Z = 0;
            if ( ( DoorDirection cross vTemp ).Z > 0 )
            {
              KeyRot[1]=RotPositif;
              KeyPos[1]=PosPositif;
              bBlocked= (BloqueePourLeJoueur==SensPositif)||(BloqueePourLeJoueur==Les2Sens);
            }
            else
            {
              KeyRot[1]=RotNegatif;
              KeyPos[1]=PosNegatif;
              bBlocked= (BloqueePourLeJoueur==SensNegatif)||(BloqueePourLeJoueur==Les2Sens) ;
            }
          }
          else
          {
            if ( (vector(EventInstigator.rotation) cross (BasePos - EventInstigator.Location)).z>0 )
            {
              bBlocked= (BloqueePourLeJoueur==SensPositif)||(BloqueePourLeJoueur==Les2Sens) ;
            }
            else
            {
              bBlocked= (BloqueePourLeJoueur==SensNegatif)||(BloqueePourLeJoueur==Les2Sens) ;
            }
          }
          bBlocked = bBlocked && EventInstigator.IsPlayerPawn();
          if (!bBlocked)
          {
            if ( bAlertIfSeenOpen && EventInstigator.IsPlayerPawn())
            {
              SetTimer(2.0,true);
              bWarnSoldiers = true;
            }
            GotoState( 'PlayerTriggerToggle', 'Open' );
          }
        }
        else
        {
          if ( bAlertIfSeenOpen && EventInstigator.IsPlayerPawn())
          {
            SetTimer(2.0,true);
            bWarnSoldiers = true;
          }
          GotoState( 'PlayerTriggerToggle', 'Close' );
        }
      }
    }

    event Timer2()
    {
      local vector tV;


      tV = AutoCloseLastEventInstigator.Location - Location;
//      tV.Z = 0.0;
//      if ( bOpened && (vSize(tV) > 200.0) && (vector(AutoCloseLastEventInstigator.rotation) dot  tV > 0.0) )
      // optimize 2 lines above
      if ( bOpened && ((tV.X*tv.X+tV.Y*tV.y) > 40000.0) && (Level.TimeSeconds - LastRenderTime > 1.0) )
        GotoState( 'PlayerTriggerToggle', 'AutoClose' );
      else if ( bClosed )
        SetTimer2(1.0, false);
//        PlayerTrigger(none, AutoCloseLastEventInstigator);
    }
Open:
  bClosed = false;
  DoOpen();
  FinishInterpolation();
  FinishedOpening();
  if ( SavedTrigger != None )
    SavedTrigger.EndEvent();
  if( bTriggerOnceOnly )
  {
    bInteractive = false;
    GotoState('');
    stop;
  }
  if ( AutoCloseMe )
    SetTimer2(AutoCloseDelay, false);
  Stop;
Close:
  SetTimer2(0.0, false);
  DoClose();
  FinishInterpolation();
  FinishedClosing();
  if( bTriggerOnceOnly )
  {
    bInteractive = false;
    GotoState('');
  }
  stop;
AutoClose:
  SetTimer2(0.0, false);
  DoAutoClose();
  FinishInterpolation();
  FinishedClosing();
  if( bTriggerOnceOnly )
  {
    bInteractive = false;
    GotoState('');
  }
  stop;
}

state() AnyTriggerToggle
{
     function Trigger( actor Other, pawn EventInstigator )
     {
          SavedTrigger = Other;
          Instigator = EventInstigator;
          if ( SavedTrigger != None )
               SavedTrigger.BeginEvent();
          if( KeyNum==0 || KeyNum<PrevKeyNum )
               GotoState( 'AnyTriggerToggle', 'Open' );
          else
               GotoState( 'AnyTriggerToggle', 'Close' );
     }
     function UnTrigger( actor Other, pawn EventInstigator )
     {
    Trigger( Other, EventInstigator );
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
     Stop;
Close:
     DoClose();
     FinishInterpolation();
     FinishedClosing();
}




defaultproperties
{
     bDansLes2Sens=True
     AutoCloseMe=True
     UnLockItemName="LockPick"
     UnlockItemCode="LockPick"
     hUnlocksound=Sound'XIIIsound.Items.LockSucc1'
     AutoCloseDelay=15.000000
     InitialState="PlayerTriggerToggle"
}
