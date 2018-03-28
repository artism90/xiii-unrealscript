//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIICorpse extends XIIIPawn;

var() array< class<Inventory> > InitialInv;   // Inventory to give the corpse
var() int iPreDefinedDeath;
var CorpseBlood CB;

//_____________________________________________________________________________
event ParseDynamicLoading(LevelInfo MyLI)
{
    local int i;

    Log("ParseDynamicLoading Actor="$self);
    for (i=0; i<InitialInv.Length; i++)
    {
      MyLI.ForcedClasses[MyLI.ForcedClasses.Length] = InitialInv[i];
      (InitialInv[i]).Static.StaticParseDynamicLoading(MyLI);
    }
}

//_____________________________________________________________________________
function PostBeginPlay()
{
//  Super.PostBeginPlay();
  SetupInitialInventory(self);
}

//_____________________________________________________________________________
function GiveSomething(class<Inventory> ItemClass, XIIIPawn P)
{
  local Inventory NewItem;

  if( P.FindInventoryType(ItemClass)==None )
  {
    NewItem = Spawn(ItemClass,,,P.Location);
    if( NewItem != None )
      NewItem.GiveTo(P);
  }
  else if ( Class<Ammunition>(ItemClass) != none )
  {
    NewItem = P.FindInventoryType(ItemClass);
    if (NewItem != None)
      Ammunition(NewItem).AmmoAmount += Class<Ammunition>(ItemClass).default.AmmoAmount;
  }
}

//_____________________________________________________________________________
function SetUpInitialInventory(XIIIPawn P)
{
    local int i;

    for (i=0; i<InitialInv.Length; i++)
    {
      GiveSomething(InitialInv[i], P);
    }

}

//_____________________________________________________________________________
auto state Dead
{
    ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange,
        Falling, BreathTimer, Tick, AnimEnd, TakeDamage;

    // prone body should have low height, wider radius
    function ReduceCylinder()
    {
      local float OldHeight, OldRadius;
      local vector OldLocation;

      SetCollision(True,False,False);
      OldHeight = CollisionHeight;
      OldRadius = CollisionRadius;
      SetCollisionSize(1.7 * Default.CollisionRadius, CarcassCollisionHeight);
      PrePivot = vect(0,0,1) * (OldHeight - CollisionHeight); // FIXME - changing prepivot isn't safe w/ static meshes
      OldLocation = Location;
      if ( !SetLocation(OldLocation - PrePivot) )
      {
        SetCollisionSize(OldRadius, CollisionHeight);
        if ( !SetLocation(OldLocation - PrePivot) )
        {
          SetCollisionSize(CollisionRadius, OldHeight);
          SetCollision(false, false, false);
          PrePivot = vect(0,0,0);
          if ( !SetLocation(OldLocation) )
               ChunkUp(200);
        }
      }
      PrePivot = PrePivot + vect(0,0,3);
    }
    function BeginState()
    {
      PlayDyingAnim(class'DTSuicided', vect(5,0,0));
      ReduceCylinder(); // Kept this to avoid visual pbs
      if ( CB == none )
      {
        if ( (Level.Game != none) && (Level.Game.GoreLevel == 0) )
          CB = spawn(class'CorpseBlood', self,, Location - (CollisionHeight-8) * vect(0,0,1), rotator(vect(0,0,-1)));
//        CB.DetachProjector(true);
//        CB.SetDrawScale(fRand()*0.35 + 0.1);
//        CB.AttachProjector();
      }

    }
    function bool IsDead()
    {
      return true;
    }
}

//_____________________________________________________________________________
simulated function PlayDyingAnim(class<DamageType> DamageType, vector HitLoc)
{
    local int i;

    if ( (iPreDefinedDeath >= 0) && (iPreDefinedDeath <= 7) )
      I = iPreDefinedDeath;
    else
      I = rand(10);
    switch(I)
    {
      case 0: PlayAnim('DeathEpauleGauche',120.0); break;
      case 1: PlayAnim('DeathChevilleGauche',120.0); break;
      case 2: PlayAnim('DeathChevilleDroite',120.0); break;
      case 3: PlayAnim('DeathBuste3',120.0); break;
      case 4: PlayAnim('DeathDos',120.0); break;
      case 5: PlayAnim('DeathVentre',120.0); break;
      case 6: PlayAnim('DeathBuste0',120.0); break;
      case 7: PlayAnim('DeathBuste2',120.0); break;
      case 8: PlayAnim('DeathTete2',120.0); break;
      case 9: PlayAnim('DeathTete',120.0); break;
      case 10: PlayAnim('DeathEpauleGauche',120.0); break;
    }
}

//    ControllerClass=class'XIII.Cadavre'


defaultproperties
{
     iPreDefinedDeath=-1
     bSearchable=True
     bIsDead=True
     Health=0
     ControllerClass=None
     CarcassCollisionHeight=23.000000
     bPhysicsAnimUpdate=False
     bStasis=True
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     Mesh=SkeletalMesh'XIIIPersos.XIIIM'
     CollisionHeight=78.000000
}
