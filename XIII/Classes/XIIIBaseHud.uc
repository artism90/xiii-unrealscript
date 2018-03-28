//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIBaseHud extends HUD;

//#EXEC OBJ LOAD FILE=../TexturesPC/XIIIMenu.utx PACKAGE=XIIIMENU

//var bool bNumericDisplay;     // if true, armor ( vest + helm ), life & breath are in numeric display mode
var bool bDrawWeapons;          // To display list of weapons when changing (PendingWeapon != weapon)
var bool bDrawItems;            // To display list of Items when changing (PendingItem != SelectedItem)
var bool bDrawDamageWarn;       // To display SixSense SFX
var bool SafeArea;
var bool HudCartoonSFX;
var bool CanDisplay, HideCartoonHud, HudCartoonInit;
var bool InputUp, InputDown, InputLeft, InputRight, InputOk, InputCancel;
var bool bDrawBossBar;          // Display boss life bar
var Pawn Boss;

var int OldClipX;     // Used for Messages
var XIIIPlayerController XIIIPlayerOwner; // Cast of the controller

//var texture FullDamageTex;      // texture used for drawing layer of damages/armor levels
//var texture EncartPersoTex;     // background for FullDamageTex.
//var texture CasqueTex;          // Icon for drawing when wearing a Helmet
//var texture GiletTex;           // Icon for drawing when wearing a BulletProof vest

//var localized string sSixSenseOn; // instead of a message event.

var XIIIItems DrawnItem;        // Item to draw info on screen
var float fDrawItemsTimer;      // timer used w/ the bool above.

var float LeftMargin2, RightMargin2, UpMargin2, downMargin2;  // for TV security draw, in %
var float fDrawScale;           // for reduced viewports drawing

var HudObjectifMessage HudObjMsg;          // Linked chain of messages to display (each one independant but linked in order)
var HudMPMessage HudMPMsg;          // Linked chain of messages to display (each one independant but linked in order)
var HudEndMessage HudEndMsg;          // Linked chain of messages to display (each one independant but linked in order)
var HudMessage HudMsg;          // Linked chain of messages to display (each one independant but linked in order)
var HudDialog HudDlg;           // Linked chain of Dialogs (sub-titles) to display (each one independant but linked in order)
var texture FondDlg;            // to be used by HUDMsg(s) & HUDDlg(s)
var texture FlechDlg;           // to be used by HUDMsg(s) & HUDDlg(s)
var HudCartoonWindow HudWnd;    // Linked chain of cartoon windows to display
var HudCartoonFocus HudFoc;     // Liked chain of focus windows (realtime 'outlines' of some actors

var HudState HudStt;                // for 'Saving' message type, screen-centered.

//::iKi::BEGIN
var transient actor ShowDebugActor;
//::iKi::END

var float fDrawDamageWarnTimer[4];  // timer used w/ the bool above.
var texture DamageWarnTexFront;     // Used for visual effect on screen
var texture DamageWarnTexBack;      // Used for visual effect on screen
var texture DamageWarnTexLeft;      // Used for visual effect on screen
// for damage warn type 2
var vector vDrawDamageWarnLoc[4];   // Location on screen
var texture DamageWarnTex;          // splash texture

var RenderTargetMaterial CWndMat;   // The unique material used for Cartoon windows

//var Casque Helmet;                // memorize this item to avoid findInventoryType each frame
//var GiletMk1 Vest;                // -//- same

//::DBUG::
//var localized string TESTXIII;

var float fTranspWarningDamage;     // alpha de la texture de warning

var int ViewPortId;

var texture WhiteTex;
var texture BlackTex;
var float HudCartoonOffset;
var CWndFullScreen HudCartoonWnd;
var int LastSwitchTime,RealTimeWndId, CartoonWindowNumber ;
var float X[5],Y[5],W[5],H[5];
var float OffsetX[5],OffsetY[5],OffsetW[5],OffsetH[5];
var float InitX[5],InitY[5],InitW[5],InitH[5];
var float dT;
var float switchDelay, SpeedFactor;
var sound hIntroBeginMap,hIntroBeginMapFocus,hIntroBeginMapPlayerMove;
//var CWndMyBossIsBeautiful HudBossWnd;
var int HudCartoonWndID;

// pour les focus longs (durent tant qu'un event n'est pas reçu)
// on stocke ici les données propres aux FocusTrigger et aux CartoonFocus equivalents
var HudCartoonFocus tCartoonFocus[5];
var CwndFocusTrigger tFocusTrigger[5];
var int eNbHudCartoonFocus;

var localized string sTimeLeft;

//____________________________________________________________________
// ELR init
function PostBeginPlay()
{
    // Init real-time screen capture material
    CWndMat = new(none) class'RenderTargetMaterial';
    Super.PostBeginPlay();
//    SetTimer(1.0, True);  // Used for messages management
}

//____________________________________________________________________
// ELR Add Prepare saving, do not remove...
function bool DrawLevelAction( canvas C )
{
    local string BigMessage;
    local texture LoadTex;

    if (Level.LevelAction == LEVACT_None )
    {
      if ( Level.Pauser != None )
           BigMessage = "";//PausedMessage;// PausedMessage; // Add pauser name?
      else
      {
           BigMessage = "";
           return false;
      }
    }
    else if ( Level.LevelAction == LEVACT_Loading )
    {
      if ((XIIIGameInfo(Level.Game).bGameEnded) && (!XIIIPlayerController(PlayerOwner).isInState('GameEndedDeath')))
      {
          LoadTex = XIIIGameInfo(Level.Game).MapInfo.nextLoadScreen;
          PlayerOwner.ConsoleCommand("RestoreBriefing");
          if (LoadTex != none)
          {
               C.SetPos(0 ,0);
               C.Style = 1; C.DrawColor = WhiteColor;
//               C.SetPos(C.ClipX / 2 - LoadTex.USize / 2, C.ClipY / 2 - LoadTex.VSize / 2);
               C.DrawTile(LoadTex, C.ClipX, C.ClipY, 0, 0, LoadTex.USize, LoadTex.VSize);
               BigMessage = "";
          }
      }
      else {
        //MLK Better be it static ? To consider if final solution
        LoadTex = texture(DynamicLoadObject("XIIIMenu.Loading", class'texture'));
        C.SetPos(0,0);
        C.Style = 1; C.DrawColor = WhiteColor;
        C.DrawTile(LoadTex, C.ClipX, C.clipY, 0, 0, LoadTex.USize, LoadTex.VSize);
        BigMessage = LoadingMessage;
      }
    }
    else if ( Level.LevelAction == LEVACT_Saving )
      BigMessage = SavingMessage;
    else if ( Level.LevelAction == LEVACT_Connecting )
      BigMessage = ConnectingMessage;
    else if ( Level.LevelAction == LEVACT_Precaching )
      BigMessage = PrecachingMessage;


    if ( BigMessage != "" )
    {
      C.Style = ERenderStyle.STY_Normal;
      UseLargeFont(C);
      PrintActionMessage(C, BigMessage);
      return true;
    }
    return false;
}

//____________________________________________________________________
//  Print a centered level action message with a drop shadow.
function PrintActionMessage( Canvas C, string BigMessage )
{
    local float XL, YL;

    if ( Len(BigMessage) > 10 )
      UseLargeFont(C);
    else
      UseHugeFont(C);

    C.bCenter = false;
    C.StrLen( BigMessage, XL, YL );
    C.SetPos(0.5 * (C.ClipX - XL) + 2, 0.93 * C.ClipY - YL + 2);
    C.SetDrawColor(80,80,80);
    C.DrawText( BigMessage, false );
    C.SetPos(0.5 * (C.ClipX - XL), 0.93 * C.ClipY - YL );
    C.SetDrawColor(255,255,255);
    C.DrawText( BigMessage, false );
}

//____________________________________________________________________
//::iKi::BEGIN
// toggles displaying properties of player's current viewtarget
exec function ShowDebug2(optional class<actor> aClass)
{
    local actor other, first;
    local bool bFound;

//     if ( (Level.Game != None) && !Level.Game.bCanViewOthers )
//          return;

    if (aClass!=none)
    {
      first = None;
      ForEach AllActors( aClass, other )
      {
        if ( bFound || (first == None) )
        {
          first = other;
          if ( bFound )
            break;
        }
        if ( other == ShowDebugActor )
        bFound = true;
      }

     ShowDebugActor=first;
     bShowDebugInfo = true;
     }
     else
     {
       if (ShowDebugActor==none)
         bShowDebugInfo = !bShowDebugInfo;
       else
       {
         ShowDebugActor=none;
         bShowDebugInfo = true;
       }
     }
}

simulated event WorldSpaceOverlays()
{
    local int i;
    local vector tV1, tV2;
    local rotator tR;
    local float faTan;

    Super.WorldSpaceOverlays();
    if ( ShowDebugActor!=none )
    {
    	ShowDebugActor.RenderOverlays(none);
    }
    if ( (XIIIPlayerOwner != none) && (XIIIPlayerOwner.PlayerInput != none) && XIIIPlayerOwner.PlayerInput.bCheckInputRanges )
    {
      // Circle
      tV1 = XIIIPlayerOwner.Pawn.Location;
      tR = XIIIPlayerOwner.Pawn.Rotation;
      tR.Yaw += 16384;
      tV2 = XIIIPlayerOwner.Pawn.Location + XIIIPlayerOwner.PlayerInput.fInputRange / 100 * vector(tR);
//      Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(255,255,255));
      for (i=1; i<120; i++)
      {
        tV1 = tV2;
        tR = XIIIPlayerOwner.Pawn.Rotation;
        tR.Yaw -= i*3.0*(65535/4.0/90.0) - 16384;
        tV2 = XIIIPlayerOwner.Pawn.Location + XIIIPlayerOwner.PlayerInput.fInputRange / 100 * vector(tR);
        Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(255,255,255));
      }
      tV1 = tV2;
      tR = XIIIPlayerOwner.Pawn.Rotation;
      tR.Yaw += 16384;
      tV2 = XIIIPlayerOwner.Pawn.Location + XIIIPlayerOwner.PlayerInput.fInputRange / 100 * vector(tR);
      Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(255,255,255));

      // Move
      tV1 = XIIIPlayerOwner.Pawn.Location;
      tR = XIIIPlayerOwner.Pawn.Rotation;
      tR.Yaw += 16384;
      tV2 = XIIIPlayerOwner.Pawn.Location + XIIIPlayerOwner.PlayerInput.MoveRange[0] / 100 * vector(tR);
//      Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(255,255,0));
      for (i=1; i<120; i++)
      {
        tV1 = tV2;
        tR = XIIIPlayerOwner.Pawn.Rotation;
        tR.Yaw -= i*3.0*(65535/4.0/90.0) - 16384;
        tV2 = XIIIPlayerOwner.Pawn.Location + XIIIPlayerOwner.PlayerInput.MoveRange[i] / 100 * vector(tR);
        Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(255,255,0));
      }
      tV1 = tV2;
      tR = XIIIPlayerOwner.Pawn.Rotation;
      tR.Yaw += 16384;
      tV2 = XIIIPlayerOwner.Pawn.Location + XIIIPlayerOwner.PlayerInput.MoveRange[0] / 100 * vector(tR);
      Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(255,255,0));

      // Current
//			Log("AngleRef="$AngleRef@"Max="$Max@"X="$XIIIPlayerOwner.aBaseY@"Y="$XIIIPlayerOwner.aStrafe);
      tV1 = XIIIPlayerOwner.Pawn.Location + vect(0,0,1);
      tR = XIIIPlayerOwner.Pawn.Rotation;
      tR.Yaw -= XIIIPlayerOwner.PlayerInput.CurrentInputAngle*3.0*(65535/4.0/90.0) - 16384;
      tV2 = XIIIPlayerOwner.Pawn.Location + vect(0,0,1) + XIIIPlayerOwner.PlayerInput.CurrentInput / 100 * vector(tR);
      Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(255,0,0));

      // Turn
      tV1 = XIIIPlayerOwner.Pawn.Location;
      tR = XIIIPlayerOwner.Pawn.Rotation;
      tR.Yaw += 32768;
      tV2 = XIIIPlayerOwner.Pawn.Location + XIIIPlayerOwner.PlayerInput.TurnRange[0] / 100 * vector(tR);
//      Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(255,255,0));
      for (i=1; i<120; i++)
      {
        tV1 = tV2;
        tR = XIIIPlayerOwner.Pawn.Rotation;
        tR.Yaw -= i*3.0*(65535/4.0/90.0) - 32768;
        tV2 = XIIIPlayerOwner.Pawn.Location + XIIIPlayerOwner.PlayerInput.TurnRange[i] / 100 * vector(tR);
        Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(255,0,255));
      }
      tV1 = tV2;
      tR = XIIIPlayerOwner.Pawn.Rotation;
      tR.Yaw += 32768;
      tV2 = XIIIPlayerOwner.Pawn.Location + XIIIPlayerOwner.PlayerInput.TurnRange[0] / 100 * vector(tR);
      Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(255,0,255));

      // Current
//			Log("AngleRef="$AngleRef@"Max="$Max@"X="$XIIIPlayerOwner.aBaseY@"Y="$XIIIPlayerOwner.aStrafe);
      tV1 = XIIIPlayerOwner.Pawn.Location + vect(0,0,1);
      tR = XIIIPlayerOwner.Pawn.Rotation;
      tR.Yaw -= XIIIPlayerOwner.PlayerInput.CurrentTurnInputAngle*3.0*(65535/4.0/90.0) - 32768;
      tV2 = XIIIPlayerOwner.Pawn.Location + vect(0,0,1) + XIIIPlayerOwner.PlayerInput.CurrentTurnInput / 100 * vector(tR);
      Draw3DLine(tV1, tV2, class'Canvas'.Static.MakeColor(0,0,255));
    }
}

//::iKi::END

//____________________________________________________________________
// ELR
simulated event PostRender( canvas Canvas )
{
//    local HUD H;
    local float YL,YPos;
    local Pawn P;
    local int i;

    // to be sure tap taps are erased even when not rendered.
    for (i=0; i<5; i++ )
      if ( fDrawSixSenseTimer[i] > 0 )
        fDrawSixSenseTimer[i] -= dT/6.0;
/*
    if ( XIIIPlayerController(PlayerOwner).bDrawingPortal )
      return;
*/
    if ( xiiiplayercontroller(PlayerOwner).bRenderPortal )
    {
      xiiiplayercontroller(PlayerOwner).RenderScreenOverlays(Canvas);
      return;
    }

    if ( !PlayerOwner.bBehindView )
      PlayerOwner.RenderOverLays(Canvas);

    if ( PawnOwner != PlayerOwner.ViewTarget )
    {
//      Helmet = none;
//      Vest = none;
      PawnOwner = Pawn(PlayerOwner.ViewTarget);
    }

    if ( PawnOwner != none )
    {
      if ( PawnOwner.region.Zone.FlashEffectDesc.IsActivated && !Level.Game.bGameEnded )
      {
        if ( HudMsg != none )
        {
          Canvas.SpaceX = 0;
          UseMsgFont(Canvas);
          Canvas.Style = ERenderStyle.STY_Alpha;
          HudMSG.DrawMsg(Canvas);
        }

        if ( HudDlg != none )
          HudDlg.DrawDlg(Canvas);
        return;
      }
    }

//    DisplayMessages(Canvas);
    bHideCenterMessages = DrawLevelAction(Canvas);

    if ( !bHideCenterMessages && (PlayerOwner.ProgressTimeOut > Level.TimeSeconds) )
      DisplayProgressMessage(Canvas);

    if ( bBadConnectionAlert )
      DisplayBadConnectionAlert(Canvas);
//    Log("calling DisplayBadConnectionAlert Canvas "$Canvas);

    if ( bShowDebugInfo )
    {
      YPos = 5;
      UseSmallFont(Canvas);
//      PlayerOwner.ViewTarget.DisplayDebug(Canvas,YL,YPos);
//::iKi::BEGIN
      if (ShowDebugActor==none)
        PlayerOwner.ViewTarget.DisplayDebug(Canvas,YL,YPos);
      else
	  {
        ShowDebugActor.DisplayDebug(Canvas,YL,YPos);
// 		if ( ShowDebugActor!=none )
//		{
		Canvas.SetPos(Canvas.ClipX*0.64, Canvas.ClipY*0.05-Canvas.ClipX*0.01);
		Canvas.Style = ERenderStyle.STY_Normal;
		Canvas.DrawColor.R=255;
		Canvas.DrawColor.G=255;
		Canvas.DrawColor.B=255;
//		Canvas.DrawColor.A=255;
		Canvas.DrawTile( WhiteTex, Canvas.ClipX*0.32, Canvas.ClipY*0.30+Canvas.ClipX*0.02, 0, 0, 8, 8 );

		XIIIPlayerOwner.bRenderPortal = true;
			Canvas.DrawPortal( Canvas.ClipX*0.65, Canvas.ClipY*0.05, Canvas.ClipX*0.30, Canvas.ClipY*0.30, ShowDebugActor /*actor CamActor*/, ShowDebugActor.Location+Pawn(ShowDebugActor).BaseEyeHeight*vect(0,0,1), ShowDebugActor.Rotation, /*optional int FOV*/, true /*optional bool ClearZ*/ );
			XIIIPlayerOwner.bRenderPortal = false;
//		}
	  }
//::iKi::END
    }
    else
      DrawHUD(Canvas);
// ELR no multi hud for us
//        for ( H=self; H!=None; H=H.NextHUD )
//          H.DrawHUD(Canvas);

    CanDisplay = true;
}

//____________________________________________________________________
// ELR do prepare HUD Drawing
function HUDSetup( canvas C )
{
    OldClipX = C.ClipX;
    C.Reset();
    C.SpaceX = 0;
    C.bNoSmooth = true;

    C.DrawCineFrame(Level.bCineFrame);

    if ( (C.ClipX/C.ClipY > 2.0) || (C.ClipY < 440) )
      fDrawScale=0.5;
    else
      fDrawScale=1.0;

    PawnOwner = Pawn(PlayerOwner.ViewTarget);
    if (PawnOwner == none)
    {
      PawnOwner = PlayerOwner.Pawn;
      bViewPlayer = false;
    }
    else
    {
     if ( PlayerOwner.IsInState('CameraView') )
      bViewPlayer = false;
     else
      bViewPlayer = true;
    }

    XIIIPlayerOwner = XIIIPlayerController(PlayerOwner);

    if (PawnOwner != none)
    {
      if ( XIIIPlayerController(PlayerOwner).bWaitForWeaponMode )
      {
        if ( (PawnOwner.PendingWeapon != none) ) //&& (PawnOwner.PendingWeapon != PawnOwner.Weapon) )
        {
          DrawnWeapon = PawnOwner.PendingWeapon;
        }
        else
        {
          DrawnWeapon = PawnOwner.Weapon;
          bDrawWeapons = false;
        }
      }
      else
      {
        if ( (PawnOwner.PendingItem != none) )
        {
          DrawnItem = XIIIItems(PawnOwner.PendingItem);
        }
        else if ( XIIIItems(PawnOwner.SelectedItem) != none )
        {
          DrawnItem = XIIIItems(PawnOwner.SelectedItem);
          bDrawItems = false;
        }
        else
        { // ALMOST BUG, should not have selected item none (may happen if using last medkit before locking w/ bWeaponBlock
          bDrawItems = false;
          DrawnItem = none;
          XIIIPlayercontroller(PawnOwner.controller).NextWeapon();
          PawnOwner.ChangedWeapon();
        }
      }
    }
}

//____________________________________________________________________

function InitViewportId( canvas C,bool bShowId )
{
    local controller Ctrl;
    local int Index;
    local string strViewPort;

    if( ViewPortId == -1 )
    {
        if( Level.NetMode == NM_Standalone )
        {
            if( ! Level.bLonePlayer )
            {
                Index = 1;

                for( Ctrl=Level.ControllerList; Ctrl!=None; Ctrl=Ctrl.nextController )
            		if( Ctrl.IsA('PlayerController') )
            		{
                        if( Ctrl == XIIIPlayerOwner )
                        {
                            ViewPortId = Level.Game.NumPlayers - Index;
                            break;
                        }

                        Index++;
                    }
            }
        }
    }

    if( Level.NetMode == NM_Standalone )
    {
        if( ! Level.bLonePlayer )
        {
            if( bShowId )
            {
                strViewPort = "Viewport"@ViewPortId;

                UseHugeFont(C);
                C.SpaceX = 1;
                C.bUseBorder = false;

                C.Style = ERenderStyle.STY_Alpha;
                C.DrawColor = HudBasicColor;
                C.DrawColor.A = 128;

                C.SetPos(C.ClipX/2.0,C.ClipY/2.0);
                C.DrawText(strViewPort, false);

                C.SpaceX = 0;
            }
        }
    }
}

//____________________________________________________________________

function AdjustMargin()
{
    if( Level.NetMode != NM_Standalone )
        return;

    if( ( Level.bLonePlayer ) || ( Level.Game.NumPlayers == 1 ) )
        return;

    if( LeftMargin2 == -1 )
    {
        LeftMargin2=LeftMargin;
        RightMargin2=RightMargin;
        UpMargin2=UpMargin;
        DownMargin2=DownMargin;
    }



    if( Level.Game.NumPlayers == 2 )
    {
        // Splitt 2

        if( ViewPortId == 0 )
        {
            // ViewPort 1 ( Up )

            LeftMargin = LeftMargin2;
            RightMargin = RightMargin2;
            UpMargin = UpMargin2*2;
            DownMargin = 0.02;
        }
        else
        {
            // ViewPort 2 ( Down )

            LeftMargin = LeftMargin2;
            RightMargin = RightMargin2;
            UpMargin = 0.02;
            DownMargin = DownMargin2*2;
        }
    }
    else
    {
        // Splitt 3 & 4

        if( ViewPortId == 0 )
        {
            // ViewPort 1 ( UpLeft )

            LeftMargin = LeftMargin2*2;
            RightMargin = 0.02;
            UpMargin = UpMargin2*2;
            DownMargin = 0.02;
        }
        else
        {
            if( ViewPortId == 1 )
            {
                // ViewPort 2 ( UpRight )

                LeftMargin = 0.02;
                RightMargin = RightMargin2*2;
                UpMargin = UpMargin2*2;
                DownMargin = 0.02;
            }
            else
            {
                if( ViewPortId == 2 )
                {
                    // ViewPort 3 ( DownLeft )

                    LeftMargin = LeftMargin2*2;
                    RightMargin = 0.02;
                    UpMargin = 0.02;
                    DownMargin = DownMargin2*2;
                }
                else
                {
                    // ViewPort 4 ( DownRight )

                    LeftMargin = 0.02;
                    RightMargin = RightMargin2*2;
                    UpMargin = 0.02;
                    downMargin = DownMargin2*2;
                }
            }
        }
    }
}

//____________________________________________________________________
// ELR Draw HUD
function DrawHUD( canvas C )
{
    local int i, fx, fy;

    HUDSetup( C );
    InitViewPortId( C, false );
    AdjustMargin();

    if ( !Level.bLonePlayer || (XIIIGameInfo(Level.Game).CheckPointNumber > 1) )
        HudCartoonSFX = false;
    else if( Level.InitialCartoonEffect != 0 )
        HudCartoonSFX = true;
    else if ( (Level.Game != none) && (XIIIGameInfo(Level.Game).MapInfo != none) )
        XIIIGameInfo(Level.Game).MapInfo.EndCartoonEffect = true;

    // ELR Do show scores if needed.
    if ( bShowScores && (Scoring != None) )
    {
      if ( (Level.Game== none) || (Level.NetMode != NM_StandAlone) )
        Scoring.ShowScores(C, ViewPortId, 1);
      else
        Scoring.ShowScores(C, ViewPortId, Level.Game.NumPlayers);
      return;
    }

    if( SafeArea )
        DrawSafeArea( C );

    if ( !bHideHud && (PawnOwner!=none) )
    {
      if ((Level.LevelAction == LEVACT_None) && (Level.Pauser == none))
      {
        if ( (Level.bLonePlayer) && Level.Game.bGameEnded )
        {
          EndGameDisplay(C);
          //return;  //FABE3
        }

        if ( !HudCartoonSFX )
        {
          XIIIDrawPlayerInfo(C);
          if ( bDrawBossBar )
            BossBarDisplay(C);
          if ( bViewPlayer )
          {
            if ( HudMsg != none )
            {
              C.SpaceX = 0;
              UseMsgFont(C);
              C.Style = ERenderStyle.STY_Alpha;
              HudMsg.DrawMsg(C);
            }

            XP = C.ClipX * LeftMargin;
            YP = C.ClipY * UpMargin;

            PlayerNameDisplay(C); // Draw PlayerName (multionly)

            XP = C.ClipX * LeftMargin;
            YP = C.ClipY * ( 1 - DownMargin );
            if ( (XIIIPlayerController(PawnOwner.controller)!=none) && (XIIIPlayerController(PawnOwner.Controller).aDoor != none) )
              DoorTimerDisplay(C);  // Draw DoorTimer

            if ( bDrawDamageWarn )
              DamageWarnDisplay(C);
          }
        }

        if ( HudCartoonSFX )
//            DrawCartoonWindowInGame( C );
          DrawCartoonWindowBis( C );

        XP = C.ClipX * LeftMargin + 32;
        YP = C.ClipY * UpMArgin;

        if ( HudWnd != none )
          HudWnd.DrawWnd(C);
        if ( HudFoc != none )
          HudFoc.DrawWnd(C);
        if ( HudDlg != none )
          HudDlg.DrawDlg(C);
        if ( HudStt != none )
          HudStt.DrawStt(C);
        if ( HudMpMsg != none )
          HudMpMsg.DrawMsg(C);
        if ( HudObjMsg != none )
          HudObjMsg.DrawMsg(C);
      }
    }
    else if ( Level.LevelAction == LEVACT_None )
    {
      XP = C.ClipX * LeftMargin;
      YP = C.ClipY * ( 1 - DownMargin );

      if ( HudEndMsg != none )
        HudEndMsg.DrawMsg(C);
    }
}

//____________________________________________________________________
// this function draw all the player HUD info
function XIIIDrawPlayerInfo(Canvas C)
{
    XP = int(C.ClipX * LeftMargin); // ELR align on pixels else Mipmap pbs
    YP = int(C.ClipY * ( 1 - DownMargin ));
    UseHugeFont(C);

    Super.DrawPlayerInfo(C);
    if ( bViewPlayer )
    {
      XP = C.ClipX * (1 - RightMargin);
      YP = C.ClipY * (1 - DownMargin );
      if ( DrawnWeapon != none )
      {
        //WeaponDisplay(C);     // Draw the Weapons of the player (DOWN-RIGHT Corner of the HUD).
        C.Style = ERenderStyle.STY_Normal;
        if ( XIIIPlayerController(PlayerOwner).bWaitForWeaponMode )
        {
          if ( bDrawWeapons || ( (fDrawWeaponsTimer-Level.TimeSeconds) >= 0.0))
          {
            DrawWeaponIconsList(C);
            YP -= 16;
          }
          else
            XIIIDrawAmmo(C);
        }
        else
        {
          if ( bDrawItems || ( (fDrawItemsTimer-Level.TimeSeconds) >= 0.0))
          {
            DrawItemsIconsList(C);
            YP -= 16;
          }
          else if ( DrawnItem != none )
            DrawCurrentItem(C);
        }
      }
    }
}

//____________________________________________________________________
event Tick( float DeltaTime )
{
    dT = DeltaTime;
    // ELR Super.tick useless as there is nothing in
}

//____________________________________________________________________
function AddBossBar(Pawn P)
{
    bDrawBossBar = true;
    Boss = P;
}

//____________________________________________________________________
function BossBarDisplay(Canvas C)
{
    local float Scale;
    Local int XPloc, YPloc, Heig;

    if ( (Boss == none) || Boss.bIsDead )
    {
      bDrawBossBar = false;
      return;
    }
    Scale = 1.8;
    Heig = int(LifeDisplayHeight*1.3);
    XPloc = int(C.ClipX*0.5 - 50.0*Scale - Heig);
    YPloc = int(C.ClipY - 120.0 - 2.0);
    // BackGround
    C.SetPos(XPloc, YPloc);
    C.DrawColor = HudBasicColor*0.1;
    C.DrawColor.A = 90;
    DrawStdBackground(C, Heig, int(100.0*scale+4.0));

    C.Style = ERenderStyle.STY_Alpha;

    C.Font = C.smallfont;
    C.SetDrawColor(250,220,170,255);
    C.bTextShadow = true;
    C.SetPos(XPloc+Heig+8, YPloc );
    C.DrawText(Boss.PawnName);
    C.bTextShadow = false;

    C.SetPos(XPloc+Heig+1, YPloc-4+LifeDisplayHeight);
    C.SetDrawColor(0,0,0,0);
    C.BorderColor = WhiteColor;
    C.bUseBorder = true;
    C.DrawTile(WhiteTex, 100*scale, Heig-LifeDisplayHeight, 0, 0, 1, 1);
    C.bUseBorder = false;
    C.SetPos(XPloc+Heig, YPloc-5+LifeDisplayHeight);
    C.SetDrawColor(250,190,100,196);
    C.DrawTile(WhiteTex, Boss.HealthPercent()*scale+1, Heig-LifeDisplayHeight+1, 0, 0, 1, 1);
}

//____________________________________________________________________
function DrawCartoonWindowBis( canvas C)
{
    local float dX,dY, Border, Width,Height ;
    local float XF,YF,WF,HF;
    local int Loop;

    if( Level.InitialCartoonEffect == -1 )
        Level.InitialCartoonEffect = Rand(3)+1;

    if( LastSwitchTime == -1 )
    {
        RealTimeWndId = 0;
        LastSwitchTime = Level.TimeSeconds;
    }
    else
    {
        if( !HideCartoonHud )
        {
            if( Level.TimeSeconds - LastSwitchTime > SwitchDelay )
            {
                PawnOwner.PlayMenu( hIntroBeginMapFocus );
                RealTimeWndId++;
                LastSwitchTime = Level.TimeSeconds;

                if( RealTimeWndId == CartoonWindowNumber )
                    RealTimeWndId = 0;
            }
        }
    }

    if( !HideCartoonHud )
        if( PawnOwner.velocity != vect(0,0,0) )
        {
            HideCartoonHud = true;
            XIIIGameInfo(Level.Game).MapInfo.EndCartoonEffect = true;
            PawnOwner.PlayMenu( hIntroBeginMapPlayerMove );
        }


    if( HideCartoonHud )
    {
        if( Level.InitialCartoonEffect == 1 )
        {
            // -------- ---- ----
            // |      | |   || 4 |
            // |   0  | | 2 |----
            // |      | |   |----
            // -------- ---- | 3 |
            // ------------- |   |
            // |     1      ||   |
            // ------------- ----

            switch( RealTimeWndId )
            {
                case 0:
                    OffsetX[ 0 ] = -0.50 ; OffsetY[ 0 ] = -0.50 ; OffsetW[ 0 ] = 1.50 ; OffsetH[ 0 ] = 1.50 ;
                    OffsetX[ 1 ] = 0.00 ; OffsetY[ 1 ] = 1.00 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = 0.00 ; OffsetY[ 2 ] = -1.50 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = 1.00 ; OffsetY[ 3 ] = 0.00 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 1.00 ; OffsetY[ 4 ] = -1.00 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 1:
                    OffsetX[ 0 ] = -1.00 ; OffsetY[ 0 ] = 0.00 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = -1.00 ;
                    OffsetX[ 1 ] = -0.50 ; OffsetY[ 1 ] = -1.00 ; OffsetW[ 1 ] = 1.50 ; OffsetH[ 1 ] = 2.00 ;
                    OffsetX[ 2 ] = 0.00 ; OffsetY[ 2 ] = 2.00 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = +1.00 ; OffsetY[ 3 ] = 0.00 ; OffsetW[ 3 ] = -1.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 1.00 ; OffsetY[ 4 ] = -1.00 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 2:
                    OffsetX[ 0 ] = -1.00 ; OffsetY[ 0 ] = 1.00 ; OffsetW[ 0 ] = -1.00 ; OffsetH[ 0 ] = -1.00 ;
                    OffsetX[ 1 ] = 0.00 ; OffsetY[ 1 ] = 1.00 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = -1.00 ; OffsetY[ 2 ] = -0.50 ; OffsetW[ 2 ] = 2.00 ; OffsetH[ 2 ] = 1.00 ;
                    OffsetX[ 3 ] = +1.00 ; OffsetY[ 3 ] = 1.00 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 1.00 ; OffsetY[ 4 ] = 0.00 ; OffsetW[ 4 ] = -1.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 3:
                    OffsetX[ 0 ] = 1.00 ; OffsetY[ 0 ] = 0.00 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = -0.80 ;
                    OffsetX[ 1 ] = -1.00 ; OffsetY[ 1 ] = -0.50 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = -1.00 ; OffsetY[ 2 ] = 0.50 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = -1.00 ; OffsetY[ 3 ] = -1.00 ; OffsetW[ 3 ] = 1.50 ; OffsetH[ 3 ] = 1.50 ;
                    OffsetX[ 4 ] = 0.00 ; OffsetY[ 4 ] = 1.00 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 4:
                    OffsetX[ 0 ] = 0.00 ; OffsetY[ 0 ] = 1.00 ; OffsetW[ 0 ] = -0.65 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = -1.00 ; OffsetY[ 1 ] = 0.00 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = -1.00 ; OffsetY[ 2 ] = -0.50 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = 0.00 ; OffsetY[ 3 ] = 1.50 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = -1.50 ;
                    OffsetX[ 4 ] = -1.00 ; OffsetY[ 4 ] = -0.50 ; OffsetW[ 4 ] = 1.50 ; OffsetH[ 4 ] = 1.50 ;
                    break;
            }
        }
        else if( Level.InitialCartoonEffect == 2 )
        {
            // ------------- ----
            // |      0     ||   |
            // ------------- |   |
            // -------- ---- | 4 |
            // |       || 2 ||   |
            // |   1   |---- ----
            // |       |---------
            // |       ||    3   |
            // -------- ---------

            switch( RealTimeWndId )
            {
                case 0:
                    OffsetX[ 0 ] = -0.50 ; OffsetY[ 0 ] = -0.50 ; OffsetW[ 0 ] = 1.00 ; OffsetH[ 0 ] = 1.50 ;
                    OffsetX[ 1 ] = 0.00 ; OffsetY[ 1 ] = 1.50 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = 0.00 ; OffsetY[ 2 ] = -1.50 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = -2.50 ; OffsetY[ 3 ] = 0.00 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 0.00 ; OffsetY[ 4 ] = 1.80 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 1:
                    OffsetX[ 0 ] = 0.00 ; OffsetY[ 0 ] = -1.00 ; OffsetW[ 0 ] = 0.50 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = -0.50 ; OffsetY[ 1 ] = -1.00 ; OffsetW[ 1 ] = 1.50 ; OffsetH[ 1 ] = 2.00 ;
                    OffsetX[ 2 ] = 1.20 ; OffsetY[ 2 ] = -0.50 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.80 ;
                    OffsetX[ 3 ] = 1.00 ; OffsetY[ 3 ] = 1.00 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 0.00 ; OffsetY[ 4 ] = 1.80 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 2:
                    OffsetX[ 0 ] = 0.00 ; OffsetY[ 0 ] = -0.50 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = -1.00 ; OffsetY[ 1 ] = 0.00 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = -1.00 ; OffsetY[ 2 ] = -0.50 ; OffsetW[ 2 ] = 1.50 ; OffsetH[ 2 ] = 1.00 ;
                    OffsetX[ 3 ] = 0.00 ; OffsetY[ 3 ] = 0.50 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 0.50 ; OffsetY[ 4 ] = 0.00 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 3:
                    OffsetX[ 0 ] = 0.00 ; OffsetY[ 0 ] = -0.50 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = -1.00 ; OffsetY[ 1 ] = 0.00 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = 0.00 ; OffsetY[ 2 ] = 1.00 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = -1.00 ; OffsetY[ 3 ] = -1.00 ; OffsetW[ 3 ] = 1.50 ; OffsetH[ 3 ] = 1.50 ;
                    OffsetX[ 4 ] = 1.00 ; OffsetY[ 4 ] = 1.00 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 4:
                    OffsetX[ 0 ] = -1.20 ; OffsetY[ 0 ] = 1.00 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = -0.70 ; OffsetY[ 1 ] = -1.00 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = 1.50 ; OffsetY[ 2 ] = 0.00 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = 0.00 ; OffsetY[ 3 ] = 1.50 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = -1.00 ; OffsetY[ 4 ] = -0.50 ; OffsetW[ 4 ] = 1.50 ; OffsetH[ 4 ] = 1.50 ;
                    break;
            }
        }
        else if( Level.InitialCartoonEffect == 3 )
        {
            // ---- -------- ----
            // |   ||       ||   |
            // |   ||       ||   |
            // |   ||    4  || 3 |
            // | 0 ||       ||   |
            // |   | ------- ----
            // |   | --- --------
            // |   || 1 || 2     |
            // ----  --- --------

            switch( RealTimeWndId )
            {
                case 0:
                    OffsetX[ 0 ] = -0.1 ; OffsetY[ 0 ] = -0.10 ; OffsetW[ 0 ] = 1.50 ; OffsetH[ 0 ] = 0.20 ;
                    OffsetX[ 1 ] = 0.00 ; OffsetY[ 1 ] = 1.50 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = 0.00 ; OffsetY[ 2 ] = -1.50 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = 1.00 ; OffsetY[ 3 ] = -1.00 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 1.00 ; OffsetY[ 4 ] = 1.00 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 1:
                    OffsetX[ 0 ] = -0.60 ; OffsetY[ 0 ] = 0.00 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = -0.50 ; OffsetY[ 1 ] = -1.50 ; OffsetW[ 1 ] = 1.50 ; OffsetH[ 1 ] = 1.6 ;
                    OffsetX[ 2 ] = 1.60 ; OffsetY[ 2 ] = 0.00 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = 0.00 ; OffsetY[ 3 ] = 1.30 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 0.00 ; OffsetY[ 4 ] = -1.80 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 2:
                    OffsetX[ 0 ] = -0.80 ; OffsetY[ 0 ] = 2.00 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = 0.00 ; OffsetY[ 1 ] = 1.00 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = -1.40 ; OffsetY[ 2 ] = -1.50 ; OffsetW[ 2 ] = 1.60 ; OffsetH[ 2 ] = 1.60 ;
                    OffsetX[ 3 ] = 0.20 ; OffsetY[ 3 ] = -1.70 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = -0.50 ; OffsetY[ 4 ] = -1.80 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 3:
                    OffsetX[ 0 ] = -0.20 ; OffsetY[ 0 ] = 1.60 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = -0.40 ; OffsetY[ 1 ] = -1.80 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = 0.00 ; OffsetY[ 2 ] =2.00 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = -1.40 ; OffsetY[ 3 ] = -0.20 ; OffsetW[ 3 ] = 1.60 ; OffsetH[ 3 ] = 1.0 ;
                    OffsetX[ 4 ] = -1.60 ; OffsetY[ 4 ] = 0.04 ; OffsetW[ 4 ] = -0.20 ; OffsetH[ 4 ] = -0.60 ;
                    break;
                case 4:
                    OffsetX[ 0 ] = -1.00 ; OffsetY[ 0 ] = 0.00 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = 0.00 ; OffsetY[ 1 ] = 1.60 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = 0.50 ; OffsetY[ 2 ] = 1.60 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = 1.00 ; OffsetY[ 3 ] = 0.50 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = -0.80 ; OffsetY[ 4 ] = -0.20 ; OffsetW[ 4 ] = 1.60 ; OffsetH[ 4 ] = 1.30 ;
                    break;
            }
        }
        else if( Level.InitialCartoonEffect == 4 )
        {
            // --- ----- ------- ----- ---
            // |  ||    ||      ||    ||  |
            // |  ||    ||      ||    ||  |
            // | 0|| 1  ||  2   || 3  || 4|
            // |  ||    ||      ||    ||  |
            // |  ||    ||      ||    ||  |
            // |  ||    ||      ||    ||  |
            // --- ----- ------- ----- ---

            switch( RealTimeWndId )
            {
                case 0:
                    OffsetX[ 0 ] = -0.1 ; OffsetY[ 0 ] = -0.10 ; OffsetW[ 0 ] = 1.70 ; OffsetH[ 0 ] = 0.20 ;
                    OffsetX[ 1 ] = 0.00 ; OffsetY[ 1 ] = 1.00 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = 0.00 ; OffsetY[ 2 ] = -1.00 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = 0.00 ; OffsetY[ 3 ] = 1.00 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 0.00 ; OffsetY[ 4 ] = -1.00 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 1:
                    OffsetX[ 0 ] = -0.60 ; OffsetY[ 0 ] = 0.00 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = -0.50 ; OffsetY[ 1 ] = -0.1 ; OffsetW[ 1 ] = 1.70 ; OffsetH[ 1 ] = 0.2 ;
                    OffsetX[ 2 ] = 1.10 ; OffsetY[ 2 ] = 0.00 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = 0.00 ;
                    OffsetX[ 3 ] = 0.00 ; OffsetY[ 3 ] = 1.30 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 0.00 ; OffsetY[ 4 ] = -1.80 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 2:
                    OffsetX[ 0 ] = -0.50 ; OffsetY[ 0 ] = 0.00 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = 0.80 ; OffsetY[ 1 ] =  1.20 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = -0.80 ; OffsetY[ 2 ] = -0.10 ; OffsetW[ 2 ] = 1.80 ; OffsetH[ 2 ] = 0.70 ;
                    OffsetX[ 3 ] = -0.80 ; OffsetY[ 3 ] = -1.20 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = 0.00 ;
                    OffsetX[ 4 ] = 0.50 ; OffsetY[ 4 ] = 0.00 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 3:
                    OffsetX[ 0 ] = -0.20 ; OffsetY[ 0 ] = 1.60 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = 0.00 ;
                    OffsetX[ 1 ] = -0.40 ; OffsetY[ 1 ] = -1.80 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = 0.00 ;
                    OffsetX[ 2 ] = -0.80 ; OffsetY[ 2 ] = 0.20 ; OffsetW[ 2 ] = -0.40 ; OffsetH[ 2 ] = -0.40 ;
                    OffsetX[ 3 ] = -1.20 ; OffsetY[ 3 ] = -0.10 ; OffsetW[ 3 ] = 1.70 ; OffsetH[ 3 ] = 0.2 ;
                    OffsetX[ 4 ] = 0.60 ; OffsetY[ 4 ] = 0.00 ; OffsetW[ 4 ] = 0.00 ; OffsetH[ 4 ] = 0.00 ;
                    break;
                case 4:
                    OffsetX[ 0 ] = 0.00 ; OffsetY[ 0 ] = 0.60 ; OffsetW[ 0 ] = 0.00 ; OffsetH[ 0 ] = -1.20 ;
                    OffsetX[ 1 ] = 0.00 ; OffsetY[ 1 ] = 0.80 ; OffsetW[ 1 ] = 0.00 ; OffsetH[ 1 ] = -1.60 ;
                    OffsetX[ 2 ] = 0.00 ; OffsetY[ 2 ] = 1.00 ; OffsetW[ 2 ] = 0.00 ; OffsetH[ 2 ] = -2.00 ;
                    OffsetX[ 3 ] = 0.00 ; OffsetY[ 3 ] = 1.20 ; OffsetW[ 3 ] = 0.00 ; OffsetH[ 3 ] = -2.40 ;
                    OffsetX[ 4 ] = -1.30 ; OffsetY[ 4 ] = -0.10 ; OffsetW[ 4 ] = 1.50 ; OffsetH[ 4 ] = 0.20 ;
                    break;
            }
        }

        For( Loop=0;Loop<5;Loop++)
        {
            OffsetX[ Loop ] *= SpeedFactor;
            OffsetY[ Loop ] *= SpeedFactor;
            OffsetW[ Loop ] *= SpeedFactor;
            OffsetH[ Loop ] *= SpeedFactor;
        }
    }

    Width = C.ClipX;
    Height = C.ClipY;

    dX = 8;
    dY = 8;
    Border = 3;


    // ScreenShot

    if( CanDisplay )
        if( HudCartoonWnd == none )
        {
            HudCartoonWnd = spawn(class'CWndFullScreen');
            HudCartoonWnd.MyHudForFX = self;
        }

    if( ! HudCartoonInit )
    {
         PawnOwner.PlayMenu( hIntroBeginMap );
         HudCartoonInit = true;
         HudCartoonWndID = Level.InitialCartoonEffect;

        if( Level.InitialCartoonEffect == 1 )
        {
            // -------- ---- ----
            // |      | |   || 4 |
            // |   0  | | 2 |----
            // |      | |   |----
            // -------- ---- | 3 |
            // ------------- |   |
            // |     1      ||   |
            // ------------- ----

            X[ 0 ] = Width * 0.08; Y[ 0 ] = Height * 0.08; W[ 0 ] = Width * 0.40; H[ 0 ] = Height * 0.52;
            X[ 1 ] = Width * 0.08; Y[ 1 ] = Height * 0.66; W[ 1 ] = Width * 0.62; H[ 1 ] = Height * 0.26;
            X[ 2 ] = Width * 0.52; Y[ 2 ] = Height * 0.08; W[ 2 ] = Width * 0.18; H[ 2 ] = Height * 0.52;
            X[ 3 ] = Width * 0.74; Y[ 3 ] = Height * 0.38; W[ 3 ] = Width * 0.18; H[ 3 ] = Height * 0.54;
            X[ 4 ] = Width * 0.74; Y[ 4 ] = Height * 0.08; W[ 4 ] = Width * 0.18; H[ 4 ] = Height * 0.24;
        }
        else if( Level.InitialCartoonEffect == 2 )
        {
            // ------------- ----
            // |      0     ||   |
            // ------------- |   |
            // -------- ---- | 4 |
            // |       || 2 ||   |
            // |   1   |---- ----
            // |       |---------
            // |       ||    3   |
            // -------- ---------

            X[ 0 ] = Width * 0.08; Y[ 0 ] = Height * 0.08; W[ 0 ] = Width * 0.60; H[ 0 ] = Height * 0.21;
            X[ 1 ] = Width * 0.08; Y[ 1 ] = Height * 0.35; W[ 1 ] = Width * 0.33; H[ 1 ] = Height * 0.57;
            X[ 2 ] = Width * 0.45; Y[ 2 ] = Height * 0.35; W[ 2 ] = Width * 0.23; H[ 2 ] = Height * 0.29;
            X[ 3 ] = Width * 0.45; Y[ 3 ] = Height * 0.70; W[ 3 ] = Width * 0.47; H[ 3 ] = Height * 0.22;
            X[ 4 ] = Width * 0.72; Y[ 4 ] = Height * 0.08; W[ 4 ] = Width * 0.20; H[ 4 ] = Height * 0.56;
        }
        else if( Level.InitialCartoonEffect == 3 )
        {
            // ---- -------- ----
            // |   ||       ||   |
            // |   ||       ||   |
            // |   ||    4  || 3 |
            // | 0 ||       ||   |
            // |   | ------- ----
            // |   | --- --------
            // |   || 1 || 2     |
            // ----  --- --------

            X[ 0 ] = Width * 0.08; Y[ 0 ] = Height * 0.08; W[ 0 ] = Width * 0.12; H[ 0 ] = Height * 0.84;
            X[ 1 ] = Width * 0.24; Y[ 1 ] = Height * 0.76; W[ 1 ] = Width * 0.12; H[ 1 ] = Height * 0.16;
            X[ 2 ] = Width * 0.40; Y[ 2 ] = Height * 0.76; W[ 2 ] = Width * 0.52; H[ 2 ] = Height * 0.16;
            X[ 3 ] = Width * 0.80; Y[ 3 ] = Height * 0.08; W[ 3 ] = Width * 0.12; H[ 3 ] = Height * 0.62;
            X[ 4 ] = Width * 0.24; Y[ 4 ] = Height * 0.08; W[ 4 ] = Width * 0.52; H[ 4 ] = Height * 0.62;
        }
        else if( Level.InitialCartoonEffect == 4 )
        {
            // --- ----- ------- ----- ---
            // |  ||    ||      ||    ||  |
            // |  ||    ||      ||    ||  |
            // | 0|| 1  ||  2   || 3  || 4|
            // |  ||    ||      ||    ||  |
            // |  ||    ||      ||    ||  |
            // |  ||    ||      ||    ||  |
            // --- ----- ------- ----- ---

            X[ 0 ] = Width * 0.08; Y[ 0 ] = Height * 0.08; W[ 0 ] = Width * 0.08; H[ 0 ] = Height * 0.84;
            X[ 1 ] = Width * 0.20; Y[ 1 ] = Height * 0.08; W[ 1 ] = Width * 0.12; H[ 1 ] = Height * 0.84;
            X[ 2 ] = Width * 0.36; Y[ 2 ] = Height * 0.08; W[ 2 ] = Width * 0.28; H[ 2 ] = Height * 0.84;
            X[ 3 ] = Width * 0.68; Y[ 3 ] = Height * 0.08; W[ 3 ] = Width * 0.12; H[ 3 ] = Height * 0.84;
            X[ 4 ] = Width * 0.84; Y[ 4 ] = Height * 0.08; W[ 4 ] = Width * 0.08; H[ 4 ] = Height * 0.84;
        }

        For( Loop=0;Loop<5;Loop++)
        {
            InitX[ Loop ] = X[ Loop ];
            InitY[ Loop ] = Y[ Loop ];
            InitW[ Loop ] = W[ Loop ];
            InitH[ Loop ] = H[ Loop ];
        }
    }
    else
    {
        if( HideCartoonHud )
        {
            For( Loop=0;Loop<5;Loop++)
            {
                X[ Loop ] += OffsetX[ Loop ]*dT*30*2;
                Y[ Loop ] += OffsetY[ Loop ]*dT*30*2;
                W[ Loop ] += OffsetW[ Loop ]*dT*30*2;
                H[ Loop ] += OffsetH[ Loop ]*dT*30*2;

                if( W[ Loop ] < 0.0 )
                    W[ Loop ] = 0.0;

                if( H[ Loop ] < 0.0 )
                    W[ Loop ] = 0.0;
            }

            if( X[ RealTimeWndId ] <= 0 )
            {
                X[ RealTimeWndId ] = 0.0;
                OffsetW[ RealTimeWndId ] += OffsetX[ RealTimeWndId ];
                OffsetX[ RealTimeWndId ] = 0.0;
            }

            if( Y[ RealTimeWndId ] <= 0 )
            {
                Y[ RealTimeWndId ] = 0.0;
                OffsetH[ RealTimeWndId ] += OffsetY[ RealTimeWndId ];
                OffsetY[ RealTimeWndId ] = 0.0;
            }

            if( W[ RealTimeWndId ] > Width )
            {
                W[ RealTimeWndId ]= Width;
                OffsetW[ RealTimeWndId ]= 0.0;
            }

            if( H[ RealTimeWndId ] > Height )
            {
                H[ RealTimeWndId ]= Height;
                OffsetH[ RealTimeWndId ]= 0.0;
            }
        }
    }

    // Add Cartoon Window

    C.Style = ERenderStyle.STY_Alpha;
    C.bUseBorder = false;

    C.DrawColor = BlackColor;

    C.SetPos(0,0);
    C.DrawTile(WhiteTex, X[RealTimeWndId],Height, 0, 0, WhiteTex.USize, WhiteTex.VSize);

    C.SetPos(X[RealTimeWndId],0);
    C.DrawTile(WhiteTex, Width-X[RealTimeWndId],Y[RealTimeWndId], 0, 0, WhiteTex.USize, WhiteTex.VSize);

    C.SetPos(X[RealTimeWndId]+W[RealTimeWndId],0);
    C.DrawTile(WhiteTex, Width-X[RealTimeWndId]-W[RealTimeWndId],Height, 0, 0, WhiteTex.USize, WhiteTex.VSize);

    C.SetPos(X[RealTimeWndId],Y[RealTimeWndId]+H[RealTimeWndId]);
    C.DrawTile(WhiteTex, W[RealTimeWndId],Height-Y[RealTimeWndId]-H[RealTimeWndId], 0, 0, WhiteTex.USize, WhiteTex.VSize);

    // ScreenShot Display

    C.DrawColor = WhiteColor;
    C.BorderColor = BlackColor;
    C.bUseBorder = true;

    for( Loop=0; Loop<5;Loop++)
    {
        if( RealTimeWndId != Loop )
        {
            if( ( W[Loop]!=0 ) && ( H[Loop]!=0 ) )
            {
                C.bUseBorder = false;
                C.DrawColor = WhiteColor;
                C.SetPos(X[Loop]-Width*0.01,Y[Loop]-Height*0.015);
                C.DrawTile(WhiteTex, W[Loop]+Width*0.02,H[Loop]+Height*0.03, 0, 0, WhiteTex.USize, WhiteTex.VSize);

                C.bUseBorder = true;

                C.SetPos(X[Loop],Y[Loop]);

                XF = InitX[Loop];
                XF = XF/Width*256;
                YF = InitY[Loop];
                YF = YF/Height*192+32; // convert from 1/1 to 4/3

                WF = W[Loop];
                WF = WF/Width*256;
                HF = H[Loop];
                HF = HF/Height*192; // convert from 1/1 to 4/3

                if( !HudCartoonWnd.WndIsUpdate )
                {
                    C.DrawColor = GrayColor;
                    C.DrawTile(WhiteTex, W[Loop] ,H[Loop], XF, YF, WF, HF);
                }
                else
                {
                    if( CanDisplay )
                        C.DrawTile(CWndMat, W[Loop] ,H[Loop], XF, YF, WF, HF);
                    else
                        C.DrawTile(WhiteTex, W[Loop] ,H[Loop], XF, YF, WF, HF);
                }
            }
        }
        else
        {
            C.bUseBorder = false;
            C.DrawColor = WhiteColor;

            C.SetPos(X[Loop]-Width*0.01,Y[Loop]-Height*0.015);
            C.DrawTile(WhiteTex, W[Loop]+Width*0.02,Height*0.015, 0, 0, WhiteTex.USize, WhiteTex.VSize);

            C.SetPos(X[Loop]-Width*0.01,Y[Loop]+H[Loop]);
            C.DrawTile(WhiteTex, W[Loop]+Width*0.02,Height*0.015, 0, 0, WhiteTex.USize, WhiteTex.VSize);

            C.SetPos(X[Loop]-Width*0.01,Y[Loop]-Height*0.015);
            C.DrawTile(WhiteTex, Width*0.01,H[Loop]+Height*0.03, 0, 0, WhiteTex.USize, WhiteTex.VSize);

            C.SetPos(X[Loop]+W[Loop],Y[Loop]-Height*0.015);
            C.DrawTile(WhiteTex, Width*0.01,H[Loop]+Height*0.03, 0, 0, WhiteTex.USize, WhiteTex.VSize);

            C.bUseBorder = true;
            C.DrawColor = BlackColor;
            C.SetPos(X[Loop],Y[Loop]);
            C.DrawColor.A = 0;
            C.DrawTile(WhiteTex, W[Loop],H[Loop], 0, 0, WhiteTex.USize, WhiteTex.VSize);
            C.DrawColor.A = 255;
        }
    }

    C.bUseBorder = false;

    if( ( W[RealTimeWndId]==Width ) && ( H[RealTimeWndId]==Height ) )
        if( ( X[RealTimeWndId]<=0 ) && ( Y[RealTimeWndId]<=0 ) )
        {
            HudCartoonSFX = false;
            Level.InitialCartoonEffect = 0;
            XIIIGameInfo(Level.Game).MapInfo.EndCartoonEffect = true;
            TriggerEvent( 'EndCartoonEffect', self, none);
        }
}

//____________________________________________________________________
// ELR End Game Display = GAME OVER !!
function EndGameDisplay( canvas C )
{
    if ( HudMsg != none )
    {
      C.SpaceX = 0;
      UseMsgFont(C);
      C.Style = ERenderStyle.STY_Alpha;
      HudMSG.DrawMsg(C);
    }
}

//____________________________________________________________________
function PlayerNameDisplay(Canvas C);

//____________________________________________________________________
function DoorTimerDisplay(Canvas C)
{
    local float XL,YL,X;
    local XIIIPorte Obj;
    local int iSec, iMilliSec;
    local string sTimerString;

    // Already checked != none in DoorDisplay
    Obj = XIIIPlayerController(PawnOwner.Controller).aDoor;
    if ( Obj.fUnlocktimer > 0 )
    {
      iSec = int(Obj.fUnlocktimer);
      iMilliSec = int( (Obj.fUnlocktimer - iSec)*100 );
      if ( Len(string(iMilliSec)) <= 1 )
      {
        if (iMilliSec < 10)
          sTimerString = iSec$":"$iMilliSec$"0"@sTimeLeft;
        else
          sTimerString = iSec$":0"$iMilliSec@sTimeLeft;
      }
      else
        sTimerString = iSec$":"$iMilliSec@sTimeLeft;

      UseLargeFont(C);
      C.SpaceX=0;
      C.StrLen(" 3:00"@sTimeLeft$" ", X, YL);
      X += 5;
      C.StrLen(sTimerString, XL, YL);
      C.Style = ERenderStyle.STY_Alpha;
      C.BorderColor = WhiteColor;
      C.BorderColor.A = 128;

      C.SetPos(C.ClipX/2.0 - X/2.0 - 2,C.ClipY/2.0 - 66);

      C.DrawColor = WhiteColor * 0.5;
      C.DrawColor.A = 128;
      C.bUseBorder = true;
      C.DrawTile(FondMSG, X+4, YL+4, 0, 0, FondMSG.USize, FondMSG.VSize);
      C.bUseBorder = false;

      C.DrawColor = WhiteColor;
      C.SetPos(C.ClipX/2.0-XL/2.0,C.ClipY/2.0 - 64);
      C.DrawText(sTimerString);
      C.SpaceX=0;
    }
}

//____________________________________________________________________
function DamageWarnDisplay(Canvas C)
{
    local int i;
    local float fSize, fTransp;
    local int DamageWarnType;
    local float ft;

    DamageWarnType = 1;

    bDrawDamageWarn = false;
    C.Style=ERenderStyle.STY_Translucent;
    // 0 = Front
    // 1 = Right
    // 2 = Left
    // 3 = back

    if ( DamageWarnType == 1 )
      fSize = 2.0; // *fDrawScale; // Test w/out drawscale for more splitt screen feedback
    else
      fSize = 2.5; // *fDrawScale;
    fTransp = fTranspWarningDamage*DamageWarnType;

    XP = 0.5*C.ClipX;
    YP = 0.5*C.ClipY;
    switch(DamageWarnType)
    {
    Case 1:
      if ( fDrawDamageWarnTimer[0] > 0.0 )
      { // Front
        C.DrawColor = RedColor*fTransp*fDrawDamageWarnTimer[0];
//        C.SetPos( XP - DamageWarnTexFront.Usize/2.0*fSize*4.0 , YP - 64 - DamageWarnTexFront.VSize*fSize );
        C.SetPos( XP - DamageWarnTexFront.Usize/2.0*fSize*4.0 , C.ClipY*UpMargin + 32 );
        C.DrawRect(DamageWarnTexFront, DamageWarnTexFront.USize*fSize*4.0, DamageWarnTexFront.USize*fSize*2.0);
        fDrawDamageWarnTimer[0] -= 0.05;
      }
      if ( fDrawDamageWarnTimer[1] > 0.0 )
      { // Right
        C.DrawColor = RedColor*fTransp*fDrawDamageWarnTimer[1];
//        C.SetPos( XP + 64, YP - DamageWarnTexLeft.VSize/2.0*fSize*4.0);
        C.SetPos( C.ClipX*(1.0-RightMargin) - 32 - DamageWarnTexLeft.USize*fSize*2.0, YP - DamageWarnTexLeft.VSize/2.0*fSize*4.0);
        C.DrawTile(DamageWarnTexLeft, DamageWarnTexLeft.USize*fSize*2.0, DamageWarnTexLeft.VSize*fSize*4.0, 0, 0, -DamageWarnTexLeft.USize, DamageWarnTexLeft.VSize);
        fDrawDamageWarnTimer[1] -= 0.05;
      }
      if ( fDrawDamageWarnTimer[2] > 0.0 )
      { // Left
        C.DrawColor = RedColor*fTransp*fDrawDamageWarnTimer[2];
//        C.SetPos( XP - DamageWarnTexLeft.Usize*fSize - 64, YP - DamageWarnTexLeft.VSize/2.0*fSize*4.0);
        C.SetPos( C.ClipX*LeftMargin + 32, YP - DamageWarnTexLeft.VSize/2.0*fSize*4.0);
        C.DrawRect(DamageWarnTexLeft, DamageWarnTexFront.USize*fSize*2.0, DamageWarnTexFront.USize*fSize*4.0);
        fDrawDamageWarnTimer[2] -= 0.05;
      }
      if ( fDrawDamageWarnTimer[3] > 0.0 )
      { // Back
        C.DrawColor = RedColor*fTransp*fDrawDamageWarnTimer[3];
//        C.SetPos( XP - DamageWarnTexBack.Usize/2.0*fSize*4.0, YP + 64 );
        C.SetPos( XP - DamageWarnTexBack.Usize/2.0*fSize*4.0, C.ClipY*(1.0-DownMargin) - 32 - DamageWarnTexFront.USize*fSize*2.0);
        C.DrawRect(DamageWarnTexBack, DamageWarnTexFront.USize*fSize*4.0, DamageWarnTexFront.USize*fSize*2.0);
        fDrawDamageWarnTimer[3] -= 0.05;
      }
      break;
    Case 2:
      if ( fDrawDamageWarnTimer[0] > 0.0 )
      { // front
        if ( vDrawDamageWarnLoc[0] == vect(0,0,0) )
        {
          fT = fRand()*0.5;
          vDrawDamageWarnLoc[0].Y = fT*(C.ClipY);
          vDrawDamageWarnLoc[0].X = C.ClipX*0.5 + (0.5-fT)*C.ClipX*(fRand()-0.5);
        }
        C.DrawColor = RedColor*fTransp*fDrawDamageWarnTimer[0];
        C.SetPos( vDrawDamageWarnLoc[0].x - DamageWarnTex.Usize*fSize/2.0, vDrawDamageWarnLoc[0].y - DamageWarnTex.Vsize*fSize/2.0 );
        C.DrawIcon(DamageWarnTex, fSize);
        fDrawDamageWarnTimer[0] -= 0.05;
      }
      if ( fDrawDamageWarnTimer[1] > 0.0 )
      { // right
        if ( vDrawDamageWarnLoc[1] == vect(0,0,0) )
        {
          vDrawDamageWarnLoc[1].X = 0.5 * fRand() * (C.ClipX*0.5) - DamageWarnTex.USize*fSize/2.0 + (C.ClipX*0.5);
          vDrawDamageWarnLoc[1].Y = 0.5*C.ClipX - DamageWarnTexFront.Usize*fSize/2.0;
        }
        C.DrawColor = RedColor*fTransp*fDrawDamageWarnTimer[1];
        C.SetPos( vDrawDamageWarnLoc[1].x, vDrawDamageWarnLoc[1].y );
        C.DrawIcon(DamageWarnTex, fSize);
        fDrawDamageWarnTimer[1] -= 0.05;
      }
      if ( fDrawDamageWarnTimer[2] > 0.0 )
      { // left
        if ( vDrawDamageWarnLoc[2] == vect(0,0,0) )
        {
          vDrawDamageWarnLoc[2].X = 0.5 * fRand() * (C.ClipX*0.5) - DamageWarnTex.USize*fSize/2.0;
          vDrawDamageWarnLoc[2].Y = 0.5*C.ClipX - DamageWarnTexFront.Usize*fSize/2.0;
        }
        C.DrawColor = RedColor*fTransp*fDrawDamageWarnTimer[2];
        C.SetPos( vDrawDamageWarnLoc[2].x, vDrawDamageWarnLoc[2].y );
        C.DrawIcon(DamageWarnTex, fSize);
        fDrawDamageWarnTimer[2] -= 0.05;
      }
      if ( fDrawDamageWarnTimer[3] > 0.0 )
      { // back
        if ( vDrawDamageWarnLoc[3] == vect(0,0,0) )
        {
          vDrawDamageWarnLoc[3].X = 0.5*C.ClipX - DamageWarnTexFront.Usize*fSize/2.0;
          vDrawDamageWarnLoc[3].Y = 0.5 * fRand() * (C.ClipY*0.5) - DamageWarnTex.Vsize*fSize/2.0 + (C.ClipY*0.5);
        }
        C.DrawColor = RedColor*fTransp*fDrawDamageWarnTimer[3];
        C.SetPos( vDrawDamageWarnLoc[3].x, vDrawDamageWarnLoc[3].y );
        C.DrawIcon(DamageWarnTex, fSize);
        fDrawDamageWarnTimer[3] -= 0.05;
      }
      break;
    }

    for (i=0; i<4; i++)
    {
      if ( fDrawDamageWarnTimer[i] > 0.0 )
        bDrawDamageWarn = true;
      else
        vDrawDamageWarnLoc[i] = vect(0,0,0);
    }
}


//____________________________________________________________________
// Cadre de Securite
//____________________________________________________________________

function DrawSafeArea( Canvas C )
{
    C.Style = ERenderStyle.STY_Alpha;
    C.DrawColor = GoldColor;
    C.BorderColor = GoldColor;
    C.DrawColor.A = 0;
    C.BorderColor.A = 255;
    C.bUseBorder = true;

    C.SetPos(C.ClipX*LeftMargin,C.ClipY*UpMargin);
    C.DrawTile(FondMsg, C.ClipX*(1-LeftMargin-RightMargin),C.ClipY*(1-UpMargin-DownMargin), 0, 0, FondMsg.USize, FondMsg.VSize);
    C.bUseBorder = false;
}

//____________________________________________________________________
function XIIIDrawAmmo(canvas C)
{
    local string ItemText;
    local float H , BackGroundSize, ColorFact;
    local int bDrawbulletIcon;

    // Retrieve Text
    ItemText = PawnOwner.Weapon.GetAmmoText(bDrawbulletIcon);
    UseHugeFont(C);

    if( bDrawbulletIcon == 1 )
    {
      if ( !PawnOwner.Weapon.HasAmmo() && !PawnOwner.Weapon.HasAltAmmo() && !(PawnOwner.Weapon.bHaveSlave && PawnOwner.Weapon.MySlave.ReloadCount > 0) )
      {
        ColorFact = Level.TimeSeconds*1.5 - int(Level.TimeSeconds*1.5);
        C.DrawColor = HudWarningColor * ColorFact;
      }
      else
        C.DrawColor = HudBasicColor;
      DrawAmmo(C, ItemText);
    }
}

//____________________________________________________________________
function DrawItemsIconsList(canvas C)
{
    local string ItemText;
    local float L2, H2;
    local int Loop, NbWeapon, MaxWeaponIndex, Ammo;
    local float WeaponPos;
    local PowerUps W,TW[22];
    local inventory I;
    local int XCoords, YCoords;

    NbWeapon = 0;
    I = PawnOwner.Inventory;
    while ( I != none )
    { // add items in array TW
      W = PowerUps(I);
      if ( ( W != none ) && (XIIIItems(I) != none) && I.bDisplayableInv )
      {
        TW[W.InventoryGroup] = W;
        MaxWeaponIndex = Max(MaxWeaponIndex, W.InventoryGroup);
        NbWeapon++;
      }
      I = I.Inventory;
    }

    // global pre drax init
    YP = C.ClipY * ( 1 - downMargin );
    YP -= LifeDisplayHeight;
    WeaponPos = C.ClipX * ( 1 - RightMargin ) - (NbWeapon)*(2*LifeDisplayHeight+4) - LifeDisplayHeight;
    ItemText = Left("------", Ammo);
    C.StrLen(ItemText, L2, H2);
    C.bUseBorder = false;
    C.Style = ERenderStyle.STY_Alpha;

    for( Loop=0; Loop<MaxWeaponIndex+1; Loop++)
    {
      W = TW[Loop];

      if ( W != none )
      {
        if ( (XIIIItems(W).IHand == IH_2H) && PawnOwner.bHaveOnlyOneHandFree )
          C.DrawColor = OrangeColor;
        else
          C.DrawColor = HudBasicColor*0.1;

        if ( W == DrawnItem )
          C.DrawColor.A= 140 ;
        else
          C.DrawColor.A= 70 ;

        C.SetPos( WeaponPos,YP);
        C.DrawTile(FondMsg, 2*LifeDisplayHeight,LifeDisplayHeight, 0, 0, FondMsg.USize, FondMsg.VSize);

        C.DrawColor= WhiteColor;

        if ( W == DrawnItem )
        {
          C.bUseBorder = true;
          C.BorderColor= HudBasicColor;
          C.BorderColor.A= 255 ;
        }

        C.SetPos(WeaponPos,YP);
//        C.DrawTile(W.Icon, 2*LifeDisplayHeight,LifeDisplayHeight, 0, 0, W.Icon.USize, W.Icon.VSize);
    		YCoords = XIIIItems(W).IconNumber / 4;
    		XCoords = XIIIItems(W).IconNumber - YCoords * 4;
        C.DrawTile(HudWIcons, 2*LifeDisplayHeight, LifeDisplayHeight, 64*XCoords, 32*YCoords, 64, 32);
        C.bUseBorder = false;

        // affichage du nombre d'item
        C.DrawColor= HudBasicColor;
        if ( W == DrawnItem )
          C.DrawColor.A = 255;
        else
          C.DrawColor.A = 150;

        Ammo = W.Charge;
        if( Ammo > 0 )
        {
          if( Ammo > 6 )
            Ammo = 6 ;
          ItemText = Left(sAmmoRef, Ammo);
          C.SetPos( WeaponPos,YP-LifeDisplayHeight/2-6 );
          C.DrawText(ItemText, false);
        }
        WeaponPos += 2*LifeDisplayHeight + 4;
      }
    }

    C.DrawColor = HudBasicColor*0.1;
    C.DrawColor.A= 70 ;
    C.bUseBorder = false;

    C.SetPos( WeaponPos,YP);
// HudWIcons coords 128+64(L=32) x 256-32(L=32)
//    C.DrawTile(RoundBackGroundTex, LifeDisplayHeight,LifeDisplayHeight, 32, 0, -RoundBackGroundTex.USize, RoundBackGroundTex.VSize);
    C.DrawTile(HudWIcons, LifeDisplayHeight,LifeDisplayHeight, 128+64+32, 256-32, -32, 32);

    WeaponPos= C.ClipX * ( 1 - RightMargin ) - (NbWeapon)*(2*LifeDisplayHeight+4) - LifeDisplayHeight - LifeDisplayHeight - 4;

    C.SetPos( WeaponPos,C.CurY);
//    C.DrawTile(RoundBackGroundTex, LifeDisplayHeight,LifeDisplayHeight, 0, 0, RoundBackGroundTex.USize, RoundBackGroundTex.VSize);
    C.DrawTile(HudWIcons, LifeDisplayHeight,LifeDisplayHeight, 128+64, 256-32, 32, 32);
}

//____________________________________________________________________
//
function DrawCurrentItem(canvas C)
{
    local string ItemText;
    local float H , BackGroundSize;
    local int bDrawbulletIcon;

    // Text
    UseHugeFont(C);
    C.SpaceX = 1;
    if ( (XIIIItems(PawnOwner.SelectedItem) != none) && (XIIIItems(PawnOwner.SelectedItem).bNumberedItem) )
    {
      ItemText = string(PawnOwner.SelectedItem.Charge);
      ItemText = "x"$ItemText;
    }
    else
      ItemText = PawnOwner.SelectedItem.ItemName;
//    ItemText = Lowcaps(ItemText);
    C.StrLen(ItemText, BackGroundSize, H);

    YP -= LifeDisplayHeight;

    // BackGround
    C.Style = ERenderStyle.STY_Alpha;
    C.DrawColor = HudBasicColor*0.1;
    C.DrawColor.A = 90;
    C.SetPos(XP-2*(LifeDisplayHeight-4)-(BackGroundSize+8),YP+4);
    DrawStdBackground(C, LifeDisplayHeight-4, BackGroundSize+8);

    C.bTextShadow = true;
    // Text
    C.DrawColor = HudBasicColor;
    C.SetPos(XP-(LifeDisplayHeight-4)-(BackGroundSize+8)+4,YP+2);
    C.DrawText(ItemText, false);
}

//____________________________________________________________________
function NotifyNewWeapon(Class<Weapon> WClass)
{
  local class<Pickup> PickClass;

  PickClass = class<Pickup>(DynamicLoadObject(WClass.default.PickupClassName, class'Class'));

//  Log("NotifyNewWeapon"@WClass@"PickupClass="$PickClass);
//  NewWeaponIndex = WClass.Default.InventoryGroup;
//  fDrawNewWeaponTimer = default.fDrawNewWeaponTimer;

  if ( HudMsg == none )
  {
    HudMsg = Spawn(class'HudMessage',self);
    HudMsg.SetUpLocalizedMessage( class'XIIILocalMessage', WClass.Default.InventoryGroup, none, none, PickClass, "" );
  }
  else
  {
    HudMsg.AddLocalizedMessage( class'XIIILocalMessage', WClass.Default.InventoryGroup, none, none, PickClass, "" );
  }
}

//____________________________________________________________________
Simulated function AddHudEndMessage(
  class<LocalMessage> Message,
  optional int Switch,
  optional PlayerReplicationInfo RelatedPRI_1,
  optional PlayerReplicationInfo RelatedPRI_2,
  optional Object OptionalObject,
  optional string CriticalString
  )
{
  if ( HudEndMsg == none )
  {
    HudEndMsg = Spawn(class'HudEndMessage',self);
    HudEndMsg.SetUpLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
  }
  else
  {
    HudEndMsg.AddLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
  }
}

//____________________________________________________________________
simulated function AddHudObjMessage(
  class<LocalMessage> Message,
  optional int Switch,
  optional PlayerReplicationInfo RelatedPRI_1,
  optional PlayerReplicationInfo RelatedPRI_2,
  optional Object OptionalObject,
  optional string CriticalString
  )
{
//  Log("AddHudObjMessage");
  if ( HudObjMsg == none )
  {
    HudObjMsg = Spawn(class'HudObjectifMessage',self);
    HudObjMsg.SetUpLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
  }
  else
  {
    HudObjMsg.AddLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
  }
}

//____________________________________________________________________
Simulated function AddHudMPMessage(
  class<LocalMessage> Message,
  optional int Switch,
  optional PlayerReplicationInfo RelatedPRI_1,
  optional PlayerReplicationInfo RelatedPRI_2,
  optional Object OptionalObject,
  optional string CriticalString
  )
{
  if ( HudMPMsg == none )
  {
    HudMPMsg = Spawn(class'HudMPMessage',self);
    HudMPMsg.SetUpLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
  }
  else
  {
    HudMPMsg.AddLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
  }
}

//____________________________________________________________________
Simulated function AddHudMessage(
  class<LocalMessage> Message,
  optional int Switch,
  optional PlayerReplicationInfo RelatedPRI_1,
  optional PlayerReplicationInfo RelatedPRI_2,
  optional Object OptionalObject,
  optional string CriticalString
  )
{
//  Log("AddHudMessage '"$CriticalString$"' HudMsg="$HudMsg);
  if ( HudMsg == none )
  {
    HudMsg = Spawn(class'HudMessage',self);
    HudMsg.SetUpLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
  }
  else
  {
    HudMsg.AddLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
  }
}

//____________________________________________________________________
Simulated function AddHudDialog(
  class<LocalMessage> Message,
  optional int Switch,
  optional PlayerReplicationInfo RelatedPRI_1,
  optional PlayerReplicationInfo RelatedPRI_2,
  optional Object OptionalObject,
  optional string CriticalString
  )
{
  if ( (HudDlg != none) && (Switch == 4) )
    return; // cancel adding, low priority on 4 type (message ~ can't hold more ammo)

  if ( HudDlg != none )
    HudDlg.Destroy();
  HudDlg = Spawn(class'HudDialog',self);
  HudDlg.SetUpLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
}

//____________________________________________________________________
Simulated function AddHudState(
  class<LocalMessage> Message,
  optional int Switch,
  optional PlayerReplicationInfo RelatedPRI_1,
  optional PlayerReplicationInfo RelatedPRI_2,
  optional Object OptionalObject,
  optional string CriticalString
  )
{
//  Log("HudState Message");
  if ( HudStt != none )
    HudStt.Destroy();
  HudStt = Spawn(class'HudState',self);
  HudStt.SetUpLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
}

//____________________________________________________________________
function AddHudCartoonWindow(float XPos, float YPos, float DXSize, float DYSize, BitMapMaterial Tex, float X, float Y, float XSize, float YSize, float Lifetime, color cBorder, int CWndAppearFX, bool bLowPrio)
{
  DebugLog("AddHudCartoonWindow High Priority="$!bLowPrio);
  if ( !bLowPrio )
    EraseLowPriorityCartoonWindows();

  if ( HudWnd == none )
  {
    HudWnd = Spawn(class'HudCartoonWindow',self);
    if( bLowPrio )
      HudWnd.SetUpCartoonWindow(XPos, YPos, DXSize, DYSize, Tex, X, Y, XSize, YSize, Lifetime, cBorder, CWndAppearFX, true);
    else
      HudWnd.SetUpCartoonWindow(XPos, YPos, DXSize, DYSize, Tex, X, Y, XSize, YSize, Lifetime, cBorder, CWndAppearFX, false);
  }
  else
  {
    if( bLowPrio )
      HudWnd.AddCartoonWindow(XPos, YPos, DXSize, DYSize, Tex, X, Y, XSize, YSize, Lifetime, cBorder, CWndAppearFX, true);
    else
      HudWnd.AddCartoonWindow(XPos, YPos, DXSize, DYSize, Tex, X, Y, XSize, YSize, Lifetime, cBorder, CWndAppearFX, false);
  }
}

//____________________________________________________________________
function AddHudCartoonFocus(actor Focus, int AppearFX, bool bUseVignette, float Duration, bool zoom, float zoomFOV, float zoomDist, bool bDanger)
{
  if ( HudFoc == none )
  {
    HudFoc = Spawn(class'HudCartoonFocus',self);
    HudFoc.SetUpCartoonFocus(Focus, AppearFX, bUseVignette, Duration, zoom, zoomFOV, zoomDist, bDanger);
  }
  else
  {
    HudFoc.AddCartoonFocus(Focus, AppearFX, bUseVignette, Duration, zoom, zoomFOV, zoomDist, bDanger);
  }
}

//____________________________________________________________________
function bool IsFocusing(Actor A)
{
  if ( HudFoc == none )
    return false;

  while ( HudFoc != none )
  {
    if ( HudFoc.MyFocus == A )
    {
      return true;
      break;
    }
    HudFoc = HudFoc.NextHudFoc;
  }
  return false;
}

/*
//____________________________________________________________________
function AddHudOnoOverLay(vector v3DLocation, float Size, BitMapMaterial Tex, color cColor, float Lifetime, int CWFX, float Delay)
{
  if ( !FastTrace( PawnOwner.Location + PawnOwner.EyePosition(), v3DLocation) )
    return;

  if ( HudOno == none )
  {
    HudOno = Spawn(class'HudOnomatop',self);
    HudOno.SetUpOnoOverLay(v3DLocation, Size, Tex, cColor, Lifetime, CWFX, Delay);
  }
  else
  {
    HudOno.AddOnoOverLay(v3DLocation, Size, Tex, cColor, Lifetime, CWFX, Delay);
  }
}
*/

//____________________________________________________________________
function EraseCartoonWindows()
{
    while ( HudWnd != none )
    {
      HudWnd.RemoveMe();
    }
}

//____________________________________________________________________
function EraseLowPriorityCartoonWindows()
{
  local HudCartoonWindow temp, temp2;

  DebugLog("BEGIN EraseLowPriorityCartoonWindows");

  temp = HudWnd;
  while ( temp != none )
  {
    DebugLog("  Erase ? "$Temp);

    if (temp.bLowPriority)
    {
      DebugLog("  Erasing "$Temp);
      temp2 = temp.NextHudWnd;
      temp.RemoveMe();
      temp = temp2;
    }
    else
      temp = temp.NextHudWnd;
  }
  DebugLog("END EraseLowPriorityCartoonWindows");
}

//____________________________________________________________________
simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name N )
{
//    Log("Message '"$Msg$"'");

    if ( Msg == "" )
      return;

    // ELR Add some text
    if ( (N == 'Say') || (N == 'TeamSay') )
      Msg = PRI.PlayerName$": "$Msg;

    if ( N == 'Death' )
      LocalizedMessage(class'XIIIEndGameMessage', 1, none, none, none, Msg);
    else if ( N == 'PlayerEnter' )
      LocalizedMessage(class'XIIIMultiMessage', -1, none, none, none, Msg@class'XIIIMultiMessage'.default.WelcomeMessage);
    else
      LocalizedMessage(class'XIIILocalMessage', 0, none, none, none, Msg);
}

//____________________________________________________________________
simulated function LocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString )
{
    if ( ( Message == class'XIIIEndGameMessage' ) || ( Message == class'XIIIMissionCompletedMessage' ) )
    {
      AddHudEndMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
      bHideHud = true;
    }
    else if ( Message == class'XIIIDialogMessage' )
      AddHudDialog( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
    else if ( Message == class'XIIISaveMessage' )
      AddHudState( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
    else if ( Message == class'XIIIGoalMessage' )
      AddHudObjMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
    else
      AddHudMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
}

//____________________________________________________________________
function AddDamageWarn(int RelativeHitLoc)
{
    bDrawDamageWarn = true;
//    bDrawDamageDir = true;

    // 0 = Front
    // 1 = Right
    // 2 = Left
    // 3 = back
//    log("receiving AddDamageWarn w/ RelativeHitLoc="$RelativeHitLoc);
    fDrawDamageWarnTimer[RelativeHitLoc] = 1.0;
//    fDrawDamageDirTimer[RelativeHitLoc] = 1.0;
    vDrawDamageWarnLoc[RelativeHitLoc] = vect(0,0,0);
}

//____________________________________________________________________
function ResetSixSenseSFX()
{
    local int i;

    for (i=0;i<5;i++)
      fDrawSixSenseTimer[i] = 0.0;
}

//____________________________________________________________________
function AddSixSenseFX(Vector V)
{
    local int i, iOldestTimer;
    local float fOldestTimer;

//    Log("AddSixSenseFX called");
    fOldestTimer = 99.0;
    iOldestTimer = -1;
    for (i=0;i<5;i++)
    {
      if ( fDrawSixSenseTimer[i] <= 0 )
      {
        vSixSensePos[i] = V;
        fDrawSixSenseTimer[i] = 1.0;
        return;
      }
      else
      {
        if ( fDrawSixSenseTimer[i] < fOldestTimer )
        {
          fOldestTimer = fDrawSixSenseTimer[i];
          iOldestTimer = i;
        }
      }
      // no slot found, erase the oldest timer
    }
    if ( iOldestTimer >= 0 )
    {
      vSixSensePos[iOldestTimer] = V;
      fDrawSixSenseTimer[iOldestTimer] = 1.0;
    }
}

//____________________________________________________________________
function AddChronoDisplay(string S, optional float Duration)
{
    bDrawChrono = true;
    if ( Duration > 0.0 )
      fDrawChronoTimer = Level.TimeSeconds+Duration;
    else
      fDrawChronoTimer = Level.TimeSeconds+1.0;
    sChronoString = S;
}

//____________________________________________________________________
// Font Selection.
function UseSmallFont(Canvas Canvas)
{
    Canvas.Font = SmallFont;
}

function UseNumericLargeFont(Canvas Canvas)
{
    Canvas.Font = Canvas.SmallFont;
}

function UseMediumFont(Canvas Canvas)
{
    if ( fDrawScale <= 0.5 )
      Canvas.Font = SmallFont;
    else if ( Canvas.ClipX <= 640 )
      Canvas.Font = MedFont;
    else
      Canvas.Font = BigFont;
}

function UseLargeFont(Canvas Canvas)
{
    if ( fDrawScale <= 0.5 )
      Canvas.Font = MedFont;
    else if ( Canvas.ClipX <= 640 )
      Canvas.Font = BigFont;
    else
      Canvas.Font = LargeFont;
}

function UseHugeFont(Canvas Canvas)
{
    if ( fDrawScale <= 0.5 )
      Canvas.Font = BigFont;
    else
      Canvas.Font = LargeFont;
}

function UseMsgFont(Canvas C)
{
    if ( fDrawScale <= 0.5 )
      C.Font = MedFont;
    else
      C.Font = BigFont;
}

function UseDialogFont(Canvas C)
{
      C.Font = BigFont;
}

function UseItemFont(Canvas C)
{
    if( C.ClipX <= 800 )
        C.Font = BigFont;
    else
        C.Font = LargeFont;
}

function UseHeadFont(Canvas C)
{
    if( C.ClipX <= 800 )
        C.Font = SmallFont;
    else
        C.Font = MedFont;
    C.Font = MedFont;
}



defaultproperties
{
     LeftMargin2=-1.000000
     RightMargin2=-1.000000
     UpMargin2=-1.000000
     downMargin2=-1.000000
     FondDlg=Texture'XIIIMenu.HUD.fondialog'
     FlechDlg=Texture'XIIIMenu.HUD.flechdialogA'
     DamageWarnTexFront=Texture'XIIIMenu.HUD.impactfront'
     DamageWarnTexBack=Texture'XIIIMenu.HUD.impactback'
     DamageWarnTexLeft=Texture'XIIIMenu.HUD.impactside'
     DamageWarnTex=Texture'XIIICine.effets.vignetteblood'
     fTranspWarningDamage=0.350000
     ViewPortId=-1
     WhiteTex=Texture'XIIIMenu.HUD.blanc'
     BlackTex=Texture'XIIIMenu.HUD.noir'
     HudCartoonOffset=-0.200000
     LastSwitchTime=-1
     CartoonWindowNumber=5
     switchDelay=1.500000
     SpeedFactor=8.000000
     hIntroBeginMap=Sound'XIIIsound.Interface__BeginMap.BeginMap__hBeginMap'
     hIntroBeginMapFocus=Sound'XIIIsound.Interface__BeginMap.BeginMap__hBeginMapFocus'
     hIntroBeginMapPlayerMove=Sound'XIIIsound.Interface__BeginMap.BeginMap__hBeginMapPlayerMove'
     sTimeLeft="left"
     SmallFont=Font'XIIIFonts.XIIISmallFont'
     MedFont=Font'XIIIFonts.XIIIConsoleFont'
     BigFont=Font'XIIIFonts.PoliceF16'
     LargeFont=Font'XIIIFonts.PoliceF20'
     RoundBackGroundTex=Texture'XIIIMenu.HUD.fondmsg2'
     FondMsg=Texture'XIIIMenu.HUD.FondMsg'
     OrangeColor=(G=180,R=220,A=255)
     BlackColor=(A=255)
     GoldColor=(G=255,R=255,A=255)
     RedColor=(R=255,A=255)
     BlueColor=(B=255,A=255)
     GreenColor=(G=255,A=255)
     TurqColor=(B=255,G=128,A=255)
     GrayColor=(B=200,G=200,R=200,A=255)
     CyanColor=(B=255,G=255,A=255)
     PurpleColor=(B=255,R=255,A=255)
     LightGreenColor=(B=140,G=255,R=140,A=255)
     LightBlueColor=(B=255,G=110,R=110,A=255)
     LightPurpleColor=(B=160,G=100,R=160,A=255)
     SixSenseTex=Texture'XIIIMenu.SFX.sonvisual'
     SixSenseDisplayTex=Texture'XIIIMenu.HUD.6sense'
     BulletIconTex=Texture'XIIIMenu.HUD.bullet_iconA'
     LeftMargin=0.070000
     RightMargin=0.070000
     UpMargin=0.070000
     DownMargin=0.070000
     HudIcons=Texture'XIIIMenu.HUD.HudIcons'
     HudWIcons=Texture'XIIIMenu.HUD.Weapon1Icons'
     sAmmoRef="••••••"
}
