//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIITransientAPawn extends XIIIAmbientPawn
     notplaceable
     abstract;

var bool bFlyer;
var bool bSwimmer;
var bool bDestroySoon;
var bool bPermanent;
var XIIITransientAPawn NextSlave; // list of slave pawns
var float SleepTime;

//_____________________________________________________________________________
function MakePermanent()
{
    bPermanent = true;
    bStasis = true;
}

//_____________________________________________________________________________
function Destroyed()
{
    local XIIITransientAPawn T;

    Super.Destroyed();
    if ( Controller != None )
    {
      if ( Controller.Pawn == self )
        XIIITransientACreature(Controller).SlavePawnDied(self);

      // remove self from slave list
      for ( T=XIIITransientAPawn(Controller.Pawn); T!=None; T=T.NextSlave )
        if ( T.NextSlave == self )
        {
          T.NextSlave = NextSlave;
          break;
        }
    }
}

//_____________________________________________________________________________
// add slaves
function Timer()
{
    local int SpawnNum, NumSlaves;
    local XIIITransientAPawn Last;

    NumSlaves = XIIITransientACreature(Controller).NumSlaves;
    if ( (Controller.Pawn != Self) || (NumSlaves <= 0) )
    {
      SetTimer(0.0, false);
      return;
    }

    if ( NumSlaves < 4 )
      SpawnNum = Min(NumSlaves,2);
    else
      SpawnNum = NumSlaves/4;

    Last = self;
    While ( Last.NextSlave != None )
      Last = Last.NextSlave;

    XIIITransientACreature(Controller).AddSlaves(Last,SpawnNum);
}

//_____________________________________________________________________________
function DestroyAll()
{
    Destroy();

    if ( NextSlave != None )
      NextSlave.DestroyAll();
}

//_____________________________________________________________________________
function VerifyLastRenderTime()
{
    if ( bPermanent )
    {
      Controller.Pawn.LastRenderTime = Level.TimeSeconds;
      return;
    }
    Controller.Pawn.LastRenderTime = Max(LastRenderTime,Controller.Pawn.LastRenderTime);
    if ( NextSlave != None )
      NextSlave.VerifyLastRenderTime();
}

//_____________________________________________________________________________
event FellOutOfWorld()
{
    Destroy();
}

//_____________________________________________________________________________
function bool EncroachingOn( actor Other )
{
    if ( (Other.Brush != None) || (Brush(Other) != None) )
      return true;

    return false;
}

//_____________________________________________________________________________
function EncroachedBy( actor Other )
{
}

//_____________________________________________________________________________
singular function PhysicsVolumeChange( PhysicsVolume NewVolume )
{
    if ( (NewVolume.bWaterVolume && !bSwimmer) )
    {
      Velocity *= -1;
      Acceleration *= -1;
    }
}

//_____________________________________________________________________________
function float MoveTimeTo(vector Destination)
{
    return 1;
}

//_____________________________________________________________________________
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
                              Vector momentum, class<DamageType> damageType)
{
    Died(instigatedBy.Controller,damageType,hitLocation);
}

//_____________________________________________________________________________
function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    if ( Controller.Pawn == self )
      Controller.PawnDied();
    PlayDying(DamageType, HitLocation);
    GotoState('Dying');
    if ( PhysicsVolume.bDestructive )
    {
      Destroy();
      return;
    }
}

//_____________________________________________________________________________
function float GetSleepTime()
{
    return (SleepTime * FRand());
}

//_____________________________________________________________________________
// Wandering state used only by Slave Pawns
auto state Wandering
{
    ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

begin:
    if ( Controller == None )
      Destroy();
    else if ( Controller.Pawn != self )
    {
      if ( Controller.Pawn == None )
      {
        Controller.PawnDied();
        Controller.GotoState('Wandering','KeepGoing');
      }
      else
      {
        // slaves pick destination to follow master pawn
        XIIITransientACreature(Controller).PickSlaveDestination(self);
        Sleep( GetSleepTime() );
        Goto('Begin');
      }
    }
}

//_____________________________________________________________________________
State Dying
{
    ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

    function Landed(vector HitNormal)
    {
      SetPhysics(PHYS_None);
      GotoState('Dying', 'Dead');
      //fixme - destroy and leave splat mark if bug
    }

    function BeginState()
    {
      // don't call super
    }

Dead:
    Sleep(5);
    if ( Level.bDropDetail || (Level.TimeSeconds - LastRenderTime > 1) )
      Destroy();
    else
      Goto('Dead');
Begin:
    AnimRate = 0;
    SetPhysics(PHYS_Falling);
}



defaultproperties
{
     SleepTime=2.000000
     bLOSHearing=False
     bUnlit=True
     bCollideActors=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     RemoteRole=ROLE_None
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
