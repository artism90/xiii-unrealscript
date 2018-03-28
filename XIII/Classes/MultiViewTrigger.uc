//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MultiViewTrigger extends XIIITriggers;

var() int mainViewportDestinationX, mainViewportDestinationY;
var() int mainViewportDestinationW, mainViewportDestinationH;
var() float mainViewportDestinationTime;
var() float mainViewportDurationTime;
var() float mainViewportLeadOutTime;
var() color mainBorderColor;

var() actor CWndSfxTrigger;

var() bool bTriggerOnTouch;

var() actor CamPosition[4];
var() actor CamTarget[4];
var() vector CamTargetOffset[4];
var() actor CamSfxTrigger;
var() float CamFOV[4];
var() float CamDuration[4];
var() float CamStartDelay[4];
var() int CamPosX[4];
var() int CamPosY[4];
var() int CamSizeX[4];
var() int CamSizeY[4];
var() color CamBorderColor[4];
var() Texture OnoTexture[4];
var() int OnoPosX[4];
var() int OnoPosY[4];
var() int OnoSizeX[4];
var() int OnoSizeY[4];
var() float OnoDelay[4];
var() float OnoDuration[4];
var() enum eCamAppearFX
{
	CAMFX_None,
	CAMFX_Zoom,
	CAMFX_ComeFromLeft,
	CAMFX_ComeFromAbove,
	CAMFX_ComeFromRight,
	CAMFX_ComeFromUnder,
	CAMFX_ComeFromTopLeft,
	CAMFX_ComeFromTopRight,
	CAMFX_ComeFromDownLeft,
	CAMFX_ComeFromDownright,
} CamAppearFX[4];
var() enum eCamRemoveFX
{
  CAMOUTFX_None,
  CAMOUTFX_Zoom,
	CAMOUTFX_GoToLeft,
	CAMOUTFX_GoToAbove,
	CAMOUTFX_GoToRight,
	CAMOUTFX_GoToUnder,
	CAMOUTFX_GoToTopLeft,
	CAMOUTFX_GoToTopRight,
	CAMOUTFX_GoToDownLeft,
	CAMOUTFX_GoToDownright,
} CamRemoveFX[4];
var() int CamAppearSpeed[4];
var() int CamRemoveSpeed[4];

event Trigger( actor Other, pawn EventInstigator )
{
  local int q;
  local XIIIPlayerController XP;
  local MultiViewport MP;
  if (EventInstigator!=none && XIIIPlayerController(EventInstigator.controller)!=none)
  {
    XP = XIIIPlayerController(EventInstigator.controller);
    Log("MultiView Triggered");
    XP.multiviewport = Spawn(class'MultiViewport', XIIIPlayerController(EventInstigator.controller));
    MP = XP.multiviewport;
    MP.MyHudForFX = XIIIBaseHUD(XIIIPlayerController(EventInstigator.controller).MyHud);

    MP.mainViewportDestinationX = mainViewportDestinationX;
    MP.mainViewportDestinationY = mainViewportDestinationY;
    MP.mainViewportDestinationW = mainViewportDestinationW;
    MP.mainViewportDestinationH = mainViewportDestinationH;
    MP.mainViewportDestinationTime = mainViewportDestinationTime;

    MP.CWndSfxTrigger = CWndSfxTrigger;
    MP.fStartTime = Level.TimeSeconds;
    MP.mainViewportDurationTime = mainViewportDurationTime;
    MP.mainViewportLeadOutTime = mainViewportLeadOutTime;
    MP.mainBorderColor = mainBorderColor;

    MP.CamSfxTrigger = CamSfxTrigger;
    for (q=0; q<4; q++)
    {
      MP.CamPosition[q] = CamPosition[q];
      MP.CamTarget[q] = CamTarget[q];
      MP.CamFOV[q] = CamFOV[q];
      MP.CamDuration[q] = CamDuration[q];
      MP.CamPosX[q] = CamPosX[q];
      MP.CamPosY[q] = CamPosY[q];
      MP.CamSizeX[q] = CamSizeX[q];
      MP.CamSizeY[q] = CamSizeY[q];
      MP.CamBorderColor[q] = CamBorderColor[q];
      MP.OnoTexture[q] = OnoTexture[q];
      MP.OnoPosX[q] = OnoPosX[q];
      MP.OnoPosY[q] = OnoPosY[q];
      MP.OnoSizeX[q] = OnoSizeX[q];
      MP.OnoSizeY[q] = OnoSizeY[q];
      MP.OnoDelay[q] = OnoDelay[q];
      MP.OnoDuration[q] = OnoDuration[q];
      MP.CamAppearFX[q] = CamAppearFX[q];
      MP.CamRemoveFX[q] = CamRemoveFX[q];
      MP.CamStartDelay[q] = CamStartDelay[q];
      MP.camAppearSpeed[q] = camAppearSpeed[q];
      MP.camRemoveSpeed[q] = camRemoveSpeed[q];
      MP.CamTargetOffset[q] = CamTargetOffset[q];
    }

    if (CWndSfxTrigger != none && CWndSfxTrigger(CWndSfxTrigger) != none)
    {
      Log("CWndSfxTrigger triggered!");
      CWndSfxTrigger(CWndSfxTrigger).Trigger(self, EventInstigator);
    }
    Destroy();
  }
}

event Touch(Actor other)
{
  if (bTriggerOnTouch)
    Trigger(other, Pawn(other));
}



defaultproperties
{
     mainViewportDestinationX=200
     mainViewportDestinationY=200
     mainViewportDestinationW=200
     mainViewportDestinationH=200
     mainViewportDestinationTime=5.000000
     mainViewportDurationTime=5.000000
     mainViewportLeadOutTime=5.000000
     mainBorderColor=(B=255,G=255,R=255,A=255)
     CamFOV(0)=45.000000
     CamFOV(1)=45.000000
     CamFOV(2)=45.000000
     CamFOV(3)=45.000000
     CamDuration(0)=4.000000
     CamDuration(1)=4.000000
     CamDuration(2)=4.000000
     CamDuration(3)=4.000000
     CamStartDelay(0)=0.500000
     CamStartDelay(1)=0.500000
     CamStartDelay(2)=0.500000
     CamStartDelay(3)=0.500000
     CamPosX(0)=100
     CamPosX(1)=100
     CamPosX(2)=250
     CamPosX(3)=250
     CamPosY(0)=100
     CamPosY(1)=250
     CamPosY(2)=250
     CamPosY(3)=100
     CamSizeX(0)=100
     CamSizeX(1)=100
     CamSizeX(2)=100
     CamSizeX(3)=100
     CamSizeY(0)=100
     CamSizeY(1)=100
     CamSizeY(2)=100
     CamSizeY(3)=100
     CamBorderColor(0)=(B=255,G=255,R=255,A=255)
     CamBorderColor(1)=(B=255,G=255,R=255,A=255)
     CamBorderColor(2)=(B=255,G=255,R=255,A=255)
     CamBorderColor(3)=(B=255,G=255,R=255,A=255)
     OnoDuration(0)=10.000000
     OnoDuration(1)=10.000000
     OnoDuration(2)=10.000000
     OnoDuration(3)=10.000000
     CamAppearSpeed(0)=5
     CamAppearSpeed(1)=5
     CamAppearSpeed(2)=5
     CamAppearSpeed(3)=5
     CamRemoveSpeed(0)=20
     CamRemoveSpeed(1)=20
     CamRemoveSpeed(2)=20
     CamRemoveSpeed(3)=20
}
