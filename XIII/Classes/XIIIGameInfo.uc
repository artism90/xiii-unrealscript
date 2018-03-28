//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIGameInfo extends GameInfo;

enum PlatForm
{
  PF_PC,
  PF_PS2,
  PF_XBOX,
  PF_GC,
};
var config PlatForm PlateForme;   // Current Game System running on
var MapInfo MapInfo;              // Contain the MapInfo if it's there
var bool bRocketArena;

enum EndGameTypes
{
  EGT_MultiDeath,
  EGT_SoloDeath,
  EGT_AntiGoal,
  EGT_Falling,
  EGT_Success,
};
var EndGameTypes XIIIEndGameType;
var sound hEndGameSound;

var name StartSpotEvent;          // My be used by the mapinfo to know where we loaded the game (initialization of the map).
var int CheckpointNumber;         // Indicates the checkpoint number we last reached (0 = map start)
VAR string PlayerName, PlayerClass;
VAR int PlayerTeam;

//_____________________________________________________________________________
// ELR Check PF
function PostBeginPlay()
{
    log("###"@self@"PostBeginPlay");

    Super.PostBeginPlay();
}



//_____________________________________________________________________________
function SetLonePlayer()
{
    Level.bLonePlayer=true;
}

//_____________________________________________________________________________
/* Initialize the game.
 The GameInfo's InitGame() function is called before any other scripts (including
 PreBeginPlay() ), and is used by the GameInfo to initialize parameters and spawn
 its helper classes.
 Warning: this is called before actors' PreBeginPlay.
*/
event InitGame( string Options, out string Error )
{
    SetLonePlayer();

    PlayerName = ParseOption( Options, "Name" );
    PlayerClass = ParseOption( Options, "Class" );
    PlayerTeam = GetIntOption( Options, "Team", 0 );

    log("### InitGame Options"@Options@"bLonePlayer="$Level.bLonePlayer);

    Super.InitGame(Options, Error);
    if (Level.bLonePlayer)
    {
      if ( GameRulesModifiers == None )
        GameRulesModifiers = Spawn(class'XIIISoloGameRules');
      else
        GameRulesModifiers.AddGameRules(Spawn(class'XIIISoloGameRules'));
    }
/*
    else
    {
      if ( GameRulesModifiers == None )
        GameRulesModifiers = Spawn(class'XIIIMJGameRules');
      else
        GameRulesModifiers.AddGameRules(Spawn(class'XIIIMJGameRules'));
    }
*/
}

//_____________________________________________________________________________
event PlayerController Login( string Portal, string Options, out string Error)
{
    local PlayerController PC;

    log("### Login Portal"@Portal@"Options"@Options);
    PC = Super.Login(Portal, Options, Error);
    if ( Level.bLonePlayer )
      RestartPlayer(PC); // Must do this because PC.Pawn must exist when exiting Login for loading games
    return PC;
}

//_____________________________________________________________________________
function RestartPlayer( Controller aPlayer )
{
    local NavigationPoint startSpot;
    local bool foundStart;
    local int TeamNum,i;
    local class<Pawn> DefaultPlayerClass;
    local XIIIPlayerPawn XPP;

    log("### Restarting Player"@aPlayer);

    if( bRestartLevel && Level.NetMode!=NM_DedicatedServer && Level.NetMode!=NM_ListenServer )
    {
      log("  # returning because bRestartLevel="$bRestartLevel@"and we are not a server");
      return;
    }

    if ( (aPlayer.PlayerReplicationInfo == None) || (aPlayer.PlayerReplicationInfo.Team == None) )
      TeamNum = 255;
    else
      TeamNum = aPlayer.PlayerReplicationInfo.Team.TeamIndex;

    startSpot = FindPlayerStart(aPlayer, TeamNum);
    if( startSpot == None )
    {
      log(" Player start not found!!!");
      return;
    }

/*
    if ( (aPlayer.PlayerReplicationInfo.Team != None)
      && ((aPlayer.PawnClass == None) || !aPlayer.PlayerReplicationInfo.Team.BelongsOnTeam(aPlayer.PawnClass)) )
           aPlayer.PawnClass = class<Pawn>(DynamicLoadObject(aPlayer.PlayerReplicationInfo.Team.DefaultPlayerClassName, class'Class'));

*/
    // In solo games default player class is always XIIIPlayerPawn
    aPlayer.PawnClass = class<Pawn>(DynamicLoadObject(DefaultPlayerClassName, class'Class'));

    if ( (aPlayer.Pawn==none) && (aPlayer.PawnClass != None) )
      aPlayer.Pawn = Spawn(aPlayer.PawnClass,,,StartSpot.Location,StartSpot.Rotation);

    log("  # Giving pawn"@aPlayer.Pawn);
    if( aPlayer.Pawn==None )
    {
//      DefaultPlayerClass = class<Pawn>(DynamicLoadObject(GetDefaultPlayerClassName(aPlayer), class'Class'));
      // In solo games default player class is always
      DefaultPlayerClass = class<Pawn>(DynamicLoadObject(DefaultPlayerClassName, class'Class'));
      aPlayer.Pawn = Spawn(DefaultPlayerClass,,,StartSpot.Location,StartSpot.Rotation);
    }
    if ( aPlayer.Pawn == None )
    {
      log("Couldn't spawn player of type "$aPlayer.PawnClass$" at "$StartSpot);
      aPlayer.GotoState('Dead');
      return;
    }

    aPlayer.Possess(aPlayer.Pawn);
    aPlayer.PawnClass = aPlayer.Pawn.Class;

    PlayTeleportEffect(aPlayer, true, true);
    aPlayer.ClientSetRotation(aPlayer.Pawn.Rotation);
/* Moved to AcceptInventory.
    AddDefaultInventory(aPlayer.Pawn);
*/
//    if ( !bInventorySetUp && (aPlayer.Pawn!=none) )
//      AcceptInventory(aPlayer.Pawn);
    Log("  # TRIGGERING StartSpot.Event="$StartSpot.Event);
    StartSpotEvent = StartSpot.Event;
    TriggerEvent( StartSpot.Event, StartSpot, aPlayer.Pawn);
}

//_____________________________________________________________________________
// got rid of duplicates item after changing map/loading there
event AcceptInventory(pawn PlayerPawn)
{
    local XIIIThingsToSave S;
    local XIIISaveGameTrigger T;
    local XIIIPlayerPawn P;
    local int i;
    local inventory Inv, AmmoInv;
    local mapinfo MI;

    log("### Accepting Inventory for "$PlayerPawn);
    if ( PlayerPawn.Weapon.bIsSlave )
      PlayerPawn.Weapon = PlayerPawn.Weapon.SlaveOf;
    Log("  # PlayerPawn.Weapon="$PlayerPawn.Weapon@"Slave ?"@PlayerPawn.Weapon.bIsSlave);

    foreach allactors(class'MapInfo', MI)
      break;

    P = XIIIPlayerPawn(PlayerPawn);
//    XIIICheatManager(PlayerController(PlayerPawn.Controller).CheatManager).LogInventory();

    Log("  # Setting min health (health="$P.Health$") default="$P.default.health@"setting to "$Max(P.Default.Health * 0.25, P.Health));
    P.Health = Max(P.Default.Health * 0.25 + 1, P.Health);
    if (P!= none)
    {
      S = XIIIThingsToSave(P.FindInventoryType(class'XIIIThingsToSave'));

      if (S!=none)
      {
        Log("  # found XIIIThingsToSave who have Tag "$S.XIIISaveGameTriggerTag);
        // Get back the player's HP
        P.Health = Max(P.Health, S.Health);
        P.SpeedFactorLimit = S.SpeedFactorLimit;
        CheckpointNumber = S.CheckpointNumber;
        if (S.SoundToLaunch != none)
        {
            log("  # Launching music "$S.SoundToLaunch);
            PlayMusic(S.SoundToLaunch);
        }

        // Get rid of the save trigger that were used to bring us back here
        foreach allactors(class'XIIISaveGameTrigger', T, S.XIIISaveGameTriggerTag)
          break;
        if ( T != none )
        {
          T.CleanMap();
          for ( i=0; i<S.ObjectivesState.Length ; i++ )
          {
            MI.Objectif[i].bCompleted = S.ObjectivesState[i].bCompleted;
            MI.Objectif[i].bPrimary = S.ObjectivesState[i].bPrimary;
            MI.Objectif[i].bAntiGoal = S.ObjectivesState[i].bAntiGoal;
          }
          log("  # Cleaning Map, updating Objectives & Destroying "$T$" because tag matches loaded game XIIISaveGameTriggerTag");
          T.Destroy();
        }
        else
        {
          log("  # had not found any XIIISaveGameTrigger w/ correct tag");
        }
        S.Destroy();
      }
      else
        Log("  # Cannot find XIIIThingsToSave");
    }

    //default accept all inventory except default weapon (spawned explicitly)
    AddDefaultInventory(PlayerPawn);
    bInventorySetUp = true;
    log("### bInventorySetUp"@bInventorySetUp);

    // Here we must make sure ammo is after weapon in inventory list.
    Log("  # Checking Dual Weapons...");
    Inv = PlayerPawn.Inventory;
    while ( Inv != none )
    {
      if ( XIIIWeapon(Inv) != none )
      { // Found weapon, must find ammo linked and reinsert it after else save/loading pb will happen
        if ( XIIIWeapon(Inv).bIsSlave )
        { // Slave has been setup by giveto because bInventorySetUp was false, now check if we really have skill
          if ( PlayerPawn.CanHoldDualWeapons() )
          { // have skill, just put the dual weapon in place
            PlayerPawn.InsertInventory(XIIIWeapon(Inv), XIIIWeapon(Inv).SlaveOf);
          }
          else
          { // have two weapons but notallowed to handle them, remove dual
            XIIIWeapon(Inv).SlaveOf.MySlave = none;
            XIIIWeapon(Inv).SlaveOf.bHaveSlave = false;
            XIIIWeapon(Inv).SlaveOf.bEnableSlave = false;
            Inv.Destroy();
          }
        }
        AmmoInv = XIIIWeapon(Inv).AmmoType;
        Log("  # BEF AmmoInv="$AmmoInv@"("$Ammunition(AmmoInv).AmmoAmount$")");
        PlayerPawn.DeleteInventory(AmmoInv);
        AmmoInv.GiveTo(PlayerPawn);
        XIIIWeapon(Inv).AmmoType = Ammunition(AmmoInv);
        Log("  # AFT AmmoInv="$AmmoInv@"("$Ammunition(AmmoInv).AmmoAmount$")");
      }
      Inv=Inv.Inventory;
    }

    Log("  # PlayerPawn.Weapon="$PlayerPawn.Weapon@"Slave ?"@PlayerPawn.Weapon.bIsSlave);
    if ( PlayerPawn.Weapon != none )
    {
      if ( PlayerPawn.Weapon.bIsSlave )
      {
        if ( PlayerPawn.Weapon.Silencer != none )
          PlayerPawn.Weapon.Silencer.Destroy();
        PlayerPawn.Weapon.PutDown();
        PlayerPawn.Weapon = PlayerPawn.Weapon.SlaveOf;
      }
      PlayerPawn.Weapon.BringUp();
    }

    // Reset/Give the player his left hand
    XIIIPlayerPawn(PlayerPawn).LHand = XIIILeftHand(PlayerPawn.FindInventoryType(class'XIIILeftHand'));
    if ( XIIIPlayerPawn(PlayerPawn).LHand == none )
    {
      XIIIPlayerPawn(PlayerPawn).LHand = Spawn(class'XIIILeftHand',PlayerPawn);
      XIIIPlayerPawn(PlayerPawn).LHand.GiveTo(PlayerPawn);
      XIIIPlayerPawn(PlayerPawn).LHand.Instigator=PlayerPawn;
    }
}

//_____________________________________________________________________________
// Spawn any default inventory for the player.
function AddDefaultInventory( pawn PlayerPawn )
{
    local Weapon newWeapon;
    local class<Weapon> WeapClass;

    //log("### AddDefaultInventory call for"@PlayerPawn);
    // Spawn default weapon.
    WeapClass = BaseMutator.GetDefaultWeapon();
    //log("  # WeapClass"@WeapClass);
    newWeapon = Weapon(PlayerPawn.FindInventoryType(WeapClass));
    if ( NewWeapon != none )
    {
      NewWeapon.Destroy();
      NewWeapon = none;
    }
    if( (WeapClass!=None) && (newWeapon == None) )
    {
      newWeapon = Spawn(WeapClass,,,PlayerPawn.Location);
      //log("  # newWeapon"@newWeapon);
      if( newWeapon != None )
      {
        newWeapon.GiveTo(PlayerPawn);
        newWeapon.BringUp();
        newWeapon.bCanThrow = false; // don't allow default weapon to be thrown out
      }
    }
    SetPlayerDefaults(PlayerPawn);
}

//_____________________________________________________________________________
// ELR drop inventory when dead
function DiscardInventory( Pawn Other )
{
// Do nothing, corpse searching
    local actor dropped;
    local inventory Inv;
    local float speed;
    local rotator tRot;

    for( Inv=Other.Inventory; Inv!=None; Inv=Inv.Inventory )
    {
      if ( (Fists(Inv)!=none) || (FistsAmmo(Inv)!=none) || (XIIILeftHand(Inv)!=none) )
        Inv.Destroy();

      if( inv.IsA('MarioSuperBonus') )
          inv.Destroy();
    }
}

//_____________________________________________________________________________
// ELR when corpse chunked up.
function DropInventory( Pawn other )
{
    Super.DiscardInventory(other);
}

//_____________________________________________________________________________
function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
//    local Controller P;

    if ( (GameRulesModifiers != None) && !GameRulesModifiers.CheckEndGame(Winner, Reason) )
      return false;

    // all player cameras focus on winner or final scene (picked by gamerules)
    // ELR Get rid of this, do it after GameEndedMode is set.
/*    for ( P=Level.ControllerList; P!=None; P=P.NextController )
    {
      P.ClientGameEnded();
      P.GotoState('GameEnded');
    } */
    return true;
}

//_____________________________________________________________________________
// ELR GameEnded in solo mode = GameOver
function EndGame( PlayerReplicationInfo Winner, string Reason )
{
    local Controller P;
    local int N;
    local string GameOver;
    local XIIIPlayerController XPC;

    N = InStr(Reason, ":");
    if (N != -1)
    {
      GameOver = Mid(Reason,N+1);
      Reason = Left(Reason,N);
    }

    if (GameOver == "")
    {
      GameOver = class'XIII.XIIIEndGameMessage'.default.GoalInCompleteMsg;
    }

    // don't end game if not really ready
    if ( !CheckEndGame(Winner, Reason) )
    {
      bOverTime = true;
      return;
    }

    if (XIIIGameInfo(Level.Game).MapInfo != none)
      XPC = XIIIGameInfo(Level.Game).MapInfo.XIIIController;

    bGameEnded = true;
    TriggerEvent('EndGame', self, None);
    if ( Reason=="PlayerKilled" )
    {
      if ( XPC != none )
        XPC.MyHUD.LocalizedMessage( class'XIIIEndGameMessage', 1, XPC.PlayerReplicationInfo );
//      Level.Game.BroadCastLocalizedMessage(class'XIIIEndGameMessage', 1, winner);
      if ( Level.bLonePlayer )
        XIIIEndGameType = EGT_SoloDeath;
      else
        XIIIEndGameType = EGT_MultiDeath;
    }
    else if ( Reason=="PlayerFalling" )
    {
      if ( XPC != none )
        XPC.MyHUD.LocalizedMessage( class'XIIIEndGameMessage', 4, XPC.PlayerReplicationInfo);
//      Level.Game.BroadCastLocalizedMessage(class'XIIIEndGameMessage', 4, winner);
      XIIIEndGameType = EGT_Falling;
    }
    else if ( Reason=="GoalIncomplete" )
    {
      if ( XPC != none )
        XPC.MyHUD.LocalizedMessage( class'XIIIEndGameMessage', 3, XPC.PlayerReplicationInfo, none, self, GameOver );
      XIIIEndGameType = EGT_AntiGoal;
    }
    else if ( Reason=="GoalComplete" )
    {
      if ( XPC != none )
        XPC.MyHUD.LocalizedMessage( class'XIIIMissionCompletedMessage', 0, XPC.PlayerReplicationInfo, none, self, MapInfo.MessageMissionSuccess ); //
//      XPC.MyHUD.LocalizedMessage(class'XIIIMissionCompletedMessage', 2, winner);
      XIIIEndGameType = EGT_Success;
    }


    if ( Reason=="GoalIncomplete" )
    { // wait 2 seconds before locking game
      gotoState('PendingEndGame');
      return;
    }

    // do this now instead of in CheckEndGame to have XIIIEndGameType initialized.
    for ( P=Level.ControllerList; P!=None; P=P.NextController )
    {
      P.ClientGameEnded();
      P.GotoState('GameEnded');
//    Log("PlayingSound hEndGameSound="$hEndGameSound$" w/ XIIIEndGameType="$XIIIEndGameType);
      if ( P.Pawn.IsPlayerPawn() )
        P.Pawn.PlaySound(hEndGameSound, int(XIIIEndGameType));
    }
    EndLogging(Reason);
//    Log("Game Ended w/ XIIIEndGameType="$XIIIEndGameType);
}


//_____________________________________________________________________________
/* ProcessServerTravel()
 Optional handling of ServerTravel for network games.
*/
function ProcessServerTravel( string URL, bool bItems )
{
    local playercontroller P, LocalPlayer;
    local inventory Obj;

    if (StatLog != None)
    {
      StatLog.LogGameEnd("mapchange");
      StatLog.StopLog();
      StatLog.Destroy();
      StatLog = None;
    }

    // Notify clients we're switching level and give them time to receive.
    // We call PreClientTravel directly on any local PlayerPawns (ie listen server)
    log("ProcessServerTravel:"@URL);
    foreach DynamicActors( class'PlayerController', P )
      if( NetConnection( P.Player)!=None )
        P.ClientTravel( URL, TRAVEL_Relative, bItems );
      else
      {
        LocalPlayer = P;
        P.PreClientTravel();
      }

    if ( (Level.NetMode == NM_ListenServer) && (LocalPlayer != None) )
      Level.NextURL = Level.NextURL$"?Skin="$LocalPlayer.GetDefaultURL("Skin")
        $"?Face="$LocalPlayer.GetDefaultURL("Face")
        $"?Team="$LocalPlayer.GetDefaultURL("Team")
        $"?Name="$LocalPlayer.GetDefaultURL("Name")
        $"?Class="$LocalPlayer.GetDefaultURL("Class");

    // First reset inventory to what is allowed when exiting the map
    // Just keep Skills and docs.
    if ( (MapInfo != none) && !MapInfo.NextMapKeepInventory )
    {
      Log(" > Don't keep inventory for next map");
      foreach allactors(class'inventory', Obj)
      {
        if ( (Obj != none) && (Obj.Owner == LocalPlayer.Pawn) )
        if ( (Weapon(Obj)!=none) || (Armor(Obj)!=none) || (Ammunition(Obj)!=none) || (XIIIItems(Obj)!=none) )
          Obj.Destroy();
      }
      LocalPlayer.Pawn.Health = LocalPlayer.Pawn.default.Health;
    }

//    if( Level.bLonePlayer )
//      Level.NextSwitchCountdown = 6.0;
//    else if( Level.NetMode!=NM_DedicatedServer && Level.NetMode!=NM_ListenServer )
      Level.NextSwitchCountdown = 0.0;
}

//_____________________________________________________________________________
// Return whether an item should respawn.
function bool ShouldRespawn( Pickup Other )
{
    if( Level.bLonePlayer )
      return false;

    if( Other.MyMarker == none )
        return false;

    return Other.ReSpawnTime!=0.0;
}

//_____________________________________________________________________________
// ELR In solo should just send a single message.
function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> damageType)
{
    local string S;

    S = ParseKillMessage(XIIIPawn(Killer.Pawn).PawnName, "XIII", class<XIIIDamageType>(DamageType).Static.SoloDeathMessage(Killer, Other));
    Playercontroller(Other).ClientMessage(S, 'Death');
}

//_____________________________________________________________________________
function int ReduceDamage( int Damage, pawn injured, pawn instigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
    local int OriginalDamage;
    local Inventory I;
    local int ArmorDamage;

    OriginalDamage = Damage;

    if ( (XIIIPawn(Injured).LHand != none) && XIIIPawn(Injured).LHand.bActive && !XIIIPawn(Injured).LHand.pOnShoulder.bIsDead && (XIIIPawn(Injured).GetDamageSide(HitLocation) < 4) && DamageType.default.bArmorStops)
      Damage *= 0.5; // Having an ostage reduce front damage by half.

    if( injured.PhysicsVolume.bNeutralZone )
      Damage = 0;
    else if ( injured.InGodMode() ) // God mode
      Damage = 0;
    else if ( (injured.Inventory != None) && (damage > 0) && DamageType.default.bArmorStops ) //then check if carrying armor
    {
      if ( Injured.Vest != none )
        Damage = Injured.Vest.ArmorAbsorbDamage(Damage, DamageType, HitLocation);
      if ( Injured.Helm != none )
        Damage = Injured.Helm.ArmorAbsorbDamage(Damage, DamageType, HitLocation);
    }

    if ( GameRulesModifiers != None )
      return GameRulesModifiers.NetDamage( OriginalDamage, Damage,injured,instigatedBy,HitLocation,Momentum,DamageType );

    return Damage;
}

//_____________________________________________________________________________
state PendingEndGame
{
    Event BeginState()
    {
      SetTimer(2.0, false);
    }
    Event Timer()
    {
      local Controller P;

      // do this now instead of in CheckEndGame to have XIIIEndGameType initialized.
      for ( P=Level.ControllerList; P!=None; P=P.NextController )
      {
        P.ClientGameEnded();
        P.GotoState('GameEnded');
        if ( P.Pawn.IsPlayerPawn() )
          P.Pawn.PlaySound(hEndGameSound, int(XIIIEndGameType));
      }
      EndLogging("GoalIncomplete");
      gotostate('');
    }
    function EndGame( PlayerReplicationInfo Winner, string Reason )
    {
      return;
    }
}



defaultproperties
{
     hEndGameSound=Sound'XIIIsound.Interface__EndMap.EndMap__hEndMap'
     bRestartLevel=False
     DefaultPlayerClassName="XIII.XIIIPlayerPawn"
     HUDType="XIII.XIIIBaseHUD"
     GameName="Solo Game"
     MutatorClass="XIII.XIIISoloMutator"
     PlayerControllerClassName="XIII.XIIIPlayerController"
}
