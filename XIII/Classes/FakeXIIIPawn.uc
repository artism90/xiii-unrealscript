//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FakeXIIIPawn extends XIIIPawn;

//_____________________________________________________________________________
// ELR
event PostBeginPlay()
{
    Super(Pawn).PostBeginPlay();
}



defaultproperties
{
     GroundSpeed=0.000000
     WaterSpeed=0.000000
     AirSpeed=0.000000
     bPhysicsAnimUpdate=False
     bStasis=True
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
}
