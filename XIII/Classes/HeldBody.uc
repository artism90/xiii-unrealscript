//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HeldBody extends InventoryAttachment;

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
}

//_____________________________________________________________________________
simulated event PostNetBeginPlay()
{
    Super(Actor).PostNetBeginPlay();
}

//_____________________________________________________________________________
state UnGrabbed
{
    Event AnimEnd(int channel)
    {
      Destroy();
    }
}



defaultproperties
{
     RelativeLocation=(X=-16.799999,Y=40.599998,Z=80.000000)
     RelativeRotation=(Yaw=16384)
     Mesh=SkeletalMesh'XIIIPersos.XIIIM'
     DrawScale=0.300000
}
