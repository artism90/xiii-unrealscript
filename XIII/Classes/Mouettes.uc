//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Mouettes extends XIIIBirds;

//_____________________________________________________________________________
// Here we are on ground, waiting for the player to disturb us
auto state WaitingforPerturbation
{
    function BeginState()
    {
      Pawn.SetPhysics(PHYS_Walking);
      XIIIBird(Pawn).PlayOnGround();
      SetTimer(1.0, true);
    }

    function EndState()
    {
      Pawn.SetPhysics(PHYS_Flying);
      Pawn.Velocity=vect(0,0,400);
      SetTimer(0.0, false);
    }
    
    event HearNoise( float Loudness, Actor NoiseMaker)
    {
      if ( vSize(NoiseMaker.Location - location) < fSecurityDist*2 )
      {
        log(self$" had heard "$NoiseMaker$", Taking Off");
        GotoState('Wandering');
      }
    }

    event Trigger( Actor Other, Pawn EventInstigator )
    {
//        Log(self@"triggered");
//      if ( vSize(EventInstigator.Location - location) < fSecurityDist*2 )
//      {
        log(self$" had been triggerid by "$EventInstigator$", Taking Off");
        GotoState('Wandering');
//      }
    }

    function SeePlayer(Pawn seen)
    {
      if ( vSize(seen.Location - location) < fSecurityDist*2 )
      {
        log(self$" had seen "$seen$" near, Taking Off");
        GotoState('Wandering');
      }
    }

    function Timer()
    {
      local XIIIPawn other;
      
      foreach dynamicactors(class'XIIIPawn', other)
        if (vSize(other.Location - location) < fSecurityDist)
        {
          log(self$" near "$other$", Taking off");
          gotostate('Wandering');
        }
    }
    
    function vector PickDestination(XIIITransientAPawn P)
    {
      // Target in front of me to keep the Beginning node rotation
      return StartingSpot.Location + vector(StartingSpot.Rotation);
    }

Begin:
    Destination = PickDestination(XIIITransientAPawn(Pawn));
    FocalPoint = Destination;
}



defaultproperties
{
     PawnTypes(0)=Class'XIII.mouette'
     bOffCameraSpawns=False
     LocationTypeForSpawn=Class'XIII.MouetteSpot'
}
