//-----------------------------------------------------------
// Trigger to display CWnd on screen
//-----------------------------------------------------------
class CWndSFXTrigger extends XIIITriggers
  native;

var int iPhase;
var() actor CamPosition[4];
//var() bool bHighquality; // no more use, just aligned the texture on screen (by casting coords to int)
var() actor CamTarget[4];
var() vector CamTargetOffset[4];
var() float CWndFOV[4];
var() float CWndDuration[4];
var() float DelayBeforeNextCWnd[3];
var() int CWndPosX[4];
var() int CWndPosY[4];
var() int CWndSize[4];
var() int CWndSizeY[4];
var() color CWndBorderColor[4];
var() color FilterColor[4];
var() float HighLight[4];
var() Material FilterTexture[4];
var() enum eCWndAppearFX
{
	CAFX_None,
	CAFX_ComeFromLeft,
	CAFX_ComeFromAbove,
	CAFX_StretchHorizontal,
	CAFX_StretchVertical,
	CAFX_Zoom,
	CAFX_ComeFromRight,
	CAFX_ComeFromUnder,
	CAFX_ComeFromTopLeft,
	CAFX_ComeFromTopRight,
	CAFX_ComeFromDownLeft,
	CAFX_ComeFromDownright,
} CWndAppearFX[4];
var() enum eCWndSoundType
{
	CSTYPE_None,
	CSTYPE_TipsOrWalkthrough,
	CSTYPE_WarningOrDanger,
	CSTYPE_DialogOrWait,
} CWndSoundType[4];

// to handle old CWndAlert coll type
var() bool bTriggerOnTouch;
var() bool bSeeXIII;
var() bool bTriggerOnceOnly;
var() bool bAnimatedInRealtime;
var() bool bVisibleOnlyIfTargetIsBehind;

var() Texture OnoTexture[4];
var() int OnoPosX[4];
var() int OnoPosY[4];
var() int OnoSize[4];
var() int OnoSizeY[4];
var() localized array<string> OverLayMessage0;
var() localized array<string> OverLayMessage1;
var() localized array<string> OverLayMessage2;
var() localized array<string> OverLayMessage3;

var() float animationDuration[4];


//____________________________________________________________________
function Touch(actor other)
{
    if ( !bTriggerOnTouch )
      return;
    if ( (Pawn(Other) != none) && Pawn(Other).IsPlayerPawn() )
    {
      bTriggerOnTouch = false;
      Trigger(Other, Pawn(Other));
    }
}

//____________________________________________________________________
function Trigger( actor Other, pawn EventInstigator )
{
//    Log(self@"trigger !!");

    local XIIIPlayerController XPC;

    XPC = XIIIGameInfo(Level.Game).MapInfo.XIIIController;

    // cas d une scene qui se passe sous les yeux du joueur
    if (( bVisibleOnlyIfTargetIsBehind ) && ( XPC.CanSee(Pawn(CamTarget[0])) ))
    {
    	Destroy();
    	return;
    }

    if ( (Level.Game != none) && (Level.Game.DetailLevel < 2) )
      bAnimatedInRealTime = false;
    iPhase = -1;
    SetTimer(0.001, false);
    Instigator = XPC.Pawn;
    Disable( 'Trigger' );
    TriggerEvent( Event, Self, EventInstigator );
}

//____________________________________________________________________
event Timer()
{
    Local CWndOnTrigger CWnd;
    local XIIIBaseHUD XBU;

    iPhase ++;
    if ( (CamPosition[iPhase] == none) || (CamTarget[iPhase] == none) )
    {
      if ( bTriggerOnceOnly )
        Destroy();
      else
        Enable( 'Trigger' );
      return;
    }

    foreach allactors(class'XIIIBaseHUD', XBU)
    {
      if ( XBU != none )
        break;
    }

    CWnd = Spawn(class'CWndOnTrigger', Instigator);
    if ( CWnd != none )
    {
//      CWnd.CWndNB = iPhase;
      CWnd.bSeeXIII = bSeeXIII;
      CWnd.bAnimatedInRealtime = bAnimatedInRealtime;
      if (CWndDuration[iPhase] < animationDuration[iPhase])
        CWnd.AnimationDuration = CWndDuration[iPhase]-0.01f;
      else
        CWnd.AnimationDuration = animationDuration[iPhase];
      CWnd.Cam = CamPosition[iPhase];
      if ( (CamTarget[iPhase].isa('gennmi') || CamTarget[iPhase].isa('GenPlongeurs')) && (CamTarget[iPhase].instigator != none) )
        CWnd.Tar = CamTarget[iPhase].Instigator;
      else
        CWnd.Tar = CamTarget[iPhase];
      CWnd.vTarOffset = CamTargetOffset[iPhase];
      CWnd.CWndDuration = CWndDuration[iPhase];
      CWnd.vScrPosX = CWndPosX[iPhase];
      CWnd.vScrPosY = CWndPosY[iPhase];
      CWnd.CWndSizeX = CWndSize[iPhase];
      if ( CWndSizeY[iPhase] == 0 )
        CWnd.CWndSizeY = CWndSize[iPhase];
      else
        CWnd.CWndSizeY = CWndSizeY[iPhase];
      CWnd.CWndFOV = CWndFOV[iPhase];
      CWnd.MyHudForFX = XBU;
      CWnd.CWndBorderColor = CWndBorderColor[iPhase];
      CWnd.FilterColor = FilterColor[iPhase];
      CWnd.HighLight = HighLight[iPhase];
      CWnd.FilterTexture = FilterTexture[iPhase];
      CWnd.CWndAppearFX = CWndAppearFX[iPhase];
      CWnd.CWndSoundType = CWndSoundType[iPhase];
      switch ( iPhase )
      { // can't declare array of dynamic arrays ;)
        case 0 :
          CWnd.OverlayMsg = OverLayMessage0;
          break;
        case 1 :
          CWnd.OverlayMsg = OverLayMessage1;
          break;
        case 2 :
          CWnd.OverlayMsg = OverLayMessage2;
          break;
        case 3 :
          CWnd.OverlayMsg = OverLayMessage3;
          break;
      }
      if ( OnoTexture[iPhase] != none )
      {
        CWnd.OnoTexture = OnoTexture[iPhase];
        CWnd.OnoPosX = OnoPosX[iPhase];
        CWnd.OnoPosY = OnoPosY[iPhase];
        CWnd.OnoSize = OnoSize[iPhase];
        if ( OnoSizeY[iPhase] == 0 )
          CWnd.OnoSizeY = OnoSize[iPhase]*OnoTexture[iPhase].VSize/OnoTexture[iPhase].USize;
        else
          CWnd.OnoSizeY = OnoSizeY[iPhase];
      }
      CWnd.Timer();
    }
    if ( iPhase < 3 )
      SetTimer( DelayBeforeNextCWnd[iPhase], false );
    else if ( bTriggerOnceOnly )
      Destroy();
    else
      Enable( 'Trigger' );
}


defaultproperties
{
     CWndFOV(0)=45.000000
     CWndFOV(1)=45.000000
     CWndFOV(2)=45.000000
     CWndFOV(3)=45.000000
     CWndDuration(0)=2.000000
     CWndDuration(1)=2.000000
     CWndDuration(2)=2.000000
     CWndDuration(3)=2.000000
     DelayBeforeNextCWnd(0)=0.500000
     DelayBeforeNextCWnd(1)=0.500000
     DelayBeforeNextCWnd(2)=0.500000
     CWndPosX(1)=132
     CWndPosX(2)=264
     CWndPosX(3)=396
     CWndSize(0)=128
     CWndSize(1)=128
     CWndSize(2)=128
     CWndSize(3)=128
     CWndBorderColor(0)=(B=255,G=255,R=255,A=255)
     CWndBorderColor(1)=(B=255,G=255,R=255,A=255)
     CWndBorderColor(2)=(B=255,G=255,R=255,A=255)
     CWndBorderColor(3)=(B=255,G=255,R=255,A=255)
     FilterColor(0)=(B=255,G=255,R=255)
     FilterColor(1)=(B=255,G=255,R=255)
     FilterColor(2)=(B=255,G=255,R=255)
     FilterColor(3)=(B=255,G=255,R=255)
     bTriggerOnceOnly=True
     bAnimatedInRealtime=True
     animationDuration(0)=15.000000
     animationDuration(1)=15.000000
     animationDuration(2)=15.000000
     animationDuration(3)=15.000000
}
