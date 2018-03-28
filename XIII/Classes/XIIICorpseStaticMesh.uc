//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIICorpseStaticMesh extends XIIIPawn;

var() array< class<Inventory> > InitialInv;   // Inventory to give the corpse
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
    bCanBeGrabbed = false;
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

    function BeginState()
    {
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



defaultproperties
{
     bSearchable=True
     bIsDead=True
     Health=0
     ControllerClass=None
     bPhysicsAnimUpdate=False
     bStasis=True
     bAcceptsProjectors=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     bUseCylinderCollision=True
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'PersosMorts.GI_Mort'
     CollisionRadius=58.000000
     CollisionHeight=24.000000
}
