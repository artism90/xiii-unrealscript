//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIPlayerInteraction extends Interaction;

var bool bDebugTrace;

var LevelInfo Level;            // Because non-accessible by Objects (only actors)
var XIIIPlayerController MyPC;  // just to avoid thousands class-castings
var XIIIWeapon XWeap;
var XIIIItems XItem;
var actor TargetActor;
var actor FiringTargetActor;
var vector FiringTargHitLoc, TargHitLoc, FiringTargHitNorm, TargHitNorm;
var float TargDist;

var bool bCanPickup;            // Can pickup something
var bool bCanHook;              // have a hookpoint in target and hook in hand
var bool bCanTrigger;           // have a targetable trigger
var bool bCanDoor;              // can interact w/ a door
var bool bCanClimbDoor;         // Can climb a door (previous bool is true)
var bool bCanUnLockDoor;        // door is locked
var bool bCantDoor;             // non interactive door
var bool bCanSearchCorpse;      // can search corpse (some dead)
var bool bCanGrabCorpse;        // can take corpse    (grab someone dead)
var bool bCanTakePrisonner;     // can take prisonner (grab someone alive)
var bool bCanStun;              // Can stun (someone alive)
var bool bCanBreak;             // Can break item
var bool bCanHeal;              // Can Heal self
var bool bEasyInteractOn;       // to display differently
var bool bDBDrawLog;

var texture GrabItemTex;        // Std Icon, normal = grab std pickup
var texture DecoWeaponTex;      // Grab 'decoration' that can be used as a weapon
var texture GrapplePointTex;    // HookPoint can be hooked
var texture OpenDoorTex, ClimbDoorTex, NoOpenDoorTex, ClosedDoorTex, OpenAbleDoorTex;    // doors interactions icons
var texture SearchBodyTex, TakeCorpseTex, TakePrisonnerTex, StunTex;    // Pawns interactions icons
var texture BreakTex;           // Breakable interaction icons
var texture TyrolTex;           // Tyrol Points
var texture NoShootTex;
var texture DotTex;
var texture HealTex;
var texture CH;                 // Crosshair drawn

var rotator AdjustedAim;
var vector StartTrace;
var float CrosshairAlpha;

var array<Actor> EasyInteractives;
var bool bCheckedEasyInteractives;

CONST INTERACTIONDIST=160.0;
CONST STUNDIST=100.0;
CONST STUNWITHDECODIST=150.0;

//_____________________________________________________________________________
function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
    if ( Action!=IST_Press )
      return false;
    else if (Key == IK_Escape)
    {
    	MyPC.ShowMenu();
    	return true;
    }
    else if( Key==IK_Home )
    {
      bDebugTrace = !bDebugTrace;
      return true;
    }
    else
      return false;
}

//_____________________________________________________________________________
// EndMap - Prevent before to change of map.
simulated event EndMap()
{
    if ( (MyPC != none) && !Level.bLonePlayer && (Level.NetMode != NM_StandAlone) )
    { // OnLine
      MyPC.StatUpdate();
    }
    XItem = none;
    XWeap = none;
    MyPC = none;
    TargetActor = none;
    FiringTargetActor = none;
    Level = none;
}

//_____________________________________________________________________________
function SwitchLog()
{
    bDBDrawLog = !bDBDrawLog;
}

//_____________________________________________________________________________
simulated event MyPCPostRender(Canvas C)
{
    local bool bDrawWeaponCrosshair, bDrawItemCrosshair;
    local XIIIWeapon XW;
    local vector X,Y,Z;
    local float XLength;
    local bool bZoomed;
    local int i, TraceType;
    local material HitMat;
    local Actor oldtarget;
    local actor A;
    local float BestEasyInteract;
    CONST AUTOAIMMAXDIST=3000;

    if ( (MyPC != none) && !bCheckedEasyInteractives )
    {
      bCheckedEasyInteractives = true;
      foreach MyPC.AllActors(class'Actor', A)
        if ( A.bEaseInteract )
          EasyInteractives[EasyInteractives.Length] = A;
      if ( EasyInteractives.Length > 0 )
        for ( i = 0; i<EasyInteractives.Length; i++ )
          DebugLog("SETUP EASY interaction WITH"@i@"-"@EasyInteractives[i]);
    }

    ResetInteractions();

    oldtarget = TargetActor;

    if ( (MyPc == none) || (MyPC.Pawn == none) || MyPC.Pawn.bIsDead || MyPC.bBehindView )
      return;


    if ( (MyPC.ViewTarget != MyPC.pawn)
      || MyPC.IsInState('CameraView') || MyPC.IsInState('NoControl')
      || MyPC.IsInState('NoMove') || MyPC.IsInState('GameEnded')
      )
      return;

    C.bNoSmooth = false;
    C.Style = 5; //ERenderStyle.STY_Alpha;

    GetAxes(MyPC.Rotation,X,Y,Z);

    FiringtargetActor = none;
    MyPC.OldBestTarget = MyPC.BestTarget;
    MyPC.BestTarget = none;
    if ( MyPC.bWeaponMode )
    {
      if ( (MyPC.Pawn != none) && (MyPC.Pawn.Weapon != none) && (XIIIWeapon(MyPC.Pawn.Weapon) != none) )
      {
        XWeap = XIIIWeapon(MyPC.Pawn.Weapon);
        TraceType = XIIIAmmo(XWeap.AmmoType).TraceType;
        if ( (XWeap.WHand == WHA_Fist) || (XWeap.WHand == WHA_Deco) )
          StartTrace = XWeap.Instigator.Location + XWeap.Instigator.EyePosition();
        else
          StartTrace = XWeap.GetFireStart(X,Y,Z)+16*X;
        AdjustedAim = MyPC.AdjustAimForDisplay(XWeap.AmmoType, StartTrace);
        if ( XWeap.ShouldDrawCrosshair(C) )
        {
          bDrawWeaponCrosshair = true;
        }
        else
        {
          if ( XWeap.bZoomed || MyPC.bZooming )
          {
            if ( XWeap.ZCrossHair != none )
            {
              bZoomed=true;
              XWeap.bDrawZoomedCrosshair = true;
            }
            else
              bDrawWeaponCrosshair = true;
          }
        }
        X = vector(AdjustedAim);
        FiringTargetActor = MyPC.BestTarget;
        FiringTargHitLoc = fMax(XWeap.TraceDist, INTERACTIONDIST) * X + StartTrace;
        XWeap.AmmoType.WarnTarget( FiringTargetActor, XWeap.Instigator, X);
      }
      // compute interaction TargetActor
      StartTrace = MyPC.Pawn.Location + MyPC.Pawn.EyePosition();

      TargetActor = MyPC.ReturnTrace(TargHitLoc, TargHitNorm, INTERACTIONDIST * X + StartTrace, StartTrace, true);
      if ( CamViewTrigger(oldtarget) != none && CamViewTrigger(TargetActor) == none)
        { CamViewTrigger(oldtarget).UnLookedAt(MyPC.Pawn); }
    }
    else if ( (MyPC.Pawn != none) && (MyPC.Pawn.SelectedItem != none) && (XIIIItems(MyPC.Pawn.SelectedItem) != none) )
    {
      XItem = XIIIItems(MyPC.Pawn.SelectedItem);
      if ( XItem.ShouldDrawCrosshair(C) )
        bDrawItemCrosshair = true;
      //if ( (Micro(XItem) != none) && (Micro(XItem).bZoomed || MyPC.bZooming) )      // creates a dependency with micro
      if ( XItem.IsA('Micro') && (!XItem.ShouldDrawCrosshair(C) || MyPC.bZooming) )   // creates no dependency with micro, and since micro.ShouldDrawCrosshair() = !micro.bZoomed
      {
        bDrawItemCrosshair = false;
        XItem.bDrawZoomedCrosshair = true;
        bZoomed = true;
      }

      // compute interaction TargetActor
      StartTrace = MyPC.Pawn.Location + MyPC.Pawn.EyePosition();
      if ( Hook(MyPC.Pawn.SelectedItem) != none )
        TargetActor = MyPC.ReturnTrace(TargHitLoc, TargHitNorm, 10000 * X + StartTrace, StartTrace, true);
      else
        TargetActor = MyPC.ReturnTrace(TargHitLoc, TargHitNorm, INTERACTIONDIST * X + StartTrace, StartTrace, true);
      if ( CamViewTrigger(oldtarget) != none && CamViewTrigger(TargetActor) == none)
        { CamViewTrigger(oldtarget).UnLookedAt(MyPC.Pawn); }
    }
    else // should never happen but ?
    {
      TargetActor = none;
    }
    if ( TargetActor == none )
    { // check w/ all EaseInteract actors
      if ( EasyInteractives.Length > 0 )
      {
        BestEasyInteract = 0.80;
        for ( i = 0; i<EasyInteractives.Length; i++ )
        {
          if ( EasyInteractives[i].bDeleteMe )
          {
            EasyInteractives.Remove(i, 1);
            i--;
          }
          else if ( EasyInteractives[i].LastRenderTime > Level.TimeSeconds - 0.2 )
          {
            TargDist = vSize(EasyInteractives[i].Location - MyPC.Pawn.Location - MyPC.Pawn.EyePosition());
            if ( TargDist < INTERACTIONDIST )
            {
              if ( vector(MyPC.Rotation) dot normal(EasyInteractives[i].Location - MyPC.Pawn.Location - MyPC.Pawn.EyePosition()) > BestEasyInteract )
              {
                if ( MyPC.FastTrace( EasyInteractives[i].Location , MyPC.Pawn.Location + MyPC.Pawn.EyePosition()) )
                {
                  BestEasyInteract = vector(MyPC.Rotation) dot normal(EasyInteractives[i].Location - MyPC.Pawn.Location - MyPC.Pawn.EyePosition());
                  TargetActor = EasyInteractives[i];
                  bEasyInteractOn = true;
                }
              }
            }
          }
        }
      }
      if ( TargetActor != none )
      {
        TargDist = vSize(TargetActor.Location - MyPC.Pawn.Location - MyPC.Pawn.EyePosition());
        bEasyInteractOn = true;
      }
    }
    else
      TargDist = vSize(TargHitLoc - StartTrace);

    if ( bDBDrawLog )
      Log(" we do have "$FiringTargetActor$"["$vSize(FiringTargHitLoc - StartTrace)$"] & "$TargetActor$"["$TargDist$"] in crosshair"); //$", TarHitLoc="$TargHitLoc$" bWeaponMode="$MyPC.bWeaponMode);

//    if ( bDebugTrace && (TargetActor != none) )
//      TargetActor.Spawn(class'BulletDustEmitter',,, TargHitLoc+TargHitNorm, Rotator(TargHitNorm));

    if ( !bZoomed && (TargetActor != none) && !TargetActor.bDeleteMe && !MyPC.IsInState('MayClimbDoor') && !MyPC.IsInState('ClimbDoor') && !MyPC.IsInState('ClimbToHookNavPoint') )
    {
      if ( DrawInteractions(C) )
      {
        bDrawWeaponCrosshair = false;
        bDrawItemCrosshair = false;
      }
    }
    if ( bDrawWeaponCrosshair )
    {
//      if ( MyPC.bFixedCrosshair )
        DrawFixWeaponCrosshair(C);
//      else
//        DrawWeaponCrosshair(C);
    }
    if ( bDrawItemCrosshair )
      DrawItemCrosshair(C);
}

/*
//_____________________________________________________________________________
simulated function DrawWeaponCrosshair(Canvas C)
{
    local int XLength;
    local vector vT;
    local float fSize;

    if ( MyPC.MyHud.bHideHud )
      return;

    if ( MyPC.iCrosshairMode == 0 )
      return;

    fSize = MyPC.fCrosshairSize;
    C.bUseBorder = false;

    if ( ((XIIIPawn(FiringTargetActor) != none) && (!XIIIPawn(FiringTargetActor).bIsDead || XIIIPawn(FiringTargetActor).GameOver != GO_Never) )
      || ((XIIIMover(FiringTargetActor) != none) && XIIIMover(FiringTargetActor).IsBreakableByPlayer()) )
    {
      if ( MyPC.iCrosshairMode == 1 )
        CrosshairAlpha = fMin(1.0, CrosshairAlpha + 0.25);
      else
        CrosshairAlpha = 1.0;
      if ( (XIIIPawn(FiringTargetActor) != none) && (XIIIPawn(FiringTargetActor).GameOver != GO_Never) )
      {
        fSize=MyPC.fCrosshairSize/2.0;
        CH = NoShootTex;
        C.SetDrawColor(255,255,255,0*CrosshairAlpha);
      }
      else
      {
        CH = XWeap.Crosshair;
        C.SetDrawColor(255,0,0,255*CrosshairAlpha);
      }
      C.Style = 3; //ERenderStyle.STY_Translucent;
      C.bNoSmooth = true;
      XLength = 34.0*fSize;
      if ( MyPC.bFloatingCrosshair )
      {
        vT = WorldToScreen(FiringTargHitLoc);
        vT.X = fClamp( vT.X, C.CLipX*1.2/3, C.CLipX*1.8/3);
        vT.Y = fClamp( vT.Y, C.CLipY*1.2/3, C.CLipY*1.8/3);
      }
      else
        vT = vect(1,0,0)*C.ClipX/2 + vect(0,1,0)*C.ClipY/2;
      XLength = 32.0*fSize;
      if ( CH != none )
      {
        C.SetPos(vT.x - XLength*0.5, vT.y - XLength*0.5);
        C.DrawTile(CH, XLength, XLength, 0, 0, CH.USize, CH.VSize);
        C.SetDrawColor(255,255,255,255*CrosshairAlpha);
        C.bNoSmooth = false;
        C.SetPos(vT.x- XLength/2, vT.y - XLength/2);
        C.DrawTile(CH, XLength, XLength, 0, 0, CH.USize, CH.VSize);
      }
      XLength = 32.0*2.0;
      C.bNoSmooth = false;
      C.SetDrawColor(255,255,255,255);
      C.SetPos(vT.x - XLength/16, vT.y - XLength/16);
      C.DrawTile(DotTex, XLength/8, XLength/8, 0, 0, DotTex.USize, DotTex.VSize); // minimal cost
      if ( (XIIIPawn(FiringTargetActor) != none) && (XIIIPawn(FiringTargetActor).PlayerReplicationInfo != none) )
      {
        C.Font = C.smallfont;           //font'Policef16'; // ELR Must be intializeed to avoid crash
        if ( MyPC.PlayerReplicationInfo.Team != none )
        {
          if ( XIIIPawn(FiringTargetActor).PlayerReplicationInfo.Team.TeamIndex == MyPC.PlayerReplicationInfo.Team.TeamIndex )
          {
            C.SetDrawColor(128,255,128,128);
            C.DrawText( XIIIPawn(FiringTargetActor).PlayerReplicationInfo.PlayerName@"("$int(Pawn(FiringTargetActor).HealthPercent())$"%)");
          }
          else
          {
            C.SetDrawColor(255,128,128,128);
            if (XIIIGameInfo(level.game)!=none && XIIIGameInfo(level.game).bRocketArena)
              C.DrawText( XIIIPawn(FiringTargetActor).PlayerReplicationInfo.PlayerName@"("$int(Pawn(FiringTargetActor).HealthPercent())$"%)");
            else
            C.DrawText( XIIIPawn(FiringTargetActor).PlayerReplicationInfo.PlayerName);
          }
        }
        else
        {
          C.SetDrawColor(255,128,128,128);
          if (XIIIGameInfo(level.game)!=none && XIIIGameInfo(level.game).bRocketArena)
            C.DrawText( XIIIPawn(FiringTargetActor).PlayerReplicationInfo.PlayerName@"("$int(Pawn(FiringTargetActor).HealthPercent())$"%)");
          else
          C.DrawText( XIIIPawn(FiringTargetActor).PlayerReplicationInfo.PlayerName);
        }
      }
      else if ( (XIIIPawn(FiringTargetActor) != none) && Pawn(FiringTargetActor).bBoss )
      {
        C.Font = C.smallfont;                //font'Policef16'; // ELR Must be intializeed to avoid crash
        C.SetDrawColor(255,255,128,196);
        C.DrawText( Pawn(FiringTargetActor).PawnName@"("$int(Pawn(FiringTargetActor).HealthPercent())$"%)");
      }
    }
    else
    {
      if ( MyPC.iCrosshairMode == 1 )
      {
        // Don't change CH, use the old one for fading away
        if ( CH == NoShootTex )
          fSize=MyPC.fCrosshairSize/2.0;
        CrosshairAlpha = fMax(0.0, CrosshairAlpha - 0.25);
      }
      else
      {
        CH = XWeap.Crosshair;
        CrosshairAlpha = 1.0;
      }
      C.bNoSmooth = false;
      XLength = 32 * fSize;
      if ( MyPC.bFloatingCrosshair )
        vT = WorldToScreen(StartTrace + vector(AdjustedAim)*3000);
      else
        vT = vect(1,0,0)*C.ClipX/2 + vect(0,1,0)*C.ClipY/2;
      if ( CrosshairAlpha > 0.0 && (CH != none) )
      {
        C.SetDrawColor(255,255,255,255*CrosshairAlpha);
        vT.X = fClamp( vT.X, C.CLipX*1.2/3, C.CLipX*1.8/3);
        vT.Y = fClamp( vT.Y, C.CLipY*1.2/3, C.CLipY*1.8/3);
        C.SetPos(vT.x - XLength/2, vT.y - XLength/2);
        C.DrawTile(CH, XLength, XLength, 0, 0, CH.USize, CH.VSize); // minimal cost
      }
      XLength = 32 * 2.0;
      C.SetDrawColor(255,255,255,255);
      C.SetPos(vT.x - XLength/16, vT.y - XLength/16);
      C.DrawTile(DotTex, XLength/8, XLength/8, 0, 0, DotTex.USize, DotTex.VSize); // minimal cost
    }
}
*/

//_____________________________________________________________________________
simulated function DrawFixWeaponCrosshair(Canvas C)
{
    local int XLength;
    local vector vT;
    local float fSize;

    if ( MyPC.MyHud.bHideHud )
      return;

    if ( MyPC.iCrosshairMode == 0 )
      return;

    fSize=MyPC.fCrosshairSize;
//    CH = XWeap.Crosshair;
    C.bUseBorder = false;

    if ( ((XIIIPawn(FiringTargetActor) != none) && (!XIIIPawn(FiringTargetActor).bIsDead || XIIIPawn(FiringTargetActor).GameOver != GO_Never) )
      || ((XIIIMover(FiringTargetActor) != none) && XIIIMover(FiringTargetActor).IsBreakableByPlayer()) )
    {
      if ( MyPC.iCrosshairMode == 1 )
        CrosshairAlpha = fMin(1.0, CrosshairAlpha + 0.15);
      else
        CrosshairAlpha = 1.0;
      if ( (XIIIPawn(FiringTargetActor) != none) && (XIIIPawn(FiringTargetActor).GameOver != GO_Never) )
      {
        fSize=MyPC.fCrosshairSize/2.0;
        CH = NoShootTex;
        C.SetDrawColor(255,255,255,0*CrosshairAlpha);
      }
      else
      {
        CH = XWeap.Crosshair;
        C.SetDrawColor(255,0,0,255*CrosshairAlpha);
      }
      C.Style = 5; // 5 = alpha // 3 = ERenderStyle.STY_Translucent;
      C.bNoSmooth = true;
//      XLength = 34.0*fSize;
//      vT = WorldToScreen(FiringTargHitLoc);
//      vT.X = fClamp( vT.X, C.CLipX*1.2/3, C.CLipX*1.8/3);
//      vT.Y = fClamp( vT.Y, C.CLipY*1.2/3, C.CLipY*1.8/3);
      vT = vect(1.0, 0, 0)*C.CLipX/2.0 + vect(0, 1.0, 0)*C.CLipY/2.0;
      XLength = 34.0*fSize;
      if ( CH != none )
      {
        C.SetPos(vT.x - XLength*0.5, vT.y - XLength*0.5);
        C.DrawTile(CH, XLength, XLength, 0, 0, CH.USize, CH.VSize);
        C.SetDrawColor(255,255,255,255*CrosshairAlpha);
        C.bNoSmooth = false;
        XLength = 32.0*fSize;
        C.SetPos(vT.x- XLength/2, vT.y - XLength/2);
        C.DrawTile(CH, XLength, XLength, 0, 0, CH.USize, CH.VSize);
      }
      XLength = 32.0*2.0;
      C.bNoSmooth = false;
      C.SetDrawColor(255,255,255,255);
      C.SetPos(vT.x - XLength/16, vT.y - XLength/16);
      C.DrawTile(DotTex, XLength/8, XLength/8, 0, 0, DotTex.USize, DotTex.VSize); // minimal cost
      if ( (XIIIPawn(FiringTargetActor) != none) && (XIIIPawn(FiringTargetActor).PlayerReplicationInfo != none) )
      {
        C.Font = C.smallfont;           //font'Policef16'; // ELR Must be intializeed to avoid crash
        if ( MyPC.PlayerReplicationInfo.Team != none )
        {
          if ( XIIIPawn(FiringTargetActor).PlayerReplicationInfo.Team.TeamIndex == MyPC.PlayerReplicationInfo.Team.TeamIndex )
          {
            C.SetDrawColor(128,255,128,128);
            C.DrawText( XIIIPawn(FiringTargetActor).PlayerReplicationInfo.PlayerName@"("$int(Pawn(FiringTargetActor).HealthPercent())$"%)");
          }
          else
          {
            C.SetDrawColor(255,128,128,128);
            C.DrawText( XIIIPawn(FiringTargetActor).PlayerReplicationInfo.PlayerName);
          }
        }
        else
        {
          C.SetDrawColor(255,128,128,128);
          C.DrawText( XIIIPawn(FiringTargetActor).PlayerReplicationInfo.PlayerName);
        }
      }
      else if ( (XIIIPawn(FiringTargetActor) != none) && Pawn(FiringTargetActor).bBoss )
      {
        C.Font = C.smallfont;                //font'Policef16'; // ELR Must be intializeed to avoid crash
        C.SetDrawColor(255,255,128,196);
        C.DrawText( Pawn(FiringTargetActor).PawnName@"("$int(Pawn(FiringTargetActor).HealthPercent())$"%)");
      }
    }
    else
    {
      if ( MyPC.iCrosshairMode == 1 )
      {
        // Don't change CH, use the old one for fading away
        if ( CH == NoShootTex )
          fSize=MyPC.fCrosshairSize/2.0;
        CrosshairAlpha = fMax(0.0, CrosshairAlpha - 0.15);
      }
      else
      {
        CH = XWeap.Crosshair;
        CrosshairAlpha = 1.0;
      }
      C.bNoSmooth = false;
      XLength = 32 * fSize;
//      vT = WorldToScreen(StartTrace + vector(AdjustedAim)*3000);
      vT = vect(1.0, 0, 0)*C.CLipX/2.0 + vect(0, 1.0, 0)*C.CLipY/2.0;
      if ( CrosshairAlpha > 0.0 && (CH != none) )
      {
        C.SetDrawColor(255,255,255,255*CrosshairAlpha);
        vT.X = fClamp( vT.X, C.CLipX*1.2/3, C.CLipX*1.8/3);
        vT.Y = fClamp( vT.Y, C.CLipY*1.2/3, C.CLipY*1.8/3);
        C.SetPos(vT.x - XLength/2, vT.y - XLength/2);
        C.DrawTile(CH, XLength, XLength, 0, 0, CH.USize, CH.VSize); // minimal cost
      }
      XLength = 32 * 2.0;
      C.SetDrawColor(255,255,255,255);
      C.SetPos(vT.x - XLength/16, vT.y - XLength/16);
      C.DrawTile(DotTex, XLength/8, XLength/8, 0, 0, DotTex.USize, DotTex.VSize); // minimal cost
    }
}

//_____________________________________________________________________________
function DrawItemCrosshair(Canvas C)
{
    local texture CH;
    local float XLength;

    if ( XItem.IsA('Med') && XIIIPawn(MyPC.Pawn).IsWounded() )
    {
      C.SetDrawColor(255,255,255,128);
      XLength = 24 * MyPC.fCrosshairSize;
      C.SetPos(0.503 * C.ClipX - XLength/2.0, 0.504 * C.ClipY - XLength/2.0);
      C.DrawTile(HealTex, XLength, XLength, 0, 0, HealTex.USize, HealTex.VSize);
    }
    else if ( XItem.Crosshair != none )
    {
      C.SetDrawColor(255,255,255,255);
      CH = XItem.Crosshair;
      XLength = 32 * MyPC.fCrosshairSize;
      C.SetPos(0.503 * C.ClipX - XLength/2.0, 0.504 * C.ClipY - XLength/2.0);
      C.DrawTile(CH, XLength, XLength, 0, 0, CH.USize, CH.VSize);
    }
    else
    {
      C.SetDrawColor(255,255,255,255);
      XLength = 32 * 2.0;
      C.SetPos(0.503 * C.ClipX - XLength/16.0, 0.504 * C.ClipY - XLength/16.0);
      C.DrawTile(DotTex, XLength/8, XLength/8, 0, 0, DotTex.USize, DotTex.VSize); // minimal cost
    }
}

//____________________________________________________________________
function DrawAction(Canvas C, int NbIcons, int index, texture Tex)
{
    C.SetPos(0.5 * C.ClipX - (NbIcons-index*2)*(Tex.USize/2.0), 0.5 * C.ClipY - (Tex.VSize/2.0));
    C.DrawIcon(Tex, 1.0);
}

//____________________________________________________________________
function ResetInteractions()
{
    bEasyInteractOn = false;
    bCanPickup = false;
    bCanHook = false;
    bCanTrigger = false;
    bCanDoor = false;
    bCanClimbDoor = false;
    bCanUnLockDoor = false;
    bCantDoor = false;
    bCanSearchCorpse = false;
    bCanGrabCorpse = false;
    bCanTakePrisonner = false;
    bCanStun = false;
    bCanBreak = false;
    bCanHeal = false;
    if ( (TargetActor != none) && TargetActor.bDeleteMe )
      TargetActor = none;
}

//____________________________________________________________________
function bool DrawInteractions(Canvas C)
{
    local int Index, NbIconsDrawn;
    local bool bHaveDrawnSomething;
    local PowerUps PwrU;
    local vector vFocusLoc;
    local float XL, YL;
    local float XP1, YP1, XP2, YP2;

    NbIconsDrawn=0;
    bHaveDrawnSomething = false;

    // Decide of interactions.
    // PICKUP
    if ( (Pickup(TargetActor) != none) && (TargetActor != MyPC.Pawn.Base) && (TargDist < INTERACTIONDIST) && Level.bLonePlayer )
    {
      if ( (XIIIDecoPickup(TargetActor) == none) || !XIIIPawn(MyPC.Pawn).LHand.bActive )
      {
        bCanPickup = true;
        NbIconsDrawn ++;
        if ( MyPC.bAutoPickup && (XIIIDecoPickup(TargetActor) == none) )
        {
          MyPC.Grab();
          if ( (TargetActor == none) || TargetActor.bDeleteMe )
          {
            bCanPickup = false;
            NbIconsDrawn --;
            TargetActor = none;
          }
        }
      }
    }
    // HOOK
    if ( (HookPoint(TargetActor) != none) && MyPC.AllowHooking() )
    { bCanHook = true; NbIconsDrawn ++; }
    // TRIGGER
    if ( (XIIITriggers(TargetActor) != none) && (TargDist < INTERACTIONDIST) && XIIITriggers(TargetActor).bCanBeLocked && Level.bLonePlayer )
    {
      if ( ( Level.Game != none) && (Level.Game.DetailLevel > 1) && CamViewTrigger(TargetActor) != none )
      {
        CamViewTrigger(TargetActor).LookedAt(MyPC.Pawn);
      }
      else
      {
        bCanTrigger = true;
        if ( MagneticPassTrigger(TargetActor) != none )
        { bCanDoor = true; NbIconsDrawn ++; }
        else
        { NbIconsDrawn ++; }
      }
    }
    // DOOR
    if ( (TargetActor != none) && (TargetActor != MyPC.Pawn.Base) && Level.bLonePlayer ) // don't interact with our base (close door we had climbed on...)
    {
      if ( (XIIIPorte(TargetActor) != none) && (TargDist < INTERACTIONDIST) && !XIIIPorte(TargetActor).bNoInteractionIcon )
      {
        if ( TargetActor.IsInState('Locked') || !TargetActor.IsInState('PlayerTriggerToggle') )
        { bCanDoor = true; bCanUnLockDoor = true; NbIconsDrawn ++; }
        else
        {
          if ( XIIIPorte(TargetActor).CanBeOperated(MyPC.Pawn) )
          {
            bCanDoor = true;
            NbIconsDrawn ++;
          }
          else
          { bCantDoor = true; NbIconsDrawn ++; }
        }
        if ( MyPC.TryClimbDoor(TargetActor, TargHitLoc, TargHitNorm) )
        { bCanClimbDoor = true; NbIconsDrawn ++; }
      }
      else if ( PorteDecors(TargetActor) != none && (TargDist < INTERACTIONDIST) )
      { } //bCantDoor = true; NbIconsDrawn ++; }
//      else if ( (BreakAbleMover(TargetActor) != none) && !XIIIMover(TargetActor).bNoInteractionIcon && (TargDist < 180) && MyPC.bWeaponMode )
      else if ( TargetActor.IsA('BreakAbleMover') && !XIIIMover(TargetActor).bNoInteractionIcon && (TargDist < INTERACTIONDIST) )
      {
        if ( XIIIMover(TargetActor).IsBreakableByPlayer() )
          { bCanBreak = true; NbIconsDrawn ++; }
      }
//      else if ( (UnBreakable(TargetActor)!=none) && !XIIIMover(TargetActor).bNoInteractionIcon && (TargDist < INTERACTIONDIST) )
      else if ( (UnBreakable(TargetActor)!=none) && (TargDist < INTERACTIONDIST) )
      { /* bCantBreak = true; NbIconsDrawn ++; // ELR Don't do anything */  }
      else if ( TargetActor.IsA('XIIIMovable') && !XIIIMover(TargetActor).bNoInteractionIcon && (TargDist < INTERACTIONDIST) )
      { bCanDoor = true; NbIconsDrawn ++; }
      else if ( (XIIIMover(TargetActor) != none) && !XIIIMover(TargetActor).bNoInteractionIcon && (TargDist < INTERACTIONDIST) )
      {
        bCanDoor = true;
        if ( !TargetActor.IsInState('PlayerTriggerToggle') )
        { bCanUnLockDoor = true; NbIconsDrawn ++; }
        else
          NbIconsDrawn ++;
      }
    }

    if ( (XIIIPawn(TargetActor) != none) && Level.bLonePlayer )
    {
      if ( XIIIPawn(TargetActor).bSearchable && (TargDist < INTERACTIONDIST) )
      {
        if ( XIIIPawn(TargetActor).inventory != none )
        {
          bCanSearchCorpse = true;
          NbIconsDrawn ++;
          if ( MyPC.bAutoPickup )
          {
            MyPC.SearchPawn(XIIIPawn(TargetActor));
          }
        }
        if ( XIIIPawn(MyPC.Pawn).CanGrabCorpse(XIIIPawn(TargetActor)) )
        {
          bCanGrabCorpse = true;
          NbIconsDrawn ++;
        }
      }
      else if ( (TargetActor != none) && !XIIIPawn(TargetActor).bIsDead )
      {
        if ( (TargDist < STUNDIST) && XIIIPawn(MyPC.Pawn).CanTakePrisonner(XIIIPawn(TargetActor)) && (XIIIPawn(TargetActor).GetDamageSide(TargHitLoc) >= 6) )
        {
          bCanTakePrisonner = true;
          NbIconsDrawn ++;
        }
        if (  (TargDist < STUNWITHDECODIST) && (XIIIPawn(MyPC.Pawn).CanStun(XIIIPawn(TargetActor)))
          && ( (XIIIPawn(TargetActor).GetDamageSide(TargHitLoc) >= 6) || (DecoWeapon(XIIIPawn(MyPC.Pawn).Weapon)!=none) )
           )
        {
          bCanStun = true;
          NbIconsDrawn ++;
        }
      }
    }

    // Draw interactions
    Index = 0;
    C.SetDrawColor(255,255,255,255);
    if ( bCanPickup )
    {
      if ( XIIIDecoPickup(TargetActor) != none )
        DrawAction(C, NbIconsDrawn, index, DecoWeaponTex);
      else
        DrawAction(C, NbIconsDrawn, index, GrabItemTex);
      index ++;
      bHaveDrawnSomething = true;
    }
    if ( bCanHook )
    {
      if ( (Hook(XItem) != none) && (HookPoint(TargetActor) != none) )
      {
        if ( VSize(TargetActor.Location - MyPC.Pawn.Location) + 50.0 > HookPoint(TargetActor).RopeLength )
          C.SetDrawColor(255,0,0,255);
      }
      else
        C.SetDrawColor(255,255,255,255);
      DrawAction(C, NbIconsDrawn, index, GrapplePointTex);
      C.SetDrawColor(255,255,255,255);
      index ++;
      bHaveDrawnSomething = true;
    }
    if ( bCanTrigger )
    {
      if ( TyrolTrigger(TargetActor) != none )
      {
        DrawAction(C, NbIconsDrawn, index, TyrolTex);
        index ++;
        bHaveDrawnSomething = true;
      }
      else if ( !bCanDoor )
      {
        DrawAction(C, NbIconsDrawn, index, GrabItemTex);
        index ++;
        bHaveDrawnSomething = true;
      }
    }
    if ( bCanDoor )
    {
      if ( bCanTrigger )
      {
        // Must be a MagneticPasstrigger or doortrigger
        DrawAction(C, NbIconsDrawn, index, MagneticPasstrigger(TargetActor).Icon);
        index ++;
        bHaveDrawnSomething = true;
      }
      else if ( bCanUnLockDoor )
      {
        PwrU = MyPC.TryInteractWithDoor(TargetActor);
        if ( PwrU != none )
          DrawAction(C, NbIconsDrawn, index, OpenAbleDoorTex);
        else
          DrawAction(C, NbIconsDrawn, index, ClosedDoorTex);
        index ++;
        bHaveDrawnSomething = true;
      }
      else
      {
        DrawAction(C, NbIconsDrawn, index, OpenDoorTex);
        index ++;
        bHaveDrawnSomething = true;
      }
      if ( bCanClimbDoor )
      {
        DrawAction(C, NbIconsDrawn, index, ClimbDoorTex);
        index ++;
        bHaveDrawnSomething = true;
      }
    }
    if ( bCantDoor )
    {
      DrawAction(C, NbIconsDrawn, index, NoOpenDoorTex);
      index ++;
      bHaveDrawnSomething = true;
    }
    if ( bCanSearchCorpse )
    {
      DrawAction(C, NbIconsDrawn, index, SearchBodyTex);
      index ++;
      bHaveDrawnSomething = true;
    }
    if ( bCanGrabCorpse )
    {
      DrawAction(C, NbIconsDrawn, index, TakeCorpseTex);
      index ++;
      bHaveDrawnSomething = true;
    }
    if ( bCanStun )
    {
      DrawAction(C, NbIconsDrawn, index, StunTex);
      index ++;
      bHaveDrawnSomething = true;
    }
    if ( bCanTakePrisonner )
    {
      DrawAction(C, NbIconsDrawn, index, TakePrisonnerTex);
      index ++;
      bHaveDrawnSomething = true;
    }
    if ( bCanBreak )
    {
      DrawAction(C, NbIconsDrawn, index, BreakTex);
      index ++;
      bHaveDrawnSomething = true;
    }
/*
    if ( !bHaveDrawnSomething )
    {
      Log("bHaveDrawnNothing");
      if ( !MyPC.bWeaponMode && MyPC.Pawn.SelectedItem.IsA('Med') )
      {
        Log("  Drawing Heal");
        DrawAction(C, 0, 1, HealTex);
        bHaveDrawnSomething = true;
      }
    }
*/
    if ( bHaveDrawnSomething )
    {
      if ( (bEasyInteractOn || TargetActor.bEaseInteract) && !XIIIBaseHud(MYPC.MyHud).IsFocusing(TargetActor) )
      {
        vFocusLoc = WorldToScreen(TargetActor.Location);
        XL = 32;
        YL = 32;
        XP1 = int(vFocusLoc.X - XL);
        XP2 = int(vFocusLoc.X + XL);
        YP1 = int(vFocusLoc.Y - YL);
        YP2 = int(vFocusLoc.Y + YL);
        C.DrawColor = C.Static.MakeColor(0,0,0,0);
        C.BorderColor = C.Static.MakeColor(0,0,0,255);
        C.bUseBorder = true;
        // outer outline
        C.SetPos(XP1 - 2, YP1 - 2);
        C.DrawRect(XIIIBaseHUD(MyPC.MyHud).FondDlg, (XP2 - XP1)+4, (YP2 - YP1)+4);
        // inner outline
        C.SetPos(XP1, YP1);
        C.BorderColor = C.Static.MakeColor(255,255,255,255);
        C.DrawRect(XIIIBaseHUD(MyPC.MyHud).FondDlg, (XP2 - XP1), (YP2 - YP1));
        C.bUseBorder = false;
      }
    }
    return bHaveDrawnSomething;
}



defaultproperties
{
     GrabItemTex=Texture'XIIIMenu.HUD.Hand_SearchBody'
     DecoWeaponTex=Texture'XIIIMenu.HUD.Hand_DecoWeapon'
     GrapplePointTex=Texture'XIIIMenu.HUD.Hand_GrapplePoint'
     OpenDoorTex=Texture'XIIIMenu.HUD.Hand_SearchBody'
     ClimbDoorTex=Texture'XIIIMenu.HUD.Hand_ClimbDoor'
     NoOpenDoorTex=Texture'XIIIMenu.HUD.Hand_UnOpenable'
     ClosedDoorTex=Texture'XIIIMenu.HUD.Hand_UnOpenable'
     OpenAbleDoorTex=Texture'XIIIMenu.HUD.Hand_ClosedDoor'
     SearchBodyTex=Texture'XIIIMenu.HUD.Hand_SearchBody'
     TakeCorpseTex=Texture'XIIIMenu.HUD.Hand_TakeCorpse'
     TakePrisonnerTex=Texture'XIIIMenu.HUD.Hand_TakePrisonner'
     StunTex=Texture'XIIIMenu.HUD.Hand_Stun'
     BreakTex=Texture'XIIIMenu.HUD.Hand_Break'
     TyrolTex=Texture'XIIIMenu.HUD.Hand_TyrolPoint'
     NoShootTex=Texture'XIIIMenu.HUD.MireNoshoot'
     DotTex=Texture'XIIIMenu.HUD.Miredot'
     HealTex=Texture'XIIIMenu.HUD.life2A'
     bVisible=True
}
