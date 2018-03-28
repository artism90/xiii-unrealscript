//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Keys extends XIIIItems;

var Travel String KeyCodeName;

var bool bPicking;  // to validate the beginning of the picking process
var bool bUsed;     // to activate alt set of anims w/ tool in place
var bool bDestroyAfterDownEnd;  // destroy the key after the down end (no more use for this key)

//_____________________________________________________________________________
function bool HandlePickupQuery( Pickup Item )
{
    //Default = always allowed to have multiple copies (multiple events)
    if ( Inventory == None )
      return false;

    return Inventory.HandlePickupQuery(Item);
}

//_____________________________________________________________________________
// ELR
function UseMe()
{
//    log("UseMe Call for "$self);
    if ( !XIIIPlayerController(XIIIpawn(Owner).controller).TryPickLock() )
      GotoState('Idle');
}

//_____________________________________________________________________________
State InUse
{
    event BeginState()
    {
      PlayUsing();
      UseMe();
    }

    event EndState()
    {
      bPicking = false;
    }

    function Activate() {}

    simulated event AnimEnd(int Channel)
    {
      if ( bChangeItem )
      {
        XIIIPlayerController(XIIIpawn(Owner).controller).CancelPickLock();
        GotoState('DownItem');
        return;
      }
      if ( !bPicking )
      {
        bPicking = true;
//        UseMe();
//        enable('tick');
      }
      PlayUsing();
    }

    event Tick(float dT)
    {
//      log("Tick Call for "$self);
      if ( XIIIPlayerController(XIIIpawn(Owner).controller).CheckPickLock() )
      {
        PlayUsingEnd();
        GotoState('UsingEnd');
      }
    }
}

//_____________________________________________________________________________
state idle
{
    simulated function Activate()
    {
      if ( !XIIIPlayerController(XIIIpawn(Owner).controller).CanUseLockPick() )
        return;
      if ( XIIIPawn(Owner).bHaveOnlyOneHandFree && (IHand == IH_2H) )
        PlayerController(Pawn(owner).controller).MyHud.LocalizedMessage(class'XIIISoloMessage', 8);
      else
        GotoState('InUse');
    }
}

//_____________________________________________________________________________
State UsingEnd
{
    ignores Activate;

    event AnimEnd(int channel)
    {
      local XIIIPorte PorteTmp;
      local bool bPorteTrouvee; // I assume that is false by default

      DebugLog("  > UsingEnd AnimEnd for "$self);

      foreach DynamicActors(class'XIIIPorte',PorteTmp)
      {
        if ((PorteTmp.GetStateName() == 'locked')
          && (PorteTmp.UnlockItemCode == KeyCodeName))
        {
          bPorteTrouvee = true;
          break;
        }
      }
      if (!bPorteTrouvee)
      {
        if ( Pawn(Owner) != None )
        {
          XIIIPlayercontroller(XIIIPawn(Owner).controller).NextWeapon();
//          XIIIPawn(Owner).ChangedWeapon(); // ELR don't need as sent when down animend
        }
        bDestroyAfterDownEnd = true;
        bDisplayableInv = false;
        bActivatable = false;
        GotoState('DownItem');
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
state DownItem
{
    simulated function BeginState()
    {
      DebugLog("  > DownItem BeginState for "$self);
      PlayDown();
      EndUse();
    }

    simulated event AnimEnd(int Channel)
    {
      DebugLog("  > DownItem AnimEnd for "$self@"bDestroyAfterDownEnd="$bDestroyAfterDownEnd);
      if ( bDestroyAfterDownEnd )
      {
        if ( Pawn(Owner).SelectedItem == self )
          Pawn(Owner).SelectedItem = none;
        if ( Pawn(Owner).PendingItem == self )
          Pawn(Owner).PendingItem = none;
        Pawn(Owner).ChangedWeapon();
        Destroy();
        return;
      }
//      Log("DownItem AnimEnd");
      bChangeItem = false;
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
simulated function PlayUsing()
{
    PlayAnim('Fire', 2.0);
}

//_____________________________________________________________________________
function PlayUsingEnd()
{
    TweenAnim('Wait', 0.2);
}



defaultproperties
{
     KeyCodeName="DEFAULTKEY"
     MeshName="XIIIDeco.FPSClefM"
     hSelectItemSound=Sound'XIIIsound.Items.LockSel1'
     IconNumber=22
     sItemName="Key"
     bAutoActivate=True
     bActivatable=True
     ExpireMessage="Key was used."
     ActivateSound=Sound'XIIIsound.Items.LockFire1'
     InventoryGroup=4
     bDisplayableInv=True
     PickupClass=Class'XIII.KeyPicks'
     Charge=1
     PlayerViewOffset=(X=12.000000,Y=3.000000,Z=-8.000000)
     ItemName="Key"
}
