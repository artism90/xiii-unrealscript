//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MitraillGuardController extends AIController;

var XIIIPawn XIIITarget;      // the current target
var MitraillTop GunnedTurret; // the controlled turret.
var float fAcquireTimer;      // time to recognize player & shoot.
//var bool bAware;              // Player already seen, target faster.
var float fTraceAccuracy;     // Accuracy of the shoot, more accurate w/ time
var int TeamID;

//_____________________________________________________________________________
auto state Gunning
{
    function Tick(float DT)
    {
      local rotator R;
      local vector X,Y,Z;

      if ( XIIITarget == none )
      {
        GunnedTurret.TrySetRotation(Rotation);
        bFire = 0.0;
      }
      else
      {
        if( ( !FastTrace(XIIITarget.Location, GunnedTurret.Location) ) || ( XIIITarget.bIsDead ) )
        {
          XIIITarget = none;
          GunnedTurret.TrySetRotation(Rotation);
          bFire = 0.0;
          return;
        }
        X = XIIITarget.Location - Location;
        Z = vect(0,0,1);
        Y = Z cross X;
        R = OrthoRotation(X,Y,Z);
        if ( GunnedTurret.TrySetRotation(R) )
        {
          if ( bFire == 0.0 )
          {
            bFire = 1.0;
            GunnedTurret.Fire();
          }
          else
          {
//            Log("fTraceAccuracy="$fTraceAccuracy);
            GunnedTurret.TraceAccuracy = fTraceAccuracy;
            fTraceAccuracy = (fTraceAccuracy * (1/DT) + 5.0) / (1/DT + 1);
          }
        }
        else
          bFire = 0.0;
      }
      SetRotation(GunnedTurret.Rotation);
    }

    function SeePlayer(Pawn SeenPlayer)
    {
//      log(SeenPlayer.Controller.PlayerReplicationInfo.Team.TeamIndex@GunnedTurret.TeamID);

      if( SeenPlayer.Controller.PlayerReplicationInfo.Team.TeamIndex == GunnedTurret.TeamID )
          return;

      if ( (XIIITarget == none) && (vSize(SeenPlayer.Location - GunnedTurret.Location) < GunnedTurret.TraceDist) )
      {
        fAcquireTimer = GunnedTurret.fGuardReactionDelay + frand() * 1.0;
/*        if ( bAware )
          fAcquireTimer /= 2.0; */
        SetTimer(fAcquireTimer, false);
        XIIITarget = XIIIPawn(SeenPlayer);
        fTraceAccuracy = 120.0;
      }
    }

    function Timer()
    {
      if ( (XIIITarget != none) && FastTrace(XIIITarget.Location, GunnedTurret.Location) )
      {
//        bAware=true;
        Enable('tick');
      }
      else
      {
        XIIITarget = none;
        Disable('tick');
      }
    }

Begin:
  Disable('Tick');
  Sleep(0.5);
  GunnedTurret = MitraillTop(Pawn.ControlledActor);
}



defaultproperties
{
}
