//-----------------------------------------------------------
// XBOX FILE
// Specific FX to be displayed when a falling occured
//-----------------------------------------------------------
class CWndFalling extends CWndBase;

var int iPhase;
var Actor Falling;  // should be the falling actor
var vector CamPos;
var texture onotext;
var float fov;

CONST WNDSIZE=256;
CONST SFXDURATION=3.0;
CONST SPACEX=17;

//SOUTHEND Moving frame code
//_____________________________________________________________________________
simulated function Tick(float DeltaT)
{
    local float temp;

    if (XIIIPlayerController(MyHudForFX.PlayerOwner.Pawn.Controller).multiViewport != none
     || XIIIPlayerController(MyHudForFX.PlayerOwner.Pawn.Controller).fCamViewPercent>0.0)
    {
      MyHUDForFX.EraseLowPriorityCartoonWindows();
//      Destroy(); // should not be needed as I'm Low priority
      return;
    }
    temp = VSize(falling.location-campos)*2.54/200;
    if (temp > 10.0)
      temp = 10.0;
    if (temp < 1.0)
      temp = 1.0;
    fov = 90 - 7*temp;

    HideUnwanted();
    switch (iPhase)
    {
      Case 1:
        MyHudForFX.CWndMat.Update( 0, 0, WNDSIZE, WNDSIZE, campos, rotator(falling.location - campos), fov, FilterColor,HighLight,FilterTexture );
      break;
    }
    RestoreUnwanted();
}


//_____________________________________________________________________________
event Timer()
{
    local float temp;

    DebugLog(self@"Timer, iPhase="$iPhase@"MyHudForFX="$MyHudForFX);

    if ( (iPhase == 0) && (MyHudForFX.HudWnd != none) )
    {
      MyHudForFX.EraseLowPriorityCartoonWindows();
      if ( MyHudForFX.HudWnd != none )
      {
        Destroy();
        return;
      }
    }
    iPhase ++;
    HideUnwanted();
    switch (iPhase)
    {
      Case 1:
        DebugLog(self@"Timer, iPhase="$iPhase@"MyHudForFX="$MyHudForFX);
        temp = VSize(falling.location-campos)*2.54/200;
        if (temp > 10.0)
          temp = 10.0;
        if (temp < 1.0)
          temp = 1.0;
        fov = 90 - 7*temp;

        MyHudForFX.CWndMat.Update( 0, 0, WNDSIZE, WNDSIZE, campos, rotator(falling.location - campos), fov, FilterColor,HighLight,FilterTexture );
//        Log("Add Falling CWnd");
        AddWnd(0, 0, (WNDSIZE-10)*3/4, (WNDSIZE-10), MyHudForFX.CWndMat, 0, WNDSIZE*1/8, WNDSIZE*3/4, WNDSIZE*7/8, SFXDURATION, true);
        SetTimer(3.5, true);

        CWndBorderColor = class'canvas'.static.MakeColor(0,0,0,0);
//        Log("Add Falling OnoTex");
        AddWnd(80, 100, 150, 100, onotext, 0, 0, onotext.USize, onotext.VSize, SFXDURATION, true);
        CWndBorderColor = default.CWndBorderColor;

        break;
      Case 2:
        Destroy();
        break;
    }
    RestoreUnwanted();
}


defaultproperties
{
     onotext=Texture'XIIICine.effets.death2'
     CWndAppearFX=2
     CWndSoundType=0
}
