//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIICreatureManager extends Info
     abstract
     placeable;

var XIIITransientACreature MyCreatures;   // Ambient creature list
var int NumCreatures;                     // Number of creatures controlled
var() int MaxCreatures;
var() class<XIIITransientACreature> TransientCreatures[8];  // allowable TransientAmbientCreature classes
var int NumClasses;                       // number of TransientAmbientCreature classes (determined in postbeginplay)
var PlayerController LocalPlayer;
var() int SpawnRadius;                    // radius of area to spawn creatures
var() int TriggerRadius;                  // radius of area to be triggered by player
var XIIITransientACreature Prey;          // last spawned creature - could be prey for next spawn

//_____________________________________________________________________________
function PostBeginPlay()
{
    local int i;

    log(self$" starting up!!!");
    Super.PostBeginPlay();

    if (Level.NetMode == NM_DedicatedServer )
    {
      Destroy();
      return;
    }

    For ( i=0; i<ArrayCount(TransientCreatures); i++ )
      if ( TransientCreatures[NumClasses] != None )
        NumClasses++;

    log(self$" started up w/ "$NumClasses$" TransientCreatures types");

    if ( TransientCreatures[0].default.LocationTypeForSpawn != none )
    {
      // We do spawn creatures on specific spots.
      SpawnAllCreaturesFromspots();
      log("all Creature Spawns should be done now on the correct location...");
    }
    else
      SetTimer(1.0,true);
}

//_____________________________________________________________________________
function XIIITransientACreature AddCreature(Class<XIIITransientACreature> SpawnClass, vector SpawnLoc, rotator SpawnRot)
{
    local XIIITransientACreature A;

    A = spawn(SpawnClass,self,,SpawnLoc+SpawnClass.Default.CollisionHeight*vect(0,0,1), SpawnRot);


    if ( (A != None) && A.bDeleteMe )
      A = A.Replacement;
    if ( (A != None) && !A.bDeleteMe )
    {
      A.NextCreature = MyCreatures;
      MyCreatures = A;
      NumCreatures++;
      return A;
    }
    return none;
}

//_____________________________________________________________________________
function RemoveCreature(XIIITransientACreature Remove)
{
    local XIIITransientACreature A;

    // check if A is in my list
    if ( Remove == MyCreatures )
      MyCreatures = Remove.NextCreature;
    else
    {
      for ( A=MyCreatures; A!=None; A=A.NextCreature )
        if ( A.NextCreature == Remove )
        {
          A.NextCreature = Remove.NextCreature;
          break;
        }
    }

    NumCreatures--;
}

//_____________________________________________________________________________
function bool InSpawnRange()
{
    return ( VSize(Location - LocalPlayer.Location) < SpawnRadius  );
}

//_____________________________________________________________________________
// check if should spawn or destroy temporary ambient creatures
function Timer()
{
    local XIIITransientACreature A;
    local Controller C;
    local class<XIIITransientACreature> SpawnClass;
    local float Dist;
    local vector SpawnLoc, SpawnDir, ViewPos;

    // make sure I know who my player is
    if ( LocalPlayer == None )
    {
      for ( C=Level.ControllerList; C!=None; C=C.NextController )
        if ( C.IsA('PlayerController')
          && (Viewport(PlayerController(C).Player) != None) )
        {
          LocalPlayer = PlayerController(C);
          break;
        }
    }

    for ( A=MyCreatures; A!=None; A=A.NextCreature )
      if ( Level.TimeSeconds - A.Pawn.LastRenderTime > 1 )
        A.NotVisible(); // after a few seconds, destroy

    // Add transient creature
    // Note - pawns will also inform me when they die, so I can spawn appropriate carrion feeders (after a little while)
    // and herd animals will ask for bugs
    // only add optional creatures if frame rate is high enough and there aren't too many
    // FIXME - add more initially, reduce maxcreatures if combat (how do you determine that?)
    log("Almost add creature, last render "$Region.Zone.LastRenderTime$" for "$Region.Zone);
    if ( Level.bDropDetail || (NumCreatures >= MaxCreatures)
//      || (Level.TimeSeconds - Region.Zone.LastRenderTime > 0.5)
      || (VSize(LocalPlayer.ViewTarget.Location - Location) > TriggerRadius) )
    {
      return;
    }

    // maybe wait a bit
    if ( VSize(LocalPlayer.ViewTarget.Velocity) < 200 )
    {
      if ( FRand() < 0.5 )
        return;
    }

    // pick what type of creature to spawn
    SpawnClass = TransientCreatures[Rand(NumClasses)];
    // add new creatures? - either beyond fog dist (if close) or far enough to be not visible (bugs)
    // or just off screen with AI to come on screen
    // bugs are added to their group one at a time
    // find a spot to spawn the creature
    log("try to spawn a "$SpawnClass);

    // pick spawn location
    Dist = SpawnClass.Default.MinSpawnDist + FRand() * (SpawnClass.Default.MaxSpawnDist - SpawnClass.Default.MinSpawnDist);
    SpawnDir = vector(LocalPlayer.Rotation);
    SpawnDir.Z = 0;
    SpawnLoc = LocalPlayer.ViewTarget.Location + Dist * Normal(SpawnDir);

    // make sure spawnlocation is within SpawnRadius
    if ( VSize(SpawnLoc - Location) > SpawnRadius )
      SpawnLoc = Location + SpawnRadius * Normal(SpawnLoc - Location);

    // check if now too close to player
    Dist = VSize(LocalPlayer.ViewTarget.Location - SpawnLoc);
    if ( Dist < SpawnClass.Default.MinSpawnDist )
      return;

    SpawnLoc = SpawnClass.Static.FindSpawnLocation(Dist,SpawnDir,LocalPlayer);
    log("try to spawn a "$SpawnClass$" at "$SpawnLoc);
    if ( SpawnLoc == vect(0,0,0) )
      return;

    Prey = AddCreature(SpawnClass, SpawnLoc, rotator(Spawndir));
    if ( (Prey != None)
      && (FRand() < 0.3)
      && (Prey.PredatorType != None)
      && (Prey.PredatorType.Default.MinSpawnDist < Dist) )
    {
      // sometimes spawn predator in conjunction with prey
      A = AddCreature(Prey.PredatorType, SpawnLoc, rotator(SpawnDir));
    }
    Prey = None;
}

//_____________________________________________________________________________
function SpawnAllCreaturesFromSpots()
{
    local XIIITransientACreature A;
    local actor other;
    local vector SpawnLoc, SpawnDir, ViewPos;

    log(" BEGIN spawning "$TransientCreatures[0]);
    ForEach AllActors( TransientCreatures[0].default.LocationTypeForSpawn, other )
    {
      if (other != none)
      {
        SpawnLoc = Other.Location;
        A = AddCreature(TransientCreatures[0], SpawnLoc, Other.Rotation);
        log("    Spawned "$TransientCreatures[0]$" at "$Other$" w/ rotation="$Other.Rotation);
        A.StartingSpot = KeyPoint(Other);
        A.Pawn.Event = Other.Event;
        A.Pawn.Tag = Other.Tag;
        A.Event = Other.Event;
        A.Tag = Other.Tag;
      }
      else
      {
        log("    No Location to spawn "$TransientCreatures[0]);
      }
    }
    log(" END spawning "$TransientCreatures[0]);
}



defaultproperties
{
     MaxCreatures=10
     SpawnRadius=6000
     TriggerRadius=8000
}
