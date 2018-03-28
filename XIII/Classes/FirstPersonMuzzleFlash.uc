//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FirstPersonMuzzleFlash extends InventoryAttachment;

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
}



defaultproperties
{
     bAcceptsProjectors=False
     bTearOff=True
     bUnlit=True
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'StaticExplosifs.MuzzleFlash_NMI'
     Style=STY_Translucent
}
