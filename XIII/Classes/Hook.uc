//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Hook extends XIIIItems;

var HookPoint PotHookPoint;     // If there is a Hookpoint in the Crosshair

var HookProjectile MyHook;
var HookLink MyLink;
//var FreeHookLink MyFHLink;

var vector HookPoint;           // Hooking point
var float HookLength;           // Position on the Rope to the HookPoint
var float MaxHookLength;        // Max Lenght of the Hook Rope
var float HookUpSpeed, HookDownSpeed;   // Speed we are climbing/dropping while hooked
var bool bGoUp, bGoDown;

var array<hookpoint> PotentialHP;   // Array of potentials HP in the level
var texture PotHookIcon;            // Icon to use to display the potential hook points on screen

var sound hHookMoveSound;
var sound hHookEndSound;
var sound hHookFireSound;
var sound hHookReleaseSound;
var sound hHookClik;

var bool bHooked;               // used for playing right animations
var int AnimState;              // used for playing animation chain (firing then down then selectcommande)

var bool ActivatedByJump;
var bool ActivatedByDuck;
var bool ActivatedByAltFire;
var bool ActivatedByFire;
var bool bMirrored;
var vector tV;

var InventoryAttachment HookMec;  // Used for rope visual
var InventoryAttachment HookHarn; // Used for rope visual
var float HookSpring;             // -//-, make the hookmec move up/down if going up/down
var float HookMecRot;             // -//-, make the hookmec rotate according to movement
var float HookMecPrep;            // -//-, make the hookmec go out smoothly when activated

//var localized string sHooked, sHookUp, sHookDown;

CONST DBHook=false;

//_____________________________________________________________________________
Static function StaticParseDynamicLoading(LevelInfo MyLI)
{
    Log("Hook StaticParseDynamicLoading class="$default.class);
    Super.StaticParseDynamicLoading(MyLI);
    MyLI.ForcedMeshes[MyLI.ForcedMeshes.Length] =
      Mesh(DynamicLoadObject(default.MeshName, class'mesh'));
    MyLI.ForcedStaticMeshes[MyLI.ForcedStaticMeshes.Length] =
      StaticMesh(DynamicLoadObject("MeshArmesPickup.Grappin_harnais", class'StaticMesh'));
    MyLI.ForcedStaticMeshes[MyLI.ForcedStaticMeshes.Length] =
      StaticMesh(DynamicLoadObject("MeshArmesPickup.Grappin_moulinet", class'StaticMesh'));
}

//_____________________________________________________________________________
// ELR Add displayfov and bWeaponMode
simulated event RenderOverlays( canvas Canvas )
{
    if ( bRendered && bHidden )
    {
      bHidden = false;
      RefreshDisplaying();
    }

    if ( !XIIIPlayerController(Pawn(Owner).Controller).bWeaponMode )
    {
      if ( (Instigator == None) || (Instigator.Controller == None))
        return;
      SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
      SetRotation( Instigator.GetViewRotation() );
      SetBase(Pawn(Owner).Controller);
      DrawTargets(Canvas);
    }
}

/*
//_____________________________________________________________________________
// ELR
simulated function GetLinksCoords(out vector S1, out vector E1, out Vector S2, out Vector E2);
*/

//_____________________________________________________________________________
simulated function DrawTargets(Canvas C)
{
    if ( (XIIIPlayerController(Pawn(Owner).Controller).MyInteraction.TargetActor != none) && !XIIIPlayerController(Pawn(Owner).Controller).MyInteraction.TargetActor.bDeleteMe )
      PotHookPoint = HookPoint(XIIIPlayerController(Pawn(Owner).Controller).MyInteraction.TargetActor);
    else
      PotHookPoint = none;
//    if ( PotHookPoint != none )
//      Log("POTHOOK Radius"@PotHookPoint.CollisionRadius@"x"@PotHookPoint.CollisionHeight);
    if ( !IsInState('HookInUse') && (PotHookPoint == none) )
      OutlinePotentialTarget(C);
}

//_____________________________________________________________________________
// Used to reset coll size when releasing hook
function ResetPotentialTargets()
{
    local int i;
    local vector V;

    if ( PotentialHP.Length > 0 )
    {
      for (i=0;i<PotentialHP.Length;i++)
      {
        // Reset collision size of hookpoints
        PotentialHP[i].SetCollisionSize(PotentialHP[i].Default.CollisionRadius, PotentialHP[i].Default.CollisionHeight);
      }
    }
}

//_____________________________________________________________________________
simulated function OutlinePotentialTarget(Canvas C)
{
    local int i;
    local vector V, hitLoc, HitNorm;
    local material HitMat;
    local actor A;

    if ( PotentialHP.Length > 0 )
    {
      for (i=0;i<PotentialHP.Length;i++)
      {
        A = Trace(HitLoc, HitNorm,
          PotentialHP[i].Location, Location,
          false,
          vect(0,0,0),
          HitMat,
          TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon);
        if ( PotentialHP[i].bInteractive && (A == none)
        && ( vector(Pawn(Owner).Controller.Rotation) dot (PotentialHP[i].Location - Location) > 0.707 )
          )
        {
          // Try setting collision size of hookpoints to grow w/ distance to player
          PotentialHP[i].SetCollisionSize(
            Max(PotentialHP[i].Default.CollisionRadius, vSize(Location - PotentialHP[i].Location) / 500.0 * PotentialHP[i].Default.CollisionRadius),
            Max(PotentialHP[i].Default.CollisionHeight, vSize(Location - PotentialHP[i].Location) / 500.0 * PotentialHP[i].Default.CollisionHeight)
            );
          //
          V = XIIIPlayerController(Pawn(Owner).Controller).Player.Console.WorldToScreen(PotentialHP[i].Location);
          C.SetPos(V.X - PotHookIcon.USize/4.0, V.Y - PotHookIcon.VSize/4.0);
          C.Style = ERenderStyle.STY_Alpha;
          if ( VSize(PotentialHP[i].Location - Pawn(Owner).Location) + 50.0 > PotentialHP[i].RopeLength )
            C.SetDrawColor(255,0,0,255);
          else
            C.SetDrawColor(255,255,255,255);
//          C.DrawTile(PotHookIcon, PotHookIcon.USize, PotHookIcon.VSize, 0, 0, PotHookIcon.USize, PotHookIcon.VSize);
          C.DrawIcon(PotHookIcon, 0.5);
//          Log("Potential HP target="$PotentialHP[i]);
        }
      }
    }
}

//_____________________________________________________________________________
simulated function InitPotentialTargets()
{
    local HookPoint HP;

    PotentialHP.Length = 0; // Clean Array
    foreach AllActors(class'HookPoint', HP)
      if ( HP != none )
      {
        PotentialHP.Length = PotentialHP.Length + 1;
        PotentialHP[PotentialHP.Length - 1] = Hp;
      }
}

//_____________________________________________________________________________
Simulated function UseMe()
{
//    if ( TryHooking() )
    if ( DBHook ) log(self@"UseMe, PotHookPoint="$PotHookPoint);

    if ( PotHookPoint != none )
    {
      HookPoint = PotHookPoint.Location;
      PotHookPoint.SetCollisionSize(PotHookPoint.Default.CollisionRadius/2.0, PotHookPoint.Default.CollisionHeight/2.0);
      HookLength = VSize(HookPoint - Pawn(Owner).Location) + 50.0;
      MaxHookLength = PotHookPoint.RopeLength;
      if ( MaxHookLength < HookLength ) // Too far away
        return;
//      log("    HookLength="$HookLength@"MaxHookLength="$MaxHookLength);

//      MyHook=Spawn(class'HookProjectile',,, Owner.Location + Instigator.CalcDrawOffset(self),Rotator(HookPoint-Location));
//    PlayerViewOffset=(X=5.00,Y=6.00,Z=-5.80)
      PlayerViewOffset = vect(8.0, 4.0, -5.8);
      MyHook=Spawn(class'HookProjectile',,, Owner.Location + Instigator.CalcDrawOffset(self),Rotator(HookPoint-Location));
      PlayerViewOffset = default.PlayerViewOffset;
      if (MyHook != none)
      {
        MyHook.SetOwner(self);
        if ( MyLink != none )
          MyLink.ForceDestroy(); // erase old link
        MyLink = Spawn(class'HookLink',,, Owner.Location + Instigator.CalcDrawOffset(self),Rotator(HookPoint-Location));
        if (MyLink != none)
        {
          MyLink.HStart = self;
          MyLink.HEnd = MyHook;
          MyLink.LinkIndex = 0;
        }
        HookMecPrep = -1.0;
        if ( HookMec == none )
          HookMec = spawn(class'HookMecanismAttach');
        else
        {
          HookMec.bHidden = false;
          HookMec.RefreshDisplaying();
        }
        if ( HookHarn == none )
          HookHarn = spawn(class'HookHarnessAttach');
        else
        {
          HookHarn.bHidden = false;
          HookHarn.RefreshDisplaying();
        }


/*
        MyFHLink=Spawn(class'FreeHookLink',,, Owner.Location + Instigator.CalcDrawOffset(self),Rotator(HookPoint-Location));
        if ( MyFHLink != none )
        {
          MyFHLink.HStart=self;
          MyFHLink.HEnd=MyHook;
          MyFHLink.LinkIndex = 0;
        }
*/
      }
      PlayRolloffSound(hHookFireSound, self);
      XIIIPawn(Owner).GoHooking(self);
      SetTimer(0.25, false);
      bHooked = true;
      ActivatedByAltFire = false;
      if ( !ActivatedByFire && (Pawn(Owner).Physics == PHYS_Falling) )
        ActivatedByJump = true; // else we will go down non-stop until surface
      else
        ActivatedByJump = false;
      ActivatedByDuck = false;
      bGoUp = false;
      PlayUsing();
      GotoState('HookInUse');
      if ( ActivatedByFire ) // after gotostate to change bGoDown to true
        bGoDown = true;
      else
        bGodown = false;
    }
}

//_____________________________________________________________________________
// Onyl used while active
function Release()
{
}

//_____________________________________________________________________________
event Destroyed()
{
    Super.Destroyed();
    if ( DBHook ) log(self$" Destroyed");
    if (MyHook != none)
      MyHook.Destroy();
    if (MyLink != none)
      MyLink.Destroy();
    if ( HookMec != none )
      HookMec.Destroy();
    if ( HookHarn != none )
      HookHarn.Destroy();
}

//_____________________________________________________________________________
state Activated
{
    simulated function BeginState()
    {
      Instigator = Pawn(Owner);
      if ( DBHook ) Log(">>> Activated BeginState for "$self@"AnimState="$AnimState);
      PlaySelect();
      InitPotentialTargets();
      bRendered = true;
//      bHidden = false;
//      RefreshDisplaying();
      bChangeItem = false;
    }
}

//_____________________________________________________________________________
state Idle
{
    simulated function BeginState()
    {
      if ( DBHook ) Log(">>> Idle BeginState for "$self@"AnimState="$AnimState);
    }
    function Activate()
    {
      if ( DBHook ) Log("  > Idle Activate for "$self);
      UseMe();
    }
    simulated function AnimEnd(int Channel)
    {
      if ( DBHook ) Log("  > Idle AnimEnd for "$self@"AnimState="$AnimState);
      if (Charge <= 0)
      {
        UsedUp();
        return;
      }
      if ( bChangeItem )
      {
        GotoState('DownItem');
        return;
      }
      if (AnimState == 3)
      {
        PlaySelect();
        AnimState = 0;
      }
      else
        PlayIdle();
    }
    event EndState()
    {
      ResetPotentialTargets();
    }
}

//_____________________________________________________________________________
// In Use
state HookInUse
{
    function BeginState()
    {
      if ( DBHook ) Log(">>> HookInUse BeginState for "$self@"Instigator="$Instigator);
      bGoUp = false;
      bGoDown = false;
      disable('Tick');
    }
    function EndState()
    {
    }

    simulated function AnimEnd(int Channel)
    {
      if ( DBHook ) Log("  > HookInUse AnimEnd AnimState="$AnimState);
      if ( bChangeItem )
      {
        bChangeItem = false;
        GotoState('DownHookInUse');
        return;
      }
      if ( AnimState == 1 )
      {
        PlaySelect();
        AnimState = 2;
      }
      else
      {
        if ( (AnimState == 2) && bGoUp )
          PlayClimbUp();
        else
          PlayIdle();
        AnimState = 0;
      }
    }

    function ReduceRopeLength(float DT)
    {
      if ( HookLength>150 )
      {
        HookLength = vSize(HookPoint - Pawn(Owner).Location); // don't allow teleports
        HookLength -= (DT * HookUpSpeed);
        if ( HookLength<150 ) HookLength = 150;
      }
//      if ( DBHook ) log(" reduce HookLength="$HookLength@"DT="$DT);
    }
    function IncreaseRopeLength(float DT)
    {
      if ( (HookLength<(100+vSize(HookPoint - Pawn(Owner).Location))) && (HookLength < MaxHookLength) )
      {
        HookLength += (DT * HookDownSpeed);
        if (HookLength > MaxHookLength) HookLength = MaxHookLength;
      }
//      if ( DBHook ) log(" increase HookLength="$HookLength@"DT="$DT);
    }

    function Release()
    {
      if ( DBHook ) log(self$" Released");
      if (MyHook != none)
        MyHook.Destroy();
      if (MyLink != none)
        MyLink.ShouldDestroy();
/*
      if (MyFHLink != none)
        MyFHLink.Destroy();
*/
      Disable('tick');
      GoToState('Idle');
      StopSound(hHookMoveSound);
      PlayRolloffSound(hHookReleaseSound,self);
      if (AnimState != 0)
        TweenDown();
      else
        PlayDown();
      bHooked = false;
      XIIIPlayerController(Instigator.Controller).bHooked = false;
      bGoUp = false;
      bGoDown = false;
    }

    function Activate()
    {
      if ( DBHook ) log(self$" Activated in state HookInUse");
      SetTimer(0.25, false);
      PlaySound(hHookClik);
    }

    function Tick(float DeltaTime)
    {
      local vector V1,V2;

      if ( (Pawn(Owner).Physics==PHYS_Walking) || (Pawn(Owner).Physics == PHYS_Swimming) )
      {
        if ( bGoDown )
        {
          bGoDown = false;
          disable('tick');
//          ItemName = sHooked;
          ActivatedByJump=false;
          ActivatedByDuck=false;
          ActivatedByFire=false;
          ActivatedByAltFire=false;
        }
      }
      else if ( (Pawn(Owner).Physics != PHYS_Falling) && (Pawn(Owner).Physics != PHYS_Swimming) )
      {
        Release();
        return;
      }
      if ( (XIIIPlayerController(Pawn(Owner).controller).bWeaponMode) || (Pawn(Owner).SelectedItem != self) )
      {
        bGoUp = false;
        bGoDown = false;
        disable('tick');
//        ItemName = sHooked;
        ActivatedByJump=false;
        ActivatedByDuck=false;
        ActivatedByFire=false;
        ActivatedByAltFire=false;
      }

//      log(self$" Tick w/ bGoUp="$bGoUp$" bGoDown="$bGoDown);
      if ( bGoUp )
      {
        if ( (ActivatedByFire && Pawn(Owner).PressingFire()) || (ActivatedByJump && (XIIIPlayercontroller(Pawn(Owner).Controller).bAltJump > 0.0)) )
        {
          ReduceRopeLength(DeltaTime);
          if ( HookLength == 150 )
          {
            // Should try to climb there
            if ( (PotHookPoint != none) && (PotHookPoint.ClimbableHookNavPoint != none) )
            {
              V1 = PotHookPoint.ClimbableHookNavPoint.location - HookPoint;
              V1.Z = 0.0;
              V2 = Pawn(Owner).location - HookPoint;
              V2.Z = 0.0;
              if ( V1 dot V2 < 0.0 )
              {
//                log("PotHookPoint="$PotHookPoint$" HookNavPoint="$PotHookPoint.ClimbableHookNavPoint);
                Release();
                XIIIPlayerController(Pawn(Owner).controller).GoClimbHookNavPoint(PotHookPoint, PotHookPoint.ClimbableHookNavPoint);
              }
            }
//            else
//              log("PotHookPoint="$PotHookPoint$" no HookNavPoint, Not climbing");
          }
        }
        else
        { // stop going up as no more order is given
          bGoUp = false;
          bGoDown = false;
          disable('tick');
//          ItemName = sHooked;
          StopSound(hHookMoveSound);
          PlayRolloffSound(hHookEndSound, self);
          PlaySound(hHookClik);
          PlayStop();
          ActivatedByJump=false;
          ActivatedByDuck=false;
          ActivatedByFire=false;
          ActivatedByAltFire=false;
        }
      }
      else if ( bGoDown )
      {
//        log("Tick ActivatedByDuck="$ActivatedByDuck@"bAltDuck="$XIIIPlayerController(Pawn(Owner).controller).bAltDuck);
        if ( (ActivatedByAltFire && !Pawn(Owner).PressingAltFire()) || (ActivatedByDuck && (XIIIPlayerController(Pawn(Owner).controller).bAltDuck == 0.0)) )
        { // stop going down as no more order is given
          bGoUp = false;
          bgoDown = false;
          disable('Tick');
//          ItemName = sHooked;
          StopSound(hHookMoveSound);
          PlayRolloffSound(hHookEndSound, self);
          PlaySound(hHookClik);
          ActivatedByJump=false;
          ActivatedByDuck=false;
          ActivatedByFire=false;
          ActivatedByAltFire=false;
        }
        else
          IncreaseRopeLength(DeltaTime);
      }
      else
      {
        disable('Tick');
//        ItemName = sHooked;
        StopSound(hHookMoveSound);
        PlayRolloffSound(hHookEndSound, self);
        PlaySound(hHookClik);
//        ActivatedByJump=false;
//        ActivatedByDuck=false;
//        ActivatedByFire=false;
//        ActivatedByAltFire=false;
      }
    }

    function Timer()
    {
      if ( DBHook ) log(self$" timer Going UP/Down"@bGoUp@bGoDown@"Activated by Fire="$ActivatedByFire@"Duck="$ActivatedByDuck@"Jump="$ActivatedByJump@"AltFire="$ActivatedByAltFire);
      if ( (ActivatedByFire && Pawn(Owner).PressingFire()) || (ActivatedByJump && (XIIIPlayercontroller(Pawn(Owner).Controller).bAltJump > 0.0)) )
      { // order is given to go up
        if ( bGoDown )
        {
          StopSound(hHookMoveSound);
          PlayRolloffSound(hHookEndSound, self);
        }
        if ( DBHook ) log(self$" checking climbing, goin'up");
        bGoUp = true;
        bGoDown = false;
//        ItemName = sHookUp;
        enable('tick');
        PlayClimbUp();
        PlayRolloffSound(hHookMoveSound, self);
        ActivatedByDuck=false;
        ActivatedByAltFire=false;
      }
      else if ( (ActivatedByAltFire && Pawn(Owner).PressingAltFire()) || (ActivatedByDuck && (XIIIPlayercontroller(Pawn(Owner).Controller).bAltDuck > 0.0)) )
      { // order is given to go Down
        if ( bGoUp )
        {
          StopSound(hHookMoveSound);
          PlayRolloffSound(hHookEndSound, self);
        }
        if ( DBHook ) log(self$" checking climbing, goin'down");
        Enable('tick');
//        ItemName = sHookDown;
        bGoUp = false;
        bGoDown = true;
        PlayClimbDown();
        PlayRolloffSound(hHookMoveSound, self);
        ActivatedByJump=false;
        ActivatedByFire=false;
      }
      else if ( !ActivatedByJump || ActivatedByFire )
      {
        if ( bGoDown )
        {
          if ( DBHook ) log(self$" checking climbing, stop goin'down");
          Disable('tick');
          bGoUp = false;
          bGoDown = false;
//          ItemName = sHooked;
          StopSound(hHookMoveSound);
          PlayRolloffSound(hHookEndSound, self);
          PlayClimbDown();
          ActivatedByJump=false;
          ActivatedByDuck=false;
        }
        else
        {
          if ( DBHook ) log(self$" checking climbing, goin'down");
          Enable('tick');
//          ItemName = sHookDown;
          bGoUp = false;
          bGoDown = true;
          PlayClimbDown();
          PlayRolloffSound(hHookMoveSound, self);
          ActivatedByJump=false;
        }
      }
      else // activated by jump but jump released
      {
        Disable('tick');
        bGoUp = false;
        bGoDown = false;
//        ItemName = sHooked;
        StopSound(hHookMoveSound);
        PlayRolloffSound(hHookEndSound, self);
        PlayClimbDown();
        ActivatedByJump=false;
        ActivatedByDuck=false;
      }
    }
}

//_____________________________________________________________________________
// In Use but down
state DownHookInUse
{
    simulated function BeginState()
    {
      if ( DBHook ) Log(">>> DownHookInUse BeginState for "$self@"AnimState="$AnimState);
      StopSound(hHookMoveSound);
      bGoUp = false;
      bGoDown = false;
      AnimState = 0;
      PlayDown();
//      EndUse();
    }

    simulated function AnimEnd(int Channel)
    {
      if ( DBHook ) Log(">>> DownHookInUse AnimEnd for "$self@"AnimState="$AnimState);
      bChangeItem = false;
      if ( bHooked )
        GotoState('IdleHookInUse');
      else
        GotoState('');
      Pawn(Owner).ChangedWeapon();
    }

    simulated function Activate() {}

    function Release()
    { // Released while going down
      if ( DBHook ) log(self$" Released in state DownHookInUse");
      if (MyHook != none)
        MyHook.Destroy();
      if (MyLink != none)
        MyLink.ShouldDestroy();
      Disable('tick');
//      GotoState('Down');
      StopSound(hHookMoveSound);
      PlayRolloffSound(hHookReleaseSound, self);
      bHooked = false;
      XIIIPlayerController(Instigator.Controller).bHooked = false;
      bGoUp = false;
      bGoDown = false;
      AnimState = 0;
    }
}

//_____________________________________________________________________________
// In Use but down
state IdleHookInUse
{
    simulated event BeginState()
    {
      if ( DBHook ) Log(">>> IdleHookInUse BeginState for "$self@"AnimState="$AnimState);
    }

    function Release()
    { // Released while down
      if ( DBHook ) log(self$" Released in state DownHookInUse");
      if (MyHook != none)
        MyHook.Destroy();
      if (MyLink != none)
        MyLink.ShouldDestroy();
/*
      if (MyFHLink != none)
        MyFHLink.Destroy();
*/
      Disable('tick');
//      bChangeItem = true;
      GoToState('DownItemRopeCut');
      StopSound(hHookMoveSound);
      PlayRolloffSound(hHookReleaseSound, self);
/*      if (AnimState != 0)
        TweenDown();
      else
        PlayDown(); */
      bHooked = false;
      XIIIPlayerController(Instigator.Controller).bHooked = false;
      bGoUp = false;
      bGoDown = false;
      AnimState = 0;
    }

    simulated function BringUp()
    {
      if( bActivatable )
      {
        if ( (Level.Game != none) && (Level.Game.StatLog != None) )
          Level.Game.StatLog.LogItemActivate(Self, Pawn(Owner));
        GoToState('ActivatedHookInUse');
      }
    }
    simulated function Activate() {}
}

//_____________________________________________________________________________
state ActivatedHookInUse
{
    simulated function BeginState()
    {
      Instigator = Pawn(Owner);
      if ( DBHook ) Log(">>> ActivatedHookInUse BeginState for "$self@"AnimState="$AnimState);
      PlaySelect();
    }

    simulated function AnimEnd(int Channel)
    {
      if ( DBHook ) Log("  > ActivatedHookInUse AnimEnd bChangeItem="$bChangeItem);
      if ( bChangeItem )
      {
        GotoState('DownHookInUse');
        return;
      }
      PlayIdle();
      GotoState('HookInUse');
    }

    simulated function Activate() {}

    function Release()
    { // Released while down
      if ( DBHook ) log(self$" Released in state ActivatedHookInUse");
      if (MyHook != none)
        MyHook.Destroy();
      if (MyLink != none)
        MyLink.ShouldDestroy();
      Disable('tick');
      bHooked = false;
      XIIIPlayerController(Instigator.Controller).bHooked = false;
      bGoUp = false;
      bGoDown = false;
      AnimState = 0;
      GoToState('Activated');
      StopSound(hHookMoveSound);
      PlayRolloffSound(hHookReleaseSound, self);
    }
}

//_____________________________________________________________________________
state DownItemRopeCut
{
    simulated function BeginState()
    {
      if ( DBHook ) Log(">>> DownItemRopeCut BeginState for "$self@"AnimState="$AnimState);
//      PlayDown(); // Don't play anim
      AnimState = 0;
      EndUse();
    }

    simulated function AnimEnd(int Channel)
    {
      if ( DBHook ) Log("  > DownItem AnimEnd");
      bChangeItem = false;
      GotoState('');
//      Pawn(Owner).ChangedWeapon();
      if ( (Pawn(Owner).SelectedItem != self) || XIIIPlayerController(Pawn(Owner).Controller).bWeaponMode )
      {
        bRendered = false;
        bHidden = true;
        RefreshDisplaying();
      }
    }

    simulated function Activate() {}
}

//_____________________________________________________________________________
simulated function PlaySelect()
{
    if ( DBHook ) Log(self@"PlaySelect, bHooked="$bHooked);
    if ( bHooked )
    {
      if ( !bMirrored )
      {
        PlayerViewOffset.y = - default.PlayerViewOffset.y;
        tV = default.DrawScale3D;
        tV.x *= -1.0;
        SetDrawScale3D(tV);
        bMirrored = true;
        RefreshDisplaying();
      }
      PlayAnim('SelectCommande',1.0);
    }
    else
    {
      if ( bMirrored )
      {
        PlayerViewOffset.y = default.PlayerViewOffset.y;
        tV = default.DrawScale3D;
        SetDrawScale3D(tV);
        bMirrored = false;
        RefreshDisplaying();
      }
      PlayAnim('Select',1.0);
      PlayRolloffSound(hSelectItemSound, self);
    }
}

//_____________________________________________________________________________
simulated function PlayDown()
{
    if ( DBHook ) Log(self@"PlayDown, bHooked="$bHooked@"AnimState="$AnimState);
    if ( bHooked )
    {
      if ( AnimState == 1 )
      {
        if ( bMirrored )
        {
          PlayerViewOffset.y = default.PlayerViewOffset.y;
          tV = default.DrawScale3D;
          SetDrawScale3D(tV);
          bMirrored = false;
          RefreshDisplaying();
        }
        PlayAnim('Down',1.0);
      }
      else
      {
        if ( !bMirrored )
        {
          PlayerViewOffset.y = - default.PlayerViewOffset.y;
          tV = default.DrawScale3D;
          tV.x *= -1.0;
          SetDrawScale3D(tV);
          bMirrored = true;
          RefreshDisplaying();
        }
        PlayAnim('DownCommande',1.0);
        AnimState = 3;
      }
    }
    else
    {
      if ( bMirrored )
      {
        PlayerViewOffset.y = default.PlayerViewOffset.y;
        tV = default.DrawScale3D;
        SetDrawScale3D(tV);
        bMirrored = false;
        RefreshDisplaying();
      }
      PlayAnim('Down', 1.0);
    }
}

//_____________________________________________________________________________
simulated function TweenDown()
{
    if ( DBHook ) Log(self@"TweenDown, bHooked="$bHooked@"AnimState="$AnimState);
    if ( AnimState == 1 )
    {
      bHooked = false;
      XIIIPlayerController(Instigator.Controller).bHooked = false;
      PlaySelect();
      AnimState = 0;
    }
    else
    {
      if ( !bMirrored )
      {
        PlayerViewOffset.y = - default.PlayerViewOffset.y;
        tV = default.DrawScale3D;
        tV.x *= -1.0;
        SetDrawScale3D(tV);
        bMirrored = true;
        RefreshDisplaying();
      }
      PlayAnim('DownCommande',3.0,0.2);
      AnimState = 3;
    }
}

//_____________________________________________________________________________
simulated function PlayIdle()
{
    if ( DBHook ) Log(self@"PlayIdle, bHooked="$bHooked);
    if ( bHooked )
    {
      if ( !bMirrored )
      {
        PlayerViewOffset.y = - default.PlayerViewOffset.y;
        tV = default.DrawScale3D;
        tV.x *= -1.0;
        SetDrawScale3D(tV);
        bMirrored = true;
        RefreshDisplaying();
      }
      PlayAnim('WaitCommande',1.0);
    }
    else
    {
      if ( bMirrored )
      {
        PlayerViewOffset.y = default.PlayerViewOffset.y;
        tV = default.DrawScale3D;
        SetDrawScale3D(tV);
        bMirrored = false;
        RefreshDisplaying();
      }
      PlayAnim('Wait', 1.0);
    }
}

//_____________________________________________________________________________
simulated function PlayUsing()
{
    if ( DBHook ) Log(self@"PlayUsing");
    if ( bMirrored )
    {
      PlayerViewOffset.y = default.PlayerViewOffset.y;
      tV = default.DrawScale3D;
      SetDrawScale3D(tV);
      bMirrored = false;
      RefreshDisplaying();
    }
    PlayAnim('Fire', 2.0);
    AnimState = 1;
}
//_____________________________________________________________________________
simulated function PlayClimbUp()
{
    if ( AnimState == 1 ) // hook has been fired
      return;
    if ( DBHook ) Log(self@"PlayClimbUp");
    if ( !bMirrored )
    {
      PlayerViewOffset.y = - default.PlayerViewOffset.y;
      tV = default.DrawScale3D;
      tV.x *= -1.0;
      SetDrawScale3D(tV);
      bMirrored = true;
      RefreshDisplaying();
    }
    if ( AnimState == 0 )
      PlayAnim('ClimbUp', 2.0);
}
//_____________________________________________________________________________
simulated function PlayClimbDown()
{
    if ( AnimState == 1 ) // hook has been fired
      return;
    if ( DBHook ) Log(self@"PlayClimbDown");
    if ( !bMirrored )
    {
      PlayerViewOffset.y = - default.PlayerViewOffset.y;
      tV = default.DrawScale3D;
      tV.x *= -1.0;
      SetDrawScale3D(tV);
      bMirrored = true;
      RefreshDisplaying();
    }
    if ( AnimState == 0 )
      PlayAnim('ClimbDown', 2.0);
}
//_____________________________________________________________________________
simulated function PlayStop()
{
    if ( DBHook ) Log(self@"PlayStop");
    if ( !bMirrored )
    {
      PlayerViewOffset.y = - default.PlayerViewOffset.y;
      tV = default.DrawScale3D;
      tV.x *= -1.0;
      SetDrawScale3D(tV);
      bMirrored = true;
      RefreshDisplaying();
    }
    PlayAnim('Stop', 2.0);
}

/*
    sHooked="Hook (Hooked)"
    sHookUp="Hook (Up)"
    sHookDown="Hook (Down)"
*/


defaultproperties
{
     HookUpSpeed=150.000000
     HookDownSpeed=300.000000
     PotHookIcon=Texture'XIIIMenu.HUD.Hand_GrapplePoint'
     hHookMoveSound=Sound'XIIIsound.SpecActions.HookMov'
     hHookEndSound=Sound'XIIIsound.SpecActions.HookEnd'
     hHookFireSound=Sound'XIIIsound.SpecActions.HookFire'
     hHookReleaseSound=Sound'XIIIsound.SpecActions.HookLet'
     hHookClik=Sound'XIIIsound.SpecActions.HookClick'
     MeshName="XIIIArmes.FpsGrappinM"
     CrossHair=Texture'XIIIMenu.HUD.MireGrappin'
     IHand=IH_2H
     hSelectItemSound=Sound'XIIIsound.SpecActions.HookSel'
     IconNumber=21
     sItemName="Hook"
     bCanHaveMultipleCopies=True
     bAutoActivate=True
     bActivatable=True
     ExpireMessage="Hook was used."
     InventoryGroup=5
     bDisplayableInv=True
     PickupClassName="XIII.HookPick"
     Charge=1
     PlayerViewOffset=(X=5.000000,Y=6.000000,Z=-5.800000)
     BobDamping=0.975000
     ItemName="HOOK"
}
