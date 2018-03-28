//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CWndFullScreen extends CWndBase;

var color FilterColor;
var bool WndIsUpdate;

event PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(0.01, false);
}

//_____________________________________________________________________________
event Timer()
{
    local vector CameraLocation;
    local rotator CameraRotation;
    local actor ViewActor;

    MyHudForFX.XIIIPlayerOwner.PlayerCalcView(ViewActor,CameraLocation,CameraRotation);
    MyHudForFX.CWndMat.Update( 0, 0, 255, 255, CameraLocation, CameraRotation, MyHudForFX.XIIIPlayerOwner.defaultFOV, FilterColor,0,none  );
	WndIsUpdate = true;
//    Log("ScreenShot ----> FOV="@MyHudForFX.XIIIPlayerOwner.defaultFOV);
}


defaultproperties
{
     FilterColor=(B=255,G=200,R=200,A=100)
}
