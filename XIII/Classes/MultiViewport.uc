//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MultiViewport extends Info;

// Main viewport will scale and move to become
var int mainViewportDestinationX, mainViewportDestinationY;
var int mainViewportDestinationW, mainViewportDestinationH;
var float mainViewportDestinationTime;
var float mainViewportDurationTime;
var float mainViewportLeadOutTime;
var color mainBorderColor;

var bool firstRenderThisFrame;
var texture WhiteTex;
var texture BlackTex;
var float fStartTime;

var actor CWndSfxTrigger;

var int iPhase;
var XIIIBaseHUD MyHudForFX;

var actor CamPosition[4];
var actor CamTarget[4];
var vector CamTargetOffset[4];
var actor CamSfxTrigger;
var float CamFOV[4];
var float CamDuration[4];
var float CamStartDelay[4];
var int CamPosX[4];
var int CamPosY[4];
var int CamSizeX[4];
var int CamSizeY[4];
var color CamBorderColor[4];
var Texture OnoTexture[4];
var int OnoPosX[4];
var int OnoPosY[4];
var int OnoSizeX[4];
var int OnoSizeY[4];
var float OnoDelay[4];
var float OnoDuration[4];
var int CamAppearFX[4];
var int CamRemoveFX[4];
var int CamAppearSpeed[4];
var int CamRemoveSpeed[4];

var int CamInit[4];
var int CX[4],CY[4],CW[4],CH[4];
var int CDX[4],CDY[4],CDW[4],CDH[4];
var int CamRemoving[4];
var int CamRemoved[4];

var bool bEnded;


//_____________________________________________________________________________
event PostBeginPlay()
{
  fStartTime = Level.TimeSeconds;
  /*if (CWndSfxTrigger != none && CWndSfxTrigger(CWndSfxTrigger) != none)
  {
    CWndSfxTrigger(CWndSfxTrigger).Trigger(self, Instigator);
  }*/
}

//_____________________________________________________________________________
function DrawBorderWnd( Canvas C , int W , int H , int X, int Y, int BorderX, int BorderY, color BorderWndColor)
{
  local int Height, Width;

  C.Style = ERenderStyle.STY_Alpha;
  C.bUseBorder = false;
  C.DrawColor = BorderWndColor;
  C.BorderColor = class'Canvas'.Static.MakeColor(0,0,0);

  C.SetPos(X-BorderX-1 , Y-BorderY-1);
  C.DrawTile(BlackTex, W+BorderX*2+2,2,0,0,BlackTex.USize, BlackTex.VSize);
  C.SetPos(X-BorderX-1 , Y-BorderY-1);
  C.DrawTile(BlackTex, 2,H+BorderY*2+2,0,0,BlackTex.USize, BlackTex.VSize);
  C.SetPos(X+W+BorderX-1 , Y-BorderY-1);
  C.DrawTile(BlackTex, 2,H+BorderY*2+2,0,0,BlackTex.USize, BlackTex.VSize);
  C.SetPos(X-BorderX-1 , Y+H+BorderY-1);
  C.DrawTile(BlackTex, W+BorderX*2+2,2,0,0,BlackTex.USize, BlackTex.VSize);

  Height = H + 2*BorderY;
  Width = BorderX;

  C.SetPos(X - BorderX, Y - BorderY);
  C.DrawTile(WhiteTex, Width,Height, 0, 0, WhiteTex.USize, WhiteTex.VSize);

  C.SetPos(X + W, Y - BorderY);
  C.DrawTile(WhiteTex, Width,Height, 0, 0, WhiteTex.USize, WhiteTex.VSize);

  Height = BorderY;
  Width = W + 2*BorderX;

  C.SetPos(X - BorderX, Y - BorderY);
  C.DrawTile(WhiteTex, Width,Height, 0, 0, WhiteTex.USize, WhiteTex.VSize);

  C.SetPos(X - BorderX, Y + H);
  C.DrawTile(WhiteTex, Width,Height, 0, 0, WhiteTex.USize, WhiteTex.VSize);
  /*
  C.bUseBorder = True;
  C.DrawColor.A = 0;
  Height = H;
  Width = W;

  C.SetPos(X , Y);
  C.DrawTile(WhiteTex, Width,Height, 0, 0, WhiteTex.USize, WhiteTex.VSize);
  */

  C.bUseBorder = false;
  C.DrawColor = class'Canvas'.Static.MakeColor(0,0,0);
}

//_____________________________________________________________________________
function InitCam(int q)
{
  CamInit[q] = 1;
  CX[q] = CamPosX[q];
  CY[q] = CamPosY[q];
  CW[q] = CamSizeX[q];
  CH[q] = CamSizeY[q];

  switch(CamAppearFX[q])
  {
  	case 1://MultiViewTrigger.CAMFX_Zoom:
  	  CW[q] = 1;
  	  CH[q] = 1;
  	  CX[q] = CamPosX[q] + (CamSizeX[q]>>1);
  	  CY[q] = CamPosY[q] + (CamSizeY[q]>>1);
    break;
  	case 2://MultiViewTrigger.CAMFX_ComeFromLeft:
  	  CX[q] = 0;
  	  CW[q] = 1;
    break;
  	case 3://MultiViewTrigger.CAMFX_ComeFromAbove:
  	  CY[q] = 0;
  	  CH[q] = 1;
    break;
  	case 4://MultiViewTrigger.CAMFX_ComeFromRight:
  	  CX[q] = 639;
  	  CW[q] = 1;
    break;
  	case 5://MultiViewTrigger.CAMFX_ComeFromUnder:
  	  CY[q] = 479;
  	  CH[q] = 1;
    break;
  	case 6://MultiViewTrigger.CAMFX_ComeFromTopLeft:
  	  CX[q] = 0;
  	  CW[q] = 1;
  	  CY[q] = 0;
  	  CH[q] = 1;
    break;
  	case 7://MultiViewTrigger.CAMFX_ComeFromTopRight:
  	  CX[q] = 639;
  	  CW[q] = 1;
  	  CY[q] = 0;
  	  CH[q] = 1;
    break;
  	case 8://MultiViewTrigger.CAMFX_ComeFromDownLeft:
  	  CX[q] = 0;
  	  CW[q] = 1;
  	  CY[q] = 479;
  	  CH[q] = 1;
    break;
  	case 9://MultiViewTrigger.CAMFX_ComeFromDownright:
  	  CX[q] = 639;
  	  CW[q] = 1;
  	  CY[q] = 479;
  	  CH[q] = 1;
    break;
  	case 10://MultiViewTrigger.CAMFX_None:
    default:
    break;
  }
}

//_____________________________________________________________________________
function RemoveCam(int q)
{
  CamRemoving[q] = 1;
  CDX[q] = CamPosX[q];
  CDY[q] = CamPosY[q];
  CDW[q] = CamSizeX[q];
  CDH[q] = CamSizeY[q];

  switch(CamRemoveFX[q])
  {
  	case 1://MultiViewTrigger.CAMOUTFX_Zoom:
  	  CDW[q] = 1;
  	  CDH[q] = 1;
  	  CDX[q] = CamPosX[q] + (CamSizeX[q]>>1);
  	  CDY[q] = CamPosY[q] + (CamSizeY[q]>>1);
    break;
  	case 2://MultiViewTrigger.CAMOUTFX_GoToLeft:
  	  CDX[q] = 0;
  	  CDW[q] = 1;
    break;
  	case 3://MultiViewTrigger.CAMOUTFX_GoToAbove:
  	  CDY[q] = 0;
  	  CDH[q] = 1;
    break;
  	case 4://MultiViewTrigger.CAMOUTFX_GoToRight:
  	  CDX[q] = 639;
  	  CDW[q] = 1;
    break;
  	case 5://MultiViewTrigger.CAMOUTFX_GoToUnder:
  	  CDY[q] = 479;
  	  CDH[q] = 1;
    break;
  	case 6://MultiViewTrigger.CAMOUTFX_GoToTopLeft:
  	  CDX[q] = 0;
  	  CDW[q] = 1;
  	  CDY[q] = 0;
  	  CDH[q] = 1;
    break;
  	case 7://MultiViewTrigger.CAMOUTFX_GoToTopRight:
  	  CDX[q] = 639;
  	  CDW[q] = 1;
  	  CDY[q] = 0;
  	  CDH[q] = 1;
    break;
  	case 8://MultiViewTrigger.CAMOUTFX_GoToDownLeft:
  	  CDX[q] = 0;
  	  CDW[q] = 1;
  	  CDY[q] = 479;
  	  CDH[q] = 1;
    break;
  	case 9://MultiViewTrigger.CAMOUTFX_GoToDownright:
  	  CDX[q] = 639;
  	  CDW[q] = 1;
  	  CDY[q] = 479;
  	  CDH[q] = 1;
    break;
  	case 10://MultiViewTrigger.CAMOUTFX_None:
    default:
      CamRemoved[q] = 1;
      CamRemoving[q] = 0;
    break;
  }
}

//_____________________________________________________________________________
function ExecuteCam(int q)
{
  if (CamRemoving[q]==0)
  {
    if (CW[q] < CamSizeX[q])
    {
      CW[q] += CamAppearSpeed[q]*2;
      if (CW[q] > CamSizeX[q])
        CW[q] = CamSizeX[q];
    }
    if (CH[q] < CamSizeY[q])
    {
      CH[q] += CamAppearSpeed[q]*2;
      if (CH[q] > CamSizeY[q])
        CH[q] = CamSizeY[q];
    }
    if (CX[q] < CamPosX[q])
    {
      CX[q] += CamAppearSpeed[q];
      if (CX[q] > CamPosX[q])
        CX[q] = CamPosX[q];
    }
    if (CY[q] < CamPosY[q])
    {
      CY[q] += CamAppearSpeed[q];
      if (CY[q] > CamPosY[q])
        CY[q] = CamPosY[q];
    }
    if (CX[q] > CamPosX[q])
    {
      CX[q] -= CamAppearSpeed[q];
      if (CX[q] < CamPosX[q])
        CX[q] = CamPosX[q];
    }
    if (CY[q] > CamPosY[q])
    {
      CY[q] -= CamAppearSpeed[q];
      if (CY[q] < CamPosY[q])
        CY[q] = CamPosY[q];
    }
  }
  else
  {
    if (CamRemoveFX[q] == 1) // Zoom
    {
      if (CW[q] > CDW[q])
      {
        CW[q] -= CamRemoveSpeed[q];
        if (CW[q] < CDW[q])
          CW[q] = CDW[q];
      }
      if (CH[q] > CDH[q])
      {
        CH[q] -= CamRemoveSpeed[q];
        if (CH[q] < CDH[q])
          CH[q] = CDH[q];
      }
    }
    else
    {
      if (CX[q] == CDX[q])
      {
        if (CW[q] > CDW[q])
        {
          CW[q] -= CamRemoveSpeed[q];
          if (CW[q] < CDW[q])
            CW[q] = CDW[q];
        }
      }
      else if (CX[q] >= 640-CW[q])
      {
        if (CW[q] > CDW[q])
        {
          CW[q] -= CamRemoveSpeed[q];
          if (CW[q] < CDW[q])
            CW[q] = CDW[q];
        }
      }

      if (CY[q] == CDY[q])
      {
        if (CH[q] > CDH[q])
        {
          CH[q] -= CamRemoveSpeed[q];
          if (CH[q] < CDH[q])
            CH[q] = CDH[q];
        }
      }
      else if (CY[q] >= 480-CH[q])
      {
        if (CH[q] > CDH[q])
        {
          CH[q] -= CamRemoveSpeed[q];
          if (CH[q] < CDH[q])
            CH[q] = CDH[q];
        }
      }
    }

    if (CX[q] < CDX[q])
    {
      CX[q] += CamRemoveSpeed[q];
      if (CX[q] > CDX[q])
        CX[q] = CDX[q];
    }
    if (CY[q] < CDY[q])
    {
      CY[q] += CamRemoveSpeed[q];
      if (CY[q] > CDY[q])
        CY[q] = CDY[q];
    }
    if (CX[q] > CDX[q])
    {
      CX[q] -= CamRemoveSpeed[q];
      if (CX[q] < CDX[q])
        CX[q] = CDX[q];
    }
    if (CY[q] > CDY[q])
    {
      CY[q] -= CamRemoveSpeed[q];
      if (CY[q] < CDY[q])
        CY[q] = CDY[q];
    }

    if (CX[q]==CDX[q] && CY[q]==CDY[q] && CW[q]==CDW[q] && CH[q]==CDH[q])
    {
      CamRemoved[q] = 1;
      CamRemoving[q] = 0;
    }
  }
}

//_____________________________________________________________________________
simulated event RenderOverlays( canvas C )
{
  local float deltaTime;
  local eDrawType DT_mem;
  local float mainViewportScale;
  local int mwx,mwy,mww,mwh;
  local int q;

  deltaTime = Level.TimeSeconds-fStartTime;

  if (Level.TimeSeconds < fStartTime+mainViewportDestinationTime)
    mainViewportScale = 1.0-((fStartTime+mainViewportDestinationTime)-Level.TimeSeconds)/mainViewportDestinationTime;
  else if (Level.TimeSeconds > fStartTime+mainViewportDestinationTime+mainViewportDurationTime)
    mainViewportScale = ((fStartTime+mainViewportDestinationTime+mainViewportDurationTime+mainViewportLeadOutTime)-Level.TimeSeconds)/mainViewportLeadOutTime;
  else
    mainViewportScale = 1.0;

  if (Level.TimeSeconds > fStartTime+mainViewportDestinationTime+mainViewportDurationTime+mainViewportLeadOutTime)
  {
    bEnded = true;
    //return;
  }

  if (mainViewportScale<0.0)
    mainViewportScale = 0.0;
  if (mainViewportScale>1.0)
    mainViewportScale = 1.0;

  mwx = (mainViewportDestinationX)*mainViewportScale;
  mwy = (mainViewportDestinationY)*mainViewportScale;
  mww = 640+(mainViewportDestinationW-640)*mainViewportScale;
  mwh = 480+(mainViewportDestinationH-480)*mainViewportScale;

  Level.SetOnlyPostRender(true);

  if (firstRenderThisFrame)
  {
    firstRenderThisFrame = false;
    DT_mem = DrawType;
    XIIIPlayerController(owner).bRenderPortal = true;

    //Log("Drawing MultiViewport");
    DrawBorderWnd( c , mww , mwh , mwx, mwy, 5, 5, mainBorderColor);
    C.DrawPortal(mwx, mwy, mww, mwh, XIIIPlayerController(owner), XIIIPlayerController(owner).location, XIIIPlayerController(owner).rotation);
    /*
    C.SetPos(0.0, 0.0);
    C.DrawTile(texture'XIIIMenu.Blanc',320*scale+8,240*scale+8,0,0,1,1);

    XIIIPlayerController(Instigator.controller).bRenderPortal = true;
    DT_mem = DrawType;
    SetDrawType(DT_none);
    XIIIPlayerController(Instigator.controller).bBehindView = true;
    C.DrawPortal(4,4,320*scale,240*scale,self,location,rotation);
    XIIIPlayerController(Instigator.controller).bBehindView = false;
    SetDrawType(DT_mem);
    XIIIPlayerController(Instigator.controller).bRenderPortal = false;
    */

    MyHudForFX.PlayerOwner.Pawn.bOwnerNoSee = false;
    if ( XIIIPlayerController(MyHudForFX.PlayerOwner).bWeaponMode )
      MyHudForFX.PlayerOwner.Pawn.weapon.bOwnerNoSee = true;
    else
      MyHudForFX.PlayerOwner.Pawn.SelectedItem.bOwnerNoSee = true;
    for (q=0; q<4; q++)
    {
      if (CamRemoved[q]==0 && CamPosition[q] != none && CamTarget[q] != none && deltaTime > CamStartDelay[q])
      {
        if (deltaTime < CamStartDelay[q] + CamDuration[q] || CamRemoving[q]==1)
        {
          if (CamInit[q]==0)
          {
            InitCam(q);
          }
        }
        else if (CamRemoving[q]==0)
        {
          RemoveCam(q);
        }
        ExecuteCam(q);
        DrawBorderWnd( c , CW[q], CH[q], CX[q], CY[q], 5, 5, CamBorderColor[q]);
        C.DrawPortal(CX[q], CY[q], CW[q], CH[q], CamPosition[q], CamPosition[q].location, rotator(CamTarget[q].location + CamTargetOffset[q] - CamPosition[q].location), CamFOV[q]);

        if (OnoTexture[q] != none && deltaTime > CamStartDelay[q]+OnoDelay[q] && deltaTime < CamStartDelay[q] + OnoDelay[q] + OnoDuration[q])
        {
          C.Style = ERenderStyle.STY_Alpha;
          C.bUseBorder = false;
          C.SetPos(OnoPosX[q] , OnoPosY[q]);
          C.DrawTile(OnoTexture[q], OnoSizeX[q], OnoSizeY[q],0,0,OnoTexture[q].USize,OnoTexture[q].VSize);
        }
      }
    }
    MyHudForFX.PlayerOwner.Pawn.bOwnerNoSee = true;
    if ( XIIIPlayerController(MyHudForFX.PlayerOwner).bWeaponMode )
      MyHudForFX.PlayerOwner.Pawn.weapon.bOwnerNoSee = false;
    else
      MyHudForFX.PlayerOwner.Pawn.SelectedItem.bOwnerNoSee = false;

    SetDrawType(DT_mem);
    XIIIPlayerController(owner).bRenderPortal = false;
    firstRenderThisFrame = true;
  }
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
     firstRenderThisFrame=True
     WhiteTex=Texture'XIIIMenu.HUD.blanc'
     BlackTex=Texture'XIIIMenu.HUD.noir'
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
     CamAppearSpeed(0)=5
     CamAppearSpeed(1)=5
     CamAppearSpeed(2)=5
     CamAppearSpeed(3)=5
     CamRemoveSpeed(0)=20
     CamRemoveSpeed(1)=20
     CamRemoveSpeed(2)=20
     CamRemoveSpeed(3)=20
}
