//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HudCartoonWindow extends Info
  NotPlaceable;

var HudCartoonWindow NextHudWnd;
var HudCartoonWindow PrevHudWnd;

var float XL, YL, DXS, DYS, XSt, YSt, XS, YS, EndOfLife;
var BitMapMaterial WndTex;
var color BorderColor;
var float XP, YP;                 // optim to compute coords & mem them for multiple uses

// vars for appearance sfx
var float StartOfLife;
var int CWndAppearFX;

// vars for overlay text
var array<string> OverlayMsg;     // message to display in overlay
var float OMsgWidth, OMsgH;       // witdh of the message, Height of one line
var float OMsgX, OMsgY;           // position of message
var bool bLowPriority;

CONST TRANSITDELAY=0.15;          // transition delay for SFXs

//____________________________________________________________________
simulated function SetUpCartoonWindow(float XPos, float YPos, float DXSize, float DYSize, BitMapMaterial Tex, float X, float Y, float XSize, float YSize, float Lifetime, color cBorder, int CWAFX, bool bLowPrio)
{
    XL = XPos;
    YL = YPos;
    DXS = DXSize;
    DYS = DYSize;
    WndTex = Tex;
    XSt = X;
    YSt = Y;
    XS = XSize;
    YS = YSize;
    StartOfLife = Level.TimeSeconds;
    EndOfLife = Level.TimeSeconds + LifeTime;
    BorderColor = cBorder;
    CWndAppearFX = CWAFX;
    bLowPriority = bLowPrio;
}

simulated function AddCartoonWindow(float XPos, float YPos, float DXSize, float DYSize, BitMapMaterial Tex, float X, float Y, float XSize, float YSize, float Lifetime, color cBorder, int CWAFX, bool bLowPrio)
{
    if ( bLowPrio && !bLowPriority )
      return; // don't add this as we have a high priority window on screen

    if ( NextHudWnd == none )
    {
      NextHudWnd = Spawn(class'HudCartoonWindow',Owner);
      NextHudWnd.PrevHudWnd = self;
      if( bLowPrio )
        NextHudWnd.SetUpCartoonWindow(XPos, YPos, DXSize, DYSize, Tex, X, Y, XSize, YSize, Lifetime, cBorder, CWAFX, true);
      else
        NextHudWnd.SetUpCartoonWindow(XPos, YPos, DXSize, DYSize, Tex, X, Y, XSize, YSize, Lifetime, cBorder, CWAFX, false);
    }
    else
    {
      if( bLowPrio )
        NextHudWnd.AddCartoonWindow(XPos, YPos, DXSize, DYSize, Tex, X, Y, XSize, YSize, Lifetime, cBorder, CWAFX, true);
      else
        NextHudWnd.AddCartoonWindow(XPos, YPos, DXSize, DYSize, Tex, X, Y, XSize, YSize, Lifetime, cBorder, CWAFX, false);
    }
}

//____________________________________________________________________
simulated function DrawWnd(Canvas C)
{
    local float fDrawScale;
    local int i;
    local float MsgXL, MsgYL;
    local float XAF, YAF, XSize, YSize;
    local float tX, tY;

    switch ( CWndAppearFX )
    {
      Case 0: //CAFX_None:
        XAF = 1.0;
        YAF = 1.0;
        XSize = 1.0;
        YSize = 1.0;
        break;
      Case 1: //CAFX_ComeFromLeft:
        XAF = 1.0 - fMax(0, StartOfLife + TRANSITDELAY - Level.TimeSeconds)*(1.0/TRANSITDELAY);
        YAF = 1.0;
        XSize = 1.0;
        YSize = 1.0;
        break;
      Case 2: //CAFX_ComeFromAbove:
        XAF = 1.0;
        YAF = 1.0 - fMax(0, StartOfLife + TRANSITDELAY  - Level.TimeSeconds)*(1.0/TRANSITDELAY);
        XSize = 1.0;
        YSize = 1.0;
        break;
      Case 3: //CAFX_StretchHorizontal:
        XAF = 1.0;
        YAF = 1.0;
        XSize = 1.0 - fMax(0, StartOfLife + TRANSITDELAY*0.5 - Level.TimeSeconds)*(1.0/TRANSITDELAY*0.5);
        YSize = 1.0;
        break;
      Case 4: //CAFX_StretchVertical:
        XAF = 1.0;
        YAF = 1.0;
        XSize = 1.0;
        YSize = 1.0 - fMax(0, StartOfLife + TRANSITDELAY*0.5 - Level.TimeSeconds)*(1.0/TRANSITDELAY*0.5);
        break;
      Case 5: //CAFX_Zoom
        XAF = 1.0;
        YAF = 1.0;
        XSize = 1.0 - fMax(0, StartOfLife + TRANSITDELAY*0.5 - Level.TimeSeconds)*(1.0/TRANSITDELAY*0.5);
        YSize = XSize;
        break;
      Case 6: //CAFX_ComeFromRight:
        XAF = 1.0 + fMax(0, StartOfLife + TRANSITDELAY - Level.TimeSeconds)*(1.0/TRANSITDELAY);
        YAF = 1.0;
        XSize = 1.0;
        YSize = 1.0;
        break;
      Case 7: //CAFX_ComeFromUnder:
        XAF = 1.0;
        YAF = 1.0 + fMax(0, StartOfLife + TRANSITDELAY  - Level.TimeSeconds)*(1.0/TRANSITDELAY);
        XSize = 1.0;
        YSize = 1.0;
        break;
      Case 8: //CAFX_ComeFromTopLeft:
        XAF = 1.0 - fMax(0, StartOfLife + TRANSITDELAY - Level.TimeSeconds)*(1.0/TRANSITDELAY);
        YAF = XAF;
        XSize = 1.0;
        YSize = 1.0;
        break;
      Case 9: //CAFX_ComeFromTopRight:
        XAF = 1.0 + fMax(0, StartOfLife + TRANSITDELAY - Level.TimeSeconds)*(1.0/TRANSITDELAY);
        YAF = 2.0 - XAF;
        XSize = 1.0;
        YSize = 1.0;
        break;
      Case 10: //CAFX_ComeFromDownLeft:
        XAF = 1.0 - fMax(0, StartOfLife + TRANSITDELAY - Level.TimeSeconds)*(1.0/TRANSITDELAY);
        YAF = 2.0 - XAF;
        XSize = 1.0;
        YSize = 1.0;
        break;
      Case 11: //CAFX_ComeFromDownRight:
        XAF = 1.0 + fMax(0, StartOfLife + TRANSITDELAY - Level.TimeSeconds)*(1.0/TRANSITDELAY);
        YAF = XAF;
        XSize = 1.0;
        YSize = 1.0;
        break;
    }
/*
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
*/
    fDrawScale = C.ClipX/640.0;

    if (EndOfLife - Level.TimeSeconds > 0.01)
    {
      tX = DXS*fDrawScale*XSize;
      tY = DYS*fDrawScale*YSize;
      C.Style = ERenderStyle.STY_Alpha;

      if ( XAF <= 1.0 ) // come from left
        XP = int((XL*fDrawScale+XIIIBaseHUD(Owner).LeftMargin*C.ClipX) * XAF + DXS*fDrawScale*0.5*(1.0-XSize));
      else // come from right
        XP = int(
          (XL*fDrawScale+XIIIBaseHUD(Owner).LeftMargin*C.ClipX) * (2.0 - XAF)
          + (XAF - 1.0) * C.ClipX
          + DXS*fDrawScale*0.5*(1.0-XSize));
      if ( YAF <= 1.0 ) // come from above
        YP = int((YL*fDrawScale+XIIIBaseHUD(Owner).UpMargin*C.ClipY) * YAF + DYS*fDrawScale*0.5*(1.0-YSize));
      else // come from below
        YP = int(
          (YL*fDrawScale+XIIIBaseHUD(Owner).UpMargin*C.ClipY) * (2.0 - YAF)
          + (YAF - 1.0) * C.ClipY
          + DYS*fDrawScale*0.5*(1.0-YSize));

      if ( BorderColor.A != 0 )
      { // optim, drawing this is faster than using border (1 tile faster than 8 lines).
        C.SetPos(XP-8, YP-8);
        C.DrawColor = C.Static.MakeColor(0,0,0,255);
        C.DrawRect(XIIIBaseHUD(Owner).FondDlg, tX + 16, tY + 16);
        C.SetPos(XP-6, YP-6);
        C.DrawColor = BorderColor;
        C.DrawRect(XIIIBaseHUD(Owner).FondDlg, tX + 12, tY + 12);
        C.SetPos(XP-2,YP-2);
        C.DrawColor = C.Static.MakeColor(0,0,0,255);
        C.DrawRect(XIIIBaseHUD(Owner).FondDlg, tX + 4, tY + 4);
      }

      C.DrawColor = C.Static.MakeColor(255,255,255,255);
      C.SetPos(XP,YP);
      C.DrawTile(WndTex, tX, tY, XSt, YSt, XS, YS);

      // Draw Overlay message
      if ( OverlayMsg.Length > 0 )
      {
        XIIIBaseHUD(Owner).UseDialogFont(C);
        C.SpaceX = 0;
//        C.bTextShadow = true; // ELR Drawing Cwnd is time consuming enough, don't enable text shadows here
        if ( OMsgWidth == 0 )
        {
          for ( i=0; i<OverlayMsg.Length; i++)
          {
            C.StrLen( OverlayMsg[i], MsgXL, MsgYL);
            OMsgWidth = fMax( MsgXL, OMsgWidth );
            OMsgH = fMax( MsgYL, OMsgH );
          }
        }
        OMsgX = XL + DXS;
        OMsgY = YL + 10;
        XP = OMsgX*fDrawScale + XIIIBaseHUD(Owner).LeftMargin*C.ClipX - 3;
        YP = OMsgY*fDrawScale + XIIIBaseHUD(Owner).UpMargin*C.ClipY - 3;
        C.Style = ERenderStyle.STY_Alpha;
        C.SetPos(XP-2, YP-2);
        C.SetDrawColor(0,0,0,255);
        C.DrawRect(XIIIBaseHUD(Owner).FondDlg, OMsgWidth + 6 + 4, OMsgH*OverlayMsg.Length + 6 + 4);
        C.SetPos(XP, YP);
        C.SetDrawColor(220,220,220,255);
        C.DrawRect(XIIIBaseHUD(Owner).FondDlg, OMsgWidth + 6 , OMsgH*OverlayMsg.Length + 6);
        XP = OMsgX*fDrawScale + XIIIBaseHUD(Owner).LeftMargin*C.ClipX;
        YP = OMsgY*fDrawScale + XIIIBaseHUD(Owner).UpMargin*C.ClipY;
        C.SetDrawColor(15,15,15,255);
        for ( i=0; i<OverlayMsg.Length; i++)
        {
          C.SetPos(XP, YP + i*OMsgH);
          C.DrawText(OverlayMsg[i]);
        }
      }
    }

    if (NextHudWnd != none)
      NextHudWnd.DrawWnd(C);

    if ( Level.TimeSeconds > EndOfLife )
      ReMoveMe();
}

//____________________________________________________________________
function RemoveMe()
{
    XIIIBaseHUD(Owner).CWndMat.FreeRect(XSt, YSt, XS, YS);

    if (PrevHudWnd == none)
    {
      if (NextHudWnd != none)
      {
        XIIIBaseHUD(Owner).HudWnd = NextHudWnd;
        NextHudWnd.PrevHudWnd = none;
      }
      else
        XIIIBaseHUD(Owner).HudWnd = none;
    }
    else
    {
      PrevHudWnd.NextHudWnd = NextHudWnd;
      if ( NextHudWnd != none )
        NextHudWnd.PrevHudWnd = PrevHudWnd;
    }
    Destroy();
}



defaultproperties
{
     BorderColor=(B=255,G=255,R=255,A=255)
}
