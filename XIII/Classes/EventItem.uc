//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EventItem extends XIIIItems;

var float EventDist;

//_____________________________________________________________________________
// ELR OverRide HandlePickupQuery to allow multiple possession of same class
// Only Return True if we are not allowed multiple possession of the same class
function bool HandlePickupQuery( Pickup Item )
{
    //Default = always allowed to have multiple copies (multiple events)
    if ( Inventory == None )
      return false;

    return Inventory.HandlePickupQuery(Item);
}

//_____________________________________________________________________________
// ELR CauseEvent
Simulated function UseMe()
{
    local Actor A;
//    local vector X, Y, Z;
    local float dist;
    local vector dir;

//    GetAxes(pawn(owner).GetViewRotation(),X,Y,Z);

    A = XIIIPlayercontroller(Pawn(Owner).controller).MyInteraction.TargetActor;
    if ( (A != none) && (A.Tag == Event) )
    {
      Dir = A.Location - Owner.Location;
      Dist = VSize(Dir);
      if ( Dist<EventDist )
      {
        A.Trigger(self, Pawn(Owner));
        Instigator.PlayRolloffSound(ActivateSound, self);
      }
    }

    XIIIPlayerController(XIIIpawn(Owner).controller).TryPickLock();
}

//_____________________________________________________________________________
state Idle
{
/*
    simulated function Activate()
    {
      if ( XIIIPawn(Owner).bHaveOnlyOneHandFree && (IHand == IH_2H) )
      {
        PlayerController(Pawn(owner).controller).MyHud.LocalizedMessage(class'XIIISoloMessage', 8);
      }
      else
        GotoState('InUse');
    }
*/
    simulated function Activate()
    {
      local Actor A;
      local float dist;
      local vector dir;

      DebugLog("@@@ Idle Activate call for"@self);

      if( !bActivatable )
        return;

      A = XIIIPlayercontroller(Pawn(Owner).controller).MyInteraction.TargetActor;
      if ( (A != none) && (A.Tag == Event) )
      {
        Dir = A.Location - Owner.Location;
        Dist = VSize(Dir);
        if ( Dist<EventDist )
        {
          if (Level.Game.StatLog != None)
            Level.Game.StatLog.LogItemActivate(Self, Pawn(Owner));
          GoToState('InUse');
        }
      }
    }
}

//_____________________________________________________________________________
simulated function PlayUsing()
{
//    Log(self@"PlayUsing");
    PlayAnim('Fire', 2.0);
//    PlaySound(ActivateSound); // not playing sound when using, only when efficiently using
}



defaultproperties
{
     EventDist=200.000000
     IconNumber=22
     bAutoActivate=True
     bActivatable=True
     ExpireMessage="EventItem was used."
     InventoryGroup=10
     bDisplayableInv=True
     PickupClass=Class'XIII.EventItemPick'
     Charge=1
     PlayerViewOffset=(X=12.000000,Y=3.000000,Z=-8.000000)
     ItemName="EventItem"
}
