//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HeadShotSFXTrigger extends XIIITriggers;

var() color FilterColor;
var() float HighLight;
var() Material FilterTexture;

//____________________________________________________________________
// Triggered by a character when dying, check if died by requireed cond then spawn CWndHeadShot
function Trigger( actor Other, pawn EventInstigator )
{
    // Other = Dead, EventInstigator = Killer
    Local XIIIPawn XP;
    Local CWndHeadShot CWnd;

    if ( !EventInstigator.IsPlayerPawn() )
      return;

    XP = XIIIPawn(Other);
    DebugLog("HeadShotSFXTrigger by "$XP$" HitDamageType="$XP.HitDamageType);
    if ( (XP == none) || (XP.HitDamageType != class'DTHeadShot') )
      return;

    XP = XIIIPlayerPawn(EventInstigator);
    if ( XIIIBaseHUD(XIIIPlayerController(XP.Controller).MyHud).HudDlg != none )
      return;
    XIIIBaseHUD(XIIIPlayerController(XP.Controller).MyHud).EraseLowPriorityCartoonWindows();
    if ( CWnd != none )
        CWnd.Destroy();
    CWnd = Spawn(class'XIII.CWndHeadShot',XP);
    if ( CWnd != none )
    {
      CWnd.Killed = XIIIPawn(Other);
      CWnd.MyHudForFX = XIIIBaseHUD(XIIIPlayerController(XP.Controller).MyHud);
      CWnd.FilterColor = FilterColor;
      CWnd.HighLight = HighLight;
      CWnd.FilterTexture = FilterTexture;
      CWnd.Timer();
      DebugLog("HeadShotSFXTrigger NewCWnd"@CWnd);
    }
//    Destroy(); // now this can be triggered several times
}



defaultproperties
{
     FilterColor=(G=116,R=244,A=150)
     HighLight=0.300000
}
