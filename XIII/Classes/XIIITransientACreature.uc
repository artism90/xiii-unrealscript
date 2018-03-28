
// TransientAmbientCreature
// The base class of controllers for ambient creatures which are created an destroyed
// on the client as the player walks around (small stuff like bugs, birds, etc.)

//-----------------------------------------------------------
class XIIITransientACreature extends AIController;

var XIIICreatureManager MyManager;
var XIIITransientACreature NextCreature;    // transient ambient creature list managed by AmbientCreatureManager
var class<Pawn> PawnTypes[8];               // pawns which can be controlled by this controller on land - pick one when spawning
var class<XIIITransientACreature> PredatorType;    // who eats my pawns (optional)
var class<XIIITransientACreature> AltPredatorType; // who eats my pawns (optional)
var class<XIIITransientACreature> UnderWaterType;  // who to replace me with underwater (optional)
var float MinSpawnDist;                     // minimum distance for spawning in player's line of sight
var float MaxSpawnDist;                     // maximum distance for spawning in player's line of sight
var bool  bOffCameraSpawns;                 // if true, use off camera spawns
var bool  bUnderWaterCreatures;             // if true, my pawns are meant for underwater
var class<Pawn> PickedClass;
var XIIITransientACreature Prey;            // if hunter, what I'm hunting
var float FlockRadius;                      // radius in which to spawn slaves
var int NumSlaves;                          // number of slave pawns
var XIIITransientACreature Replacement;     // replacement if destroyed because of wrong zone
var class<XIIICreaturePoint> LocationTypeForSpawn;  // the points where the creatures should be spawned
var KeyPoint StartingSpot;                  // Starting Spot to turn/move around if needed


//_____________________________________________________________________________
function PostBeginPlay()
{
    Super.PostBeginPlay();

    MyManager = XIIICreatureManager(Owner);
    Prey = MyManager.Prey;

    // make sure in an appropriate zone
    if ( PhysicsVolume.bPainCausing )
    {
      Destroy();
      return;
    }
    if ( PhysicsVolume.bWaterVolume != bUnderWaterCreatures )
    {
      // try to replace me with underwater alternative
      if ( UnderWaterType != None )
        Replacement = spawn(UnderWaterType, Owner);

      Destroy();
      return;
    }

    AddPawn();
}

//_____________________________________________________________________________
function AddSlaves(XIIITransientAPawn Last, int SpawnNum)
{
    while (SpawnNum > 0)
    {
      SpawnNum--;
      Last.NextSlave = SpawnSlave();
      if ( Last.NextSlave != None )
      {
        NumSlaves--;
        Last.NextSlave.Controller = self;
        Last = Last.NextSlave;
      }
    }
}

//_____________________________________________________________________________
function XIIITransientAPawn SpawnSlave()
{
    local vector V, HitNormal, HitLocation;
    local actor HitActor;
    local float HitTime;

    V = InitialLocation(Pawn.Location);
    // check trace
    HitActor = Trace(HitLocation, HitNormal, V, Pawn.Location, false);
    if ( HitActor != None )
      V = HitLocation - (2 + Pawn.CollisionRadius) * Normal(V - Pawn.Location);
    return XIIITransientAPawn(spawn(Pawn.Class,self,,V));
}

//_____________________________________________________________________________
function vector InitialLocation(vector CurrentLocation)
{
    return (CurrentLocation + VRand() * FlockRadius);
}

//_____________________________________________________________________________
function AddPawn()
{
    local int NumClasses;
    local Pawn P;

    // add an appropriate pawn
    // note that I've been spawned at ground level
    if ( PickedClass == None )
    {
      While ( NumClasses < ArrayCount(PawnTypes) )
      {
        if ( PawnTypes[NumClasses] != None )
          NumClasses++;
        else
          break;
      }
      if ( NumClasses == 0 )
      {
        log(self$" have No pawn classes to spawn");
        return;
      }
      PickedClass = PawnTypes[Rand(NumClasses)];
    }
    P = Spawn(PickedClass,self,,Location + (PickedClass.Default.CollisionHeight + 2) * Vect(0,0,1), SpawnRotation());
    log("AddPawn : "$self$" Spawned his pawn "$P);
    if ( P != None )
      Possess(P);
    if ( Pawn == None )
      Destroy();
    else
    {
      Pawn.LastRenderTime = Level.TimeSeconds;
      if ( NumSlaves > 0 )
        Pawn.SetTimer(0.2, true);
    }
}

//_____________________________________________________________________________
function Rotator SpawnRotation()
{
    local Rotator SpawnRot;

    SpawnRot.Yaw = Rand(65535);
    return SpawnRot;
}

//_____________________________________________________________________________
function Destroyed()
{
    if ( MyManager != None )
      MyManager.RemoveCreature(self);
    Super.Destroyed();
}

//_____________________________________________________________________________
function NotVisible()
{
    if ( Pawn == None )
    {
      PawnDied();
      return;
    }
    XIIITransientAPawn(Pawn).VerifyLastRenderTime();
    if ( Level.TimeSeconds - Pawn.LastRenderTime > MaxHiddenTime() )
      XIIITransientAPawn(Pawn).DestroyAll();
}

//_____________________________________________________________________________
function float MaxHiddenTime()
{
    return ( 10 + 5 * FRand() );
}

//_____________________________________________________________________________
function SlavePawnDied(Pawn P)
{
    if ( P == Pawn )
      PawnDied();
}

//_____________________________________________________________________________
function PawnDied()
{
    if ( XIIITransientAPawn(Pawn).NextSlave != None )
      Possess(XIIITransientAPawn(Pawn).NextSlave);
    else
      Destroy();
}

//_____________________________________________________________________________
/* FindSpawnLocation()
Find a suitable spawn location for the ambient creature (far enough away from the player)
if none can be found, returns vect(0,0,0)
*/
static function vector FindSpawnLocation(float Dist, vector SpawnDir, PlayerController Viewer)
{
    local rotator SpawnRot;
    local actor HitActor;
    local vector HitLocation, HitNormal, SpawnLoc, StartLoc;
    // FIXME - some creatures may look for fixed spawn points (e.g. bat cave)

    // if off camera spawning, then modify spawndir
    // FIXME - don't always if beyond max visible distance (where thing is less than one pixel)
    if ( Default.bOffCameraSpawns && (!Viewer.Region.Zone.bDistanceFog || (Viewer.Region.Zone.DistanceFogEnd > Dist))  )
    {
      SpawnRot = Rotator(SpawnDir);
      if ( FRand() < 0.5 )
        SpawnRot.Yaw += Viewer.FOVAngle * 182; // 65536/360
      else
        SpawnRot.Yaw -= Viewer.FOVAngle * 182; // 65536/360

      SpawnDir = Vector(SpawnRot);
    }
    SpawnLoc = Viewer.ViewTarget.Location + Dist * SpawnDir;
    // find ground
    HitActor = Viewer.Trace(HitLocation, HitNormal, SpawnLoc, Viewer.ViewTarget.Location + Viewer.ViewTarget.CollisionRadius * Vect(0,0,1), false);

    if ( HitActor == None )
      return FindGround(Viewer, SpawnLoc);

    //  OK - try to go over obstacle
    HitActor = Viewer.Trace(HitLocation, HitNormal, HitLocation - 50 * HitNormal, HitLocation, false);

    if ( HitActor != None )
    {
      // give up?
      if ( (HitNormal.Z < 0.8)
        || (VSize(HitLocation - Viewer.ViewTarget.Location) < Default.MinSpawnDist) )
        return vect(0,0,0);

      return HitLocation;
    }

    // ok- go up
    StartLoc = HitLocation - 100 * HitNormal + vect(0,0,500);
    HitActor = Viewer.Trace(HitLocation, HitNormal, StartLoc, HitLocation - 100 * HitNormal, false);

    if ( HitActor != None )
      StartLoc = HitLocation;
    Dist = VSize(HitLocation - SpawnLoc);
    HitActor = Viewer.Trace(HitLocation, HitNormal, StartLoc + Dist * SpawnDir, StartLoc, false);

    if ( HitActor == None )
      return FindGround(Viewer, SpawnLoc);
    else if ( HitNormal.Z >= 0.8 )
      return HitLocation;

    return vect(0,0,0);
}

//_____________________________________________________________________________
static function vector FindGround(PlayerController Viewer, vector StartLoc)
{
    local actor HitActor;
    local vector HitLocation, HitNormal;

    // find ground
    HitActor = Viewer.Trace(HitLocation, HitNormal, StartLoc - vect(0,0,10000), StartLoc, false);
    if ( (HitActor == None) || (HitNormal.Z < 0.8) )
      return Vect(0,0,0);

    return HitLocation;
}

//_____________________________________________________________________________
function vector PickDestination(XIIITransientAPawn P)
{
    return Pawn.Location;
}

//_____________________________________________________________________________
function PickSlaveDestination(XIIITransientAPawn P);

//_____________________________________________________________________________
auto State Wandering
{
Begin:
    Destination = PickDestination(XIIITransientAPawn(Pawn));
    FocalPoint = Destination;
    Sleep(XIIITransientAPawn(Pawn).MoveTimeTo(Destination));
    if ( AmbientSound != None )
      SetLocation(Pawn.Location);
    Goto('Begin');
}

//     UnderWaterType=class'AmbientCreatures.FishSchool'


defaultproperties
{
     MinSpawnDist=500.000000
     MaxSpawnDist=3000.000000
     bOffCameraSpawns=True
     FlockRadius=200.000000
     RemoteRole=ROLE_None
}
