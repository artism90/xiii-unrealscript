//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CWndFocusTrigger extends XIIITriggers;

var() bool bRequireSixSenseSkill; // SixSenseSkill is requireed to trigger the Focus
var() bool bUseVignette;          // Use the vignette when zoomed.
var() bool bDanger;
var() bool zoomFocus;

var() float TriggerDistance;      // max Distance to trigger focus
var() float FocusDuration;        // duration of focus drawing.
var() actor Focus;                // the actor to focus.
var() enum eCWndFocusAppear
{
  ECWFA_Zoom,
  ECWFA_Lines,
} CWndFocusAppearFX;              // appearance FX (only Zoom handled now)
var() int iTriggerCount;          // Number of times the trigger can occur
var() enum eCWndFocusSoundType
{
    CFSTYPE_None,
    CFSTYPE_Focus,
    CFSTYPE_FocusWarn,
} CWndFocusSoundType;
var() name EventFinFocus;
var sound hCWndFocus[2];
var() float zoomDistance;
var() float zoomFOV;

//____________________________________________________________________
event PostBeginPlay()
{
    DebugLog(self@"PostBeginPlay Focus="$Focus);
    if ( (Focus == none) || Focus.bDeleteMe )
    {
      Focus = none; // if it was bDeleteMe
      Destroy();
      return;
    }
    Super.PostBeginPlay();
}

//____________________________________________________________________
auto state() WaitForBeingSeen
{
    event BeginState()
    {
      SetTimer(1.0, false);
      if ( (focus.isa('gennmi') || focus.isa('GenPlongeurs')) && (focus.instigator != none) )
        focus=focus.instigator;
    }

    event Timer()
    { // Only called in solo mode
      local float fTime, fDist;
      local XIIIPlayerPawn XPP;
      local actor A;
      local vector HitLoc, HitNorm;
      local material HitMat;

//      DebugLog(self@"WaitForBeingSeen Timer Focus="$Focus@" bDeleted ?"$Focus.bDeleteMe);
      if ( (Focus == none) || Focus.bDeleteMe )
      { // check just in case Focus destroyed in-game
        Focus = none; // if it was bDeleteMe
        Destroy();
        return;
      }
      if ( (Level.Game == none) || (XIIIGameInfo(Level.Game).MapInfo == none) || (XIIIGameInfo(Level.Game).MapInfo.XIIIPawn == none) )
      {
        SetTimer(2.0, false);
        return;
      }
      XPP = XIIIPlayerPawn(XIIIGameInfo(Level.Game).MapInfo.XIIIPawn);
      if ( (XPP == none) || (XPP.Controller == none) )
      {
        SetTimer(2.0, false);
        return;
      }
      if ( bRequireSixSenseSkill && ((XPP.SSSk == none) || !XPP.SSSk.bImOn) )
      {
        SetTimer(2.0, false);
        return;
      }

      fDist = vSize(XPP.Location - Focus.Location);
      if ( (fDist < TriggerDistance) && ((Focus.Location - XPP.Location) dot vector(XPP.Controller.Rotation) > 0.757) )
      { // if player see me create focus
        A = Trace(HitLoc, HitNorm, Focus.Location, XPP.Location, true, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanSeeThrough);
        if ( (A == none) || (A == Focus) )
        {
//          Log("FOCUS PlayingSound type"@CWndFocusSoundType);
          if ( CWndFocusSoundType > 0 )
            XPP.PlaySound(hCWndFocus[CWndFocusSoundType-1]);
          else
            XPP.PlaySound(hCWndFocus[0]);

          // Long-lasting focuses disabled by events
          if ( EventFinFocus != '')
          {
            tag = EventFinFocus;
            FocusDuration = -1;
            XIIIBaseHud(PlayerController(XPP.controller).MyHud).tFocusTrigger[XIIIBaseHud(PlayerController(XPP.controller).MyHud).eNbHudCartoonFocus] = self;
            XIIIBaseHud(PlayerController(XPP.controller).MyHud).AddHudCartoonFocus(Focus, CWndFocusAppearFX, bUseVignette, FocusDuration, zoomFocus, zoomFOV, zoomDistance, bDanger);
            GotoState('WaitEndFocus');
            return;
          }
          else
          {
            XIIIBaseHud(PlayerController(XPP.controller).MyHud).AddHudCartoonFocus(Focus, CWndFocusAppearFX, bUseVignette, FocusDuration, zoomFocus, zoomFOV, zoomDistance, bDanger);

            iTriggerCount --;
            TriggerEvent( Event, Self, XPP );
            if ( iTriggerCount <= 0 )
              Destroy();
            else
              SetTimer(FocusDuration + 1.0, false);
            return;
          }
        }
      }
      fTime = (fDist-TriggerDistance) / XPP.GroundSpeed;
      fTime *= 0.666; // security factor
      fTime = fMax(0.5, fTime); // wait a min time
      SetTimer(fTime, false);
    }
}

//____________________________________________________________________
state() WaitForBeingTriggered
{
    event Trigger( actor Other, pawn EventInstigator )
    {
      GotoState('WaitForBeingSeen');
    }
}

//_____________________________________________________________________
state WaitEndFocus
{
    event Trigger(actor Other, pawn EventInstigator )
    {
      local XIIIPlayerPawn XPP;
      local int i,j;

      // on determine le cartoon focus a eliminer a partir des tableaux dans XIIIBaseHud
      XPP = XIIIPlayerPawn(XIIIGameInfo(Level.Game).MapInfo.XIIIPawn);
      while (XIIIBaseHud(PlayerController(XPP.controller).MyHud).tFocusTrigger[i] != self)
      {
        i ++;
      }
      //log(self@" ---> DESTRUCTION DE"@XIIIBaseHud(PlayerController(XPP.controller).MyHud).tFocusTrigger[i]@XIIIBaseHud(PlayerController(XPP.controller).MyHud).tCartoonFocus[i]);
      XIIIBaseHud(PlayerController(XPP.controller).MyHud).tCartoonFocus[i].RemoveMe();

      for (j=i;j<XIIIBaseHud(PlayerController(XPP.controller).MyHud).eNbHudCartoonFocus;j++)
      {
        XIIIBaseHud(PlayerController(XPP.controller).MyHud).tFocusTrigger[j] = XIIIBaseHud(PlayerController(XPP.controller).MyHud).tFocusTrigger[j + 1];
        XIIIBaseHud(PlayerController(XPP.controller).MyHud).tCartoonFocus[j] = XIIIBaseHud(PlayerController(XPP.controller).MyHud).tCartoonFocus[j + 1];
      }
      XIIIBaseHud(PlayerController(XPP.controller).MyHud).tFocusTrigger[XIIIBaseHud(PlayerController(XPP.controller).MyHud).eNbHudCartoonFocus] = none;
      XIIIBaseHud(PlayerController(XPP.controller).MyHud).tCartoonFocus[XIIIBaseHud(PlayerController(XPP.controller).MyHud).eNbHudCartoonFocus] = none;
      XIIIBaseHud(PlayerController(XPP.controller).MyHud).eNbHudCartoonFocus --;

      //log(self@" --->"@XIIIBaseHud(PlayerController(XPP.controller).MyHud).tCartoonFocus[0]@XIIIBaseHud(PlayerController(XPP.controller).MyHud).tCartoonFocus[1]@XIIIBaseHud(PlayerController(XPP.controller).MyHud).tCartoonFocus[2]);
      //log(self@" --->"@XIIIBaseHud(PlayerController(XPP.controller).MyHud).tFocusTrigger[0]@XIIIBaseHud(PlayerController(XPP.controller).MyHud).tFocusTrigger[1]@XIIIBaseHud(PlayerController(XPP.controller).MyHud).tFocusTrigger[2]);

      Destroy();
    }
}


defaultproperties
{
     TriggerDistance=800.000000
     FocusDuration=3.000000
     iTriggerCount=1
     hCWndFocus(0)=Sound'XIIIsound.Interface__VignettesFx.VignettesFx__hFocus'
     hCWndFocus(1)=Sound'XIIIsound.Interface__VignettesFx.VignettesFx__hFocusWarning'
     zoomDistance=200.000000
     zoomFOV=50.000000
     bCollideActors=False
}
