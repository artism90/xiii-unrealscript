//-----------------------------------------------------------
// XBOX FILE
// Specific FX to be displayed when a Explosion occured
//-----------------------------------------------------------
class CWndExplosion extends CWndBase;

var int iPhase;
//var XIIIPawn Killed;  // should be the dying guy
var Actor Explosion;  // should be the explosion
var vector CamPos;
//var texture CornerTexture;
var texture onotext;
var float fov;

CONST WNDSIZE=256;
CONST SFXDURATION=3.0;
CONST SPACEX=17;

//SOUTHEND Moving frame code
//_____________________________________________________________________________
simulated function Tick(float DeltaT)
{
    if (XIIIPlayerController(MyHudForFX.PlayerOwner.Pawn.Controller).multiViewport != none
      || XIIIPlayerController(MyHudForFX.PlayerOwner.Pawn.Controller).fCamViewPercent>0.0)
    {
      MyHUDForFX.EraseLowPriorityCartoonWindows();
      Destroy();
      return;
    }
    HideUnwanted();
    MyHudForFX.PlayerOwner.Pawn.bOwnerNoSee = true; // for these force not seeing the player
    switch (iPhase)
    {
      Case 1:
        MyHudForFX.CWndMat.Update( 0, 0, WNDSIZE, WNDSIZE, campos, rotator(explosion.location + vect(0,0,10) - campos), fov, FilterColor,HighLight,FilterTexture );
      break;
    }
    RestoreUnwanted();
}


//_____________________________________________________________________________
event Timer()
{
    local float temp;
    if (iPhase==0 && MyHudForFX.HudWnd!=none)
    {
      Destroy();
      return;
    }
    iPhase ++;
    HideUnwanted();
    switch (iPhase)
    {
      Case 1:
        temp = VSize(explosion.location-campos)*2.54/200;
        if (temp > 10.0)
          temp = 10.0;
        if (temp < 1.0)
          temp = 1.0;
        fov = 120 - 7*temp;

        MyHudForFX.CWndMat.Update( 0, 0, WNDSIZE, WNDSIZE, campos, rotator(explosion.location + vect(0,0,10) - campos), fov, FilterColor,HighLight,FilterTexture );
        AddWnd(0, 0, WNDSIZE-10, (WNDSIZE-10)*3/4, MyHudForFX.CWndMat, 0, WNDSIZE*1/8, WNDSIZE, WNDSIZE*3/4, SFXDURATION, true);
        SetTimer(3.5, true);

        CWndBorderColor = class'canvas'.static.MakeColor(0,0,0,0);
        AddWnd(100, 100, 200, 200, onotext, 0, 0, onotext.USize, onotext.VSize, SFXDURATION, true);
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
     onotext=Texture'XIIICine.effets.Baommm'
     CWndAppearFX=1
     CWndSoundType=0
}
