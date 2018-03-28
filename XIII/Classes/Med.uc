//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Med extends XIIIItems
  abstract;

var int iHeal;
var sound EffectiveSound;
var bool bActivated;

//_____________________________________________________________________________
// Find the next Item (using the Inventory group)
simulated function PowerUps NextItem(PowerUps CurrentChoice, PowerUps CurrentItem)
{
    local bool bAllow2H;

    if ( (XIIIPawn(Owner).LHand != none) && XIIIPawn(Owner).LHand.bActive )
      bAllow2H = false;
    else
      bAllow2H = true;

    if ( bDisplayableInv && bActivatable && ((IHand != IH_2H) || bAllow2H) )
    {
      if ( (CurrentChoice == None) )
      {
        if ( CurrentItem != self )
          CurrentChoice = self;
      }
      // MedKit specific, if no current item given then give priority to MedKits
      if ( CurrentItem == none )
      {
        CurrentItem = self; // Test ?
        CurrentChoice = self;
      }
      else if ( (CurrentChoice != none) && (InventoryGroup == CurrentChoice.InventoryGroup) )
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
      else if ( (CurrentChoice != none) && (InventoryGroup < CurrentChoice.InventoryGroup) )
      {
        if ( (InventoryGroup > CurrentItem.InventoryGroup)
          || (CurrentChoice.InventoryGroup < CurrentItem.InventoryGroup) )
        CurrentChoice = self;
      }
      else if ( (CurrentChoice != none) && (CurrentItem != none) && ((CurrentChoice.InventoryGroup < CurrentItem.InventoryGroup)
        && (InventoryGroup > CurrentItem.InventoryGroup)) )
        CurrentChoice = self;
    }
    if ( Inventory == None )
      return CurrentChoice;
    else
      return Inventory.NextItem(CurrentChoice,CurrentItem);
}

//_____________________________________________________________________________
// ELR OverRide HandlePickupQuery to allow multiple possession of same class
// Only Return True if we are not allowed multiple possession of the same class
function bool HandlePickupQuery( Pickup Item )
{
    DebugLog(Self@"HandlePickupQuery for"@Item);
    // Stack Items, 1 charge
    if (Item.InventoryType == class)
    {
      if ( Item.Inventory != None )
        Charge += Item.Inventory.Charge;
      else
        Charge += Item.InventoryType.Default.Charge;
      Item.AnnouncePickup(Pawn(Owner));
      return true;
    }
    if ( Inventory == None )
      return false;

    return Inventory.HandlePickupQuery(Item);
}

//_____________________________________________________________________________
// Give this inventory item to a pawn.
function GiveTo( pawn Other )
{
    Local Inventory Dual;
//    Log("GIVETO (inventory)"@self@"to"@Other);
    Dual = Other.FindInventoryType(class);
    if ( Dual == none )
    {
      Instigator = Other;
      Other.AddInventory( Self );
      GotoState('');
    }
    else
    {
      Dual.Charge += Charge;
      Destroy();
    }
}

//_____________________________________________________________________________
// ELR CauseEvent
simulated function UseMeQuick(XIIIPlayercontroller XPC)
{
    local int i;
    local XIIIPawn P;
    local bool bUsedUp;

    DebugLog("@@@ UseMe for "$self);

    P = XIIIPawn(Owner);
    if (P != none )
    {
      if ( P.IsWounded() && (iHeal > 0) )
      {
        if ( Instigator.FindInventoryKind('FirstAidSkill') != none )
          P.Heal(P.Default.Health*iHeal/50);
        else
          P.Heal(P.Default.Health*iHeal/100);
        bUsedUp = true;
      }
      if ( bUsedUp )
      {
        Charge --;
        XPC.ClientFilter(
          class'Canvas'.Static.MakeColor(0,148,148,255),
          class'Canvas'.Static.MakeColor(128,128,128,255),
          1.0/0.25
        );
        XPC.ClientTargetHighLight( 0, 0, 0.25);
      }
    }
    if ( bUsedUp )
      Instigator.PlayRolloffSound(EffectiveSound, self, 0);
}

//_____________________________________________________________________________
// ELR CauseEvent
simulated function UseMe()
{
    local int i;
    local XIIIPawn P;
    local bool bUsedUp;

    DebugLog("@@@ UseMe for "$self);

    P = XIIIPawn(Owner);
    if (P != none )
    {
      if ( P.IsWounded() && (iHeal > 0) )
      {
        if ( Instigator.FindInventoryKind('FirstAidSkill') != none )
          P.Heal(P.Default.Health*iHeal/50);
        else
          P.Heal(P.Default.Health*iHeal/100);
        bUsedUp = true;
      }
      if ( bUsedUp )
        Charge --;
    }
//    if ( bUsedUp )
//      Owner.PlayRolloffSound(EffectiveSound, self);
}

//_____________________________________________________________________________
// This is called when a usable inventory item has used up it's charge.
simulated function UsedUpNoChange()
{
    DebugLog("@@@ UsedUpNoChange for "$self);
    if ( Pawn(Owner) != None )
    {
      bActivatable = false;
//      XIIIPlayercontroller(XIIIPawn(Owner).controller).cNextItem();
//      Log("  @ UsedUp Next Item="$XIIIPawn(Owner).PendingItem);
//      if ( (XIIIPawn(Owner).PendingItem == None) || (XIIIPawn(Owner).PendingItem == self) )
//        XIIIPlayercontroller(XIIIPawn(Owner).controller).NextWeapon();

//      XIIIPawn(Owner).ChangedWeapon();
      if (Level.Game.StatLog != None)
        Level.Game.StatLog.LogItemDeactivate(Self, XIIIPawn(Owner));
//      Instigator.ReceiveLocalizedMessage( MessageClass, 0, None, None, Self.Class );
    }
//    Owner.PlayRolloffSound(DeactivateSound, self);

    if ( XIIIPawn(Owner).PendingItem == self )
      XIIIPawn(Owner).PendingItem = none;
    Destroy();
}

//_____________________________________________________________________________
// This is called when a usable inventory item has used up it's charge.
simulated function UsedUp()
{
    DebugLog("@@@ UsedUp for "$self);
    if ( Pawn(Owner) != None )
    {
      bActivatable = false;
//      XIIIPlayercontroller(XIIIPawn(Owner).controller).cNextItem();
//      Log("  @ UsedUp Next Item="$XIIIPawn(Owner).PendingItem);
//      if ( (XIIIPawn(Owner).PendingItem == None) || (XIIIPawn(Owner).PendingItem == self) )
      if ( XIIIPawn(Owner).SelectedItem == self )
        XIIIPawn(Owner).SelectedItem = none;
      if ( XIIIPawn(Owner).PendingItem == self )
        XIIIPawn(Owner).PendingItem = none;
      if ( !XIIIPlayercontroller(XIIIPawn(Owner).controller).bWaitForWeaponMode )
        XIIIPlayercontroller(XIIIPawn(Owner).controller).NextWeapon();

      XIIIPawn(Owner).ChangedWeapon();
      if (Level.Game.StatLog != None)
        Level.Game.StatLog.LogItemDeactivate(Self, XIIIPawn(Owner));
//      Instigator.ReceiveLocalizedMessage( MessageClass, 0, None, None, Self.Class );
    }
//    Owner.PlayRolloffSound(DeactivateSound, self);
    Destroy();
}

//_____________________________________________________________________________
state Activated
{
    simulated function BeginState()
    {
      DebugLog(Level.TimeSeconds@"@@@ Activated BeginState for "$self);
      Instigator = Pawn(Owner);
      PlaySelect();
      bRendered = true;
//      bHidden = false;
//      RefreshDisplaying();
      bActivated = false;
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
      if ( bActivated && XIIIPawn(Owner).IsWounded() )
      {
        GotoState('InUse');
        return;
      }
      GotoState('Idle');
    }

    simulated function Activate() { DebugLog("@@@ Activated while going out"); bActivated = true; }
}

//_____________________________________________________________________________
// For medkits, the UseMe is called at the beginning & not at the end of anim.
State InUse
{
    simulated function BeginState()
    {
      DebugLog("@@@ InUse BeginState for "$self);
      PlayUsing();
      UseMe();
    }

    simulated function Activate() {}

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
      GotoState('Idle');
    }
}

//_____________________________________________________________________________
state Idle
{
    simulated function Activate()
    {
      if ( XIIIPawn(Owner).bHaveOnlyOneHandFree && (IHand == IH_2H) )
      {
        PlayerController(Pawn(owner).controller).MyHud.LocalizedMessage(class'XIIISoloMessage', 8);
      }
      else if ( XIIIPawn(owner).IsWounded() )
        GotoState('InUse');
    }
}

//_____________________________________________________________________________
simulated function PlayIdle()
{
    DebugLog("@@@"@self@"PlayIdle");
    PlayAnim('Wait', 1.0);
}

//_____________________________________________________________________________
simulated function PlayUsing()
{
    DebugLog("@@@"@self@"PlayUsing");
    PlayAnim('Fire', 2.0);
//    Instigator.PlayRolloffSound(ActivateSound, self);
}

//_____________________________________________________________________________
simulated function FPSItemNote1()
{
    Instigator.PlayRolloffSound(EffectiveSound, self, 0);
}

//_____________________________________________________________________________
simulated function FPSItemNote2()
{
    Instigator.PlayRolloffSound(EffectiveSound, self, 1);
}



defaultproperties
{
     IHand=IH_2H
     bNumberedItem=True
     bAutoActivate=True
     bActivatable=True
     ExpireMessage="Medicine was used."
     bDisplayableInv=True
     Charge=1
     PlayerViewOffset=(X=12.000000,Y=6.000000,Z=-5.000000)
     ItemName="Medecine"
}
