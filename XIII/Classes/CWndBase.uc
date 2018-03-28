//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CWndBase extends Effects;

var XIIIBaseHUD MyHudForFX;
var sound hCWndSound;
var color CWndBorderColor;
var color FilterColor;
var float HighLight;
var Material FilterTexture;
var int CWndAppearFX;
var int CWndSoundType;

CONST bDBCWnd=false;

var Color myColor;

//_____________________________________________________________________________
event PostBeginPlay()
{
    DebugLog(self@"PostBeginPlay");
    Super.PostBeginPlay();
}

//_____________________________________________________________________________
function AddWnd(float XPos, float YPos, float DXSize, float DYSize, BitMapMaterial Mat, float X, float Y, float XSize, float YSize, float Lifetime, bool bLowPrio)
{
    DebugLog(self@"AddWnd High Priority="$!bLowPrio);
    MyHudForFX.AddHudCartoonWindow(XPos, YPos, DXSize, DYSize, Mat, X, Y, XSize, YSize, Lifetime, CWndBorderColor, CWndAppearFX, bLowPrio);
}

//_____________________________________________________________________________
// Hide everything not wanted for display on CWnds
Function HideUnwanted()
{
    MyHudForFX.PlayerOwner.Pawn.bOwnerNoSee = false;
    if ( MyHudForFX.PlayerOwner.Pawn.weapon != none )
      MyHudForFX.PlayerOwner.Pawn.weapon.bOwnerNoSee = true;
    if ( MyHudForFX.PlayerOwner.Pawn.SelectedItem != none )
      MyHudForFX.PlayerOwner.Pawn.SelectedItem.bOwnerNoSee = true;
    if ( XIIIPawn(MyHudForFX.PlayerOwner.Pawn).LHand != none )
      XIIIPawn(MyHudForFX.PlayerOwner.Pawn).LHand.bOwnerNoSee = true;
}

//_____________________________________________________________________________
// Restore everything not wanted for display on CWnds
function RestoreUnWanted()
{
    MyHudForFX.PlayerOwner.Pawn.bOwnerNoSee = true;
    if ( MyHudForFX.PlayerOwner.Pawn.weapon != none )
      MyHudForFX.PlayerOwner.Pawn.weapon.bOwnerNoSee = false;
    if ( MyHudForFX.PlayerOwner.Pawn.SelectedItem != none )
      MyHudForFX.PlayerOwner.Pawn.SelectedItem.bOwnerNoSee = false;
    if ( XIIIPawn(MyHudForFX.PlayerOwner.Pawn).LHand != none )
      XIIIPawn(MyHudForFX.PlayerOwner.Pawn).LHand.bOwnerNoSee = false;
}


defaultproperties
{
     hCWndSound=Sound'XIIIsound.Interface__VignettesFx.VignettesFx__hVignette'
     CWndBorderColor=(B=255,G=255,R=255,A=255)
     FilterColor=(B=255,G=255,R=255)
     CWndSoundType=2
     bHidden=True
}
