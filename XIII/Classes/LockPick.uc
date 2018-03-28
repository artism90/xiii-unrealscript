//-----------------------------------------------------------
//
//-----------------------------------------------------------
class LockPick extends Keys;

/*
//_____________________________________________________________________________
State InUse
{
    event BeginState()
    {
      PlayUsing();
      disable('Tick');
    }

    event EndState()
    {
      bPicking = false;
    }

    function Activate() {}

    simulated Event AnimEnd(int Channel)
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
        UseMe();
        enable('tick');
      }
      PlayUsing();
    }

    function Tick(float dT)
    {
//      log("Tick Call for "$self);
      if ( XIIIPlayerController(XIIIpawn(Owner).controller).CheckPickLock() )
      {
        PlayUsingEnd();
        GotoState('UsingEnd');
      }
    }
}
*/
/*
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
*/

//_____________________________________________________________________________
State UsingEnd
{
    ignores Activate;

    event AnimEnd(int channel)
    {
      if ( bChangeItem )
      {
        GotoState('DownItem');
        return;
      }
      GotoState('Idle');
    }
}


//_____________________________________________________________________________
function PlayUsing()
{
//    Log(self@"PlayUsing");
    if ( bPicking )
      PlayAnim('Fire2', 2.0);
    else
    {
      PlayAnim('Fire1', 2.0);
      bUsed = true;
    }

    if ( XIIIPlayerController(XIIIpawn(Owner).controller).aDoor != none )
      Instigator.PlayRolloffSound(ActivateSound, self);
}

//_____________________________________________________________________________
function PlayUsingEnd()
{
    PlayAnim('Fire2ToWait2');
}

//_____________________________________________________________________________
event FPSFireNote1() // this is in  fact the selection notif
{
    Instigator.PlayRolloffSound(hSelectItemSound, self, 1);
}

//_____________________________________________________________________________
simulated function PlayIdle()
{
//    Log(self@"PlayIdle");
    PlayAnim('Wait', 1.0);
}

//_____________________________________________________________________________
simulated function PlayDown()
{
//    Log(self@"PlayDown");
    PlayAnim('Down', 1.0);
    Instigator.PlayRolloffSound(hDownItemSound, self);
}

//_____________________________________________________________________________
simulated function PlaySelect()
{
//    Log(self@"PlaySelect");
    PlayAnim('Select',1.0);
    bUsed = false;
    Instigator.PlayRolloffSound(hSelectItemSound, self, 0);
}

//    PickupClassName="XIII.UnLockerPick" // ELR Can't suse this as default is used.


defaultproperties
{
     KeyCodeName="LOCKPICK"
     MeshName="XIIIDeco.FPSPickLockM"
     hSelectItemSound=Sound'XIIIsound.Items__LockSel.LockSel__hLockSelect'
     IconNumber=20
     sItemName="LockPick"
     bCanHaveMultipleCopies=True
     ExpireMessage="LockPick was used."
     ActivateSound=Sound'XIIIsound.Items__LockFire.LockFire__hLockFire'
     InventoryGroup=3
     PickupClass=Class'XIII.UnLockerPick'
     BobDamping=0.975000
     AttachmentClass=Class'XIII.UnLockerAttach'
     ItemName="LOCKPICK"
}
