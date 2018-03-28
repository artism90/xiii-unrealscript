//=============================================================================
//
//=============================================================================
class MapInfo extends Info
    abstract;

#exec Texture Import File=Textures\mapinfo_ico.tga Name=MapInfo_ico Mips=Off
#exec OBJ LOAD FILE=XIIICine.utx PACKAGE=XIIICine

var bool DBObjectives;
var() bool bBriefing;                                   // Do we have a briefing
var() bool NextMapKeepInventory;                        // Keep the inventory (Weapons/items) in the next map
var bool bLevelComplete;
var bool bFirstTime;
var bool EndCartoonEffect;

var() array<xiiipawn> PotentialNMi;

var(Shadows) int MaxTraceDistance;
var(Shadows) int ShadowIntensity;
var(Shadows) float ShadowMaxDist;
var(Shadows) float ShadowTransDist;
var float checkTime;
var XIIIPlayerController XIIIController;
var XIIIPawn XIIIPawn;

// ELR Memorize things for flashbacks
//var FakeXIIIPawn FakePawn;              // The pawn that will own our inventory until we're back
var XIIIPawn FakePawn;              // The pawn that will own our inventory until we're back

var int WeaponBeforeFlash;              // the weapon id we had in hand when going into flash
var PowerUps SelectedItemBeforeFlash;   // the item we had selected when going into flash

// Goal handling
struct XIIIGoals
{
    var() string GoalText;
    var bool bCompleted;
    var() bool bPrimary;
    var() bool bAntiGoal;
};

var(Objectifs) localized array<XIIIGoals> Objectif;
var(Objectifs) localized array<string> MessageGameOver;
var(Objectifs) localized string MessageMissionSuccess;

var string sIncompleteGoal;

var(Equipement) array< class<Inventory> > InitialInv;   // Inventory to give at the map start
var() string NextMapLevelWithUnr;                       // Next map to launch of objectives complete
var() texture NextLoadScreen;

var() localized string TexteDuBriefing;
var(NextMap) array<name> InventoryToDestroyBeforeNextMap;
var(NextMap) string EndMapVideo;


// MLK: Following vars are used to record spoken dialogs & to be able to consult the in the menu
var array<info> DlgMgr;     // this map dialog managers

struct DialIndex
{
    var byte Lineind, Speakerind;
};

var DialIndex _Dial;
var array<DialIndex> DialogToSave; // The structure that would be saved on disk
var array<string> sAllSentences; // Sentences for this map, separated by "scene"
var array<string> Speakers; // (Pawn) this map speakers -PawnName-, separated by "none"

//-----------------------------------------------------------------------------
// For dynamic load referencing by hand
// Forces some pointers to load (JOB)
var(ForcedLoading) array<texture> ForcedTextures;
var(ForcedLoading) array<mesh> ForcedMeshes;
var(ForcedLoading) array<staticmesh> ForcedStaticMeshes;
var(ForcedLoading) array<class> ForcedClasses;

var float MemFOVBeforeFlash;

//_____________________________________________________________________________
event ParseDynamicLoading(LevelInfo MyLI)
{
    local int i;
    Log("ParseDynamicLoading Actor="$self);
    if ( ForcedTextures.Length > 0 )
      for ( i=0; i< ForcedTextures.Length; i++ )
        MyLI.ForcedTextures[MyLI.ForcedTextures.Length] = ForcedTextures[i];
    if ( ForcedMeshes.Length > 0 )
      for ( i=0; i< ForcedMeshes.Length; i++ )
        MyLI.ForcedMeshes[MyLI.ForcedMeshes.Length] = ForcedMeshes[i];
    if ( ForcedStaticMeshes.Length > 0 )
      for ( i=0; i< ForcedStaticMeshes.Length; i++ )
        MyLI.ForcedStaticMeshes[MyLI.ForcedStaticMeshes.Length] = ForcedStaticMeshes[i];
    if ( ForcedClasses.Length > 0 )
      for ( i=0; i< ForcedClasses.Length; i++ )
      {
        MyLI.ForcedClasses[MyLI.ForcedClasses.Length] = ForcedClasses[i];
        if ( class<Inventory>(ForcedClasses[i]) != none )
    			class<Inventory>(ForcedClasses[i]).Static.StaticParseDynamicLoading(MyLI);
      }
    if ( InitialInv.Length > 0 )
      for ( i=0; i< InitialInv.Length; i++ )
      {
        if ( InitialInv[i] != none )
        {
          MyLI.ForcedClasses[MyLI.ForcedClasses.Length] = InitialInv[i];
    			InitialInv[i].Static.StaticParseDynamicLoading(MyLI);
    		}
      }
}

//_____________________________________________________________________________
function PostBeginPlay()
{
    local int i;

    for (i = 0; i < Objectif.Length; i++)
    {
      if ( Objectif[i].bAntiGoal )
        Objectif[i].bCompleted = true;
      else
        Objectif[i].bCompleted = false;
    }

    // start the script
    SetTimer(checkTime, false);
    bLevelComplete = false;

    // MLK: Better here for compatibility, FirstFrame() is executed too late
    XIIIGameInfo(Level.Game).MapInfo = self;
}

//_____________________________________________________________________________
function Timer()
{
    if ( bFirstTime )
      FirstFrame();
    if (!bLevelComplete)
      TestGoalComplete();
}

//_____________________________________________________________________________
function FirstFrame()
{
    local int i;

//    for (i=0; i<MessageGameOver.Length; i++)
//      Log("#### MessageGameOver["$i$"]="$MessageGameOver[i]);

    XIIIGameInfo(Level.Game).MapInfo=self;
    XIIIController=FindPlayerController();
    XIIIPawn=XIIIPawn(XIIIController.Pawn);
    SetupInitialInventory(XIIIPawn);
    bFirstTime=false;
    for (i=0; i<Objectif.Length; i++)
    {
      if ( Objectif[i].bPrimary && (!Objectif[i].bCompleted || Objectif[i].bAntiGoal) )
        DisplayGoal(i, false);
    }

    if ( Level.Game.GoreLevel != 0 )
    {
// PARENTAL LOCL ON
		ReplaceATextureByAnOther( Texture'XIIICine.effets.blodspotA', Texture'XIIICine.effets.blodspotAPL' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.bloodheadshotA', Texture'XIIICine.effets.bloodheadshotAPL' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.bloodprojM', Texture'XIIICine.effets.bloodprojMPL' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.goutteblood', Texture'XIIICine.effets.gouttebloodPL' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.jikleblood', Texture'XIIICine.effets.jiklebloodPL' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.projectionblodA', Texture'XIIICine.effets.projectionblodAPL' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.vignetteblood', Texture'XIIICine.effets.vignettebloodPL' );
	}
	else
	{
// PARENTAL LOCL OFF
		ReplaceATextureByAnOther( Texture'XIIICine.effets.blodspotAPL', Texture'XIIICine.effets.blodspotA' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.bloodheadshotAPL', Texture'XIIICine.effets.bloodheadshotA' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.bloodprojMPL', Texture'XIIICine.effets.bloodprojM' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.gouttebloodPL', Texture'XIIICine.effets.goutteblood' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.jiklebloodPL', Texture'XIIICine.effets.jikleblood' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.projectionblodAPL', Texture'XIIICine.effets.projectionblodA' );
		ReplaceATextureByAnOther( Texture'XIIICine.effets.vignettebloodPL', Texture'XIIICine.effets.vignetteblood' );
	}

    TriggerEvent('MapStart',self,none);
}

//_____________________________________________________________________________
function XIIIPlayerController FindPlayerController()
{
    local Controller C;
    for( C=Level.ControllerList; C!=None; C=C.nextController )
        if( C.IsA('XIIIPlayerController') )
        {
            return XIIIPlayerController(C);
        }
    return none;
}

//_____________________________________________________________________________
function Inventory GiveSomething(class<Inventory> ItemClass, XIIIPawn P)
{
  local Inventory NewItem;

  if( P.FindInventoryType(ItemClass)==None )
  {
    NewItem = Spawn(ItemClass,,,P.Location);
    if( NewItem != None )
      NewItem.GiveTo(P);
  }
  else
  {
    NewItem = P.FindInventoryType(ItemClass);
    if ( Ammunition(NewItem) != none )
      Ammunition(NewItem).AddAmmo(Class<Ammunition>(ItemClass).default.AmmoAmount);
//      Ammunition(NewItem).AmmoAmount += Class<Ammunition>(ItemClass).default.AmmoAmount;
  }
  return NewItem;
}

//_____________________________________________________________________________
function SetUpInitialInventory(XIIIPawn P)
{
    local int i;

    if ( P.IsPlayerPawn() )
      Log("### SetUpInitialInventory for "$P);
    for (i=0; i<InitialInv.Length; i++)
    {
      GiveSomething(InitialInv[i], P);
    }
    if ( P.IsPlayerPawn() )
      Log("### END SetUpInitialInventory");
}

//_____________________________________________________________________________
// Save the player's inventory to give him whatever we want in a flashback
function bool SaveInventoryForFlash(XIIIPawn P)
{
//    local FakeXIIIPawn FP;
    local XIIIPawn FP;
    local weapon W;
    local XIIIItems XI;

    if ( FakePawn != none )
      return true;

    // We do create the fake pawn that will hold the player's inventory
//    FP=Spawn(class'FakeXIIIPawn',,,P.Location);
    XIIIPawn.SetCollision(true, false, false);
    XIIIPawn.SetDrawType(DT_None);
    XIIIPawn.bIsInCine = true;
    class'XIIIPlayerPawn'.default.bCollideWorld = false;
//    class'XIIIPlayerPawn'.default.bCollideWhenPlacing = false;
    FP = Spawn(class'XIIIPlayerPawn',,,P.Location);
//    class'XIIIPlayerPawn'.default.bCollideWhenPlacing = true;
    class'XIIIPlayerPawn'.default.bCollideWorld = true;
    if ( FP != none )
    {
      Level.Game.AddDefaultInventory(FP);
      FP.SetRotation(XIIIPawn.Rotation);
      FakePawn = FP;
      XIIIWeapon(XIIIPawn.Weapon).UnFire(0); // ELR Make weapon react like if release fire (to disable grenad pb)
      XIIIController.UnPossess();
      XIIIController.Possess(FP);
      XIIIController.SetViewTarget(FP);
      MemFOVBeforeFlash = XIIIController.FOVAngle;
      XIIIController.FOVAngle = XIIIController.DefaultFOV;
      XIIIController.DesiredFOV = XIIIController.DefaultFOV;

//    [FRD] inscription a la basesoldierlist
  		level.game.BaseSoldierList.Length = level.game.BaseSoldierList.Length + 1;
      level.game.BaseSoldierList[level.game.BaseSoldierList.Length - 1] = FP;

      FP.SetRotation(XIIIPawn.Rotation);
      if ( XIIIPawn.bIsCrouched )
      {
        FP.ShouldCrouch(true);
        FP.StartCrouch(FP.CollisionHeight - FP.CrouchHeight);
        FP.EyeHeight = FP.BaseEyeHeight;
      }
      FP.bCollideWorld = true;
      FP.EyeHeight = FP.BaseEyeHeight;
      FP.SetCollision(true,true,true);
      Log("### Saving inventory before flash FakePawn="$FakePawn@"XIIIPawn="$XIIIPawn);
      return true;
    }
    // If unable to spawn playerpawn then
    Log("### BIG BUG ### COULD NOT SAVE INVENTORY BEFORE FLASH !!!");
    return false;
}

//_____________________________________________________________________________
// Restore the player's inventory after a flashback
function bool RestoreInventoryAfterFlash(XIIIPawn P)
{
	local int i;
    Log("### Restoring inventory before flash FakePawn="$FakePawn@"XIIIPawn="$XIIIPawn);
    if (FakePawn != none)
    {
		//    [FRD] suppression de la basesoldierlist
		for (i = 0; i <level.game.BaseSoldierList.Length; i++)
		{
			if (level.game.BaseSoldierList[i] == FakePawn )
			{
				level.game.BaseSoldierList.Remove(i,1);
				break;
			}
		}
		//
      XIIIController.UnPossess();
      XIIIController.Possess(XIIIPawn);
      XIIIController.SetViewTarget(XIIIPawn);
      XIIIController.FOVAngle = MemFOVBeforeFlash;
      XIIIController.DesiredFOV = MemFOVBeforeFlash;

      XIIIPawn.SetCollision(true, True, true);
      XIIIPawn.SetDrawType(DT_Mesh);
      XIIIPawn.bIsInCine = false;
      if ( XIIIPawn.bIsCrouched )
      {
        XIIIPawn.ShouldCrouch(true);
        XIIIPawn.StartCrouch(XIIIPawn.CollisionHeight - XIIIPawn.CrouchHeight);
        XIIIPawn.EyeHeight = XIIIPawn.BaseEyeHeight;
      }
      Log("   Restoring Weapon/Item Status WeaponMode ?"@XIIIController.bWeaponMode);
      if ( XIIIController.bWeaponMode )
      {
        Log("   WeaponMode, Weapon="$XIIIPawn.Weapon);
        if ( XIIIPawn.Weapon.HasAmmo() )
          XIIIPawn.Weapon.GotoState('Idle');
        else
        {
          XIIIController.NextWeapon();
          XIIIPawn.Weapon.gotoState('DownWeapon');
        }
      }
      else
      {
        Log("   ItemMode, Item="$XIIIPawn.SelectedItem);
        if ( XIIIPawn.SelectedItem != none )
          XIIIPawn.SelectedItem.GotoState('Idle');
        else
        {
          XIIIController.NextWeapon();
          XIIIPawn.ChangedWeapon();
        }
      }
      FakePawn.Destroy();
      FakePawn = none;
      return true;
    }
    return false;
}

//_____________________________________________________________________________
function PostRender(canvas C);

//_____________________________________________________________________________
function SetGoalComplete(int N)
{
    local string S;
    local string sGameOver;

    if (DBObjectives) Log("SetGoalComplete "$N);

    if ( Level.Game.bGameEnded )
      return;

    if ( N >= Objectif.Length )
      return;

    if ( Objectif[N].bAntiGoal && Objectif[N].bPrimary )
    {
      // too bad, game over.
      Objectif[N].bCompleted = false;
      sGameOver = sIncompleteGoal$MessageGameOver[N];
      Level.Game.EndGame( XIIIController.PlayerReplicationInfo, sGameOver );
      return;
    }

    Objectif[N].bCompleted = true;

    XIIIController.MyHUD.LocalizedMessage( class'XIIIGoalMessage', 1, XIIIController.PlayerReplicationInfo, none, self, Objectif[N].GoalText );
    TestGoalComplete();
    if ( bLevelComplete )
      DoTravel();
}

//_____________________________________________________________________________
FUNCTION DoTravel()
{
    LOCAL Inventory inv, inv2;
    LOCAL int i;

    Level.Game.EndGame( XIIIController.PlayerReplicationInfo, "GoalComplete" );

    Inv = XIIIPawn.Inventory;
    while ( Inv!=none )
    {
      Inv2 = Inv.Inventory; // Memorize next inventory
      if ( ( Inv.IsA('Keys') && !Inv.IsA('LockPick') ) || Inv.IsA('MagneticCard') )
        Inv.Destroy();
      if ( inv.IsA('Weapon') && (Weapon(inv).WHand == WHA_Deco) )
      {
        if ( XIIIPawn.Weapon == inv )
          XIIIPawn.Weapon = none;
        inv.Destroy();
      }
      Inv=Inv2;
    }

    for ( i=0; i<InventoryToDestroyBeforeNextMap.Length;i++)
    {
      while( true )
      {
        inv = XIIIPawn.FindInventoryKind( InventoryToDestroyBeforeNextMap[i] );
        if (inv == none)
          break;
        inv.Destroy();
      }
    }
}

//_____________________________________________________________________________
// Goal Become primary
function SetPrimaryGoal(int N)
{
    if (DBObjectives) Log("SetPrimaryGoal "$N);
    if ( !Objectif[N].bPrimary )
    {
      Objectif[N].bPrimary = true;
      DisplayGoal(N, true);
    }
}

//_____________________________________________________________________________
// Goal is not primary anymore
function SetSecondaryGoal(int N)
{
    if (DBObjectives) Log("SetSecondaryGoal "$N);
    if ( Objectif[N].bPrimary )
    {
      Objectif[N].bPrimary = false;
    }
}

//_____________________________________________________________________________
// Send goal to display
function DisplayGoal(int N, optional bool bDelay)
{
    if (DBObjectives) Log("Display Goal "$N$" delay="$bDelay);
//    XIIIController.ClientMessage( Objectif[N].GoalText, 'GoalType');
    if ( Objectif[N].bAntiGoal )
    {
      if (Objectif[N].GoalText != "")
      {
        if ( bDelay )
            XIIIController.MyHUD.LocalizedMessage( class'XIIIGoalMessage', 10, XIIIController.PlayerReplicationInfo, none, self, Objectif[N].GoalText );
          else
            XIIIController.MyHUD.LocalizedMessage( class'XIIIGoalMessage', 2, XIIIController.PlayerReplicationInfo, none, self, Objectif[N].GoalText );
      }
    }
    else if ( bDelay )
      XIIIController.MyHUD.LocalizedMessage( class'XIIIGoalMessage', 8, XIIIController.PlayerReplicationInfo, none, self, Objectif[N].GoalText );
    else
      XIIIController.MyHUD.LocalizedMessage( class'XIIIGoalMessage', 0, XIIIController.PlayerReplicationInfo, none, self, Objectif[N].GoalText );
}

//_____________________________________________________________________________
function TestGoalComplete()
{
    local int t, MissionEnd;

    if (DBObjectives) log("Testing goal");
    if (Objectif.Length > 0)
    {
      MissionEnd = 0;
      for (t = 0; t < Objectif.Length; t++)
      {
        if (Objectif[t].bCompleted) MissionEnd++;
      }

//      log("Objectives="$Objectif.Length$" MissionEnd="$MissionEnd);
      if (MissionEnd == Objectif.Length)
      {
        bLevelComplete = true;
      }
    }
    for (t = 0; t < Objectif.Length; t++)
      if (DBObjectives) log("  > Objective "$t$" Primary ? "$Objectif[t].bPrimary$" complete ?"$Objectif[t].bCompleted$" bAntiGoal ?"$Objectif[t].bAntiGoal);
}

//_____________________________________________________________________________
function CloseDoor(XIIIMover P, bool bLock)
{
    if ( !P.bClosed )
      P.PlayerTrigger(self, XIIIPawn);
    if ( bLock )
      p.BloqueePourLeJoueur = Les2Sens;
}

//_____________________________________________________________________________
// tell self that a pawn has been generated (to be taken into account if necessary)
function GeneratedPawn(Actor Generator, Pawn Other);




defaultproperties
{
     DBObjectives=True
     NextMapKeepInventory=True
     bFirstTime=True
     MaxTraceDistance=250
     ShadowIntensity=196
     ShadowMaxDist=1500.000000
     ShadowTransDist=1000.000000
     checkTime=0.100000
     MessageMissionSuccess="Level Completed"
     sIncompleteGoal="GoalIncomplete:"
     Texture=Texture'XIII.MapInfo_ico'
}
