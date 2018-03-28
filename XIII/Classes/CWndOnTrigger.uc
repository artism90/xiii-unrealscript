//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CWndOnTrigger extends CWndBase;

var bool bSeeXIII;

var int iPhase;
var float CWndDuration, CWndFOV;
var actor Cam;
var actor Tar;
var vector vTarOffset;
var int vScrPosX, vScrPosY;
var int CWndSizeX;
var int CWndSizeY;
var int iA, iB;

// SE XBOX Specific (to be used in SPCWndOnTriggerclass)
var bool bAnimatedInRealtime;
var float AnimationDuration;
// SE XBOX END

var texture OnoTexture;
var int OnoPosX;
var int OnoPosY;
var int OnoSize;
var int OnoSizeY;

var array<string> OverlayMsg;     // message to display in overlay
var HudCartoonWindow LastCWnd;

var Color myColor;

//_____________________________________________________________________________
event PostBeginPlay()
{
    if ( bDBCWnd )
      Log(self@"CWndOnTrigger PostBeginPlay RealTime="$bAnimatedInRealtime);
    Super.PostBeginPlay();
/*
    if ( bAnimatedInRealtime )
      Enable('Tick');
    else
      Disable('Tick');
*/
}

//_____________________________________________________________________________
// real time update of CWnd material
simulated function Tick(float DeltaT)
{
    if ( XIIIPawn(Tar) != none )
    { // cancel realtime computing if target has died to avoid him disappear if XIII grab him
      if ((Pawn(Tar).bIsDead || XIIIPawn(Tar).IsDead()) && !Pawn(Tar).IsAnimating())
        bAnimatedInRealtime = false;
      else if ( Pawn(Tar).bHidden )
        bAnimatedInRealtime = false;
      // Change filter color if target pawn died
      if ( Pawn(Tar).bIsDead )
        FilterColor = class'Canvas'.Static.MakeColor(255,0,0,128);
    }

    if ( !bAnimatedInRealtime )
    {
      if ( bDBCWnd )
        Log(self@"CWndOnTrigger Tick Disabling Tick");
      Disable('Tick');
      return;
    }


//    if ( bDBCWnd )
//      Log(self@"CWndOnTrigger Tick");
    HideUnwanted();
    MyHudForFX.PlayerOwner.Pawn.bOwnerNoSee = !bSeeXIII;

    switch (iPhase)
    {
      Case 1:
	  	MyHudForFX.CWndMat.Update( iA, iB, CWndSizeX, CWndSizeY, cam.location, rotator(Tar.location+vTarOffset-cam.location), CWndFOV, FilterColor,HighLight,FilterTexture );
      break;
    }
    RestoreUnwanted();
}

//_____________________________________________________________________________
event Timer()
{
    if (iPhase==0)
      MyHudForFX.EraseLowPriorityCartoonWindows();
    iPhase ++;
    if ( bDBCWnd )
      Log(self@"CWndOnTrigger Timer "$IPhase);
    HideUnwanted();
    MyHudForFX.PlayerOwner.Pawn.bOwnerNoSee = !bSeeXIII;

    switch (iPhase)
    {
      Case 1:
        MyHudForFX.CWndMat.AllocRect( CWndSizeX, CWndSizeY, iA,iB );
        if ( bDBCWnd )
          Log("Displaying window coords="$iA@""$iB@" for image"$CWndSizeX$"x"$CWndSizeY);

        if ( (iA >= 0) && (iB >= 0) )
        {
          MyHudForFX.CWndMat.Update( iA, iB, CWndSizeX, CWndSizeY, Cam.location, rotator(Tar.location+vTarOffset-Cam.location), CWndFOV, FilterColor,HighLight,FilterTexture );
          LastCWnd = MyHudForFX.HudWnd;
          if ( LastCWnd != none ) // memorize last CWnd to include OverLayMsg to the new one
          {
            while ( LastCWnd.NextHudWnd != none )
            {
              LastCWnd = LastCWnd.NextHudWnd;
            }
          }
          AddWnd(vScrPosX, vScrPosY, CWndSizeX, CWndSizeY, MyHudForFX.CWndMat, iA, iB, CWndSizeX, CWndSizeY, CWndDuration, false);

          if ( LastCWnd == none ) // Add OverLayMsg
            MyHudForFX.HudWnd.OverlayMsg = OverlayMsg;
          else
            LastCWnd.NextHudWnd.OverlayMsg = OverlayMsg;

          if ( OnoTexture != none )
          {
            CWndBorderColor = class'canvas'.static.MakeColor(0,0,0,0);
            AddWnd(OnoPosX, OnoPosY, OnoSize, OnoSizeY, OnoTexture, 0, 0, OnoTexture.USize, OnoTexture.VSize, CWndDuration, false);
            CWndBorderColor = default.CWndBorderColor;
          }
          if ( CWndSoundType > 0 )
            Owner.PlaySound(hCWndSound, CWndSoundType);

          if (bAnimatedInRealtime)
            SetTimer(AnimationDuration, false);
          else
            SetTimer(0.1, false);
        }
        else
        {
          bAnimatedInRealtime = false;
          LOG(" Cancel CWND Creation for Cam="$Cam@"Tar="$Tar);
          SetTimer(0.1, false);
        }
        break;
      Case 2:
        Destroy();
        break;
    }
    RestoreUnwanted();
}


defaultproperties
{
}
