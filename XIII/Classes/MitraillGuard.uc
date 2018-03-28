//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MitraillGuard extends XIIIPawn
    NotPlaceable;

var int TeamID;
//_____________________________________________________________________________
event PostBeginPlay()
{
    Super.PostBeginPlay();
    if ( (ControllerClass != None) && (Controller == None) )
      Controller = spawn(ControllerClass);

    MitraillGuardController(Controller).TeamID=TeamID;
    //log("++++++++++ MitraillGuard"@TEamID@"++++++++++++");
    ShouldCrouch(true);
}



defaultproperties
{
     ControllerClass=Class'XIII.MitraillGuardController'
     DrawType=DT_None
     Mesh=SkeletalMesh'XIIIPersos.XIIIM'
}
