//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIPlayerController extends PlayerController;

var bool bTurnWanted;           // For 90/180 turns
var bool bWeaponMode;           // true if weapons are active, false if items are active
var bool bWaitForWeaponMode;    // true if waiting for a changedweapon order
var bool bPickingUp;            // Bool to validate the GameInfo HandlePickupQuery
var bool bWeaponBlock;          // Used to block weapon switch while climbing doors.
var bool bPressedDuck;
var config bool bAltZoomingSystem;
var bool bHooked;               // Player is hooked (to use it in walk/swim
var config bool bFixedCrosshair;
var config bool bFloatingCrosshair;

var bool bMenuIsActive;         // If true, no other display allowed
var config bool bRotationAssist;// if true, then rotation will be assisted by a 'lock' when strafing around target (Halo-like)
// SE XBox Specific, for Cameras portal rendering
var bool bRenderPortal;
var bool bOkForMoving;          // Used to wait for first rendered frame (first postrender called) to activate player movement (else will be able to move while init).

/*
var config bool bCheckTurnSpeed;// check turning speed
var float fTurnSpeed[5];        // store turning values (90/180/270/360/720°)
var int fTurnInc;
var float fTurnDeltaTime;       // time cumul
*/

var float fCamViewPercent;
var int CamViewMode;
var MultiViewport multiViewport;
// SE Xbox End
var XboxLiveManager xboxlive;
var string StatsMem;            // the string that will be used to memorize stats on clients

var byte OldWeap;               // to memorize weapon when switching weapons/items modes
var XIIIItems OldItem;          // to memorize Item when climbing doors
var XIIIPorte aDoor;            // Door to be lockpicked

var float SniperYaw;            // Used for the breath movement in sniping zoom.
var float SniperPitch;          // Used for the breath movement in sniping zoom.
var float fSniperPrecision;     // Used for the breath movement in sniping zoom.
var vector vSniperOffset;       // Used for the breath movement in sniping zoom.
var vector vSniperOffsetSpeed;  // Used for the breath movement in sniping zoom.

var Hook HookUsed;              // the hook used when in Hooked State
var HookPoint ClimbHookPoint;   // HP to use when climbing up at top of the rope
var HookNavPoint TargetHookClimb; // HNP to climb to

var vector vTyrolStart, vTyrolEnd, vTyrolDir;     // For Tyrol Behaviour
var float fTyrolSpeed;                            // For Tyrol Behaviour

var eDrawType DT_mem;           // Used for viewing through a cam.
var actor CamView;              // Used for viewing through a cam.

var actor DoorToClimb;          // Door that is climbed
var vector DoorLockedNormal;    // used for climbing doors
var vector DoorLockedPos;       // used for climbing doors
var vector DoorClimbMove;       // Movement if climbing door to check the end of climb.
var vector OldDoorClimbPos;     // used for climbing doors

var XIIIPlayerInteraction MyInteraction;
var sound hCLimbDoorSound;
var sound hEndClimbDoorSound;

// EndGame Vars
var vector vGameEndedCamLoc;
var rotator rGameEndedCamRot;
var int iGameEndedRandEffect;
var OnoFalling OnoF;

var sound hCamViewBeginUseSound;
var sound hCamViewInUseSound;
//var sound hCamViewEndUseSound;

var sound hEndClimbLadderSound;
//var sound hEnteringWaterSound;
//var sound hExitingWaterSound;

var vector vWeaponFeedBack;       // to simulate weapon feed back while firing
var vector vWeaponFeedBackReturn; // to return to normal pos after firing

var ForceFeedbackController FFController;   // For ForceFeedBack controls
var VideoPlayer VP;               // Used to play videos

var float VignetteFlashDecFactor; // Used for flash SFXs (FlashBang)
var float VignetteAlphaDecFactor; // Used for flash SFXs (FlashBang
var float VignetteSFXduration;    // Used for flash SFXs (FlashBang
var float VignetteAlpha;          // because color.a is int & we need float

var string MyInteractionClass;

var sound hTyrolStartSound;
var sound hTyrolEndSound;

var globalconfig int iCrosshairMode;    // 0 = off, 1 = On on target, 2 = always on.
var globalconfig float fCrosshairSize;

//_____________________________________________________________________________
// ELR Replicate things
replication
{
    // Variables the server should send to the client.
    reliable if ( Role==ROLE_Authority )
      bWeaponMode, bWaitForWeaponMode, ClientTargetHighLight;

    // Functions the server should send to the client.
  	unreliable if( Role==ROLE_Authority )
      ClientViewFeedBackSetup, ClientAddDamageWarn;

  	reliable if( Role<ROLE_Authority )
  	  ServerUpdateSkin;
}

//_____________________________________________________________________________
// The player wants to switch to weapon group number F.
exec function SelectWeapon( byte F )
{
    local weapon newWeapon;

    if ( Pawn.region.Zone.FlashEffectDesc.IsActivated )
      return;
    if ( (Pawn.PendingWeapon != none) && (DecoWeapon(Pawn.PendingWeapon) != none) )
      return;
    if ( (Level.Pauser!=None) || (Pawn == None) || (Pawn.Inventory == None) )
      return;

    if ( (Pawn.Weapon != None) && (Pawn.Weapon.Inventory != None) )
      newWeapon = Pawn.Weapon.Inventory.WeaponSelect(F);
    else
      newWeapon = None;
    if ( newWeapon == None )
      newWeapon = Pawn.Inventory.WeaponSelect(F);

    if ( newWeapon == None )
      return;

//    Log("SelectWeapon"@NewWeapon);
    if ( Pawn.Weapon == None )
    {
//      Log("  No Weapon");
      if ( bWeaponMode )
      {
        if ( Pawn.Weapon != newWeapon )
        {
          Pawn.PendingWeapon = newWeapon;
          Pawn.ChangedWeapon();
        }
      }
      else if ( !bWaitForWeaponMode )
      {
        XIIIBaseHud(MyHud).fDrawWeaponsTimer = Level.TimeSeconds+2.0;
        bWaitForWeaponMode = true;
        Pawn.Weapon = NewWeapon;
        SwitchWeaponMode();
      }
    }
    else
    {
      if ( bWeaponMode )
      {
        if ( Pawn.Weapon != newWeapon )
        {
          Pawn.PendingWeapon = newWeapon;
          if ( !Pawn.Weapon.PutDown() )
            Pawn.PendingWeapon = None;
        }
      }
      else
      {
        XIIIBaseHud(MyHud).fDrawWeaponsTimer = Level.TimeSeconds+2.0;
        bWaitForWeaponMode = true;
        Pawn.Weapon = NewWeapon;
        SwitchWeaponMode();
      }
    }
}

//_____________________________________________________________________________
simulated event IAmKicked()
{
    GotoState('Kicked', 'Begin');
    Pawn.bTearOff = true;
    bTearOff = true;
    Pawn.Died( None, class'DTSuicided', Pawn.Location );
    PlayerReplicationInfo.destroy();
    PlayerReplicationInfo = none;
}


//_____________________________________________________________________________
exec function ChangeSkin(string NewSkinCode)
{
    local int i;

    // DO nothing in solo.
    if ( Level.bLonePlayer )
      return;

//    Log("SKIN Exec ChangeSkin");

    // don't replicate things for nothing if non valid code.
    i = class'MeshSkinList'.Static.StaticFindSkinIndex(NewSkinCode);
    if ( i > class'MeshSkinList'.default.MeshSkinListInfo.Length )
      return;

    ServerUpdateSkin(Caps(left(NewSkinCode,4)));
//    Pawn.PlayerReplicationInfo.SkinCodeName = NewSkinCode;
//    XIIIMPPlayerPawn(Pawn).ChangeSkin();
}

//_____________________________________________________________________________
function ServerUpdateSkin(string NewSkinCode)
{
//    Log("SKIN ServerUpdateSkin");
    PlayerReplicationInfo.SkinCodeName = NewSkinCode; // will be replicated to all clients
    Pawn.ChangeSkin();  // local change on server
}

//____________________________________________________________________
simulated function ClientAddDamageWarn(int RelativeHitLoc)
{
    XIIIBaseHud(MyHud).AddDamageWarn(RelativeHitLoc);
}

//_____________________________________________________________________________
function EnterStartState()
{
	local name NewState;

	if ( Level.bLonePlayer && !bOkForMoving )
	{
	  GotoState('WaitForFirstDisplay');
	  return;
	}
  else
    Super.EnterStartState();
}

/*
//_____________________________________________________________________________
exec function ImBoss()
{
    XIIIBaseHud(MyHud).AddBossBar(XIIIPawn(Pawn));
}
*/
/*
//_____________________________________________________________________________
exec function LogInteractives()
{
    local Actor A;
    local int i;

    Log("BEGIN Interactive List");
    i = 0;
    foreach AllActors(class'Actor', A)
    {
      if ( A.bInteractive )
      {
        i++;
        Log(" -"@i@A);
      }
    }
    Log("END Interactive List");
}
*/
//_____________________________________________________________________________
exec function GoreLevel(int i)
{
    Level.Game.GoreLevel = i%2;
    Level.Game.SaveConfig();
}

//_____________________________________________________________________________
exec function FlowerPower(int i)
{
    if ( i != 0 )
      Level.Game.GoreLevel = 0;
    Level.Game.bAlternateMode = (i%2 == 1);
    Level.Game.SaveConfig();
}

//_____________________________________________________________________________
exec function DetailLevel(int i)
{
    Level.Game.DetailLevel = i%3;
    Level.Game.SaveConfig();
}

//_____________________________________________________________________________
exec function KillTarget(int i)
{
    if ( MyInteraction.FiringTargetActor != none )
      MyInteraction.FiringTargetActor.TakeDamage(10000,Pawn,vect(0,0,1),vect(0,0,1),class'DTSuicided');
}

/*
//_____________________________________________________________________________
exec function SetZoomSystem(bool B)
{
    bAltZoomingSystem = B;
    SaveConfig();
}
*/

//_____________________________________________________________________________
exec function AAM(int i)
{
    iAutoAimMode = i%2;
    SaveConfig();
}

/*
//_____________________________________________________________________________
exec function DBTurn()
{
    bCheckTurnSpeed = !bCheckTurnSpeed;
    SaveConfig();
}

//_____________________________________________________________________________
exec function DBInput(bool b)
{
    PlayerInput.bCheckInputRanges = b;
    PlayerInput.SaveConfig();
}
*/

/*
//_____________________________________________________________________________
exec function CrosshairMode(int i)
{
    iCrossHairMode = i%3;
    SaveConfig();
}
*/

//_____________________________________________________________________________
exec function AutoPickup(bool b)
{
    bAutoPickup = b;
    SaveConfig();
}

/*
//_____________________________________________________________________________
exec function FixCrosshairMode(int i)
{
    bFixedCrosshair = (i%2 == 1);
    SaveConfig();
}

//_____________________________________________________________________________
exec function FloatCrosshairMode(int i)
{
    bFixedCrosshair = false;
    bFloatingCrosshair = (i%2 == 1);
    SaveConfig();
}
*/

//_____________________________________________________________________________
exec function CrosshairSize(Float f)
{
    fCrossHairSize = fClamp(f, 0.1, 3.0);
    SaveConfig();
}

/*
//_____________________________________________________________________________
exec function LogInteraction()
{
    log("LogInteraction");
    MyInteraction.SwitchLog();
}
*/

//_____________________________________________________________________________
exec function DoHideHUD( bool B )
{
    log("DoHideHUD call with B="$B);
    MYHud.bHideHud = B;
}

/*
//_____________________________________________________________________________
exec function Teleport(name N)
{
    local XIIITeleportCheat XTC;

//    Log("Trying to Teleport to "$N);

    foreach AllActors(class'XIIITeleportCheat', XTC, N)
    {
      if (XTC != none)
      {
//        Log("Teleporting player to Spot "$XTC);
        XTC.TeleportPlayer(XIIIPlayerPawn(Pawn));
        break;
      }
    }
}
*/

/*
exec function TeleportNext()
{
    local XIIITeleportCheat XTC, XTCfirst;

//    Log("Trying to Teleport to next teleporter");

    foreach AllActors(class'XIIITeleportCheat', XTC)
    {
      if (XTCfirst == none)
        XTCfirst = XTC;
      if ( (XTC != none) && XTC.bLastUsed )
      {
        if ( XTC.NextXIIITeleportCheat != none )
        {
//          Log("Teleporting player to Spot "$XTC.NextXIIITeleportCheat);
          XTC.NextXIIITeleportCheat.TeleportPlayer(XIIIPlayerPawn(Pawn));
          XTC.NextXIIITeleportCheat.bLastUsed = true;
          XTC.bLastUsed = false;
          return;
        }
        else
        {
//          Log("Teleporting player to Spot "$XTCfirst);
          XTCfirst.TeleportPlayer(XIIIPlayerPawn(Pawn));
          XTCFirst.bLastUsed = true;
          return;
        }
      }
    }
    // if we are here it's because none have bCurrent
    if (XTCFirst != none)
    {
//      Log("Teleporting player to Spot "$XTCfirst);
      XTCfirst.TeleportPlayer(XIIIPlayerPawn(Pawn));
      XTCFirst.bLastUsed = true;
      return;
    }
}
*/

//____________________________________________________________________________
// ELR Override this
exec function BehindView( Bool B )
{
    if (!(Left(Level.GetLocalURL(), 7) ~= "mapmenu"))
      Super.BehindView(B);
    if ( B )
    {
        Pawn.weapon.bHidden = true;
        Pawn.weapon.RefreshDisplaying();
    }
    else
    {
        Pawn.weapon.bHidden = false;
        Pawn.weapon.RefreshDisplaying();
    }
}

function ClientSetBehindView(bool B)
{
    bBehindView = B;
    if ( !B && Pawn.Shadow != none )
      Pawn.Shadow.DetachProjector(true);
}

//____________________________________________________________________________
event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
    local int i;

    super.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
    // following lines needed to have weapon in 3D overlays using bDelayDisplay instead of RenderOverlays
    if ( ((Pawn == none) || Pawn.bIsDead) && (Attached.Length > 0) )
    { // may have died, if something attached (must be 1rst person/inventory weapons) then detach else crash in SetLoc if something happen to inventory
      for ( i=0; i<Attached.Length; i++)
      {
//        Log("DETACH"@Attached[i]@"from"@self);
        Attached[i].SetBase(none);
      }
    }
    SetLocation(CameraLocation);
    SetRotation(CameraRotation);
}

//____________________________________________________________________________
simulated event SetInitialState()
{
    if (Left(Level.GetLocalURL(), 7) ~= "mapmenu")
    {
      MyHud.bHideHUD = true;
//      ConsoleCommand("ShowMenu");
      GotoState('NoControl');
      return;
    }
    Super.SetInitialState();

}

//____________________________________________________________________________
// MLK: Superset to launch the briefing before the game starts
// ELR First place it is safe to use Player Var so to spawn interactions.
event InitInputSystem()
{
    local MapInfo Map;
    local int i;
    local XIIIPlayerInteraction XPI;

    Super.InitInputSystem();

    Player.Console = Player.InteractionMaster.Console;
    if (Player.Console == none)
    {
        log("PAS de Console !?!");
        return;
    }
    if (Player.Console.ViewportOwner == none)
      Player.Console.ViewportOwner = Player;

    for (i=0; i<Player.LocalInteractions.Length; i++)
    {
      if ( XIIIPlayerInteraction(Player.LocalInteractions[i]) != none )
        MyInteraction = XIIIPlayerInteraction(Player.LocalInteractions[i]);
    }
// if an interaction already exists (coming from previous map) then reuse it, don't create another

    if ( MyInteraction != none )
    {
        Player.InteractionMaster.RemoveInteraction(MyInteraction);
        MyInteraction = none;
    }

    if ( MyInteraction == none )
    {
      XPI = XIIIPlayerInteraction(Player.InteractionMaster.AddInteraction(MyInteractionClass, Player));
      if ( XPI != none )
      {
        XPI.Level = Level;
        XPI.MyPC = Self;
        MyInteraction = XPI;
      }
    }
    else
    {
      MyInteraction.Level = Level;
      MyInteraction.MyPC = Self;
    }

    SetRumbleFX(bUseRumble);

    // Autolaunch Menu if in the 'menustart'.
    if (Left(Level.GetLocalURL(), 7) ~= "mapmenu")
    {
      MyHud.bHideHUD = true;
      ConsoleCommand("ShowMenu");
      XIIIGameInfo(Level.Game).MapInfo.EndCartoonEffect = true;
      GotoState('NoControl');
    }

    if ( !Level.bLonePlayer && (Level.GetPlateforme() == 2) )
    {
      if (xboxlive == none) // Southend!!!!!!!!!1 safe for other platforms..
        xboxlive=New Class'XboxLiveManager';

      if (xboxlive.IsLoggedIn(xboxlive.GetCurrentUser()))
        ConsoleCommand("ShowMenu"); // SOUTHEND!!!!!!!!!  Need this for XBOX!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
      return;
    }

// SOLO ONLY INIT
    foreach AllActors(class'XIII.Mapinfo',map)
      break;
    if ( Map != none && Map.bBriefing )
    {
      XIIIGameInfo(Level.Game).MapInfo = Map;
      ConsoleCommand("ShowBriefing");
    }
}

//_____________________________________________________________________________
// ::DBUG::
simulated event Destroyed()
{
    Log("PLAYER"@self@"destroyed !!");
    Super.Destroyed();
}

//_____________________________________________________________________________
// ::DBUG::
function PawnDied()
{
  Log("PLAYER"@self@"PawnDied call bIsPlayer="$bIsPlayer);
  Super.PawnDied();
  // Unflash player if under flashbang sfx
  ClientFilter(
    class'Canvas'.Static.MakeColor(128,128,128,255),
    class'Canvas'.Static.MakeColor(128,128,128,255),
    1.0
  );
  ClientHighLight( class'Canvas'.Static.MakeColor(0,0,0,0), 0.0);
  ClientTargetHighLight(0,0,0.001);
  UseVignetteFilter = 0;
  UseVignetteHighlight = 0;
}

//_____________________________________________________________________________
// Setup the ForceFeedbackController
function SetRumbleFX(bool B)
{
    if ( B )
    {
      if ( FFController != none )
      {
        FFController.EnableForceFeedback(true);
      }
      else
      {
        FFController = new class'ForceFeedbackController';
        FFController.EnableForceFeedback(true);
      }
    }
    else
    {
      if ( FFController != none )
      {
        FFController.EnableForceFeedback(false);
      }
    }
}

//_____________________________________________________________________________
// Setup the ForceFeedbackController
function RumbleFX(int FXNum)
{
    if ( (FFController != none) && FFController.IsForceFeedbackEnable() )
    {
      switch(FXNum)
      {
        Case 1: // Beretta
          FFController.StartEffect(0, 0.45, 0.45, 0.00, 1.00, 0.20, 0.70, 0.35 ); Break;
        Case 2: // Hunting Gun, Left
          FFController.StartEffect(0, 0.00, 0.75, 0.00, 1.00, 0.25, 0.50, 0.35 ); Break;
        Case 3: // Hunting Gun, Right
          FFController.StartEffect(0, 0.75, 0.00, 0.00, 1.00, 0.25, 0.50, 0.35 ); Break;
        Case 4: // ShotGun
          FFController.StartEffect(0, 0.60, 0.00, 0.00, 1.00, 0.35, 0.50, 0.40 ); Break;
        Case 5: // Magnum
          FFController.StartEffect(0, 0.60, 0.60, 0.00, 1.00, 0.20, 0.70, 0.35 ); Break;
        Case 6: // M16 FX 1
          FFController.StartEffect(0, 0.15, 0.45, 0.00, 1.00, 0.10, 0.70, 0.15 ); Break;
        Case 7: // M16 inv. FX 1
          FFController.StartEffect(0, 0.45, 0.15, 0.00, 1.00, 0.10, 0.70, 0.15 ); Break;
        Case 8: // Kalash FX 1
          FFController.StartEffect(0, 0.25, 0.45, 0.00, 1.00, 0.10, 0.70, 0.15 ); Break;
        Case 9: // Kalash inv. FX 1
          FFController.StartEffect(0, 0.45, 0.25, 0.00, 1.00, 0.10, 0.70, 0.15 ); Break;
        Case 10: // Minigun FX 1
          FFController.StartEffect(0, 0.10, 0.35, 0.00, 0.70, 0.10, 0.70, 0.15 ); Break;
        Case 11: // Minigun inv. FX 1
          FFController.StartEffect(0, 0.35, 0.10, 0.00, 0.70, 0.10, 0.70, 0.15 ); Break;
        Case 12: // Sniper Rifle
          FFController.StartEffect(0, 0.90, 0.90, 0.00, 1.00, 0.15, 0.70, 0.25 ); Break;
        Case 13: // Bazooka
          FFController.StartEffect(0, 0.90, 0.90, 0.00, 0.70, 0.25, 1.00, 1.00 ); Break;
        Case 14: // CrossBow, CrossBow X3
          FFController.StartEffect(0, 0.50, 0.50, 0.00, 0.10, 0.10, 1.00, 0.25 ); Break;
        Case 15: // M60 FX 1
          FFController.StartEffect(0, 0.80, 0.40, 0.00, 1.00, 0.10, 0.70, 0.15 ); Break;
        Case 16: // M60 inv. FX 1
          FFController.StartEffect(0, 0.40, 0.80, 0.00, 1.00, 0.10, 0.70, 0.15 ); Break;
        Case 17: // Harpoon
          FFController.StartEffect(0, 0.30, 0.30, 0.00, 0.10, 0.10, 1.00, 0.20 ); Break;
/*
        Case 5:
          FFController.StartEffect(0, fRumb1, fRumb2, t1, Amplit1, t2, Amplit2, t3 );
          Break;
*/
      }
    }
}

//_____________________________________________________________________________
// SpawnDefaultHUD()
// Spawn a HUD (make sure that PlayerController always has valid HUD, even if
//  ClientSetHUD() hasn't been called
function SpawnDefaultHUD()
{
     myHUD = spawn(class'XIIIBaseHUD',self);
}

//_____________________________________________________________________________
function DisplayDebug(Canvas C, out float YL, out float YPos)
{
    Super.DisplayDebug(C, YL, YPos);

    C.DrawText("rotation "$rotation);
    YPos += YL;
    C.SetPos(4,YPos);

    C.DrawText("Weapon Mode "$bWeaponMode);
    YPos += YL;
    C.SetPos(4,YPos);

    if ( Pawn != none )
    {
/*
      if ( Pawn.PendingWeapon != none )
      {
        C.DrawText("PendingWeapon="$Pawn.PendingWeapon@"STATE"@Pawn.PendingWeapon.GetStateName());
        YPos += YL;
        C.SetPos(4,YPos);
      }
      if ( Pawn.PendingWeapon != none )
      {
        C.DrawText("Weapon="$Pawn.Weapon@"STATE"@Pawn.Weapon.GetStateName());
        YPos += YL;
        C.SetPos(4,YPos);
      }
      if ( Pawn.PendingItem != none )
      {
        C.DrawText("PendingItem="$Pawn.PendingItem@"STATE"@Pawn.PendingItem.GetStateName());
        YPos += YL;
        C.SetPos(4,YPos);
      }
      if ( Pawn.SelectedItem != none )
      {
        C.DrawText("Item="$Pawn.SelectedItem@"STATE"@Pawn.SelectedItem.GetStateName());
        YPos += YL;
        C.SetPos(4,YPos);
      }

*/
      if ( XIIIPawn(Pawn).LHand != none )
      {
        C.DrawText("LeftHand="$XIIIPawn(Pawn).LHand);
        YPos += YL;
        C.SetPos(4,YPos);
      }
    }

    C.DrawText("Rotation="$Rotation@"AdjustedAimForFiring"@rotator(AdjustedAimForFiring)@"OldAdjustAim"@rotator(OldAdjustAim));
    YPos += YL;
    C.SetPos(4,YPos);

/*    C.DrawText("bAlwaysLevel="$bAlwaysLevel@"bCenterView="$bCenterView@"bLook="$bLook@"bLookUpStairs="$bLookUpStairs@"bSnapToLevel="$bSnapToLevel);
    YPos += YL;
    C.SetPos(4,YPos); */
}

//_____________________________________________________________________________
exec function RestartLevel()
{
//    if( Level.Netmode==NM_Standalone )
    if ( Level.bLonePlayer )
      ClientTravel( "?restart", TRAVEL_Relative, false );
}

//_____________________________________________________________________________
function ClientRestart()
{
  Log("ClientRestart"@self@"Pawn="$Pawn);
	if ( Pawn == None )
	{
		GotoState('WaitingForPawn');
		return;
	}
	if ( PlayerInput != none )
	{
	  PlayerInput.iDuckMem = 0;
	  PlayerInput.bDuckCheck = false;
	  Pawn.ShouldCrouch(false);
	}
	bDuck = 0;
	Pawn.ClientRestart();
	SetViewTarget(Pawn);
	bBehindView = Pawn.PointOfView();
	EnterStartState();
}

//_____________________________________________________________________________
simulated function RenderScreenOverlays( canvas C )
{
    if ( fCamViewPercent > 0.0 )
    {
      CamView.Instigator = pawn;
      CamView.RenderOverlays(C);
    }
}

//_____________________________________________________________________________
// ELR
simulated event RenderOverlays( canvas C )
{
    if ( !Level.bCineFrame )
      MyInteraction.MyPCPostRender(C);
    else
      MyInteraction.TargetActor = none;
    // ::TODO:: Optimize using NoControl state test or overriding RenderOverlays in NoControl State ?
/*
    if ( (Pawn != none) && Pawn.region.Zone.FlashEffectDesc.IsActivated )
    { // do not simply return but hide weapons/items
      if ( Pawn.Weapon != none )
      { // should be in the flashback end effect
      }
      return;
    }
*/

/*
    if ( (Level.Game != none) && Level.Game.bGameEnded )
    {
//      Log("RenderOverlays w/ bGameEnded !!!");
      return;
    }
*/

    if ( (Level.Game != none) && (Level.Game.DetailLevel < 2) )
    { // On anything else than XBOX, use full screen render.
      if ( IsInState('CameraView') )
      {
        CamView.Instigator = pawn;
        CamView.RenderOverlays(C);
        return;
      }
    }
    else
    { // on XBox, use portal
      switch (CamViewMode)
      {
        case 0:
          fCamViewPercent -= 0.05;
          if (fCamViewPercent < 0.0)
          {
            fCamViewPercent = 0.0;
            CamView = none;
          }
        break;
        case 1:
          fCamViewPercent += 0.05;
          if (fCamViewPercent > 1.0)
            fCamViewPercent = 1.0;
        break;
      }

      if (multiViewport != none)
      {
        multiViewport.RenderOverlays(C);
        if (multiViewport.bEnded)
        {
          multiViewport.Destroy();
          multiViewport = none;
          Level.SetOnlyPostRender(false);
        }
      }

      if ( fCamViewPercent > 0.0 )
      {
        CamView.Instigator = pawn;
        CamView.RenderOverlays(C);
//        return; // don't return as we render in a viewport.
      }
    }

    if ( bWeaponMode && (Pawn != none) && (Pawn.Weapon != none) )
    {
//      if ( !Pawn.Weapon.IsAnimating() )
//        Pawn.Weapon.AnimEnd(0); // Anti bug, if selected MUST Have an animation
      if ( Pawn.Weapon.Instigator != Pawn ) // don't bNetDirty by instigator changed each frame
        Pawn.Weapon.Instigator = Pawn;
      Pawn.Weapon.RenderOverlays(C);
    }
    if ( !bWeaponMode && (Pawn != none) )
    {
//      if ( !Pawn.SelectedItem.IsAnimating() )
//        Pawn.SelectedItem.AnimEnd(0); // Anti bug, if selected MUST Have an animation
      if ( Pawn.SelectedItem != none )
        Pawn.SelectedItem.RenderOverlays(C);
      else
      { // bug ?
        NextWeapon();
        Pawn.ChangedWeapon();
      }
    }

    if ( (Pawn != none) && (XIIIPawn(Pawn).LHand != None) && (XIIIPawn(Pawn).LHand.bActive) )
    {
      XIIIPawn(Pawn).LHand.RenderOverlays(C);
    }
}

//_____________________________________________________________________________
function ClientTargetHighLight( int Alpha, float TargetHighLight, float Duration)
{ // compute Dec values per millsec
    VignetteFlashDecFactor = (TargetHighLight - VignetteHighLight) / Duration;
    VignetteAlphaDecFactor = (Alpha - VignetteColor.A) / Duration;
    VignetteSFXduration = Duration;
    VignetteAlpha = VignetteColor.A;
}

//_____________________________________________________________________________
// ELR made zooming speed higher
function AdjustView(float DeltaTime )
{
    // teleporters affect your FOV, so adjust it back down
    if ( FOVAngle != DesiredFOV )
    {
      if ( FOVAngle > DesiredFOV )
        FOVAngle = FOVAngle - FMax(7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV));
      else
        FOVAngle = FOVAngle - FMin(-7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV));
      if ( Abs(FOVAngle - DesiredFOV) <= 10 )
        FOVAngle = DesiredFOV;
    }

    // adjust FOV for weapon zooming
    if ( bZooming )
    {
      ZoomLevel += DeltaTime * 1.5;
      if (ZoomLevel > 0.95)
        ZoomLevel = 0.95;
      DesiredFOV = FClamp(90.0 - (ZoomLevel * 88.0), 1, 170);
    }

    // Handle here because we do have DeltaTime
    if ( ((UseVignetteFilter != 0) || (UseVignetteHighlight != 0)) && ( VignetteSFXduration > 0) )
    {
      VignetteHighLight += (DeltaTime * VignetteFlashDecFactor);
      VignetteAlpha += (Deltatime * VignetteAlphaDecFactor);
      VignetteColor.A = VignetteAlpha;
      VignetteSFXduration -= DeltaTime;
//      Log("VignetteSFXduration="$VignetteSFXduration@"VignetteHighLight="$VignetteHighLight@"VignetteColor="$VignetteColor.R$"."$VignetteColor.G$"."$VignetteColor.B$"."$VignetteAlpha);
      if ( VignetteSFXduration <= 0 )
      {
        UseVignetteFilter = 0;
        UseVignetteHighlight = 0;
      }
    }
}

//_____________________________________________________________________________
/* AdjustAim()
  Calls this version for player aiming help.
  Aimerror not used in this version.
  Only adjusts aiming at pawns
*/
// ELR computes AimSpot and return rotator(AimSpot - projStart)
//Simulated function rotator AdjustAim(float projSpeed, vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget, bool bTossed, bool bTrySplash)
// AimCalcMode is used as 0 = weapon firing, 1 = interface aim anticipation
Simulated function rotator AdjustAim(Ammunition FiredAmmunition, vector projStart, int AimCalcMode)
{
    if ( Pawn != None && !Pawn.IsLocallyControlled() )
      AdjustAimForDisplay(FiredAmmunition, ProjStart);

    if ( !FiredAmmunition.bInstantHit )
      return rotator(AdjustedAimForFiring);
    else
      return rotator(OldAdjustAim);
}

//_____________________________________________________________________________
exec function ShowMenu()
{
    log("SHOWMENU: "$self);
    if ( !Level.bLonePlayer || !Level.Game.bGameEnded || (XIIIGameInfo(Level.Game).XIIIEndGameType!=4) )
      ConsoleCommand("ShowTheMenu "$self);
    if ( VP != none )
      VP.Stop();
}

exec function ShowInfo()
{
    log("SHOWINFO: "$self);
    if (!bMenuIsActive)
      MyHud.ShowScores();
}

//_____________________________________________________________________________
exec function Duck( optional float F )
{
  bPressedDuck = true;
}

//_____________________________________________________________________________
exec function QuickHeal()
{
    Local inventory Inv;

    DebugLog("Quick Heal Call");
    if ( (Pawn != none) && (Pawn.region.zone != none) && Pawn.region.Zone.FlashEffectDesc.IsActivated )
      return;

    if ( bWeaponBlock )
      return;

    if ( !bWeaponMode )
    {
      if ( Med(Pawn.SelectedItem) != none )
      {
        ActivateItem();
        return;
      }
      if ( Med(Pawn.PendingItem) != none )
      { // don't use a possible pending item to avoid pb switching
        return;
      }
    }

    if ( XIIIPawn(Pawn).HealthPercent() <= 25 )
    { //seek FullMedKit
      Inv = Pawn.FindInventoryType(class'FullMedKit');
      if ( Inv == none )
        Inv = Pawn.FindInventoryType(class'MedKit');
    }
    else if ( XIIIPawn(Pawn).IsWounded() )
    { //seek MedKit
      Inv = Pawn.FindInventoryType(class'MedKit');
      if ( Inv == none )
        Inv = Pawn.FindInventoryType(class'FullMedKit');
    }
    if ( Inv != none )
    {
      DebugLog("Quick Heal Should HEAL using "$Inv);
      Med(Inv).UseMeQuick(self);
      if ( Med(Inv).Charge <=0 )
      {
        if ( Pawn.SelectedItem == Inv )
          Pawn.SelectedItem = none;
        if ( Pawn.PendingItem == Inv )
          Pawn.PendingItem = none;
        if ( OldItem == Inv )
          OldItem = none;
        Med(Inv).UsedUpNoChange();
      }
    }

}

//_____________________________________________________________________________
// ELR Use the ForceReload function of base weapons functions
exec function ReLoad()
{
    if ( (Pawn != none) && (Pawn.region.zone != none) && Pawn.region.Zone.FlashEffectDesc.IsActivated )
      return;

    ForceReload();
}

//_____________________________________________________________________________
// can't reload if have grabbed corpse/pawn
exec function ForceReload()
{
//    Log("ForceReLoad, Pawn="$Pawn@"Pawn.Weapon="$Pawn.Weapon);
    if ( Level.bLonePlayer )
    {
      if ( (Pawn != None) && (Pawn.Weapon != None) && (XIIIPawn(Pawn).LHand.pOnShoulder == none) )
        Pawn.Weapon.ForceReload();
    }
    else
      if ( (Pawn != None) && (Pawn.Weapon != None) )
        Pawn.Weapon.ForceReload();
}

//_____________________________________________________________________________
// The player wants to fire.
exec function Fire( optional float F )
{
    if ( Pawn.region.Zone.FlashEffectDesc.IsActivated )
      return;

    XIIIBaseHud(MyHud).fDrawWeaponsTimer = Level.TimeSeconds-10; // get rid of weapon/item drawing list

    if ( XIIIPlayerPawn(Pawn).SSSk != none )
      XIIIPlayerPawn(Pawn).SSSk.ResetTimer();

    if ( IsInState('CameraView') )
    {
      RestoreView();
      return;
    }
    if ( bWeaponMode )
    {
      if ( Pawn.Weapon != None )
        Pawn.Weapon.Fire(F);
    }
    else
    {
      if ( !bWeaponMode && (Hook(Pawn.SelectedItem) != none) )
      {
        if ( !Hook(Pawn.SelectedItem).bGoUp && (!Hook(Pawn.SelectedItem).bGoDown || Hook(Pawn.SelectedItem).ActivatedByFire) )
        {
          Hook(Pawn.SelectedItem).ActivatedByFire = true;
          ActivateItem();
        }
      }
      else
      {
//        log("Activating item via fire call");
        ActivateItem();
      }
      if (Level.NetMode == NM_Client)
      {
//        Log("Activate Item (on client) "@Pawn.SelectedItem);
        if ( Level.Pauser!=None )
          return;
        if ( (Pawn != None) && (Pawn.SelectedItem!=None) )
          Pawn.SelectedItem.Activate();
      }
    }
}

//_____________________________________________________________________________
// The player Release fire.
exec function UnFire( optional float F )
{
//    Log("Calling Unfire");
    if ( bWeaponMode )
    {
      if ( (Pawn != none) && (XIIIWeapon(Pawn.Weapon) != None) )
        XIIIWeapon(Pawn.Weapon).UnFire(F);
    }
}

//_____________________________________________________________________________
exec function AltFire( optional float F )
{
    if ( Pawn.region.Zone.FlashEffectDesc.IsActivated )
      return;

    if ( IsInState('CameraView') )
    {
      RestoreView();
      return;
    }
    if ( !bWeaponMode && (Hook(Pawn.SelectedItem) != none) && bHooked && !Hook(Pawn.SelectedItem).bGoDown && !Hook(Pawn.SelectedItem).bGoUp)
    {
      Hook(Pawn.SelectedItem).ActivatedByAltFire = true;
      ActivateItem();
    }
/*
    else if ( XIIIPawn(Pawn).LHand.pOnShoulder != none )
    {
      XIIIPawn(Pawn).LHand.UnGrabPawn();
    }
    else if ( MyInteraction.bCanGrabCorpse || MyInteraction.bCanTakePrisonner )
    {
      XIIIPawn(Pawn).LHand.GrabPawn(XIIIPawn(MyInteraction.TargetActor));
      XIIIPawn(Pawn).CheckMaluses();
    }
*/
//    else if ( !bWeaponMode && (Micro(Pawn.SelectedItem) != none) ) // Creates dependency
    else if ( !bWeaponMode && Pawn.SelectedItem.IsA('Micro') ) // don't create dependency
      Fire();
    else if ( bWeaponMode )
      WeaponZoom();
}

//_____________________________________________________________________________
// ELR hide/unhide Weapon
simulated function SwitchWeaponMode()
{
    local inventory I;

    DebugLog(">>> SwitchWeaponMode call, bWeaponMode="$bWeaponMode@"bWaitForWeaponMode="$bWaitForWeaponMode);

    if ( !bWeaponMode )
    {
      DebugLog("  > Calling PutDown for"@XIIIItems(Pawn.SelectedItem));
      XIIIItems(Pawn.SelectedItem).PutDown();
      if ( XIIIPawn(Pawn).bHaveOnlyOneHandFree && (XIIIWeapon(Pawn.Weapon).WHand == WHA_2HShot) )
        Pawn.PendingWeapon = Pawn.Inventory.NextWeapon(None, Pawn.Weapon);
      else
        Pawn.PendingWeapon = Pawn.Weapon;
    }
    else
    {
      if ( !bHooked ) // Reset to MedKits priority
        XIIIPawn(Pawn).SelectedItem = Pawn.Inventory.NextItem(none, none);
      else
        XIIIPawn(Pawn).SelectedItem = HookUsed;
      if ( XIIIPawn(Pawn).bHaveOnlyOneHandFree && (XIIIItems(Pawn.SelectedItem).IHand == IH_2H) )
        XIIIPawn(Pawn).SelectedItem = Pawn.Inventory.NextItem(none, XIIIPawn(Pawn).SelectedItem);
      if ( XIIIPawn(Pawn).SelectedItem != none )
      {
//        XIIIPawn(Pawn).PendingItem = Pawn.SelectedItem;
        DebugLog("  > Calling PutDown for"@Pawn.Weapon);
        Pawn.Weapon.PutDown();
      }
      else
      { // Cancel Change
        bWaitForWeaponMode = true;
      }
/*
      I = Pawn.Inventory.SelectNext();
//      log("  > SelectNext Result="$I);
      if (I != none )
      {
        XIIIPawn(Pawn).PendingItem = Pawn.SelectedItem;
//        log("  > Calling Putdown for"@Pawn.Weapon);
        Pawn.Weapon.PutDown();
      }
      else
      {
        bWaitForWeaponMode = true;
      }
*/
    }
//    ServerSwitchWeaponMode(bWeaponMode, bWaitForWeaponMode);
}

//_____________________________________________________________________________
// ELR hide/unhide Weapon (Used by the DecoWeapon to hide weapon then put it back when used)
exec function HideWeapon()
{
    if ( XIIIWeapon(pawn.Weapon) != none )
    {
      if ( bWeaponMode )
        SwitchWeapon( OldWeap );
      else
      {
        OldWeap = pawn.weapon.InventoryGroup;
        switchweapon( 0 );
      }
    }
}

//_____________________________________________________________________________
exec function PrevWeapon()
{
    if ( Pawn.region.Zone.FlashEffectDesc.IsActivated )
      return;

    if ( (Pawn.PendingWeapon != none) && (DecoWeapon(Pawn.PendingWeapon) != none) )
      return;

//    if ( (XIIIItems(Pawn.SelectedItem) != none) && XIIIItems(Pawn.SelectedItem).bChangeItem && !Pawn.SelectedItem.IsAnimating() )
//    { // Bug chance for freezed inventory switching
//      Pawn.SelectedItem.AnimEnd(0);
//    }
//    if ( (Pawn.Weapon != none) && Pawn.Weapon.bChangeWeapon && !Pawn.Weapon.IsAnimating() )
//    { // Bug chance for freezed inventory switching
//      Pawn.Weapon.AnimEnd(0);
//    }

    Pawn.PendingItem = none;

    XIIIBaseHud(MyHud).bDrawWeapons = true;
    XIIIBaseHud(MyHud).bDrawItems = false;
    XIIIBaseHud(MyHud).fDrawWeaponsTimer = Level.TimeSeconds + 1.0;
    XIIIBaseHud(MyHud).fDrawItemsTimer = Level.TimeSeconds - 1.0;

//    if ( bWeaponMode || bWaitForWeaponMode )
    if ( bWaitForWeaponMode )
    {
      if ( Level.Pauser != None )
        return;
      if ( Pawn.Weapon == None )
      {
        SwitchToBestWeapon();
        return;
      }
      if ( Pawn.PendingWeapon != None )
        Pawn.PendingWeapon = Pawn.Inventory.PrevWeapon(None, Pawn.PendingWeapon);
      else
        Pawn.PendingWeapon = Pawn.Inventory.PrevWeapon(None, Pawn.Weapon);

      if ( Pawn.PendingWeapon != None )
      {
        Pawn.Weapon.PutDown();
      }
    }
    else
    {
      XIIIBaseHud(MyHud).fDrawWeaponsTimer = Level.TimeSeconds+2.0;
      bWaitForWeaponMode = true;
      SwitchWeaponMode();
    }
}

//_____________________________________________________________________________
exec function NextWeapon()
{
    if ( Pawn.region.Zone.FlashEffectDesc.IsActivated )
      return;

    if ( (Pawn.PendingWeapon != none) && (DecoWeapon(Pawn.PendingWeapon) != none) )
      return;

//    if ( (XIIIItems(Pawn.SelectedItem) != none) && XIIIItems(Pawn.SelectedItem).bChangeItem && !Pawn.SelectedItem.IsAnimating() )
//    { // Bug chance for freezed inventory switching
//      Pawn.SelectedItem.AnimEnd(0);
//    }
//    if ( (Pawn.Weapon != none) && Pawn.Weapon.bChangeWeapon && !Pawn.Weapon.IsAnimating() )
//    { // Bug chance for freezed inventory switching
//      Pawn.Weapon.AnimEnd(0);
//    }
    Pawn.PendingItem = none;

    XIIIBaseHud(MyHud).bDrawWeapons = true;
    XIIIBaseHud(MyHud).bDrawItems = false;
    XIIIBaseHud(MyHud).fDrawWeaponsTimer = Level.TimeSeconds + 1.0;
    XIIIBaseHud(MyHud).fDrawItemsTimer = Level.TimeSeconds - 1.0;

//    if ( bWeaponMode || bWaitForWeaponMode )
    if ( bWaitForWeaponMode )
    {
//      Log("> NextWeapon call in "$self);
      if( Level.Pauser!=None )
        return;
      if ( Pawn.Weapon == None )
      {
        SwitchToBestWeapon();
        return;
      }
      if ( Pawn.PendingWeapon != None )
        Pawn.PendingWeapon = Pawn.Inventory.NextWeapon(None, Pawn.PendingWeapon);
      else
        Pawn.PendingWeapon = Pawn.Inventory.NextWeapon(None, Pawn.Weapon);

      if ( Pawn.PendingWeapon != None )
      {
        Pawn.Weapon.PutDown();
      }
    }
    else
    {
      XIIIBaseHud(MyHud).fDrawWeaponsTimer = Level.TimeSeconds+2.0;
      bWaitForWeaponMode = true;
      SwitchWeaponMode();
    }
}


//_____________________________________________________________________________
// we want the player to switch to weapon group number F.
exec function SwitchWeapon( byte F )
{
	local weapon newWeapon;

	if ( (Pawn == none) || Pawn.bIsDead )
	  return;

	if ( (Level.Pauser!=None) || (Pawn == None) || (Pawn.Inventory == None) )
		return;
	if ( (Pawn.Weapon != None) && (Pawn.Weapon.Inventory != None) )
		newWeapon = Pawn.Weapon.Inventory.WeaponChange(F);
	else
		newWeapon = None;
	if ( newWeapon == None )
		newWeapon = Pawn.Inventory.WeaponChange(F);

	if ( newWeapon == None )
	{ // ELR Don't just return, switchweapon(0) instead
    SwitchWeapon(0);
  	return;
  }

	if ( Pawn.Weapon == None )
	{
		Pawn.PendingWeapon = newWeapon;
		Pawn.ChangedWeapon();
	}
	else if ( Pawn.Weapon != newWeapon )
	{
		Pawn.PendingWeapon = newWeapon;
		if ( !Pawn.Weapon.PutDown() )
			Pawn.PendingWeapon = None;
	}
}

/*
//_____________________________________________________________________________
exec function TestNI()
{
    local int i;
    local inventory Inv;

    Inv = Pawn.Inventory;
    Log("BEGIN Testing NextItem From PawnInventory"@Inv);
    for (i=0; i<5; i++)
    {
      if ( inv != none )
      {
        if ( PowerUps(Inv) != none )
          Inv = Inv.NextItem(none, PowerUps(Inv));
        else
          Inv = Inv.NextItem(none, none);
        if ( Inv != none )
          Log("  Next Inv="$Inv);
        else
          Log("  Next Inv=NONE");
      }
    }
    Log("END Testing NextItem");
    Inv = Pawn.Inventory;
    Log("BEGIN Testing NextItem From PawnSelectedItem"@Pawn.SelectedItem);
    for (i=0; i<5; i++)
    {
      if ( inv != none )
      {
        if ( Pawn.SelectedItem != none )
          Inv = Inv.NextItem(none, Pawn.SelectedItem);
        else
          Inv = Inv.NextItem(none, none);
        if ( Inv != none )
          Log("  Next Inv="$Inv);
        else
          Log("  Next Inv=NONE");
      }
    }
    Log("END Testing NextItem");
}
*/

//_____________________________________________________________________________
// ELR Just to cancel it in some states
exec function cPrevItem()
{
    Local inventory tInv;

    if ( Pawn.region.Zone.FlashEffectDesc.IsActivated )
      return;

    DebugLog("PREVITEM bWeaponMode="$bWeaponMode@"PendingWeapon="$Pawn.PendingWeapon);

    if ( DecoWeapon(Pawn.PendingWeapon) != none )
      return;

//    if ( (XIIIItems(Pawn.SelectedItem) != none) && XIIIItems(Pawn.SelectedItem).bChangeItem && !Pawn.SelectedItem.IsAnimating() )
//    { // Bug chance for freezed inventory switching
//      Pawn.SelectedItem.AnimEnd(0);
//    }
//    if ( (Pawn.Weapon != none) && Pawn.Weapon.bChangeWeapon && !Pawn.Weapon.IsAnimating() )
//    { // Bug chance for freezed inventory switching
//      Pawn.Weapon.AnimEnd(0);
//    }

    Pawn.PendingWeapon = none;

    XIIIBaseHud(MyHud).bDrawWeapons=false;
    XIIIBaseHud(MyHud).bDrawItems = true;
    XIIIBaseHud(MyHud).fDrawItemsTimer = 1.0+Level.TimeSeconds;
    XIIIBaseHud(MyHud).fDrawWeaponsTimer = Level.TimeSeconds-1.0;

//    if ( !bWeaponMode || !bWaitForWeaponMode )
    if ( !bWaitForWeaponMode )
    { // Selecting next item
      DebugLog("  > cPrevItem call in "$self$", switching items w/ SelectedItem="$Pawn.SelectedItem);
      if( Level.Pauser != None )
        return;
      if ( XIIIPawn(Pawn).PendingItem == none )
        XIIIPawn(Pawn).PendingItem = Pawn.Inventory.PrevItem(none, Pawn.SelectedItem);
      else
        XIIIPawn(Pawn).PendingItem = Pawn.Inventory.PrevItem(none, XIIIPawn(Pawn).PendingItem);
      if ( (XIIIPawn(Pawn).PendingItem != None) && (XIIIPawn(Pawn).PendingItem != Pawn.SelectedItem) )
      {
        if(  XIIIItems(Pawn.SelectedItem) != none )
        {
          XIIIItems(Pawn.SelectedItem).PutDown();
          DebugLog("  > cPrevItem puting down"@XIIIItems(Pawn.SelectedItem));
        }
        else
        {
          Pawn.SelectedItem = XIIIPawn(Pawn).PendingItem;
          XIIIItems(XIIIPawn(Pawn).PendingItem).BringUp();
          DebugLog("  > cPrevItem BringUp"@XIIIPawn(Pawn).PendingItem@"because selected = none");
        }
        return;
      }
      if ( (XIIIPawn(Pawn).PendingItem == None) && (Pawn.SelectedItem == none) )
      {
        Warn("!@! PrevItem w/ Pending item & Item none");
        NextWeapon();
        Pawn.ChangedWeapon();
      }
    }
    else
    {
      DebugLog(">>> cPrevItem call in "$self$", going to item mode");
      XIIIBaseHud(MyHud).fDrawItemsTimer = 2.0+Level.TimeSeconds;
      bWaitForWeaponMode = false;
      SwitchWeaponMode();
    }
}

//_____________________________________________________________________________
// ELR Just to cancel it in some states
exec function cNextItem()
{
    Local inventory tInv;

    if ( Pawn.region.Zone.FlashEffectDesc.IsActivated )
      return;

    DebugLog("NEXTITEM bWeaponMode="$bWeaponMode@"PendingWeapon="$Pawn.PendingWeapon);

    if ( DecoWeapon(Pawn.PendingWeapon) != none )
      return;

//    if ( (XIIIItems(Pawn.SelectedItem) != none) && XIIIItems(Pawn.SelectedItem).bChangeItem && !Pawn.SelectedItem.IsAnimating() )
//    { // Bug chance for freezed inventory switching
//      Pawn.SelectedItem.AnimEnd(0);
//    }
//    if ( (Pawn.Weapon != none) && Pawn.Weapon.bChangeWeapon && !Pawn.Weapon.IsAnimating() )
//    { // Bug chance for freezed inventory switching
//      Pawn.Weapon.AnimEnd(0);
//    }

    Pawn.PendingWeapon = none;

    XIIIBaseHud(MyHud).bDrawWeapons = false;
    XIIIBaseHud(MyHud).bDrawItems = true;
    XIIIBaseHud(MyHud).fDrawItemsTimer = 1.0+Level.TimeSeconds;
    XIIIBaseHud(MyHud).fDrawWeaponsTimer = Level.TimeSeconds-1.0;

//    if ( !bWeaponMode || !bWaitForWeaponMode )
    if ( !bWaitForWeaponMode )
    { // Selecting next item
      DebugLog("  > cNextItem call in "$self$", switching items w/ SelectedItem="$Pawn.SelectedItem);
      if( Level.Pauser != None )
        return;
      if ( XIIIPawn(Pawn).PendingItem == none )
        XIIIPawn(Pawn).PendingItem = Pawn.Inventory.NextItem(none, Pawn.SelectedItem);
      else
        XIIIPawn(Pawn).PendingItem = Pawn.Inventory.NextItem(none, XIIIPawn(Pawn).PendingItem);
      if ( (XIIIPawn(Pawn).PendingItem != None) && (XIIIPawn(Pawn).PendingItem != Pawn.SelectedItem) )
      {
        if ( XIIIItems(Pawn.SelectedItem) != none )
        {
          XIIIItems(Pawn.SelectedItem).PutDown();
          DebugLog("  > cNextItem puting down"@XIIIItems(Pawn.SelectedItem));
        }
        else
        {
          Pawn.SelectedItem = XIIIPawn(Pawn).PendingItem;
          XIIIItems(XIIIPawn(Pawn).PendingItem).BringUp();
          DebugLog("  > cNextItem BringUp"@XIIIPawn(Pawn).PendingItem@"because selected = none");
        }
        return;
      }
      if ( (XIIIPawn(Pawn).PendingItem == None) && (Pawn.SelectedItem == none) )
      {
        Warn("!@! PrevItem w/ Pending item & Item none");
        NextWeapon();
        Pawn.ChangedWeapon();
      }
    }
    else
    {
      DebugLog(">>> cNextItem call in "$self$", going to item mode");
      XIIIBaseHud(MyHud).fDrawItemsTimer = 2.0+Level.TimeSeconds;
      bWaitForWeaponMode = false;
      SwitchWeaponMode();
    }
}

//_____________________________________________________________________________
exec function WeaponZoom()
{
//    Log(self@" WeaponZoom");
    if ( (Pawn != None) && (Pawn.Weapon != None) )
    {
      if ( XIIIWeapon(Pawn.Weapon).bHaveAltFire )
      {
//        Log(self@" calling Altfire");
        Pawn.Weapon.AltFire(0);
      }
      else
      {
//        Log(self@" calling zoom");
        Pawn.Weapon.Zoom();
      }
    }
}

//_____________________________________________________________________________
exec function Grab()
{
    local PowerUps PwrU;

    DebugLog("GRAB");
    // If in cameraview, restore view instead of interaction
    if ( IsInState('CameraView') )
    {
      RestoreView();
      return;
    }

    // Hook interactions
    if ( bHooked )
    {
      if ( !bWeaponMode  )
      {
        if ( (Hook(Pawn.SelectedItem) != none) )
        {
          Hook(Pawn.SelectedItem).Release();
          return;
        }
      }
      else if ( bWaitForWeaponMode )
      {
        cNextItem();
        return;
      }
    }
    if ( MyInteraction.bCanHook )
    {
      ActivateItem();
      return;
    }

    if ( MyInteraction.bCanBreak )
    {
      MyInteraction.TargetActor.TakeDamage(50, Pawn, MyInteraction.TargetActor.Location, vect(0,0,0), class'DTFisted');
      MyInteraction.TargetActor = none;
      return;
    }

    // Priority to interaction w/ door
    if ( MyInteraction.bCanDoor && !MyInteraction.bCanTrigger )
    {
      if ( MyInteraction.bCanUnLockDoor )
      {
        PwrU = TryInteractWithDoor(MyInteraction.TargetActor);
        if ( ( bWeaponMode ) && (PwrU != none) )
        {
          cNextItem();
          XIIIPawn(Pawn).PendingItem = PwrU;
          if ( (XIIIPawn(Pawn).PendingItem != None) && (XIIIPawn(Pawn).PendingItem != Pawn.SelectedItem) )
            XIIIItems(Pawn.SelectedItem).PutDown();
          return;
        }
        else if ( (!bWeaponMode) && (PwrU != none) )
        {
          if (PwrU == Pawn.SelectedItem)
            Pawn.SelectedItem.Activate();
          else
          {
            cNextItem();
            XIIIPawn(Pawn).PendingItem = PwrU;
            if ( (XIIIPawn(Pawn).PendingItem != None) && (XIIIPawn(Pawn).PendingItem != Pawn.SelectedItem) )
              XIIIItems(Pawn.SelectedItem).PutDown();
          }
          return;
        }
        else if ( XIIIMover(MyInteraction.TargetActor) != none )
        {
          if ( XIIIBaseHud(MyHud).HudDlg == none ) // only send this message if not in a dialog already
            MyHud.LocalizedMessage( class'XIIIDialogMessage', 1, none, none, none, XIIIMover(MyInteraction.TargetActor).LockedMessage );
          return;
        }
      }
      else
      {
        if ( XIIIMover(MyInteraction.TargetActor) != none )
        {
          XIIIMover(MyInteraction.TargetActor).PlayerTrigger(self, Pawn);
          XIIIPawn(Pawn).PlayOpenDoor();
          return;
        }
        else if ( MagneticPassTrigger(MyInteraction.TargetActor) != none )
        {
          MagneticPassTrigger(MyInteraction.TargetActor).PlayerTrigger(self, Pawn);
          XIIIPawn(Pawn).PlayOpenDoor();
          return;
        }
      }
    }

    // next priority to search a corpse
    if ( MyInteraction.bCanSearchCorpse )
    {
      SearchPawn(XIIIPawn(MyInteraction.TargetActor));
      return;
    }

    if ( MyInteraction.bCanPickup )
    {
      DebugLog("GRAB PICKUP");
      if ( MyInteraction.TargetActor.IsA('XIIIDecoPickup')
//        && ((DecoWeapon(Pawn.Weapon) != none) || (DecoWeapon(Pawn.PendingWeapon) != none)) )
        && ((DecoWeapon(Pawn.PendingWeapon) != none) || (DecoWeapon(Pawn.Weapon) != none)) )
        return;
      bPickingUp = true;
      MyInteraction.TargetActor.Touch(Pawn);
      bPickingUp = false;
      MyInteraction.TargetActor = none;
      return;
    }

    // then trigger actor
    if ( MyInteraction.bCanTrigger )
    {
      PwrU = TryInteractWithTrigger(MyInteraction.TargetActor);
//      Log("GRAB TRIGGER, Interaction item should be PwrU="$PwrU);
      if ( ( bWeaponMode ) && (PwrU != none) )
      {
        cNextItem();
        XIIIPawn(Pawn).PendingItem = PwrU;
        if ( (XIIIPawn(Pawn).PendingItem != None) && (XIIIPawn(Pawn).PendingItem != Pawn.SelectedItem) )
          XIIIItems(Pawn.SelectedItem).PutDown();
      }
      else if ( (!bWeaponMode) && (PwrU != none) )
      {
        if (PwrU == Pawn.SelectedItem)
          Pawn.SelectedItem.Activate();
        else
        {
          cNextItem();
          XIIIPawn(Pawn).PendingItem = PwrU;
          if ( (XIIIPawn(Pawn).PendingItem != None) && (XIIIPawn(Pawn).PendingItem != Pawn.SelectedItem) )
            XIIIItems(Pawn.SelectedItem).PutDown();
        }
      }
      else
        XIIITriggers(MyInteraction.TargetActor).PlayerTrigger(self, Pawn);
      return;
    }

    if ( MyInteraction.bCantDoor )
    {
      XIIIMover(MyInteraction.TargetActor).PlayerTrigger(self, Pawn);
      return;
    }

    // next priority to grab/ungrab pawn
    if ( XIIIPawn(Pawn).LHand != none )
    {
      if ( XIIIPawn(Pawn).LHand.pOnShoulder != none )
      {
        XIIIPawn(Pawn).LHand.UnGrabPawn();
        return;
      }
      else if (
          (MyInteraction.bCanGrabCorpse && XIIIPawn(Pawn).CanGrabCorpse(XIIIPawn(MyInteraction.TargetActor)) )
       || (MyInteraction.bCanTakePrisonner && XIIIPawn(Pawn).CanTakePrisonner(XIIIPawn(MyInteraction.TargetActor))) )
      {
        if ( bWeaponMode && Pawn.Weapon.bHaveSlave )
          Pawn.Weapon.MySlave.PutDown();
        XIIIPawn(Pawn).LHand.GrabPawn(XIIIPawn(MyInteraction.TargetActor));
        XIIIPawn(Pawn).CheckMaluses();
        return;
      }
    }

    if ( bWeaponMode && (Pawn.Weapon.Default.ReloadCount > Pawn.Weapon.ReloadCount) )
    {
      ReLoad();
      return;
    }

    if ( !bWeaponMode && Pawn.SelectedItem.IsA('Med') )
    {
      Pawn.SelectedItem.Activate();
      return;
    }
}

//_____________________________________________________________________________
// The player wants to active selected item
exec function ActivateItem()
{
    DebugLog("Activate Item"@Pawn.SelectedItem);
    if ( Level.Pauser!=None )
      return;
    if ( (Pawn != None) && (Pawn.SelectedItem!=None) )
      Pawn.SelectedItem.Activate();
}

//_____________________________________________________________________________
// ELR - Do we still pick the lock ? return true if no.
function bool CanUseLockPick()
{
    if ( XIIIPorte(MyInteraction.TargetActor) == none )
      return false;
    return ( XIIIPorte(MyInteraction.TargetActor).IsInState('Locked') );
}

//_____________________________________________________________________________
// ELR - Do we still pick the lock ? return true if no.
function bool CheckPickLock()
{
    local actor HitActor;

    HitActor = MyInteraction.TargetActor;
    if ( (HitActor == none) || (aDoor != HitActor) )
    {
      if ( aDoor != none )
        aDoor.UnTrigger( Pawn.SelectedItem, pawn );
      aDoor = none;
      return true;
    }
    if ( aDoor.IsInState('PlayerTriggerToggle') )
    { // Unlocked
      aDoor = none;
      MyHud.LocalizedMessage(class'XIIISoloMessage', 2);
    }
    return false;
}

//_____________________________________________________________________________
// ELR - Do we still pick the lock ? return true if no.
function CancelPickLock()
{
    if ( aDoor != none )
      aDoor.UnTrigger( Pawn.SelectedItem, pawn );
    aDoor = none;
}

//_____________________________________________________________________________
// ELR - Here we define if the controller allow the use of a lockpick
function bool TryPickLock()
{
    aDoor = XIIIPorte(MyInteraction.TargetActor);
//    DebugLog("TryPickLock "$aDoor);
    if ( (aDoor != none) && aDoor.IsInState('Locked') )
    {
      aDoor.Trigger( Pawn.SelectedItem, Pawn );
//      MyHud.LocalizedMessage(class'XIIISoloMessage', 1);
      return true;
    }
    else
      aDoor = none;
    return false;
}

//_____________________________________________________________________________
// return the inventory object to be used to interact with A
// should be used w/ Grab Controller function to automatically get the item out.
function PowerUps TryInteractWithDoor(actor A)
{
  Local XIIIPorte XP;
  local PowerUps I;

  XP = XIIIPorte(A);
  if ( (XP != none) && XP.IsInState('Locked') )
  {
    I = XIIIPawn(Pawn).FindPowerUpItemName(XP.UnLockItemName);
    if ( I == none )
      I = XIIIPawn(Pawn).FindPowerUpItemName(XP.UnLockItemCode);
//    Log(">> "$I$" should be used to interact with "$A);
    return I;
  }

  return none;
}

//_____________________________________________________________________________
// return the inventory object to be used to interact with A
// should be used w/ Grab Controller function to automatically get the item out.
function PowerUps TryInteractWithTrigger(actor A)
{
  Local XIIITriggers XT;
  local PowerUps I;

  XT = XIIITriggers(A);
  if ( XT != none )
  {
//    Log("TryInteractWithTrigger XT="$XT$" TAG="$XT.Tag);
    I = XIIIPawn(Pawn).FindPowerUpItemNameForTrigger(XT.Tag);
//    Log(">> "$I$" should be used to interact with "$A);
    return I;
  }

  return none;
}

//_____________________________________________________________________________
// ::TODO:: put in native (may not optimize the trace but everytinh else & called each frame so...)
function actor ReturnTrace(out vector HitLoc, out vector HitNorm, vector End, vector Start, bool bActor, optional vector Extent, optional out Material HitMat, optional int TraceType)
{
    local actor PickMe, PotentialDoor;
    local vector HitLoc2, HitNorm2;

    foreach TraceActors(class'actor', Pickme, HitLoc, HitNorm, End, Start, vect(0,0,0), TraceType)
    {
      if ( Pickme == Level ) // stop the iterator at first Level hit
        return none;
      if ( (Pickme != none) && Pickme.bInteractive && (PickMe != Pawn) )
      {
        if ( XIIIPorte(Pickme) != none )
        {
          PotentialDoor = Trace(HitLoc2, HitNorm2, HitLoc - HitNorm, Start, false, vect(0,0,0), HitMat, TraceType);
          if ( PotentialDoor != none )
          {
            HitLoc = hitLoc2;
            HitNorm = hitNorm2;
            Pickme = PotentialDoor;
            return PickMe;
          }
          else if ( FastTrace(HitLoc, Start) )
            return PickMe;
        }
        else
        {
          if ( FastTrace(HitLoc, Start) )
          {
            if ( Pickup(PickMe) != none )
              return PickMe;
            else
              return PickMe;
          }
        }
      }
    }
    return none;
}

//_____________________________________________________________________________
function bool AllowHooking()
{
    return ( !bWeaponMode && (Hook(Pawn.SelectedItem)!=none) );
}

//_____________________________________________________________________________
// ELR - check if we can send the controller into Tyrol state
function bool TryTyroling()
{
    return true;
}

//_____________________________________________________________________________
// Set up the tyroling params, called by TyrolTrigger
function GoTyroling(XIIITyrolNavPoint StartPoint, XIIITyrolNavPoint EndPoint, float TyrolSpeed)
{
//    Log("SetUpTyrol w/ StartPoint="$StartPoint$" EndPoint="$EndPoint$" TyrolSpeed="$TyrolSpeed);
    fTyrolSpeed = TyrolSpeed;
    vTyrolStart = StartPoint.Location - vect(0,0,1)*Pawn.CollisionHeight;
    vTyrolEnd = EndPoint.Location - vect(0,0,1)*Pawn.CollisionHeight;
    vTyrolDir = normal(vTyrolEnd - vTyrolStart);
    Pawn.SetPhysics(PHYS_None);
    Pawn.SetLocation(vTyrolStart);
    Pawn.SetRotation(rotator(vTyrolDir));
    Pawn.Velocity = vTyrolDir * 5.0;
    Pawn.Acceleration = vect(0,0,0);
    SetLocation(vTyrolStart);
    SetRotation(rotator(vTyrolDir));
    gotoState('Tyroling');
}

//_____________________________________________________________________________
function SearchPawn(XIIIPawn P)
{
    local inventory I, OwnI;
    local class<ammo> A;
    local bool bDBSearch;
    local ammunition IAmmo, IAltAmmo;

    bDBSearch = false;

    if ( !P.bIsDead )
      return;
    if ( bDBSearch ) Log(" investigating "$P$" corpse");

    XIIIPawn(Pawn).PlaySearchCorpse();

//    XIIICheatManager(CheatManager).LogInventory();
    if (P.Inventory == none)
    {
      ReceiveLocalizedMessage( class'XIIISoloMessage', 4, None, None);
      return;
    }

    if ( P.Shadow != none )
    {
      P.Shadow.bShadowIsStatic = false;
      P.SetTimer2(0.2, false);
    }

    if ( bDBSearch ) Log(">>> SearchPawn");
    I = P.Inventory;
    while ( I != none )
    {
      if ( bDBSearch )
      {
        if ( Weapon(I) != none )
          Log(" >> Processing Weapon "$I$" ReloadCount="$Weapon(I).ReloadCount@"AmmoType="$Weapon(i).AmmoType@"AltAmmoType="$Weapon(i).AltAmmoType);
        else
          Log(" >> Processing "$I);
      }
      I.Transfer(Pawn); // all transfer handling is in subclasses.
      I = P.Inventory;
    }
}

//_____________________________________________________________________________
// ELR Added to make b180Left and b180Right working.
// (Actually used as b90Left and b90Right :)
function TurnAround()
{
    if ( !bSetTurnRot )
    {
      TurnRot180 = Rotation;
      // For 90° turn
      TurnRot180.Yaw += 16384 * (b90Right - b90Left);
      // For 180° turn
      TurnRot180.Yaw += 32768 * b180turn;
      bSetTurnRot = true;
    }
    DesiredRotation = TurnRot180;
    bTurnWanted = ( DesiredRotation.Yaw != Rotation.Yaw );
}

//_____________________________________________________________________________
// Simulated weapon feedback
// Not called by H2HAmmo
function ClientViewFeedBackSetup(class<XIIIWeapon> WeapClass, optional bool bAmplify)
{
    if ( bAmplify ) // used for dual weapons amplified feedback
      vWeaponFeedBack += vect(1.5,0,0)*WeapClass.default.ViewFeedBack.x*(fRand()-0.5) + vect(0,1.5,0)*WeapClass.default.ViewFeedBack.y*(abs(fRand()*0.7)+0.3);
    else
      vWeaponFeedBack = vect(0.5,0,0)*WeapClass.default.ViewFeedBack.x*(fRand()-0.5) + vect(0,0.5,0)*WeapClass.default.ViewFeedBack.y*(abs(fRand()*0.7)+0.3);
    if ( (Level.GetPlateforme() == 1) || (Level.GetPlateforme() == 3) ) // PS2 + GC, reduce feedback
      vWeaponFeedBack *= 0.4;
}

//_____________________________________________________________________________
// Simulated weapon feedback
// Not called by H2HAmmo
function ClientViewAltFeedBackSetup(class<XIIIWeapon> WeapClass, optional bool bAmplify)
{
    if ( bAmplify ) // used for dual weapons amplified feedback
      vWeaponFeedBack = vect(1.5,0,0)*WeapClass.default.AltViewFeedBack.x*(fRand()-0.5) + vect(0,1.5,0)*WeapClass.default.AltViewFeedBack.y*(abs(fRand()*0.7)+0.3);
    else
      vWeaponFeedBack = vect(0.5,0,0)*WeapClass.default.AltViewFeedBack.x*(fRand()-0.5) + vect(0,0.5,0)*WeapClass.default.AltViewFeedBack.y*(abs(fRand()*0.7)+0.3);
    if ( (Level.GetPlateforme() == 1) || (Level.GetPlateforme() == 3) ) // PS2 + GC, reduce feedback
      vWeaponFeedBack *= 0.4;
}

//_____________________________________________________________________________
function UpdateRotation(float DeltaTime, float maxPitch)
{
    local rotator newRotation, ViewRotation;
    local int WeaponFeedBackPitch;
    local vector LocalAim;
    local int i;
    local float fSpeedLimit, fDistFact;

    if ( bInterpolating || ((Pawn != None) && Pawn.bInterpolating) )
    { // only treat shakes when interpolating
      ViewShake(deltaTime);
      return;
    }

    ViewRotation = Rotation;
    DesiredRotation = ViewRotation; //save old rotation

    if ( (b90Left != 0) || (b90Right != 0) || (b180Turn != 0) )
      TurnAround();
    else
      bSetTurnRot = false;

    if ( bTurnToNearest != 0 )
      TurnTowardNearestEnemy();
    else if ( Pawn != none )
    {
      TurnTarget = None;
      if ( bTurnWanted )
      {
        ViewRotation.Yaw = (ViewRotation.Yaw * (1/Deltatime)/10 + DesiredRotation.Yaw)/((1/Deltatime)/10+1);
      }
      bTurnWanted = false;

      if ( !bFixedCrosshair )
      {
        // ELR Try reducing turn speed when locking someone.
        if ( bLocked )
        {
//          aTurn *= 0.5;
//          aLookUp *= 0.5;
          fSpeedLimit = fClamp(Abs(LocalAim.Y) / 0.7, 0.5, 1.0);
          PlayerInput.ViewTurnAcc = fClamp(PlayerInput.ViewTurnAcc, -fSpeedLimit, fSpeedLimit);
          PlayerInput.ViewUpAcc = fClamp(PlayerInput.ViewUpAcc, -0.5, 0.5); // don't limit as much as pawns have more height than width.
          PlayerInput.ViewTurnBoost = 0.0;
          if ( bRotationAssist && (aTurn == 0) && ((aStrafe != 0) || (aForward != 0)) && (Level.Game != none) && (Level.Game.Difficulty <= 1) )
  //        if ( bRotationAssist && ((aStrafe != 0) || (aForward != 0)) && (Level.Game != none) && (Level.Game.Difficulty <= 1) )
  //        if ( bRotationAssist )// && (aTurn == 0) ) // test, to help guys w/ no arms playing XIII
          { // Assist rotation toward besttarget
            LocalAim = OldAdjustAim << Rotation; // Adjustaim vector in local coords
            aTurn += LocalAim.y * 1800;
          }
        }
      }
      else
      {
        //============== CYD+b
        // mode bFixedCrosshair : true

        if ( bLocked )
        {
          // AdjustAim vector in local coords
          LocalAim = OldAdjustAim << Rotation;
          fDistFact = fClamp(vSize(BestTarget.Location - Pawn.Location)/3000.f, 0.1, 1.0);

//          Log("turning toward target="$(aTurn*LocalAim.Y >= 0));
          // TURN SPEED
          fSpeedLimit = fClamp(Abs(LocalAim.Y) / 0.7 / fDistFact, 0.40, 1.0);
          // Try to avoid 'bumper' effect
          PlayerInput.ViewTurnAcc = fClamp(PlayerInput.ViewTurnAcc, -fSpeedLimit, fSpeedLimit);
          PlayerInput.ViewUpAcc = fClamp(PlayerInput.ViewUpAcc, -0.5, 0.5); // don't limit as much as pawns have more height than width.
          PlayerInput.ViewTurnBoost = 0.0;

          // HELP ON TARGETING
          if ( bRotationAssist
            && (aTurn == 0) && (aLookUp == 0)
            && ((aStrafe != 0) || (aForward != 0))
            && ( (Level.Game == none) // either on Clients
               || !Level.bLonePlayer  // or not in solo
               || (Level.Game.Difficulty <= 1)) )  // or in solo w/ low difficulty
          {
            if (aStrafe != 0)
            {
              aTurn += localAim.y * 200.0;
              if( !Pawn.bIsCrouched )
              {
                aTurn -= aStrafe * 0.048f * (1.0-fDistFact)*(1.0-fDistFact);
              }
            }
            if (aForward != 0) // Help more if player moving forward/backward
              aTurn += 315.f * LocalAim.y;

            // limit feedback & try to avoid speed up when exiting 'cushion'
            vWeaponFeedBack.y       *= 0.90f;
            vWeaponFeedBackReturn.y *= 0.90f;
          }
        }
        //============== CYD+e
      }

      // if turning around, SpeedUp taptaps fade
      if ( (aTurn != 0) || (aLookUp != 0) )
        for (i=0; i<5; i++ )
          if ( MyHud.fDrawSixSenseTimer[i] > 0 )
            MyHud.fDrawSixSenseTimer[i] -= XIIIBaseHud(MyHud).dT*6.0;

      if ( bCenterView )
      {
//        Log("Cancelling aLook because centerview command");
        aLookUp = 0;
      }
      // ELR WeaponFeedBack
      if ( Pawn.IsLocallyControlled() && ((abs(vWeaponFeedBack.y) > 0.1) || (abs(vWeaponFeedBack.x) > 0.1))
        )
      { // Move view because of weapon feedback
        vWeaponFeedBack.x *= 1.0 - fMin(1.0, 0.25 * 64.0 * DeltaTime); // not really proportional to framerate but
        vWeaponFeedBack.y *= 1.0 - fMin(1.0, 0.25 * 64.0 * DeltaTime); // sfx is more attenuated if low framerate so it's ok

        WeaponFeedBackPitch = (100.0 * vWeaponFeedBack.y) * 64 * DeltaTime + ViewRotation.Pitch;
        WeaponFeedBackPitch = WeaponFeedBackPitch & 65535;
        // Memorize offset
        If ((WeaponFeedBackPitch < 15500) || (WeaponFeedBackPitch > 50000))
        { // only memorize this displacement if it will occur (not limited by view)
          vWeaponFeedBackReturn.y += 100.0 * vWeaponFeedBack.y * 64 * DeltaTime;
        }
        // these one are memorized
        vWeaponFeedBackReturn.x += 100.0 * vWeaponFeedBack.x * 64 * DeltaTime;
        vWeaponFeedBackReturn.y += aLookUp;
        // Update view
        aTurn += 100.0 * vWeaponFeedBack.x * 64 * DeltaTime;
        aLookUp += 100.0 * vWeaponFeedBack.y * 64 * DeltaTime;
        // reduce effect
      }
      else
      { // Return smoothly to pos.
//        XIIIPawn(Pawn).bJumpFeedBack=false;
        aTurn -= vWeaponFeedBackReturn.x * 0.20 * 64 * DeltaTime;
        aLookUp -= vWeaponFeedBackReturn.y * 0.20 * 64 * DeltaTime;
        vWeaponFeedBackReturn *= (1.0 - 0.20 * 64 * DeltaTime);
        vWeaponFeedBack *= (1.0 - 0.20 * 64 * DeltaTime);
      }
      // End Weapon FeedBack

/*
var config bool bCheckTurnSpeed;// check turning speed
var float fTurnSpeed[5];        // store turning values (90/180/270/360/720°)
var float fTurnDeltaTime;       // time cumul
*/
/*
      // Check turning speed
      if ( bCheckTurnSpeed )
      {
        if ( aTurn != 0 )
        {
          fTurnInc += abs(43.0 * DeltaTime * aTurn);

          fTurnDeltaTime += DeltaTime;
          if ( fTurnSpeed[0] == 0.0 )
          { // first check
            if ( fTurnInc > 65536/4.0 )
            {
              fTurnSpeed[0] = fTurnDeltaTime;
              fTurnSpeed[1] = 0.0;
              MyHud.Message(none, "90 turn "$fTurnSpeed[0], 'CHEAT');
            }
          }
          else if ( fTurnSpeed[1] == 0.0 )
          { // first check
            if ( fTurnInc > 65536/2.0 )
            {
              fTurnSpeed[1] = fTurnDeltaTime;
              fTurnSpeed[2] = 0.0;
              MyHud.Message(none, "180 turn "$fTurnSpeed[1], 'CHEAT');
            }
          }
          else if ( fTurnSpeed[2] == 0.0 )
          { // first check
            if ( fTurnInc > 65536*3.0/4.0 )
            {
              fTurnSpeed[2] = fTurnDeltaTime;
              fTurnSpeed[3] = 0.0;
              MyHud.Message(none, "270 turn "$fTurnSpeed[2], 'CHEAT');
            }
          }
          else if ( fTurnSpeed[3] == 0.0 )
          { // first check
            if ( fTurnInc > 65536 )
            {
              fTurnSpeed[3] = fTurnDeltaTime;
              fTurnSpeed[4] = 0.0;
              MyHud.Message(none, "360 turn "$fTurnSpeed[3], 'CHEAT');
            }
          }
          else if ( fTurnSpeed[4] == 0.0 )
          { // first check
            if ( fTurnInc > 65536*2 )
            {
              fTurnSpeed[4] = fTurnDeltaTime;
              MyHud.Message(none, "720 turn "$fTurnSpeed[4], 'CHEAT');
            }
          }


        }
        else
        {
          fTurnDeltaTime = 0.0;
          fTurnSpeed[0] = 0.0;
          fTurnInc = 0;
        }
      }
*/
      if ( DesiredFOV != DefaultFov )
      {
        ViewRotation.Yaw += 21.5 * DeltaTime * aTurn;
        ViewRotation.Pitch += 21.5 * DeltaTime * aLookUp;
      }
      else
      {
        ViewRotation.Yaw += 43.0 * DeltaTime * aTurn;
        ViewRotation.Pitch += 43.0 * DeltaTime * aLookUp;
      }

      // ELR Handle the SniperSkill Here
      if ( (DesiredFOV != defaultFov) && (Pawn!=none) && Level.bLonePlayer && !XIIIPlayerPawn(Pawn).bIsSniper )
      {
        if ( Pawn.Acceleration == vect(0,0,0) )
        {
          if ( Pawn.bIsCrouched )
            fSniperPrecision = fmax(0.0, fSniperPrecision - DeltaTime/3.0);
          else
            fSniperPrecision = fmax(0.0, fSniperPrecision - DeltaTime/6.0);
        }
        else
          fSniperPrecision = fMin(1.0, fSniperPrecision + DeltaTime/1.8);
        ViewRotation.Pitch -= SniperPitch;
        Viewrotation.Yaw -= SniperYaw;
        // End reinit Viewrotation
        // Processing of SniperPitch & SniperYaw
        vSniperOffset.z = 0.0;
        vSniperOffsetSpeed.z = 0.0;
        vSniperOffset += vSniperOffsetSpeed * (DeltaTime/1000.0);
        vSniperOffsetSpeed -= (vSniperOffset) / (DeltaTime*Deltatime*200.0);
        vSniperOffsetSpeed += normal(vSniperOffset cross vect(0,0,1)) * 8.0;
        if ( vSize(vSniperOffsetSpeed) > 4000.0 )
          vSniperOffsetSpeed = normal(vSniperOffsetSpeed)*4000.0;
        SniperPitch = fSniperPrecision * 212.0 * sin(vsniperOffset.X) * ((DefaultFov - DesiredFOV) / DefaultFov);
        SniperYaw = fSniperPrecision * 212.0 * sin(vsniperOffset.Y) * ((DefaultFov - DesiredFOV) / DefaultFov);
        // End Processing
        // Set Viewrotation
        Viewrotation.Pitch += SniperPitch;
        Viewrotation.Yaw += SniperYaw;
      }
      else if ( pawn != none )
      { // ::TODO:: this is executed each frame whne not sniping, should be optimized
        if ( XIIIPlayerPawn(Pawn).bIsSniper )
          fSniperPrecision = 0.0;
        else
        {
          fSniperPrecision = 1.0;
          vSniperOffset = vRand()*1.56;
          vSniperOffsetSpeed = vRand();
          SniperPitch = 0.0;
          SniperYaw = 0.0;
        }
      }
      // END Sniper Handle
    }

    ViewRotation.Pitch = ViewRotation.Pitch & 65535;
    if ((ViewRotation.Pitch > 15500) && (ViewRotation.Pitch < (50000+15500)/2))
      ViewRotation.Pitch = 15500;
    else if ((ViewRotation.Pitch > (50000+15500)/2) && (ViewRotation.Pitch < 50000))
      ViewRotation.Pitch = 50000;
/*
    if ((ViewRotation.Pitch > 15500) && (ViewRotation.Pitch < 50000))
    {
      if (aLookUp > 0)
        ViewRotation.Pitch = 15500;
      else if (aLookUp < 0)
        ViewRotation.Pitch = 50000;
    }
*/

    SetRotation(ViewRotation);
    ViewShake(deltaTime);
    ViewFlash(deltaTime);

    NewRotation = ViewRotation;
    NewRotation.Roll = Rotation.Roll;

    If ( (newRotation.Pitch > maxPitch * RotationRate.Pitch) && (newRotation.Pitch < 65536 - maxPitch * RotationRate.Pitch) )
    {
      If (ViewRotation.Pitch < 32768)
        newRotation.Pitch = maxPitch * RotationRate.Pitch;
      else
        newRotation.Pitch = 65536 - maxPitch * RotationRate.Pitch;
    }
    if ( !bRotateToDesired && (Pawn != None) && (!bFreeCamera || !bBehindView) )
      Pawn.FaceRotation(newRotation, deltatime);

//    Pawn.ControllerPitch = newRotation.Pitch;

//    log("Update Pitch");
}

//_____________________________________________________________________________
function SetCamView( actor C, optional float F )
{
    if ( F==0 )
      F = 90;
    GotoState('CameraView');
    CamView = C;
    DT_mem = C.DrawType;
    C.SetDrawType(DT_none);
//    SetViewTarget(C);
    DesiredFOV = F;
    FOVAngle = F;
    DefaultFov = F;
}

function SetCamViewPortal( actor C, optional float F )
{
  if (CamView != C)
  {
    if ( F == 0 )
      F = 90;
    CamView = C;
    CamView.Trigger(self, Pawn);
  }
}

//_____________________________________________________________________________
function RestoreView()
{
//    SetViewTarget(Pawn);
    GotoState('PlayerWalking');
    CamView.SetDrawType(DT_mem);
    DefaultFOV = default.DefaultFOV;
    DesiredFOV = DefaultFOV;
    FOVAngle = DefaultFOV;
}

//_____________________________________________________________________________
// ELR - Here we send the controller into hooked state
function GoHooking(Hook H)
{
    HookUsed = H;
    bHooked = true;
//    GotoState('Hooked');
}

//_____________________________________________________________________________
// at top of a rope, climb up to the hooknavpoint
function GoClimbHookNavPoint(HookPoint HP, HookNavPoint HNP)
{
    ClimbHookPoint = HP;
    TargetHookClimb = HNP;
    bHooked = false;
    GotoState('ClimbToHookNavPoint');
}

/*
//_____________________________________________________________________________
// ELR
function bool NearWall(float walldist)
{
    local actor HitActor;
    local vector HitLocation, HitNormal, ViewSpot, ViewDist, LookDir;

    LookDir = vector(Rotation);
    ViewSpot = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1);
    ViewDist = LookDir * walldist;
    HitActor = Trace(HitLocation, HitNormal, ViewSpot + ViewDist, ViewSpot, false);
    if ( HitActor == None )
      return false;
    return true;
}
*/

//_____________________________________________________________________________
function bool TryClimbDoor(actor pDoorLocked, vector pDoorLockedPos, vector pDoorLockedNormal)
{
    local vector X, Y, Z, Start, End, HitLoc, HitNorm;
    local actor A;

    if ( (XIIIPawn(Pawn).LHand.pOnShoulder != none) || Pawn.bIsCrouched || (XIIIPorte(pDoorLocked)==none) )
      return false;

    if ( bWeaponMode && (Pawn.Weapon.WHand == WHA_Deco) )
      return false;

    if ( !XIIIPorte(pDoorLocked).bClimbAble )
      return false;
//    if ( !XIIIPorte(pDoorLocked).bOpened && !XIIIPorte(pDoorLocked).bClosed) )
    if ( !XIIIPorte(pDoorLocked).bOpened )
      return false; // don't climb if the door is moving or not climbable.

    GetAxes(Rotation,X,Y,Z);
//    if ( X.z > -0.25 ) // ELR Just check we are not looking really down
//    {
      Start = pDoorLockedPos + pDoorLockedNormal;
      End = Start + vect(0,0,1) * Pawn.CollisionHeight;
      if ( FastTrace(End,Start) )
      {
        A=Trace(HitLoc, HitNorm, End, Start, false);
        return true;
      }
//    }
    return false;
}

//_____________________________________________________________________________
// Normal gameplay execs
// Type the name of the exec function at the console to execute it
exec function Jump( optional float F )
{
    if ( LadderVolume(Pawn.PhysicsVolume) != none )
    { // Jumping in a ladder volume mean we do want to climb
      Pawn.PhysicsVolume.PawnEnteredVolume(Pawn);
      if (Pawn.Physics == PHYS_Ladder)
        return;
    }

    if ( MyInteraction.bCanClimbDoor )
    {
      DoorToClimb = MyInteraction.TargetActor;
      DoorLockedNormal = MyInteraction.TargHitNorm;
      DoorLockedPos = MyInteraction.TargHitLoc;

      GotoState('MayClimbDoor');
    }

    bPressedJump = true;
}

//_____________________________________________________________________________
event HearNoise( float Loudness, Actor NoiseMaker)
{
//    Log("__"@self@"Heard"@NoiseMaker);
//    if ( XIIIPlayerPawn(Pawn).bSixSenseOn )
    if ( vSize(NoiseMaker.location - Pawn.Location) < 2500/1.27 )
      XIIIPlayerPawn(Pawn).Heard(Loudness, NoiseMaker);
}

//_____________________________________________________________________________
// called when gameplay actually starts
simulated function MatchStarting()
{
    Log("MP-] MatchStarting for"@self);
    UseVignetteFilter = 0;
    UseVignetteHighlight = 0;
    bWeaponBlock = false;
    if ( Level.Game != none )
      Level.Game.RestartPlayer(Self);
    if ( PlayerInput != none )
    {
      PlayerInput.bDuckCheck = false;
      PlayerInput.iDuckMem = 0;
    }
}

//_____________________________________________________________________________
event TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type )
{
    local string ConsoleString;

//    log("Teammessage with PRI "$PRI$" hud "$myHud$" Player "$Player$" console "$Player.console$" string "$S@"Type "$Type);
    ConsoleString = S;
    if ( (Type == 'Say') || (Type == 'TeamSay') )
      ConsoleString = PRI.PlayerName$": "$ConsoleString;

//    Player.Console.Message( ConsoleString, 6.0 );
    myHUD.Message( PRI, S, Type );
}

//_____________________________________________________________________________
function StatUpdate();

//_____________________________________________________________________________
function ClientGameEnded()
{
//    if ( (Role < ROLE_Authority) || (Level.NetMode == NM_StandAlone) )
    if (Role < ROLE_Authority)
      GotoState('GameEnded');
}

//_____________________________________________________________________________
state PlayerClimbing
{
    event bool NotifyHitWall(vector HitNormal, actor Wall)
    { // ELR don't send HitWall to pawn while in ladder.
      return true;
    }
    function BeginState()
    {
      if ( Pawn != None )
      {
        Pawn.ShouldCrouch(false);
        bPressedJump = false;
        bDuck = 0;
        bPressedDuck = false;
        Pawn.ChangeAnimation();
      }
    }
    function EndState()
    {
      if ( Pawn != None )
      {
        Pawn.ShouldCrouch(false);
        bPressedJump = false;
        bDuck = 0;
        bPressedDuck = false;
        Pawn.ChangeAnimation();
        Pawn.PlaySound(hEndClimbLadderSound);
      }
    }
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
      local vector OldAccel;

      OldAccel = Pawn.Acceleration;
      if ( bAltDuck != 0 )
        NewAccel.Z = -2048.0;
      if ( bAltJump != 0 )
        NewAccel.Z = 2048.0;

      Pawn.Acceleration = NewAccel;
//      Log("Accel="$Pawn.Acceleration@"bIsCrouched="$Pawn.bIsCrouched$"bIsWalking="$Pawn.bIsWalking);
/*
      if ( bPressedJump )
      {
        Pawn.DoJump(bUpdating);
        if ( Pawn.Physics == PHYS_Falling )
          GotoState('PlayerWalking');
      }
*/
    }
}

//_____________________________________________________________________________
state PlayerWalking
{
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
      local vector OldAccel, HookDir, HookMove, CenterDir;
      local bool OldCrouch;

      if ( Pawn == none )
        return;
      // ELR Limit speed there ::FIXME:: but not for on-line because on serveur FOV don't change.
      if ( (Level.NetMode == NM_StandAlone) && (DefaultFOV != DesiredFOV) )
      {
        NewAccel *= 0.01;
        XIIIPawn(Pawn).SetGroundspeed(Pawn.WalkingPct / 2.0);
      }
      else
      {
        if ( bWeaponMode )
        {
          if ( (XIIIWeapon(Pawn.Weapon) != none) && XIIIWeapon(Pawn.Weapon).bHeavyWeapon )
            XIIIPawn(Pawn).SetGroundspeed(0.666);
          else if ( (XIIIPawn(Pawn).LHand != none) && XIIIPawn(Pawn).LHand.bActive )
            XIIIPawn(Pawn).SetGroundspeed(0.333);
          else
            XIIIPawn(Pawn).SetGroundspeed(1.0);
        }
        else
        {
          if ( (XIIIPawn(Pawn).LHand != none) && XIIIPawn(Pawn).LHand.bActive )
            XIIIPawn(Pawn).SetGroundspeed(0.333);
          else
            XIIIPawn(Pawn).SetGroundspeed(1.0);
        }
      }

      if ( bHooked )
      {
        if ( (Pawn.Physics==PHYS_Walking) && (Pawn.Location.z > HookUsed.HookPoint.z) )
          HookUsed.HookLength = vSize(HookUsed.HookPoint - Pawn.Location) + 1.0;
        if ( (vSize(HookUsed.HookPoint - Pawn.Location) > HookUsed.HookLength) && (Pawn.Location.z < HookUsed.HookPoint.z) )
        {
          Pawn.SetPhysics(PHYS_Falling);
          HookDir = normal(HookUsed.HookPoint - Pawn.Location);
          HookMove = HookDir * (vSize(HookUsed.HookPoint - Pawn.Location) - HookUsed.HookLength);
          Pawn.Move( HookMove );
          // Look for the speed to set the player (remove speed along rope axis).
          Pawn.Velocity -= HookDir * (HookDir dot Pawn.velocity);
        }
      }

      OldAccel = Pawn.Acceleration;
      Pawn.Acceleration = NewAccel;

//      Log("bDuck="$bDuck@"bWantsToCrouch="$Pawn.bWantsToCrouch);
      if ( bPressedJump )
      {
        if ( bHooked && !HookUsed.bGoUp && !HookUsed.bGoDown && (Hook(Pawn.SelectedItem) != none) )
        {
//          Log("Hook ActivatedByJump");
          Hook(Pawn.SelectedItem).ActivatedByJump = true;
          ActivateItem();
          return;
        }
        Pawn.DoJump(bUpdating);
      }
      if ( Pawn.Physics != PHYS_Falling )
      {
        OldCrouch = Pawn.bWantsToCrouch;
        if (bDuck == 0)
          Pawn.ShouldCrouch(false);
        else if ( Pawn.bCanCrouch )
          Pawn.ShouldCrouch(true);
      }
      else
      {
        // should reset Crouch
        if ( PlayerInput != none )
        {
          PlayerInput.bDuckCheck = false;
          PlayerInput.iDuckMem = 0;
        }
        Pawn.bWantsToCrouch = false;
        Pawn.ShouldCrouch(false);
        bDuck = 0;
        if ( !bHooked )
          bAltDuck = 0;
        if ( bHooked && bPressedDuck && !HookUsed.bGoUp && !HookUsed.bGoDown && (Hook(Pawn.SelectedItem) != none) )
        {
  //        Log("Hook ActivatedByDuck");
          HookUsed.ActivatedByDuck = true;
          ActivateItem();
          bPressedDuck = false;
          return;
        }
      }
      if ( (Hook(Pawn.SelectedItem) != none) && (Pawn.SelectedItem.IsInState('Idle') || Pawn.SelectedItem.IsInState('DownItemRopeCut')) )
        bhooked = false;
    }

    function PlayerMove( float DeltaTime )
    {
      local vector X,Y,Z, NewAccel;
      local eDoubleClickDir DoubleClickMove;
      local rotator OldRotation, ViewRotation;
      local float Speed2D;
      local bool bSaveJump;

      if ( Pawn != none ) // May happen in on-line game
        GetAxes(Pawn.Rotation,X,Y,Z);
      else
        GetAxes(Rotation,X,Y,Z);

      // ELR Add to avoid CenterView if mid-air
      if ( bHooked && (Pawn.Physics != PHYS_Walking) )
        bCenterView = False;

      // Update acceleration.
      NewAccel = aForward*X + aStrafe*Y;
      NewAccel.Z = 0;
      if ( VSize(NewAccel) < 1.0 )
        NewAccel = vect(0,0,0);
//      DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime);

      if ( bHooked && (Pawn.Base == none) )
        NewAccel *= 0.03*1.5;

      GroundPitch = 0;
      // ELR don't do snapview if zoomed
//      if ( (DefaultFov != DesiredFov) || (XIIIWeapon(Pawn.Weapon).bZoomed) )
//      {
//        Log("             ...reseting view because fov not ok or weapon zoom");

/* ELR // take this back ;)
        bSnaptoLevel = false;
        bCenterView = false;
*/

//      }
/*
      if ( bCenterView )
        log("Centering view");
*/
      if ( (Pawn != none) && Pawn.Pressingfire() )
      {
        bSnaptoLevel = false;
        bCenterView = false;
      }

      ViewRotation = Rotation;
      if ( (Pawn != none) && (Pawn.Physics == PHYS_Walking) )
      {
//        Log("PlayerWalking...");
        // tell pawn about any direction changes to give it a chance to play appropriate animation
        //if walking, look up/down stairs - unless player is rotating view
//        GroundPitch = FindStairRotation(deltaTime);
//        if ( GroundPitch != 0 )
//          Log("GroundPitch="$GroundPitch@"bLookUpStairs="$bLookUpStairs@"bSnapToLevel="$bSnapToLevel);
        if ( (bLook == 0)
          && (((Pawn.Acceleration != Vect(0,0,0)) && bAlwaysLevel && bSnapToLevel) || !bKeyboardLook) )
        {
//          Log("             ...aligning view");
          if ( bLookUpStairs && bSnapToLevel )
          {
//            Log("             ...aligning view Setting GroundPitch ViewRotation.Pitch="$ViewRotation.Pitch@"GroundPitch="$GroundPitch);
            ViewRotation.Pitch -= (GroundPitch / (DeltaTime*1000));
          }
          else if ( bCenterView && (DefaultFOV == DesiredFOV) )
          {
//            Log("             ...aligning view Centering view");
            ViewRotation.Pitch = ViewRotation.Pitch & 65535;
            if (ViewRotation.Pitch > 32768)
              ViewRotation.Pitch -= 65536;
            ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
            if ( Abs(ViewRotation.Pitch) < 1000 )
              ViewRotation.Pitch = 0;
          }
        }

        Speed2D = Sqrt(Pawn.Velocity.X * Pawn.Velocity.X + Pawn.Velocity.Y * Pawn.Velocity.Y);
        //add bobbing when walking
        CheckBob(DeltaTime, Speed2D, Y);
      }
      else
      {
        if ( !bKeyboardLook && (bLook == 0) && bCenterView )
        {
          ViewRotation.Pitch = ViewRotation.Pitch & 65535;
          if (ViewRotation.Pitch > 32768)
               ViewRotation.Pitch -= 65536;
          ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
          if ( Abs(ViewRotation.Pitch) < 1000 )
               ViewRotation.Pitch = 0;
        }
        BobTime = 0;
        WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
      }

      // Update rotation.
      SetRotation(ViewRotation);
      OldRotation = Rotation;
      // ELR Rotation Speed Down when holding corpse/Pawn
      if ( (Pawn != none) && (XIIIPawn(Pawn).LHand!=none) && (XIIIPawn(Pawn).LHand.pOnShoulder != none) )
        UpdateRotation(DeltaTime*0.75, 0);
      else
        UpdateRotation(DeltaTime, 0);

      if ( bPressedJump && Pawn.CannotJumpNow() )
      {
        bSaveJump = true;
        bPressedJump = false;
      }
      else
        bSaveJump = false;

      if ( Role < ROLE_Authority ) // then save this move and replicate it
        ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
      else
        ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
      if ( (Pawn != none) && (Pawn.ControllerPitch != Rotation.Pitch / 256) )
        Pawn.ControllerPitch = Rotation.Pitch / 256; // needed for ListenServer -> Client
      bPressedJump = bSaveJump;
    }
}

//_____________________________________________________________________________
// ELR
state PlayerSwimming
{
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
      local vector X,Y,Z, OldAccel, HookDir, HookMove, CenterDir;

      GetAxes(Rotation,X,Y,Z);

      if ( bHooked )
      { // while swimming only update hooklength
        if ( (vSize(HookUsed.HookPoint - Pawn.Location) > HookUsed.HookLength) && (Pawn.Location.z < HookUsed.HookPoint.z) )
        {
          HookDir = normal(HookUsed.HookPoint - Pawn.Location);
          HookMove = HookDir * (vSize(HookUsed.HookPoint - Pawn.Location) - HookUsed.HookLength);
          Pawn.Move( HookMove );
          // Look for the speed to set the player (remove speed along rope axis).
          Pawn.Velocity -= HookDir * (HookDir dot Pawn.velocity);
        }
      }

      OldAccel = Pawn.Acceleration;
      Pawn.Acceleration = NewAccel;

      Pawn.bUpAndOut = ((X Dot Pawn.Acceleration) > 0) && ((Pawn.Acceleration.Z > 0) || (Rotation.Pitch > 2048));
      if ( !Pawn.PhysicsVolume.bWaterVolume ) //check for waterjump
        NotifyPhysicsVolumeChange(Pawn.PhysicsVolume);
      if ( (Hook(Pawn.SelectedItem) != none) && (Pawn.SelectedItem.IsInState('Idle') || Pawn.SelectedItem.IsInState('DownItemRopeCut')) )
        bhooked = false;
    }

    function PlayerMove(float DeltaTime)
    {
      local rotator oldRotation;
      local vector X,Y,Z, NewAccel;
      local float Speed2D;

      GetAxes(Rotation,X,Y,Z);

      NewAccel = aForward*X + aStrafe*Y + aUp*vect(0,0,1);
      if ( VSize(NewAccel) < 1.0 )
        NewAccel = vect(0,0,0);

      //add bobbing when swimming
      Speed2D = Sqrt(Pawn.Velocity.X * Pawn.Velocity.X + Pawn.Velocity.Y * Pawn.Velocity.Y);
      WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * Level.TimeSeconds);
      WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * Level.TimeSeconds);

      // Update rotation.
      oldRotation = Rotation;
      UpdateRotation(DeltaTime, 2);

      if ( Role < ROLE_Authority ) // then save this move and replicate it
        ReplicateMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
      else
        ProcessMove(DeltaTime, NewAccel, DCLICK_None, OldRotation - Rotation);
      bPressedJump = false;
    }
    function bool NotifyPhysicsVolumeChange( PhysicsVolume NewVolume )
    {
      local actor HitActor;
      local vector HitLocation, HitNormal, checkpoint;

      if ( !NewVolume.bWaterVolume )
      {
        Pawn.SetPhysics(PHYS_Falling);
        if (Pawn.bUpAndOut && Pawn.CheckWaterJump(HitNormal)) //check for waterjump
        {
        // ONLY CHANGE HERE
          Pawn.velocity.Z = 400 + Pawn.CollisionHeight; //set here so physics uses this for remainder of tick
        // ONLY CHANGE HERE
//          Pawn.velocity.Z = 330 + 2 * Pawn.CollisionRadius; //set here so physics uses this for remainder of tick
          GotoState(Pawn.LandMovementState);
        }
        else if ( (Pawn.Velocity.Z > 160) || !Pawn.TouchingWaterVolume() )
          GotoState(Pawn.LandMovementState);
        else //check if in deep water
        {
          checkpoint = Pawn.Location;
          checkpoint.Z -= (Pawn.CollisionHeight + 6.0);
          HitActor = Trace(HitLocation, HitNormal, checkpoint, Pawn.Location, false);
          if (HitActor != None)
            GotoState(Pawn.LandMovementState);
          else
          {
            Enable('Timer');
            SetTimer(0.7,false);
          }
        }
      }
      else
      {
        Disable('Timer');
        Pawn.SetPhysics(PHYS_Swimming);
      }
      return false;
    }
    function BeginState()
    {
      Disable('Timer');
      Pawn.SetPhysics(PHYS_Swimming);
//      Pawn.PlaySound(hEnteringWaterSound);
    }
    function EndState()
    {
//      Pawn.PlaySound(hExitingWaterSound);
    }
}

/*
//_____________________________________________________________________________
// ELR
State Hooked extends PlayerWalking
{
    function BeginState()
    {
      Pawn.bCanCrouch=False;
      Pawn.bCanClimbLadders=False;
      bPressedDuck=false;
    }
    function EndState()
    {
      Pawn.bCanCrouch=True;
      Pawn.bCanClimbLadders=True;
    }

    //_________________
    function PlayerMove( float DeltaTime )
    {
      local vector X,Y,Z, NewAccel;
      local eDoubleClickDir DoubleClickMove;
      local rotator OldRotation, ViewRotation;
      local float Speed2D;
      local bool bSaveJump;

      GetAxes(Pawn.Rotation,X,Y,Z);
      // ELR Add to avoid CenterView if mid-air
      if ( Pawn.Physics != PHYS_Walking )
        bCenterView = False;

//      Log("aForward="$aForward@"aStrafe="$aStrafe);

      // Update acceleration.
      NewAccel = aForward*4*X + aStrafe*4*Y;
      NewAccel.Z = 0;
//      if ( NewAccel == vect(0,0,0) )
//        NewAccel = -Pawn.Velocity*200;
      if ( Pawn.Base == none )
        NewAccel *= 0.0075;

//      log("NewAccel="$NewAccel);
//      DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime);

      GroundPitch = 0;
      ViewRotation = Rotation;
      if (Pawn.Physics == PHYS_Walking)
      {
        //if walking, look up/down stairs - unless player is rotating view
        GroundPitch = FindStairRotation(deltaTime);
        if (DefaultFov != DesiredFov)
        {
          bSnaptoLevel = false;
          bCenterView = false;
        }

        if ( (bLook == 0)
          && (((Pawn.Acceleration != Vect(0,0,0)) && bAlwaysLevel && bSnapToLevel) || !bKeyboardLook) )
        {
          if ( bLookUpStairs || bSnapToLevel )
          {
            ViewRotation.Pitch = GroundPitch;
          }
          else if ( bCenterView && (DefaultFOV == DesiredFOV) )
          {
            ViewRotation.Pitch = ViewRotation.Pitch & 65535;
            if (ViewRotation.Pitch > 32768)
              ViewRotation.Pitch -= 65536;
            ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
            if ( Abs(ViewRotation.Pitch) < 1000 )
              ViewRotation.Pitch = 0;
          }
        }
        Speed2D = Sqrt(Pawn.Velocity.X * Pawn.Velocity.X + Pawn.Velocity.Y * Pawn.Velocity.Y);
        //add bobbing when walking
        CheckBob(DeltaTime, Speed2D, Y);
      }

      // Update rotation.
      SetRotation(ViewRotation);
      OldRotation = Rotation;
      UpdateRotation(DeltaTime, 1);

      if ( bPressedJump && Pawn.CannotJumpNow() )
      {
        bSaveJump = true;
        bPressedJump = false;
      }
      else
        bSaveJump = false;

      // ELR If jump pressed and colliding/facing a wall then impulse
      if ( NearWall(Pawn.CollisionRadius + 15.0) )
      {
//        Pawn.Velocity.Z = 0.0;
        if ( bPressedJump && (Pawn.Physics == PHYS_Falling) )
        {
          Pawn.Velocity -= X * 300.0;
        }
      }

      if ( Role < ROLE_Authority ) // then save this move and replicate it
        ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
      else
        ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
      bPressedJump = bSaveJump;
    }

    //_________________
    // ELR 2nd ProcessMove, trying to get rid of vel/acc and setting the player's pos
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
      local vector OldAccel, HookDir, HookMove, CenterDir;
      local bool OldCrouch;

      OldAccel = Pawn.Acceleration;

      // Not in Hook because need every frame treatment
      if ( Pawn.Physics==PHYS_Walking )
      {
        if ( Pawn.Location.z > HookUsed.HookPoint.z )
        {
          HookUsed.HookLength = vSize(HookUsed.HookPoint - Pawn.Location) + 1.0;
        }
      }

      if ( (vSize(HookUsed.HookPoint - Pawn.Location) > HookUsed.HookLength) && (Pawn.Location.z < HookUsed.HookPoint.z) )
      {
        Pawn.SetPhysics(PHYS_Falling);
        HookDir = normal(HookUsed.HookPoint - Pawn.Location);
        HookMove = HookDir * (vSize(HookUsed.HookPoint - Pawn.Location) - HookUsed.HookLength);
        Pawn.Move( HookMove );
        // Look for the speed to set the player (remove speed along rope axis).
        Pawn.Velocity -= HookDir * (HookDir dot Pawn.velocity);
      }

      Pawn.Acceleration = NewAccel;

      if ( bPressedJump )
      {
        if ( !HookUsed.bGoUp && !HookUsed.bGoDown )
        {
          Log("Hook ActivatedByJump");
          Hook(Pawn.SelectedItem).ActivatedByJump = true;
          ActivateItem();
          return;
        }
        else
          Pawn.DoJump(bUpdating);
      }
      if ( Pawn.Physics != PHYS_Falling )
      {
        OldCrouch = Pawn.bWantsToCrouch;
        if (bDuck == 0)
          Pawn.ShouldCrouch(false);
        else if ( Pawn.bCanCrouch )
          Pawn.ShouldCrouch(true);
      }
      else
      {
        if ( bPressedDuck && !HookUsed.bGoUp && !HookUsed.bGoDown )
        {
          Log("Hook ActivatedByDuck");
          HookUsed.ActivatedByDuck = true;
          ActivateItem();
          bPressedDuck=false;
          return;
        }
      }

//      if ( !bWeaponMode && (Hook(Pawn.SelectedItem) != none) && Pawn.SelectedItem.isInState('Idle') )
    // ELR we can release hook while having weapon in hand, so...
      if ( (Hook(Pawn.SelectedItem) != none) && Pawn.SelectedItem.isInState('Idle') )
      {
        GotoState('PlayerWalking');
      }
    }
}
*/

//_____________________________________________________________________________
// ELR
State Tyroling extends PlayerWalking
{
    function BeginState()
    {
      Pawn.PlaySound(hTyrolStartSound);
    }
    function EndState()
    {
      Pawn.PlaySound(hTyrolEndSound);
      Pawn.SetPhysics(PHYS_Falling);
    }

    //__________________
    function PlayerMove( float DeltaTime )
    {
      local vector X,Y,Z, NewAccel;
      local eDoubleClickDir DoubleClickMove;
      local rotator OldRotation, ViewRotation;
      local float Speed2D;
      local bool     bSaveJump;

      if ( (vTyrolDir dot (Pawn.Location - vTyrolEnd) > 0.0) || (vTyrolDir dot Pawn.Velocity < 0.0) )
      {
        Gotostate('PlayerWalking');
        return;
      }
      GetAxes(Pawn.Rotation,X,Y,Z);

      // Update acceleration.
//      NewAccel = aForward*X + aStrafe*Y;
      if ( vSize(vTyrolEnd - Pawn.Location) > 512.0 )
        // SpeedUp
        NewAccel = vTyrolDir * 400.0;
      else
        //SlowDown
        NewAccel = - vTyrolDir * 200.0;
//      DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime);

      GroundPitch = 0;
      ViewRotation = Rotation;
      if (Pawn.Physics == PHYS_Walking)
      {
        //if walking, look up/down stairs - unless player is rotating view
//        GroundPitch = FindStairRotation(deltaTime);
        if (DefaultFov != DesiredFov)
        {
          bSnaptoLevel = false;
          bCenterView = false;
        }
        if ( (bLook == 0)
          && (((Pawn.Acceleration != Vect(0,0,0)) && bAlwaysLevel && bSnapToLevel) || !bKeyboardLook) )
        {
          if ( bLookUpStairs || bSnapToLevel )
          {
            ViewRotation.Pitch = GroundPitch;
          }
          else if ( bCenterView && (DefaultFOV == DesiredFOV) )
          {
            ViewRotation.Pitch = ViewRotation.Pitch & 65535;
            if (ViewRotation.Pitch > 32768)
              ViewRotation.Pitch -= 65536;
            ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
            if ( Abs(ViewRotation.Pitch) < 1000 )
              ViewRotation.Pitch = 0;
          }
        }

        Speed2D = Sqrt(Pawn.Velocity.X * Pawn.Velocity.X + Pawn.Velocity.Y * Pawn.Velocity.Y);
        //add bobbing when walking
        CheckBob(DeltaTime, Speed2D, Y);
      }

      // Update rotation.
      SetRotation(ViewRotation);
      OldRotation = Rotation;
      UpdateRotation(DeltaTime, 1);

      if ( bPressedJump && Pawn.CannotJumpNow() )
      {
        bSaveJump = true;
        bPressedJump = false;
      }
      else
        bSaveJump = false;

      if ( Role < ROLE_Authority ) // then save this move and replicate it
        ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
      else
        ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
      bPressedJump = bSaveJump;
    }

    //__________________
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
      local vector OldAccel;
      local bool OldCrouch;

      OldAccel = Pawn.Acceleration;
      Pawn.Acceleration = NewAccel;
      Pawn.SetPhysics(PHYS_None);
      Pawn.Velocity += NewAccel * Deltatime;
      if ( vSize(Pawn.Velocity) > fTyrolSpeed )
        Pawn.Velocity = normal(Pawn.Velocity) * fTyrolSpeed;
      Pawn.Move(Pawn.Velocity * Deltatime);

      // ELR No more jump there

      if ( Pawn.Physics != PHYS_Falling )
      {
        OldCrouch = Pawn.bWantsToCrouch;
        if (bDuck == 0)
          Pawn.ShouldCrouch(false);
        else if ( Pawn.bCanCrouch )
          Pawn.ShouldCrouch(true);
      }
    }
}

//_____________________________________________________________________________

state BossView
{
    ignores ReLoad, NextWeapon, cNextItem, AltFire, Jump;

    function BeginState() {}
    function EndState() {}

    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
//    	ViewActor = ViewTarget; // ELR don't set ViewActor else sound will come as heard from it
        CameraLocation = CamView.Location;
        CameraRotation = rotator( CamView.Location - CamView.Location);
    }
}

//_____________________________________________________________________________
state CameraView
{
    ignores AltFire, Jump;
    ignores Reload, cNextItem, cPrevItem, PrevWeapon, NextWeapon;

    function BeginState()
    {
      Pawn.Playsound(hCamViewBeginUseSound);
      Pawn.Playsound(hCamViewInUseSound);
      Pawn.Velocity = vect(0,0,0);
      Pawn.Acceleration = vect(0,0,0);
    }
    function EndState()
    {
      Pawn.StopSound(hCamViewInUseSound);
      Pawn.Playsound(hCamViewBeginUseSound);
      DefaultFOV = default.DefaultFOV;
      DesiredFOV = DefaultFOV;
      FOVAngle = DefaultFOV;
    }
    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
//    	ViewActor = ViewTarget; // ELR don't set ViewActor else sound will come as heard from it
      CameraLocation = CamView.Location;
      CameraRotation = CamView.Rotation;
    }
}

//_____________________________________________________________________________
state MayClimbDoor extends PlayerWalking
{
    ignores NextWeapon, cNextItem, Grab;

    function BeginState()
    {
      SetTimer(0.1, true);
      if ( bWeaponMode )
      {
        OldWeap = pawn.weapon.InventoryGroup;
        Pawn.Weapon.PutDown();
      }
      else
      {
        if ( OldItem != none )
        {
          cNextItem();
          XIIIPawn(Pawn).PendingItem = OldItem;
        }
        else
        {
          NextWeapon();
          Switchweapon( 0 );
        }
      }
      bWeaponBlock = true;
    }
    function Timer()
    {
      if (Pawn.Velocity.Z < 0.0 )
      {
//        log(self$" should try to climb");
        SetTimer(0.0, false);
        OldDoorClimbPos = Pawn.Location;
        DoorClimbMove = vect(0,0,1.0);
        Pawn.PlaySound(hClimbDoorSound);
        GotoState('ClimbDoor');
      }
    }
    event bool NotifyLanded(vector HitNormal)
    {
      GotoState('PlayerWalking');
      return true;
    }
}

//_____________________________________________________________________________
state ClimbDoor extends PlayerWalking
{
    ignores NextWeapon, cNextItem, Grab;

    function EndState()
    {
//      Pawn.PlaySound(hEndClimbDoorSound); // ELR don't play this anytime, just in case we could have succeeded
      bWeaponBlock = false;
      if ( bWeaponMode )
      {
        Switchweapon( OldWeap );
        Pawn.ChangedWeapon();
      }
      else
      {
        if ( OldItem != none )
        {
          cNextItem();
          XIIIPawn(Pawn).PendingItem = OldItem;
        }
        else
        {
          NextWeapon();
          Switchweapon( 0 );
        }
        Pawn.ChangedWeapon();
      }
    }

    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
      local vector OldAccel;
      local vector Start,End,HitLoc,HitNorm;
      local actor A;

      DoorClimbMove = Pawn.Location - OldDoorClimbPos;
      if ( DoorClimbMove.z == 0.0 )
      {
//        log(self$" ending the climb because no more vertical speed.");
        Pawn.Acceleration = vect(0,0,0);
        Pawn.Velocity = - DoorLockedNormal * 200.0;
        GotoState('PlayerWalking');
        return;
      }
      DoorClimbMove.z = 0.0;
      if ( vSize(DoorClimbMove) > 1.0 )
      {
//        log(self$" ending the climb because the move is not the one predicted");
        Pawn.Acceleration = vect(0,0,0);
        Pawn.Velocity = - DoorLockedNormal * 200.0;
        Pawn.PlaySound(hEndClimbDoorSound); // ELR don't play this anytime, just in case we could have succeeded
        GotoState('PlayerWalking');
        return;
      }

      Start = Pawn.Location;
      End = Start - DoorLockedNormal * Pawn.CollisionRadius * 1.5;
      A = Trace(HitLoc, HitNorm, End, Start);
      if ( (A != DoorToClimb) && (A != none) )
      {
//        log(self$" ending the climb because there is obstacle in front");
//        log("DoorNormal="$DoorLockedNormal);
        Pawn.Acceleration = vect(0,0,0);
        Pawn.Velocity = - DoorLockedNormal * 200.0;
        GotoState('PlayerWalking');
        return;
      }

      OldDoorClimbPos = Pawn.Location;
      OldAccel = Pawn.Acceleration;
      Pawn.Acceleration = vect(0,0,0);
      Pawn.Velocity = - DoorLockedNormal * 400.0 + vect(0,0,1) * 150.0;

      if ( bPressedJump )
        GotoState('PlayerWalking');
    }
}

//_____________________________________________________________________________
// Player is controlling orientation of a gun turret.
state PlayerGunning
{
    ignores Reload, cNextItem, cPrevItem, PrevWeapon, NextWeapon;

    function BeginState()
    {
      local MitraillTop GunnedTurret;
      Local vector V,W;

      GunnedTurret = MitraillTop(Pawn.ControlledActor);
      V = GunnedTurret.location;
      W = vector(GunnedTurret.owner.Rotation);
      W.z = 0.0;
      W = Normal(W);
      V -= GunnedTurret.CollisionRadius * W;
      V -= Pawn.CollisionRadius * W;
      V.z = Pawn.Location.z;
      Pawn.SetCollision(false,false,false);
      Pawn.Velocity = vect(0,0,0);
      Pawn.Acceleration = vect(0,0,0);
      Pawn.SetLocation(V);
      Pawn.SetCollision(true,true,true);
      Pawn.bHidden = true;
      Pawn.RefreshDisplaying();
      Pawn.bStasis = true;
      if ( bWeaponMode )
      {
        OldWeap = pawn.weapon.InventoryGroup;
        Pawn.Weapon.PutDown();
      }
      else
      {
        OldItem = XIIIItems(Pawn.SelectedItem);
        OldItem.PutDown();
      }
      bWeaponBlock = true;
      SetViewTarget(Pawn.ControlledActor);
      DesiredFOV = 70;
      FOVAngle = 70;
    }
    function EndState()
    {
      Pawn.bHidden = false;
      Pawn.RefreshDisplaying();
      Pawn.bStasis = false;
      SetViewTarget(Pawn);
      DesiredFOV = DefaultFOV;
      FOVAngle = DefaultFOV;
      bWeaponBlock = false;
      DebugLog("GUNNING EndState OldItem="$OldItem@"bWeaponMode="$bWeaponMode);
      if ( bWeaponMode )
      {
        Switchweapon( OldWeap );
        Pawn.ChangedWeapon();
      }
      else
      {
        if ( OldItem != none )
        {
          cNextItem();
          XIIIPawn(Pawn).PendingItem = OldItem;
        }
        else
        {
          bWaitForWeaponMode = true;
          bWeaponMode = true;
          SwitchWeapon( 0 );
        }
        Pawn.ChangedWeapon();
      }
      DebugLog("GUNNING AFTER EndState OldItem="$OldItem@"bWeaponMode="$bWeaponMode);
    }

    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
      Local vector X,Y,Z;

      GetAxes(ViewTarget.rotation, X,Y,Z);
      ViewActor = ViewTarget;
      CameraLocation = ViewActor.Location - X * 60 + Z * 20.0; // + ShakeOffset;
      CameraRotation = ViewActor.Rotation;
      CalcFirstPersonView( CameraLocation, CameraRotation );
      CameraLocation -= Pawn.EyePosition();
    }

    function Leave()
    {
      local MitraillTop GunnedTurret;

      GunnedTurret = MitraillTop(Pawn.ControlledActor);
      GotoState('PlayerWalking');
      Pawn.SetPhysics(PHYS_Falling);
      GunnedTurret.LeaveControl();
    }
    function PlayerMove( float DeltaTime )
    {
      local MitraillTop GunnedTurret;

      GunnedTurret = MitraillTop(Pawn.ControlledActor);
      UpdateRotation(DeltaTime, 1);
      GunnedTurret.TrySetRotation(Rotation);
      SetRotation(GunnedTurret.Rotation);
      if ( bPressedJump )
        Leave();
    }
    exec function Grab() { Leave(); }
    exec function AltFire(float value) { Leave(); }

    exec function Fire(float value)
    {
      Mitrailltop(Pawn.ControlledActor).Fire();
    }

    simulated event RenderOverlays( canvas C )
    {
      Pawn.ControlledActor.RenderOverlays(C);
    }
}

//_____________________________________________________________________________
state ClimbToHookNavPoint extends PlayerWalking
{
    function BeginState()
    {
      Pawn.SetCollision(false,false,false);
      SetPhysics(PHYS_None);
    }
    function EndState()
    {
      Pawn.SetCollision(true,true,true);
      SetPhysics(PHYS_Walking);
    }
    function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
//      Log("ClimbToHookNavPoint ProcessMove");
      Pawn.Acceleration = vect(0,0,0);
      if ( Pawn.Location.Z < (TargetHookClimb.Location.Z) )
      {
//        Log("                    ProcessMove going up");
        Pawn.Velocity = vect(0,0,256);
      }
      else
      {
//        Log("                    ProcessMove going to nav point");
        Pawn.Velocity = normal(TargetHookClimb.Location - Pawn.Location)*256;
      }
      if ( vSize(TargetHookClimb.Location - Pawn.Location) < 20.0 )
      {
//        Log("                    GOTO PlayerWalking because reached target");
        GotoState('PlayerWalking');
      }
    }
}

//_____________________________________________________________________________
state GameEnded
{
    ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, NotifyHeadVolumeChange,
      NotifyPhysicsVolumeChange, Falling, TakeDamage, Suicide, Reload, cNextItem, NextWeapon, PrevWeapon, cPrevItem, Grab;

    simulated event RenderOverlays( canvas C ) {}
    function PawnDied() {}
    exec function ThrowWeapon() {}

    function bool IsInLethalVolume(out optional volume Vol)
    {
      local Volume V;

      ForEach Pawn.TouchingActors(class'Volume',V)
        if ( V.IsA('Lethalvolume') )
        {
          Vol = V;
          return true;
        }
      return false;
    }

    function ServerReStartGame()
    {
      Level.Game.RestartGame();
    }

// ELR E3 CHEAT
    exec function Fire( optional float F )
    {
//      ConsoleCommand("RestartLevel");
    }
    exec function AltFire( optional float F )
    {
//      ConsoleCommand("RestartLevel");
    }
// ELR END E3 CHEATS
/*
    exec function Fire( optional float F )
    {
      if ( Role < ROLE_Authority)
        return;
      if ( !bFrozen )
        ServerReStartGame();
      else if ( TimerRate <= 0 )
        SetTimer(1.5, false);
    }

    exec function AltFire( optional float F )
    {
      Fire(F);
    }
*/

    function PlayerMove(float DeltaTime)
    {
      local vector X,Y,Z;
      local Rotator ViewRotation;

      GetAxes(Rotation,X,Y,Z);
      // Update view rotation.

      if ( !bFixedCamera )
      {
        ViewRotation = Rotation;
        ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
        ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
        ViewRotation.Pitch = ViewRotation.Pitch & 65535;
        If ((ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152))
        {
          If (aLookUp > 0)
            ViewRotation.Pitch = 18000;
          else
            ViewRotation.Pitch = 49152;
        }
        SetRotation(ViewRotation);
      }
      else if ( ViewTarget != None )
        SetRotation(ViewTarget.Rotation);

      ViewShake(DeltaTime);
      ViewFlash(DeltaTime);

      if ( Role < ROLE_Authority ) // then save this move and replicate it
        ReplicateMove(DeltaTime, vect(0,0,0), DCLICK_None, rot(0,0,0));
      else
        ProcessMove(DeltaTime, vect(0,0,0), DCLICK_None, rot(0,0,0));
      bPressedJump = false;
    }

    function ServerMove
    (
      float TimeStamp,
      vector InAccel,
      vector ClientLoc,
      bool NewbRun,
      bool NewbDuck,
      bool NewbJumpStatus,
      eDoubleClickDir DoubleClickMove,
      byte ClientRoll,
      int View,
      optional byte OldTimeDelta,
      optional int OldAccel
    )
    {
      Global.ServerMove(TimeStamp, InAccel, ClientLoc, NewbRun, NewbDuck, NewbJumpStatus,
        DoubleClickMove, ClientRoll, (32767 & (Rotation.Pitch/2)) * 32768 + (32767 & (Rotation.Yaw/2)) );

    }

    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
      ViewActor = ViewTarget;
      CameraLocation = vGameEndedCamLoc;
      CameraRotation = rGameEndedCamRot;
    }

    function FindGoodView()
    {
      local vector cameraLoc;
      local rotator cameraRot, ViewRotation;
      local int tries, besttry;
      local float bestdist, newdist;
      local int startYaw;
      local actor ViewActor;

      ViewRotation = Rotation;
      ViewRotation.Pitch = 56000;
      tries = 0;
      besttry = 0;
      bestdist = 0.0;
      startYaw = ViewRotation.Yaw;

      for (tries=0; tries<16; tries++)
      {
        cameraLoc = ViewTarget.Location;
        PlayerCalcView(ViewActor, cameraLoc, cameraRot);
        newdist = VSize(cameraLoc - ViewTarget.Location);
        if (newdist > bestdist)
        {
          bestdist = newdist;
          besttry = tries;
        }
        ViewRotation.Yaw += 4096;
      }

      ViewRotation.Yaw = startYaw + besttry * 4096;
      SetRotation(ViewRotation);
    }

    function Timer()
    {
      bFrozen = false;
    }

    function BeginState()
    {
      local Pawn P;
      Local Actor A;
      Local Volume V;
      local int XIIIEndGameType;

      bFixedCamera = true;
      DesiredFOV = DefaultFOV;
      FOVAngle = DefaultFOV;

      if ( Level.Game != none )
        XIIIEndGameType = XIIIGameInfo(Level.Game).XIIIEndGameType;
      else
        XIIIEndGameType = 0;

      Log("Game Ended for "$self$" w/ mode "$XIIIEndGameType);

      // Hide all inventory that should be rendered
      if ( Pawn != none )
      {
        Pawn.bCanClimbLadders = false; // no more ladder climb (in case player jumps in a laddervolume just before gameended
        Pawn.bCanJump = false;
        bWeaponBlock = true;
/*
        Pawn.PendingWeapon = none;
        Pawn.PendingItem = none;
        if ( pawn.weapon != none )
        {
          OldWeap = pawn.weapon.InventoryGroup;
          Pawn.Weapon.PutDown();
        }
        if ( Pawn.SelectedItem != none )
        {
          OldItem = XIIIItems(Pawn.SelectedItem);
          OldItem.PutDown();
        }
*/
        if ( Pawn.Weapon != none )
        {
          Pawn.Weapon.bOwnerNoSee = true;
          Pawn.Weapon.bHidden = true;
          Pawn.Weapon.Refreshdisplaying();
          if ( Pawn.Weapon.MySlave != none )
          {
            Pawn.Weapon.MySlave.bOwnerNoSee = true;
            Pawn.Weapon.MySlave.bHidden = true;
            Pawn.Weapon.MySlave.Refreshdisplaying();
          }
        }
        if ( Pawn.SelectedItem != none )
        {
          Pawn.SelectedItem.bOwnerNoSee = true;
          Pawn.SelectedItem.bHidden = true;
          Pawn.SelectedItem.Refreshdisplaying();
        }
        if ( XIIIPawn(Pawn).LHand != none )
        {
          XIIIPawn(Pawn).LHand.bOwnerNoSee = true;
          XIIIPawn(Pawn).LHand.bHidden = true;
          XIIIPawn(Pawn).LHand.Refreshdisplaying();
        }
      }

      Global.PlayerCalcView(A, vGameEndedCamLoc, rGameEndedCamRot);

      if ( XIIIEndGameType == 1 ) // SoloDeath
      {
        if ( fRand() < 0.5 )
          iGameEndedRandEffect = 1;
        else
          iGameEndedRandEffect = -1;
        if ( XIIIPawn(pawn).HitDamageType != class'XIII.DTDrowned' )
          GotoState('GameEndedDeath');
        else
          GotoState('GameEndedDrown');
      }
      else if ( XIIIEndGameType == 3 ) // Falling
      {
        if ( IsInLethalVolume(V) )
        {
//          Log("I'm in Lethalvolume V="$V);
          OnoF = Spawn(class'OnoFalling', Pawn,,Pawn.Location);
          vGameEndedCamLoc = Lethalvolume(V).PointOfViewWhenFalling.Location;
        }
//        Log("Volume V="$V$" PointOfViewWhenFalling="$Lethalvolume(V).PointOfViewWhenFalling);
        iGameEndedRandEffect = 1;
        bBehindView = true;
        GotoState('GameEndedFalling');
      }
      else if ( XIIIEndGameType == 4 ) // Success
      {
        GotoState('GameEndedSuccess');
      }

      EndZoom();
      bFire = 0;
      bAltFire = 0;
      if ( Pawn != None )
      {
        Pawn.SimAnim.AnimRate = 0;
        Pawn.bPhysicsAnimUpdate = false;
        Pawn.StopAnimating();
        Pawn.SetCollision(false,false,false);
      }
      myHUD.bShowScores = true;
      bFrozen = true;
      if ( !bFixedCamera )
      {
        FindGoodView();
        bBehindView = true;
      }
      SetTimer(1.5, false);
      SetPhysics(PHYS_None);
      ForEach DynamicActors(class'Pawn', P)
      {
        P.Velocity = vect(0,0,0);
        P.SetPhysics(PHYS_None);
      }
    }
begin:
      if ( !Level.bLonePlayer || XIIIGameInfo(Level.Game).XIIIEndGameType==4)
		  stop;
	  Sleep(4);
      ConsoleCommand("ShowTheMenu "$self);
}

//_____________________________________________________________________________
state GameEndedDeath Extends GameEnded
{
    event PlayerTick(float dT)
    {
      DeltaT = dT;
//      Log("DeltaT="$DeltaT);
      Pawn.region.Zone.FlashEffectDesc.LayerBrightness = min(255, Pawn.region.Zone.FlashEffectDesc.LayerBrightness + DeltaT*200.0);
      Pawn.region.Zone.FlashEffectDesc.Brightness = max(10, Pawn.region.Zone.FlashEffectDesc.Brightness - DeltaT*0.05);
    }
//      Global.PlayerCalcView(A, vGameEndedCamLoc, rGameEndedCamRot);
    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
      Local vector TargetCamLoc;

      TargetCamLoc = Pawn.Location - Pawn.CollisionHeight * 0.75 * vect(0,0,1);

      if (rGameEndedCamRot.Pitch <= 15500)
        rGameEndedCamRot.Pitch = max(0, rGameEndedCamRot.Pitch - (DeltaT * 300.0));
//        rGameEndedCamRot.Pitch = max(0, rGameEndedCamRot.Pitch*0.97);
      else if (rGameEndedCamRot.Pitch >= 50000)
        rGameEndedCamRot.Pitch = min(65535, rGameEndedCamRot.Pitch + (DeltaT * 300.0));
//        rGameEndedCamRot.Pitch = min(65535, rGameEndedCamRot.Pitch*1.007);

      rGameEndedCamRot.Roll += 150.0 * (DeltaT*30.0) * iGameEndedRandEffect;
      if ( iGameEndedRandEffect > 0 )
        rGameEndedCamRot.Roll = min(rGameEndedCamRot.Roll, 12000);
      else
        rGameEndedCamRot.Roll = max(rGameEndedCamRot.Roll, -12000);
      vGameEndedCamLoc = (vGameEndedCamLoc*45.0*(DeltaT*30.0) + TargetCamLoc)/(45.0*(DeltaT*30.0)+1);

      ViewActor = ViewTarget;
      CameraLocation = vGameEndedCamLoc;
      CameraRotation = rGameEndedCamRot;
    }

    function BeginState()
    {
      Log("GameEndedDeath BeginState");
      Pawn.region.Zone.FlashEffectDesc.IsActivated = true;
      Pawn.region.Zone.FlashEffectDesc.NoGrey = true;
      Pawn.region.Zone.FlashEffectDesc.Contrast = 255;
      Pawn.region.Zone.FlashEffectDesc.LayerBrightness = 0;
      Pawn.region.Zone.FlashEffectDesc.Brightness = 128;
      Pawn.region.Zone.FlashEffectDesc.LayerColor = class'canvas'.static.makecolor(255,0,0,0);
      DeltaT = 1.0/30.0;  // init to 30 fps
      enable('Tick');
      bStasis = false;
//      SetTimer(1.5, false);
//      Log("GameEndedDeath BeginState");
    } // dont replay the GameEnded BeginState()
/*
    event Timer()
    {
			ShakeView(5.0, 300, vect(0,0,10), 120000, vect(50,50,50), 3);
    }
*/
}

//_____________________________________________________________________________
state GameEndedDrown Extends GameEnded
{
//      Global.PlayerCalcView(A, vGameEndedCamLoc, rGameEndedCamRot);
    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
      Local vector TargetCamLoc;

      TargetCamLoc = Pawn.Location; // - Pawn.CollisionHeight * 0.8 * vect(0,0,1);

//      if ( (rGameEndedCamRot.Pitch > 15500) && (rGameEndedCamRot.Pitch < 50000))
      if (rGameEndedCamRot.Pitch <= 15500)
        rGameEndedCamRot.Pitch = min(15500, rGameEndedCamRot.Pitch + 300);
      else if (rGameEndedCamRot.Pitch >= 50000)
      {
        rGameEndedCamRot.Pitch = rGameEndedCamRot.Pitch + 300;
        rGameEndedCamRot.Pitch = rGameEndedCamRot.Pitch & 65535;
      }

/*
      rGameEndedCamRot.Roll += 160*iGameEndedRandEffect;
      if ( iGameEndedRandEffect > 0 )
        rGameEndedCamRot.Roll = min(rGameEndedCamRot.Roll, 12000);
      else
        rGameEndedCamRot.Roll = max(rGameEndedCamRot.Roll, -12000);
*/

      vGameEndedCamLoc = (vGameEndedCamLoc*24.0 + TargetCamLoc)/25.0;

      ViewActor = ViewTarget;
      CameraLocation = vGameEndedCamLoc;
      CameraRotation = rGameEndedCamRot;
    }

    function BeginState()
    {
//      Log("GameEndedDeath BeginState");
    } // dont replay the GameEnded BeginState()
}

//_____________________________________________________________________________
state GameEndedFalling Extends GameEnded
{
    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
      ViewActor = ViewTarget;
      CameraLocation = vGameEndedCamLoc;
      CameraRotation = Rotator(ViewActor.Location - vGameEndedCamLoc);
    }

    function BeginState()
    {
//      Log("GameEndedFalling BeginState");
      FilterColorWanted=class'canvas'.static.makecolor(0,0,0,0);
      FilterColorSpeed=0.5;
/*
var color FilterColor;                // La couleur courante.
var color FilterColorWanted;          // La couleur vers laquelle le moteur doit converger.
var float FilterColorSpeed;           // La vitesse de convergence.
*/
    } // dont replay the GameEnded BeginState()

    function EndState()
    {
      FilterColorWanted=class'canvas'.static.makecolor(128,128,128,128);
      FilterColorSpeed=10.0;
    }

    Event bool NotifyLanded(vector HitNorm)
    {
      OnoF.OnoEnd();
      FilterColor=class'canvas'.static.makecolor(200,0,0,64);
      FilterColorWanted=class'canvas'.static.makecolor(200,0,0,64);
      Settimer(0.10, false);
      return true;
    }

    event Timer()
    {
      FilterColorWanted=class'canvas'.static.makecolor(0,0,0,0);
      FilterColorSpeed=5.0;
    }
}

//_____________________________________________________________________________
// the mission is a success, play video if available then travel
state GameEndedSuccess extends GameEnded
{
    event BeginState()
    {
//      Log("GameEndedSucess BeginState");
      SetTimer(3.0, false);
    }
    event Timer()
    {
//      Log("GameEndedSucess Timer");
      if ( (XIIIGameInfo(Level.Game).MapInfo != none) && (XIIIGameInfo(Level.Game).MapInfo.EndMapVideo != "") )
      { // Play video
        if ( VP == none )
          VP = new class'VideoPlayer';
        if ( VP != none )
          VP.Open(XIIIGameInfo(Level.Game).MapInfo.EndMapVideo);
        GotoState('PlayingVideo');
      }
      else
      { // travel
        GotoState('GameEndedSuccess', 'DoTravel');
      }
    }
Begin:
  Stop;
DoTravel:
//  Log("GameEndedSucess DoTravel... Sleep 0.3");
  sleep(1.0);
//  Log("GameEndedSucess DoTravel... End sleep");
  Level.ServerTravel(XIIIGameInfo(Level.Game).MapInfo.NextMapLevelWithUnr, true);
}

//_____________________________________________________________________________
state PlayingVideo
{
    event BeginState()
    {
      KillAllSounds();
      VP.Play();
      StopAllSounds();
    }
    event PlayerTick(float dT)
    {
      if ( VP == none )
        Level.ServerTravel(XIIIGameInfo(Level.Game).MapInfo.NextMapLevelWithUnr, true);
      else
      {
        switch (VP.GetStatus())
        {
          Case 0: // End video or no play
            Log("End video or no play");
            Level.ServerTravel(XIIIGameInfo(Level.Game).MapInfo.NextMapLevelWithUnr, true);
            break;
          Case 2: // Error while playing
            Log("Error playing video");
            Level.ServerTravel(XIIIGameInfo(Level.Game).MapInfo.NextMapLevelWithUnr, true);
            break;
          Case 1: // continue playing
        }
      }
    }
    exec function Fire( optional float F );
}

//_____________________________________________________________________________
State NoControl extends PlayerWalking
{
    ignores ReLoad, NextWeapon, PrevWeapon, cNextItem, cPrevItem, Fire, AltFire, Jump, Grab, QuickHeal;

//    simulated event RenderOverlays( canvas C ) {}

    event BeginState()
    {
      Pawn.bCanCrouch=false;
//      Log("NoControl Begin State");
      Super.BeginState();
      velocity=vect(0,0,0);
      if (!bMenuIsActive)
      Level.bCineFrame = true;
//      PlayerInput.bForceCrouch = true;
    }

    event EndState()
    {
      Pawn.bCanCrouch=true;
      Level.bCineFrame = false;
      MyInteraction.TargetActor = none; // Anticrash if target actor was a breakable mover
//      Log("NoControl End State");
//      PlayerInput.bForceCrouch = false;
    }

    function UpdateRotation(float DeltaTime, float maxPitch)
    {
      local Rotator r;
      r=Rotation;
      //		DesiredRotation=Rotation;
      ViewShake(deltaTime);
      SetRotation(r); // Force Rotation even if shaking camera
      ViewFlash(deltaTime);
    }
/*
    event Playertick(float dT)
    {
//      Log("NoControl End State");
    }


    event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
    {
      Log("NoControl PlayerCalcView");
    	ViewActor = ViewTarget;
      CameraLocation = Location;
      CameraRotation = Rotation;
    }
*/

    function PlayerMove( float DeltaTime )
    {
      local vector X,Y,Z, NewAccel;
      local eDoubleClickDir DoubleClickMove;
      local rotator OldRotation; //, ViewRotation;
      //local float Speed2D;
      //local bool bSaveJump;

//      Log("NoControl PlayerMove");
      GetAxes(Pawn.Rotation,X,Y,Z);

      // Update acceleration.
      NewAccel = vect(0,0,0);
//      DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime);

      GroundPitch = 0;
      bSnaptoLevel = false;
      bCenterView = false;
      OldRotation = Rotation;
      // MLK: Otherwise the player moves while in menu
      if (!(Left(Level.GetLocalURL(), 7) ~= "mapmenu"))
  		UpdateRotation(DeltaTime, 1);
//      ViewShake(deltaTime);
//      ViewFlash(deltaTime);

      if ( Pawn.Physics != PHYS_Falling )
      {
        Pawn.bWantsToCrouch = PlayerInput.bForceCrouch;
        Pawn.ShouldCrouch(PlayerInput.bForceCrouch);
      }

      if ( Role < ROLE_Authority ) // then save this move and replicate it
        ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
      else
        ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
      bPressedJump = false;
    }
}

//_____________________________________________________________________________
// waiting for first display to give controls to the player (else can trigger unwanted/unseen events)
// by moving while engine init (w/out screen refresh)
state WaitForFirstDisplay
{
    simulated event RenderOverLays(Canvas C)
    {
      if ( !bOkForMoving )
      {
        bOkForMoving = true;
        SetTimer(0.2, false);
      }
    }
    simulated event Timer()
    {
      EnterStartState();
    }
    function UpdateRotation(float DeltaTime, float maxPitch);
    function PlayerMove( float DeltaTime );
}


//_____________________________________________________________________________
/*State NoRotation extends PlayerWalking
{
    ignores ReLoad, NextWeapon, PrevWeapon, cNextItem, cPrevItem, Fire, AltFire, Jump, Grab, QuickHeal;

    simulated event RenderOverlays( canvas C ) {}

    event BeginState()
    {
//      Log("NoControl Begin State");
      Super.BeginState();
      velocity=vect(0,0,0);
    }

    event EndState()
    {
      MyInteraction.TargetActor = none; // Anticrash if target actor was a breakable mover
//      Log("NoControl End State");
    }

    function UpdateRotation(float DeltaTime, float maxPitch)
    {
		LOCAL Rotator r;
		r=Rotation;
		ViewShake(deltaTime);
		SetRotation(r); // Force Rotation even if shaking camera
		ViewFlash(deltaTime);
    }
}*/
//_____________________________________________________________________________
State NoMove extends PlayerWalking
{
    ignores ReLoad, NextWeapon, PrevWeapon, cNextItem, cPrevItem, Fire, AltFire, Jump, Grab, QuickHeal;
    event BeginState()
    {
      Super.BeginState();
      velocity=vect(0,0,0);
  	  rGameEndedCamRot=Rotation;
      Pawn.bCanCrouch=false;
    }
    event EndState()
    {
      MyInteraction.TargetActor = none; // Anticrash if target actor was a breakable mover
      Pawn.bCanCrouch=true;
//      Log("NoMove End State");
    }

    function PlayerMove( float DeltaTime )
    {
      local vector NewAccel;
      local eDoubleClickDir DoubleClickMove;
      local rotator OldRotation,r;

      NewAccel = vect(0,0,0);

      GroundPitch = 0;
      bSnaptoLevel = false;
      bCenterView = false;
      OldRotation = Rotation;
  	  r=Rotation-rGameEndedCamRot;

      DesiredRotation = r; //save old rotation
      r.Yaw += 32.0 * DeltaTime * aTurn;
      r.Pitch += 32.0 * DeltaTime * aLookUp;

      r.Pitch = r.Pitch & 65535;
      if ((r.Pitch > 15500) && (r.Pitch < 50000))
      {
        if (aLookUp > 0)
          r.Pitch = 15500;
        else
          r.Pitch = 50000;
      }

      r.yaw=Clamp(((r.yaw+32768)&65535)-32768,-6144,6144);
      r.Roll=0;
      r.Pitch=Clamp(((r.Pitch+32768)&65535)-32768,-3072,3072);
      SetRotation(r+rGameEndedCamRot);
      ViewShake(deltaTime);
      ViewFlash(deltaTime);

      if ( Role < ROLE_Authority ) // then save this move and replicate it
        ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
      else
        ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
      bPressedJump = false;
    }
}

//_____________________________________________________________________________
simulated State Kicked
{
    ignores ReLoad, NextWeapon, PrevWeapon, cNextItem, cPrevItem, Fire, AltFire, Jump, Grab, QuickHeal;
    simulated event BeginState()
    {
      //Log("KICKED"@self@"BeginState");
    }
    simulated event EndState()
    { // kicked are not allowed to go out of this state
      //Log("KICKED"@self@"EndState");
      SetTimer3(0.01, false);
    }
    function UpdateRotation(float DeltaTime, float maxPitch);
    function PlayerMove( float DeltaTime );
Begin:
  Sleep(4);
}

//_____________________________________________________________________________
// use to force player in Kicked State (else will go to dead after kicked
simulated event timer3()
{
//    Log("KICKED"@self@"timer3");
    GotoState('Kicked');
}

FUNCTION ClientSetHUD(class<HUD> newHUDType, class<Scoreboard> newScoringType)
{
	SUPER.ClientSetHUD( newHUDType, newScoringType);

	if ( int(ConsoleCommand("Get GameInfo GoreLevel") ) != 0 )
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


}


defaultproperties
{
     bWeaponMode=True
     bWaitForWeaponMode=True
     bAltZoomingSystem=True
     bFixedCrosshair=True
     hCLimbDoorSound=Sound'XIIIsound.SpecActions.LeonClimb1'
     hEndClimbDoorSound=Sound'XIIIsound.SpecActions.LeonClimb2'
     hCamViewBeginUseSound=Sound'XIIIsound.Items.CameraOn'
     hCamViewInUseSound=Sound'XIIIsound.Items.CameraRumble'
     hEndClimbLadderSound=Sound'XIIIsound.SpecActions__LadderClimb.LadderClimb__hEndClimbLadder'
     MyInteractionClass="XIII.XIIIPlayerInteraction"
     hTyrolStartSound=Sound'XIIIsound.Movers__TyrolCable.TyrolCable__hCableStart'
     hTyrolEndSound=Sound'XIIIsound.Movers__TyrolCable.TyrolCable__hCableEnded'
     iCrosshairMode=1
     fCrosshairSize=2.000000
     fLookSpeed=1.000000
     bUseRumble=True
     CheatClass=Class'XIII.XIIICheatManager'
     PlayerReplicationInfoClass=Class'XIII.XIIIPlayerReplicationInfo'
     bHasRollOff=False
     bHasPosition=False
}
