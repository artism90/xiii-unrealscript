//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIBirds extends XIIITransientACreature;

var int MinFlockSize;     // number of slave birds
var int MaxFlockSize;
var int fSecurityDist;

//_____________________________________________________________________________
function PostBeginPlay()
{
    Super.PostBeginPlay();
    if ( Pawn == None )
      return;
    NumSlaves = MinFlockSize + Rand(MaxFlockSize-MinFlockSize);
}

//_____________________________________________________________________________
auto State Wandering
{
    function vector PickDestination(XIIITransientAPawn P)
    {
      local vector Dest;
      local XIIIBird B;

//      log(self$" Wandering PickDestination call");
      if ( P.bDestroySoon && (P.LastRenderTime > 1) )
      {
        P.Destroy();
        return P.Location;
      }
      B = XIIIBird(P);
      if ( FRand() < 0.5 )
        B.PlayCall();
//      Dest = FRand() * B.CircleRadius * VRand();
//      Dest.Z /= 2.0;
//      Dest += StartingSpot.Location + vect(0,0,100) + vect(0,0,1)*B.HeightOffset;
      Dest = StartingSpot.Location + vect(0,0,100) + vect(0,0,1)*B.HeightOffset;
/*
      if ( VSize(MyManager.LocalPlayer.Pawn.Location - B.Location) < FlockRadius )
        Dest.Z = FMax(Dest.Z,Location.Z) + 300;
      if ( Location.Z - Dest.Z > 200 )
        Dest.Z = Location.Z;
*/
      B.PlayGlideOrFly(Dest);
      return Dest;
    }

    function PickSlaveDestination(XIIITransientAPawn P)
    {
      local vector Dest;

      Dest = PickDestination(P);

      if ( P.bDeleteMe )
        return;

      P.Acceleration = P.AccelRate * Normal(Dest - P.Location);
      P.SleepTime = VSize(Dest - P.Location)/P.AirSpeed;
      P.DesiredRotation = Rotator(P.Acceleration);
    }

    function BeginState()
    {
      if ( NumSlaves > 0 )
        AddSlaves(XIIITransientAPawn(Pawn),NumSlaves);
    }
}



defaultproperties
{
     fSecurityDist=400
     MinSpawnDist=1500.000000
     MaxSpawnDist=15000.000000
     bCollideWorld=True
     Tag="'"
     CollisionRadius=80.000000
     CollisionHeight=60.000000
}
