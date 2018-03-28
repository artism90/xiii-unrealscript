//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HudCartoonFocus extends Info
  NotPlaceable;

var HudCartoonFocus NextHudFoc;
var HudCartoonFocus PrevHudFoc;

var actor MyFocus;

// vars for appearance sfx
var float StartOfLife, EndOfLife;
var int CWndAppearFX;
var float FocusWidth, FocusHeight;  // target Width & Height of 'outline' (in fact half w/h)
var color BorderColor;
var float XP1, YP1, XP2, YP2;       // coords of 'outline'

var color FilterColor;
var float HighLight;
var Material FilterTexture;
var int CWndX, CWndY;
var bool bEnableCWnd;
var bool bUseVignette;
var bool bModeInfini;

// vars for overlay text
var array<string> OverlayMsg;       // message to display in overlay
var float OMsgWidth, OMsgH;         // witdh of the message, Height of one line
var float OMsgX, OMsgY;             // position of message

var bool zoomFocus;
var float zoomCameraDistance;
var float zoomCameraFOV;

var bool bCartoonFocusDanger;

CONST TRANSITDELAY=0.35;            // transition delay for appearance SFXs

//____________________________________________________________________
simulated function DrawWnd(Canvas C);

//____________________________________________________________________
simulated function SetUpCartoonFocus(Actor Focus, int AppearFX, bool bVignette, float Duration, bool zoom, float zoomFOV, float zoomDist, bool bDanger)
{
    MyFocus = Focus;
    FocusWidth = fMax(Focus.CollisionRadius, 30);
    FocusHeight = fMax(Focus.COllisionHeight, 30);
    StartOfLife = Level.TimeSeconds;
    if (Duration < 0)
    {
      // cas de focus longs desactivables par event
      EndOfLife = StartOfLife;
      bModeInfini = true;
      XIIIBaseHUD(Owner).tCartoonFocus[XIIIBaseHUD(Owner).eNbHudCartoonFocus] = self;
      XIIIBaseHUD(Owner).eNbHudCartoonFocus ++;
    }
    else
    {
      EndOfLife = StartOfLife + Duration;
    }
    CWndAppearFX = AppearFX;
    bUseVignette = bVignette;
    zoomFocus = zoom;
    zoomCameraFOV = zoomFOV;
    zoomCameraDistance = zoomDist;
    bCartoonFocusDanger = bDanger;
    switch ( CWndAppearFX )
    {
      Case 0:
        GotoState('AppearZoom');
        break;
      Case 1:
        GotoState('AppearZoom');
        break;
    }
}

//____________________________________________________________________
simulated function AddCartoonFocus(Actor Focus, int AppearFX, bool bUseVignette, float Duration, bool zoom, float zoomFOV, float zoomDist, bool bDanger)
{
    if ( NextHudFoc == none )
    {
      NextHudFoc = Spawn(class'HudCartoonFocus',Owner);
      NextHudFoc.PrevHudFoc = self;
      NextHudFoc.SetUpCartoonFocus(Focus, AppearFX, bUseVignette, Duration, zoom, zoomFOV, zoomDist, bDanger);
    }
    else
    {
      NextHudFoc.AddCartoonFocus(Focus, AppearFX, bUseVignette, Duration, zoom, zoomFOV, zoomDist, bDanger);
    }
}

//____________________________________________________________________
function RemoveMe()
{
    if ( bEnableCWnd && bUseVignette )
      XIIIBaseHUD(Owner).CWndMat.FreeRect(CWndX, CWndY, FocusWidth*2, FocusHeight*2);

    if (PrevHudFoc == none)
    {
      if (NextHudFoc != none)
      {
        XIIIBaseHUD(Owner).HudFoc = NextHudFoc;
        NextHudFoc.PrevHudFoc = none;
      }
      else
      XIIIBaseHUD(Owner).HudFoc = none;
    }
    else
    {
      PrevHudFoc.NextHudFoc = NextHudFoc;
      if ( NextHudFoc != none )
        NextHudFoc.PrevHudFoc = PrevHudFoc;
    }
    Destroy();
}

//____________________________________________________________________
state AppearZoom
{
    simulated function BeginState()
    {
      Disable('tick');
    }

    simulated function DrawWnd(Canvas C)
    {
      local vector campos;
      local int x1,y1,x2,y2;
      local eDrawType DT_mem;
      Local Vector vFocusLoc;
      local float fVarSize;
      local float XL, YL; // realtime length & width of icon
      local float fAlpha; // from 0.f to 1.f, 1 = transition ended
      local actor A;
      local vector HitLoc, HitNorm;
      local material HitMat;

      if ( MyFocus == none )
      {
        RemoveMe();
        Return;
      }
//      Log("Angle="$normal(MyFocus.Location - (XIIIBaseHUD(Owner).PawnOwner.Location + XIIIBaseHUD(Owner).PawnOwner.EyePosition())) dot vector(XIIIBaseHUD(Owner).XIIIPlayerOwner.rotation));
      if ( normal(MyFocus.Location - (XIIIBaseHUD(Owner).PawnOwner.Location + XIIIBaseHUD(Owner).PawnOwner.EyePosition())) dot vector(XIIIBaseHUD(Owner).XIIIPlayerOwner.rotation) < 0.707 )
      {
        if (NextHudFoc != none)
          NextHudFoc.DrawWnd(C);
        if (( Level.TimeSeconds > EndOfLife ) && !bModeInfini )
          RemoveMe();
        return;
      }
      A = Trace(HitLoc, HitNorm, MyFocus.Location, XIIIBaseHUD(Owner).PawnOwner.Location, true, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanSeeThrough);
      if ( (A != none) && (A != MyFocus) )
      {
        if (NextHudFoc != none)
          NextHudFoc.DrawWnd(C);
        if (( Level.TimeSeconds > EndOfLife ) && !bModeInfini )
          RemoveMe();
        return;
      }

      vFocusLoc = XIIIBaseHUD(Owner).XIIIPlayerOwner.Player.Console.WorldToScreen(MyFocus.Location);
      C.Style = ERenderStyle.STY_Alpha;
      fVarSize = 100.0
        / vSize(MyFocus.Location - ( XIIIBaseHUD(Owner).PawnOwner.Location + XIIIBaseHUD(Owner).PawnOwner.EyePosition()))
        / Tan(XIIIBaseHUD(Owner).XIIIPlayerOwner.FOVAngle);

      fAlpha = (Level.TimeSeconds - StartOfLife) / TRANSITDELAY;
      XL = FocusWidth * fVarSize;
      YL = FocusHeight * fVarSize;
      if ( fAlpha <= 0.97 )
      {
        XP1 = int(C.ClipX * XIIIBaseHUD(Owner).LeftMargin * ( 1.0 - fAlpha ) + fAlpha * (vFocusLoc.X - XL));
        XP2 = int(C.ClipX * (1.0 - XIIIBaseHUD(Owner).RightMargin) * ( 1.0 - fAlpha ) + fAlpha * (vFocusLoc.X + XL));
        YP1 = int(C.ClipY * XIIIBaseHUD(Owner).UpMargin * ( 1.0 - fAlpha ) + fAlpha * (vFocusLoc.Y - YL));
        YP2 = int(C.ClipY * (1.0 - XIIIBaseHUD(Owner).DownMargin) * ( 1.0 - fAlpha ) + fAlpha * (vFocusLoc.Y + YL));
      }
      else
      {
        XP1 = int(vFocusLoc.X - XL);
        XP2 = int(vFocusLoc.X + XL);
        YP1 = int(vFocusLoc.Y - YL);
        YP2 = int(vFocusLoc.Y + YL);
      }
/*
      // white border
      C.DrawColor = C.Static.MakeColor(255,255,255,255);
      // Above
      C.SetPos(XP1 - 8, YP1 - 8);
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1) + 16, 8);
      // Left
      C.SetPos(XP1 - 8, YP1 - 8);
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, 8, (YP2 - YP1) + 16);
      // Under
      C.SetPos(XP1 - 8, YP2);
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1) + 16, 8);
      // Right
      C.SetPos(XP2, YP1 - 8);
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, 8, (YP2 - YP1) + 16);
*/

      C.DrawColor = C.Static.MakeColor(0,0,0,0);
      C.BorderColor = C.Static.MakeColor(0,0,0,255);
      C.bUseBorder = true;
      // outer outline
      if ( bCartoonFocusDanger )
      {
        C.SetPos(XP1 - 1, YP1 - 1);
        C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1)+2, (YP2 - YP1)+2);
      }
      else
      {
        C.SetPos(XP1 - 2, YP1 - 2);
        C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1)+4, (YP2 - YP1)+4);
      }
      // inner outline
      C.SetPos(XP1, YP1);
      if ( bCartoonFocusDanger )
        C.BorderColor = C.Static.MakeColor(190,66,24,255);
      else
        C.BorderColor = C.Static.MakeColor(255,255,255,255);
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1), (YP2 - YP1));
      C.bUseBorder = false;

      if ( fAlpha > 0.97 )
      {
        if ( !bUseVignette )
        {
          bEnableCWnd = true;
        }
        else
        {
          if ( !bEnableCWnd )
          {
            XIIIBaseHUD(Owner).CWndMat.AllocRect( FocusWidth*2, FocusHeight*2, CWndX, CWndY );
            Log(self$"Call to AllocRect size="$FocusWidth*2$"x"$FocusHeight*2$" result pos="$CWndX$","$CWndY);
          }
          if ( (CWndX < 0) || (CWndY < 0) )
          {
            if ( !bModeInfini )
              RemoveMe();
            return;
          }
          else
            bEnableCWnd = true;
        }
        Enable('tick');
      }
      if (NextHudFoc != none)
        NextHudFoc.DrawWnd(C);
      if (( Level.TimeSeconds > EndOfLife ) && !bModeInfini )
        RemoveMe();
    }

    simulated function Tick(float DeltaT)
    { // Because Update(...) CAN'T be called while in postrender
      if ( bEnableCWnd )
      {
        if ( bUseVignette )
          XIIIBaseHUD(Owner).CWndMat.Update( CWndX, CWndY, FocusWidth*2, FocusHeight*2, MyFocus.Location + fMax(MyFocus.CollisionRadius, MyFocus.CollisionHeight) / 17.0 * 100.0 * normal(XIIIBaseHUD(Owner).PawnOwner.Location - MyFocus.Location), rotator(MyFocus.Location - XIIIBaseHUD(Owner).PawnOwner.Location), 20, FilterColor, HighLight, FilterTexture );
        GotoState('ZoomToStandardCWnd');
      }
    }
}

//____________________________________________________________________
state ZoomToStandardCWnd
{
    simulated function DrawWnd(Canvas C)
    {
      local vector campos;
      local int x1,y1,x2,y2;
      local eDrawType DT_mem;
      Local Vector vFocusLoc;
      local float XL, YL; // realtime length & width of icon
      local float fAlpha; // from 0.f to 1.f, 1 = transition ended
      local actor A;
      local vector HitLoc, HitNorm;
      local material HitMat;

//      Log("Angle="$normal(MyFocus.Location - (XIIIBaseHUD(Owner).PawnOwner.Location + XIIIBaseHUD(Owner).PawnOwner.EyePosition())) dot vector(XIIIBaseHUD(Owner).XIIIPlayerOwner.rotation));
      if ( normal(MyFocus.Location - (XIIIBaseHUD(Owner).PawnOwner.Location+XIIIBaseHUD(Owner).PawnOwner.EyePosition())) dot vector(XIIIBaseHUD(Owner).XIIIPlayerOwner.rotation) < 0.707 )
      {
        if (NextHudFoc != none)
          NextHudFoc.DrawWnd(C);
        if (( Level.TimeSeconds > EndOfLife ) && !bModeInfini )
          RemoveMe();
        return;
      }
      A = Trace(HitLoc, HitNorm, MyFocus.Location, XIIIBaseHUD(Owner).PawnOwner.Location, true, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanSeeThrough);
      if ( (A != none) && (A != MyFocus) )
      {
        if (NextHudFoc != none)
          NextHudFoc.DrawWnd(C);
        if (( Level.TimeSeconds > EndOfLife ) && !bModeInfini )
          RemoveMe();
        return;
      }

      if ( ( vSize(MyFocus.Location - XIIIBaseHUD(Owner).PawnOwner.Location) < 300 ) && !bModeInfini )
      {
        if (NextHudFoc != none)
          NextHudFoc.DrawWnd(C);
        RemoveMe();
        return;
      }

      if ( (Pawn(MyFocus) != none) && Pawn(Myfocus).bIsDead && (Pawn(MyFocus).Inventory == none) )
      { // ELR why focusing on a dead pawn w/out inventory ?
        if (NextHudFoc != none)
          NextHudFoc.DrawWnd(C);
        RemoveMe();
        return;
      }

      vFocusLoc = XIIIBaseHUD(Owner).XIIIPlayerOwner.Player.Console.WorldToScreen(MyFocus.Location);
      C.Style = ERenderStyle.STY_Alpha;

      fAlpha = (Level.TimeSeconds - StartOfLife - TRANSITDELAY) / TRANSITDELAY;
      XL = FocusWidth;
      YL = FocusHeight;
      XP1 = int(vFocusLoc.X - XL);
      XP2 = int(vFocusLoc.X + XL);
      YP1 = int(vFocusLoc.Y - YL);
      YP2 = int(vFocusLoc.Y + YL);
      // white border
/*
      C.DrawColor = C.Static.MakeColor(255,255,255,255);
      // Above
      C.SetPos(XP1 - 8, YP1 - 8);
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1) + 16, 8);
      // Left
      C.SetPos(XP1 - 8, YP1 - 8);
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, 8, (YP2 - YP1) + 16);
      // Under
      C.SetPos(XP1 - 8, YP2);
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1) + 16, 8);
      // Right
      C.SetPos(XP2, YP1 - 8);
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, 8, (YP2 - YP1) + 16);
*/

      if ( bUseVignette )
      {
        C.DrawColor = C.Static.MakeColor(0,0,0,0);
        C.BorderColor = C.Static.MakeColor(0,0,0,255);
        C.bUseBorder = true;
        // outer outline
        if ( bCartoonFocusDanger )
        {
          C.SetPos(XP1 - 1, YP1 - 1);
          C.DrawRect(XIIIBaseHUD(Owner).FondDlg, FocusWidth*2+2, FocusHeight*2+2);
        }
        else
        {
          C.SetPos(XP1 - 2, YP1 - 2);
          C.DrawRect(XIIIBaseHUD(Owner).FondDlg, FocusWidth*2+4, FocusHeight*2+4);
        }
        // inner outline
        C.SetPos(XP1, YP1);
        C.DrawColor = C.Static.MakeColor(255,255,255,255);
        if ( bCartoonFocusDanger )
          C.BorderColor = C.Static.MakeColor(190,66,24,255);
        else
          C.BorderColor = C.Static.MakeColor(255,255,255,255);
//        C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1), (YP2 - YP1));
//        Log("bUseVignette CWndX="$CWndX@"CWndY="$CWndY@FocusWidth*2$"x"@FocusHeight*2);
        C.DrawTile(XIIIBaseHUD(Owner).CWndMat, FocusWidth*2, FocusHeight*2, CWndX, CWndY, FocusWidth*2, FocusHeight*2);
        C.bUseBorder = false;
      }
      else
      {
        C.DrawColor = C.Static.MakeColor(0,0,0,0);
        C.BorderColor = C.Static.MakeColor(0,0,0,255);
        C.bUseBorder = true;
        // outer outline
        if ( bCartoonFocusDanger )
        {
          C.SetPos(XP1 - 1, YP1 - 1);
          C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1)+2, (YP2 - YP1)+2);
        }
        else
        {
          C.SetPos(XP1 - 2, YP1 - 2);
          C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1)+4, (YP2 - YP1)+4);
}
        // inner outline
        C.SetPos(XP1, YP1);
        if ( bCartoonFocusDanger )
          C.BorderColor = C.Static.MakeColor(190,66,24,255);
        else
          C.BorderColor = C.Static.MakeColor(255,255,255,255);
        C.DrawRect(XIIIBaseHUD(Owner).FondDlg, (XP2 - XP1), (YP2 - YP1));
        C.bUseBorder = false;
      }

      if ( (zoomFocus && (Level.Game != none) && (Level.Game.DetailLevel > 1)) && !(XIIIBaseHUD(Owner).XIIIPlayerOwner.bRenderPortal))
      {
        if (!XIIIPlayerPawn(XIIIBaseHUD(Owner).XIIIPlayerOwner.Pawn).bIsSniper)
        {
          if (!(XP2<0 || XP1>C.ClipX || YP2<0 || YP1>C.ClipY))
          {
            campos = myFocus.location - zoomCameraDistance*normal(MyFocus.location-XIIIBaseHUD(Owner).XIIIPlayerOwner.location) + vect(0,0,20);
            x1 = XP1;
            y1 = YP1;
            x2 = XP2;
            y2 = YP2;
            if (XP1<0) x1=0;
            if (YP1<0) y1=0;
            if (XP2>C.ClipX) x2=C.ClipX;
            if (YP2>C.ClipY) y2=C.ClipY;
            C.SetPos(x1, y1);
            DT_mem = DrawType;
            SetDrawType(DT_none);
            XIIIBaseHUD(Owner).XIIIPlayerOwner.bRenderPortal = true;
            C.DrawPortal(x1,y1,(x2-x1),(y2-y1),XIIIBaseHUD(Owner).XIIIPlayerOwner,campos,rotator(MyFocus.location-campos), zoomCameraFOV);
            XIIIBaseHUD(Owner).XIIIPlayerOwner.bRenderPortal = false;
            SetDrawType(DT_mem);
          }
        }
      }

      if (NextHudFoc != none)
        NextHudFoc.DrawWnd(C);
      if (( Level.TimeSeconds > EndOfLife ) && !bModeInfini )
        ReMoveMe();
    }
}



defaultproperties
{
     BorderColor=(B=255,G=255,R=255,A=255)
     FilterColor=(B=255,G=255,R=255)
     zoomCameraDistance=200.000000
     zoomCameraFOV=50.000000
}
