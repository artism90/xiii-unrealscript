//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIItems extends Powerups;

// Inventory Groups :
// 0 = Medkit
// 1 = FulMedKit
// 2 = spec medkits (plage/beach)
// 3 = Lockpick
// 4 | 7 = Keys
// 5 = Hook
// 6 = Photo
// 8 = Micro
// 10-11 = Event Items

var string MeshName;      // to allow dynamic load of mesh (optimize memory)
var float DisplayFOV;     // FOV for drawing the items
var texture CrossHair;    // Crosshair when using item
var enum eItemHand
{
  IH_1H,
  IH_2H,
} IHand;

var() sound hSelectItemSound;
var() sound hDownItemSound;
var() name EventCausedOnPick;

var texture ZCrosshair;             // texture to use for Zoomed Crosshair
var texture ZCrosshairDot;          // texture to use for Zoomed Crosshair (the dot)
var bool bChangeItem;               // To switch items/weapons
var bool bDrawZoomedCrosshair;
var bool bNumberedItem;             // to display number of charges in HUD
var bool bRendered;                 // to avoid fps item rendered before renderoverlays w/ right position

var int IconNumber;       // to display using the global texture instead of singular icons
var travel localized string sItemName;

//_____________________________________________________________________________
Static function StaticParseDynamicLoading(LevelInfo MyLI)
{
    Log("XIIIItems StaticParseDynamicLoading class="$default.class);
    Super.StaticParseDynamicLoading(MyLI);
    MyLI.ForcedMeshes[MyLI.ForcedMeshes.Length] =
      Mesh(DynamicLoadObject(default.MeshName, class'mesh'));
}

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
    // Dynamic load mesh
    if ( (Mesh == none) && (MeshName != "") )
    {
      Mesh = SkeletalMesh(DynamicLoadObject(MeshName, class'mesh'));
      default.mesh = mesh;
    }
    // Dynamic load Attachment Static Mesh if exists
    if ( (AttachmentClass != none) && (class<XIIIWeaponAttachment>(AttachmentClass) != none) && (class<XIIIWeaponAttachment>(AttachmentClass).default.StaticMeshName != "") )
    {
      DynamicLoadObject(class<XIIIWeaponAttachment>(AttachmentClass).default.StaticMeshName, class'StaticMesh');
    }
    Super.PostBeginPlay();
    bRendered = false;
    bHidden = true;
    RefreshDisplaying();
    if ( sItemName != "" )
      ItemName = sItemName;
}

//_____________________________________________________________________________
// ELR Add displayfov and bWeaponMode
simulated event RenderOverlays( canvas Canvas )
{
//    DebugLog(Level.TimeSeconds@self$" RenderOverlays bDrawZoomedCrosshair="$bDrawZoomedCrosshair);

    if ( bRendered && bHidden )
    {
      bHidden = false;
      RefreshDisplaying();
    }

    if ( !XIIIPlayerController(Pawn(Owner).Controller).bWeaponMode || !XIIIPlayerController(Pawn(Owner).Controller).bWaitForWeaponMode )
    {
//      Log(self@"RenderOverlays Instigator="$Instigator@"Instigator.Controller="$Instigator.Controller);
//      if ( (Instigator == None) || (Instigator.Controller == None))
//        return;
      if ( bDrawZoomedCrosshair )
      {
        DrawZoomedCrosshair(Canvas);
      }
      else
      {
        SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
        SetRotation( Instigator.GetViewRotation() );
//        Canvas.DrawActor(self, false, true, displayFOV);
        SetBase(Pawn(Owner).Controller);
      }
//      DrawCrossHair(Canvas);
    }
}

//_____________________________________________________________________________
simulated function bool ShouldDrawCrosshair(Canvas C)
{
    return true;
}

//_____________________________________________________________________________
simulated function DrawZoomedCrosshair(Canvas C)
{
    local float XSize, YSize;
    local float fDrawScale;

    fDrawScale = XIIIBaseHud(XIIIPlayerController(Pawn(Owner).Controller).MyHud).fDrawScale;

    XSize = ZCrossHair.USize*fDrawScale;

    C.SetDrawColor(255,255,255,255);
    C.SetPos(0.50 * C.ClipX-0.5 - XSize, 0.50 * C.ClipY-0.5 - XSize);
    C.DrawTile(ZCrossHair, XSize, XSize, 0, 0,-ZCrossHair.USize, ZCrossHair.VSize);
//    C.SetPos(0.50 * C.ClipX-0.5, 0.50 * C.ClipY-0.5 - XSize);
    C.DrawTile(ZCrossHair, XSize, XSize, 0, 0,ZCrossHair.USize, ZCrossHair.VSize);
    C.SetPos(0.50 * C.ClipX-0.5 - XSize, 0.50 * C.ClipY-0.5);
    C.DrawTile(ZCrossHair, XSize, XSize, 0, 0,-ZCrossHair.USize, -ZCrossHair.VSize);
//    C.SetPos(0.50 * C.ClipX-0.5, 0.50 * C.ClipY-0.5);
    C.DrawTile(ZCrossHair, XSize, XSize, 0, 0,ZCrossHair.USize, -ZCrossHair.VSize);
//    C.SetPos(0.50 * C.ClipX - XSize, 0.50 * C.ClipY);
//    C.DrawIcon(ZCrossHairReflet, fDrawScale);

    C.SetDrawColor(255,0,0,255);
    C.Style = ERenderStyle.STY_Alpha;
    C.SetPos(0.50 * C.ClipX - ZCrosshairDot.USize/2.0, 0.50 * C.ClipY - ZCrosshairDot.VSize/2.0);
    C.DrawIcon(ZCrosshairDot, 1.0);
    C.SetDrawColor(255,255,255,255);
    C.Style = ERenderStyle.STY_Alpha;
    YSize=0.5*C.ClipY - XSize;
    XSize=0.5*C.ClipX - XSize;
    // Left Part
    C.SetPos(0, 0);
    C.DrawTile(ZCrossHair, XSize-0.5, C.ClipY, 230, 2, 16, 16);
    // Up part
    C.SetPos(XSize-0.5, 0);
    C.DrawTile(ZCrossHair, C.ClipX - XSize*2.0, YSize-0.5, 230, 2, 16, 16);
    // Right Part
    C.SetPos(C.ClipX - XSize-0.5, 0);
    C.DrawTile(ZCrossHair, XSize+0.5, C.ClipY, 230, 2, 16, 16);
    //Down Part
    C.SetPos(XSize-0.5, C.ClipY - YSize-0.5);
    C.DrawTile(ZCrossHair, C.CLipX - XSize*2.0, YSize+0.5, 230, 2, 16, 16);

    bDrawZoomedCrosshair = false;
}

//_____________________________________________________________________________
// ELR Add some info to the ShowDebug Exec
simulated function DisplayDebug(Canvas C, out float YL, out float YPos)
{
    local string S;
    local name anim;
    local float frame,rate;

    C.DrawText("SELECTED ITEM="$self@"Event="$Event@"TAG="$Tag);
    YPos += YL;
    C.SetPos(4,YPos);
//    C.DrawText("     in state="$getStateName());
    C.DrawText("     STATE: "$GetStateName()$" Timer: "$TimerCounter@"bChangeItem: "$bChangeItem, false);
    YPos += YL;
    C.SetPos(4,YPos);
    GetAnimParams(0,Anim,frame,rate);
    S = "     AnimSequence "$Anim$" Frame "$frame$" Rate "$rate;
    C.DrawText(S);
    YPos += YL;
    C.SetPos(4,YPos);
}

//_____________________________________________________________________________
simulated function AttachToPawn(Pawn P)
{
    local name BoneName;

    if ( ThirdPersonActor == None )
    {
      ThirdPersonActor = Spawn(AttachmentClass,Owner);
      InventoryAttachment(ThirdPersonActor).InitFor(self);
    }
    BoneName = XIIIPawn(P).GetItemBoneFor(self);
    if ( BoneName == '' )
    {
      ThirdPersonActor.SetLocation(P.Location);
      ThirdPersonActor.SetBase(P);
    }
    else
      P.AttachToBone(ThirdPersonActor,BoneName);

    ThirdPersonActor.SetRelativeLocation(ThirdPersonRelativeLocation);
    ThirdPersonActor.SetRelativeRotation(ThirdPersonRelativeRotation);
}

//_____________________________________________________________________________
// Find the next Item (using the Inventory group)
simulated function PowerUps PrevItem(PowerUps CurrentChoice, PowerUps CurrentItem)
{
    local bool bAllow2H;

    DebugLog(self@"PrevItem, Inventory="$Inventory@"CurrentChoice="$CurrentChoice);

    if ( (XIIIPawn(Owner).LHand != none) && XIIIPawn(Owner).LHand.bActive )
      bAllow2H = false;
    else
      bAllow2H = true;

    if ( bDisplayableInv && bActivatable && ((IHand != IH_2H) || bAllow2H) )
    {
      if ( (CurrentChoice == None) )
      {
        if ( CurrentItem == none )
        {
          CurrentItem = self;
          CurrentChoice = self;
        }
        else if ( CurrentItem != self )
          CurrentChoice = self;
      }
      else if ( InventoryGroup == CurrentChoice.InventoryGroup )
      {
        if ( InventoryGroup == CurrentItem.InventoryGroup )
        {
          if ( (GroupOffset < CurrentItem.GroupOffset)
            && (GroupOffset > CurrentChoice.GroupOffset) )
            CurrentChoice = self;
        }
        else if ( GroupOffset > CurrentChoice.GroupOffset )
          CurrentChoice = self;
      }
      else if ( InventoryGroup > CurrentChoice.InventoryGroup )
      {
        if ( (InventoryGroup < CurrentItem.InventoryGroup)
          || (CurrentChoice.InventoryGroup > CurrentItem.InventoryGroup) )
        CurrentChoice = self;
      }
      else if ( (CurrentChoice.InventoryGroup > CurrentItem.InventoryGroup)
        && (InventoryGroup < CurrentItem.InventoryGroup) )
        CurrentChoice = self;
    }
    if ( Inventory == None )
      return CurrentChoice;
    else
      return Inventory.PrevItem(CurrentChoice,CurrentItem);
}

//_____________________________________________________________________________
// Find the next Item (using the Inventory group)
simulated function PowerUps NextItem(PowerUps CurrentChoice, PowerUps CurrentItem)
{
    local bool bAllow2H;

    DebugLog(self@"NextItem, Inventory="$Inventory@"CurrentChoice="$CurrentChoice);
    if ( (XIIIPawn(Owner).LHand != none) && XIIIPawn(Owner).LHand.bActive )
      bAllow2H = false;
    else
      bAllow2H = true;

    if ( bDisplayableInv && bActivatable && ((IHand != IH_2H) || bAllow2H) )
    {
      if ( (CurrentChoice == None) )
      {
        if ( CurrentItem == none )
        {
          CurrentItem = self;
          CurrentChoice = self;
        }
        else if ( CurrentItem != self )
          CurrentChoice = self;
      }
      else if ( InventoryGroup == CurrentChoice.InventoryGroup )
      {
        if ( InventoryGroup == CurrentItem.InventoryGroup )
        {
          if ( (GroupOffset > CurrentItem.GroupOffset)
            && (GroupOffset < CurrentChoice.GroupOffset) )
            CurrentChoice = self;
        }
        else if ( GroupOffset < CurrentChoice.GroupOffset )
          CurrentChoice = self;
      }
      else if ( InventoryGroup < CurrentChoice.InventoryGroup )
      {
        if ( (InventoryGroup > CurrentItem.InventoryGroup)
          || (CurrentChoice.InventoryGroup < CurrentItem.InventoryGroup) )
        CurrentChoice = self;
      }
      else if ( (CurrentChoice.InventoryGroup < CurrentItem.InventoryGroup)
        && (InventoryGroup > CurrentItem.InventoryGroup) )
        CurrentChoice = self;
    }
    if ( Inventory == None )
      return CurrentChoice;
    else
      return Inventory.NextItem(CurrentChoice,CurrentItem);
}

/*
//_____________________________________________________________________________
// Select first activatable powerup.
function Powerups SelectNext()
{
    local inventory I;
    local int CurrentItemIndex , ItemNumber ;
    local PowerUps NextItem;
    local XIIIItems XI;
    local XIIIItems CurrentXItem, TempItem;
    local bool FirstTime, FirstMed;
    local bool bAllow2H;

    ItemNumber = 0;
    I = Pawn(Owner).Inventory;
    NextItem = none;

    CurrentXItem = XIIIItems(Pawn(Owner).SelectedItem);
    if ( (XIIIPawn(Owner).LHand != none) && XIIIPawn(Owner).LHand.bActive )
      bAllow2H = false;
    else
      bAllow2H = true;

//    log(" ");
//    Log("----------------------------------------------");
//    Log("SelectedItem="@CurrentXItem);
//    Log("PendingItem="@Pawn(Owner).PendingItem);

    if( Pawn(Owner).PendingItems == none )
    {
        if( XIIIPlayerController(Pawn(Owner).Controller).bHooked )
        { // changing from weapons to items while hooked will bring back hook
          I = Pawn(Owner).Inventory;
          while ( I != none )
          {
            XI = XIIIItems(I);
            if ( (XI != none) && I.bDisplayableInv && XI.bActivatable && (bAllow2H || (IHand != IH_2H)))
            {
              if( XI.InventoryGroup == 4 ) // diff if here
              {
                CurrentXItem = XI;
                break;
              }
            }
            I = I.Inventory;
          }
          if ( CurrentXItem != none )
            FirstMed = true;
          FirstTime = true;
        }
        else
        { // change from weapons to items bring back medicine
          I = Pawn(Owner).Inventory;
          while ( I != none )
          {
            XI = XIIIItems(I);
            if ( (XI != none) && I.bDisplayableInv && XI.bActivatable && (bAllow2H || (IHand != IH_2H)) )
            {
              if( XI.InventoryGroup == 0 )
              {
                CurrentXItem = XI;
                break;
              }
              else if( XI.InventoryGroup == 1 )
                CurrentXItem = XI;
            }
            I = I.Inventory;
          }
          if ( CurrentXItem != none )
            FirstMed = true;
          FirstTime = true;
        }
    }
    else if( XIIIItems(Pawn(Owner).PendingItems) != XIIIItems(Pawn(Owner).SelectedItem) )
      CurrentXItem = XIIIItems(Pawn(Owner).PendingItems);

    if ( (CurrentXItem == none) && bActivatable )
      CurrentXItem = self;

    if ( CurrentXItem != none )
      CurrentItemIndex = CurrentXItem.InventoryGroup;
    else
      CurrentItemIndex = -1;

    if( ! FirstMed )
    {
      I = Pawn(Owner).Inventory;
      while ( I != none )
      {
        XI = XIIIItems(I);
        if ( (XI != none) && I.bDisplayableInv && XI.bActivatable && (bAllow2H || (IHand != IH_2H)) )
        {
          if( XI.InventoryGroup > CurrentItemIndex )
          {
            if( NextItem == none )
              NextItem = XI;
            else if( XI.InventoryGroup < NextItem.InventoryGroup )
              NextItem = XI;
          }
          ItemNumber++;
        }
        I = I.Inventory;
      }

      if( ( NextItem == none ) && ( ItemNumber > 0 ) )
      {
        I = Pawn(Owner).Inventory;
        CurrentItemIndex = 9999;
        while ( I != none )
        {
          XI = XIIIItems(I);
          if ( (XI != none) && I.bDisplayableInv && XI.bActivatable && (bAllow2H || (IHand != IH_2H)) )
          {
            if( XI.InventoryGroup < CurrentItemIndex )
            {
              NextItem = XI;
              CurrentItemIndex = XI.InventoryGroup;
            }
            ItemNumber++;
          }
          I = I.Inventory;
        }
      }
    }

    if ( FirstMed )
      NextItem = CurrentXItem;
    if ( FirstTime )
      Pawn(Owner).SelectedItem = NextItem;
    Pawn(Owner).PendingItems = NextItem;

    return NextItem;
}
*/

//_____________________________________________________________________________
// ELR
function PickupFunction(Pawn Other)
{
    if ( bActivatable && Other.SelectedItem == None)
      Other.SelectedItem = self;
    if ( bActivatable && bAutoActivate && Other.bAutoActivate )
      Activate();
}

//_____________________________________________________________________________
// Give this inventory item to a pawn.
function GiveTo( pawn Other )
{
//    Log("GIVETO (inventory)"@self@"to"@Other);

	// cause event on pick
	if (EventCausedOnPick != 'none' )
        TriggerEvent(EventCausedOnPick,none,none );

	Super.GiveTo( Other );
}

//_____________________________________________________________________________
// Transfer this inventory to Player (for SearchCorpse)
function Transfer( pawn Other )
{
    local XIIIItems Dual;

//    Log("TRANSFER (inventory)"@self@"to"@Other);
    if ( Instigator != none )
    {
  		DetachFromPawn(Instigator);
      Instigator.DeleteInventory(self);
    }

    Dual = XIIIItems(Other.FindInventoryType(class));

    if ( Dual == none )
    {
      if ( PickupClass != none )
      {
        Other.PlaySound(PickupClass.default.PickupSound);
        Other.ReceiveLocalizedMessage( PickupClass.default.MessageClass, 0, None, None, PickupClass );
      }
      GiveTo(Other);
    }
    else
    {
      if ( PickupClass != none )
      {
        Other.PlaySound(PickupClass.default.PickupSound);
        Other.ReceiveLocalizedMessage( PickupClass.default.MessageClass, 0, None, None, PickupClass );
      }
      Dual.Charge += Charge;
      Destroy();
    }
}

//_____________________________________________________________________________
function Landed(Vector HitNormal)
{
    local Pickup P;
    local rotator newRot;

    SetDrawType(Default.DrawType);
    SetDrawScale(Default.DrawScale);
    NetPriority = Default.NetPriority;
    Mesh = Default.Mesh;
    bRendered = false;
    bHidden = true;
    RefreshDisplaying();
    newRot = Rotation;
    newRot.pitch = 0;
    bCollideWorld = false;
    SetRotation(newRot);
    P = Spawn(PickupClass);
    if ( P != None )
    {
      XIIIPickup(P).InvItemName = ItemName;
      P.RespawnTime = 0.0; // no respawning
      P.Inventory = self;
    }
    else
      Destroy();
}

//_____________________________________________________________________________
simulated function bool PutDown()
{
    DebugLog("GLOBAL PutDown for"@self);
    bChangeItem = true;
    return true;
}

//_____________________________________________________________________________
simulated function BringUp()
{
    DebugLog(">>> BringUp called for item"@self);

    if( bActivatable )
    {
      if ( (Level.Game != none) && (Level.Game.StatLog != None) )
        Level.Game.StatLog.LogItemActivate(Self, Pawn(Owner));
//      Log("  > BringUp sending item"@self@"in state 'Activated' from '"@GetStateName()$"'");
      GoToState('Activated');
//      Log("  > BringUp sent item"@self@"in state"@GetStateName());
      bRendered = true;
//      bHidden = false;
//      RefreshDisplaying();
    }
}

//_____________________________________________________________________________
// Toggle Activation of selected Item.
simulated function Activate()
{
//    Log("@@@ Activate call for"@self);
    if( bActivatable )
    {
      if (Level.Game.StatLog != None)
        Level.Game.StatLog.LogItemActivate(Self, Pawn(Owner));
      GoToState('Activated');
    }
}

//_____________________________________________________________________________
// ELR when in state activated & using
simulated function UseMe()
{
    Pawn(Owner).PendingItem = none;
}

//_____________________________________________________________________________
// ELR called in Beginstate of Downweapon
simulated function EndUse();

//_____________________________________________________________________________
// This is called when a usable inventory item has used up it's charge.
simulated function UsedUp()
{
//    Log("@@@ UsedUp for "$self);
    if ( Pawn(Owner) != None )
    {
      bActivatable = false;
      XIIIPlayercontroller(XIIIPawn(Owner).controller).cNextItem();
//      Log("  @ UsedUp Next Item="$XIIIPawn(Owner).PendingItem);
      if ( (XIIIPawn(Owner).PendingItem == None) || (XIIIPawn(Owner).PendingItem == self) )
        XIIIPlayercontroller(XIIIPawn(Owner).controller).NextWeapon();

      XIIIPawn(Owner).ChangedWeapon();
      if (Level.Game.StatLog != None)
        Level.Game.StatLog.LogItemDeactivate(Self, XIIIPawn(Owner));
//      Instigator.ReceiveLocalizedMessage( MessageClass, 0, None, None, Self.Class );
    }
    Instigator.PlayRolloffSound(DeactivateSound, self);
    Destroy();
}

//_____________________________________________________________________________
state Activated
{
    simulated function BeginState()
    {
      Instigator = Pawn(Owner);
      DebugLog(Level.TimeSeconds$"  > Activated BeginState for "$self@"Instigator="$Instigator);
      PlaySelect();
      bRendered = true;
//      bHidden = false;
//      RefreshDisplaying();
      bChangeItem = false;
    }

    simulated function AnimEnd(int Channel)
    {
      DebugLog("  > Activated AnimEnd bChangeItem="$bChangeItem);
      if ( bChangeItem )
      {
        GotoState('DownItem');
        return;
      }
      GotoState('Idle');
    }

    simulated function Activate() {}
}

//_____________________________________________________________________________
state DownItem
{
    simulated function BeginState()
    {
//      Log("  > DownItem BeginState for "$self);
      PlayDown();
      EndUse();
    }

    simulated function AnimEnd(int Channel)
    {
//      Log("DownItem AnimEnd");
      bChangeItem=false;
      GotoState('');
      Pawn(Owner).ChangedWeapon();
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
state Idle
{
    simulated function BeginState()
    {
      DebugLog("  > Idle BeginState for "$self);
      PlayIdle();
      bActive=true;
    }

    simulated function EndState()
    {
      bActive=true;
    }

    simulated function AnimEnd(int Channel)
    {
      if (Charge <=0)
      {
        UsedUp();
        return;
      }
      if ( bChangeItem )
      {
        GotoState('DownItem');
        return;
      }
      PlayIdle();
    }

    simulated function Activate()
    {
      if ( XIIIPawn(Owner).bHaveOnlyOneHandFree && (IHand == IH_2H) )
      {
        PlayerController(Pawn(owner).controller).MyHud.LocalizedMessage(class'XIIISoloMessage', 8);
      }
      else
        GotoState('InUse');
    }

    simulated function bool PutDown()
    {
      DebugLog("IDLE PutDown for"@self);
      GotoState('DownItem');
      return true;
    }
}

//_____________________________________________________________________________
State InUse
{
    simulated function BeginState()
    {
      DebugLog("  > InUse BeginState for "$self);
      PlayUsing();
    }

    simulated function Activate() {}

    simulated function AnimEnd(int Channel)
    {
      UseMe();
      if (Charge <=0)
      {
        UsedUp();
        return;
      }
      if ( bChangeItem )
      {
        GotoState('DownItem');
        return;
      }
      GotoState('Idle');
    }
}

//_____________________________________________________________________________
simulated function PlaySelect()
{
    DebugLog(self@"PlaySelect");
    PlayAnim('Select',1.0);
    Instigator.PlayRolloffSound(hSelectItemSound, self, 0);
}

//_____________________________________________________________________________
simulated function PlayDown()
{
    DebugLog(self@"PlayDown");
    PlayAnim('Down', 1.0);
    Instigator.PlayRolloffSound(hDownItemSound, self);
}

//_____________________________________________________________________________
simulated function PlayIdle()
{
    DebugLog(self@"PlayIdle");
    PlayAnim('Wait', 1.0);
}

//_____________________________________________________________________________
simulated function PlayUsing()
{
    DebugLog(self@"PlayUsing");
    PlayAnim('Fire', 2.0);
    Instigator.PlayRolloffSound(ActivateSound, self);
}

//    Icon=texture'XIIIMenu.FistsIcon'


defaultproperties
{
     MeshName="XIIIArmes.FpsM"
     DisplayFOV=50.000000
     IconNumber=20
     PlayerViewOffset=(X=4.000000,Y=5.000000,Z=-9.000000)
     bReplicateInstigator=True
     bDelayDisplay=True
     bSpecialDelayFov=True
     bIgnoreDynLight=False
     DrawType=DT_Mesh
     DrawScale=0.300000
     MessageClass=Class'XIII.XIIIPickupMessage'
}
