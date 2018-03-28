//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MitraillTrigger extends XIIITriggers
    notplaceable;

/* // ELR Don't use this anymore because NotPlaceAble
//____________________________________________________________________
function PostBeginPlay()
{
    if ( MitraillTop(Owner) == none )
    {
      log("####"@self@"Destroyed, not spawned by Mitrailltop");
      Destroy();
      Return;
    }
    Super.PostBeginPlay();
} */

//____________________________________________________________________
function PlayerTrigger( actor Other, pawn EventInstigator )
{
    local Controller C;

//    Log("---- "$self$" triggered");
    if ( MitraillTop(Owner).PawnControlling == none )
    {
      C = EventInstigator.controller;
      EventInstigator.ControlledActor = Owner;
      C.GotoState('PlayerGunning');
      MitraillTop(Owner).TakeControl(EventInstigator);
    }
}



defaultproperties
{
     bCanBeLocked=True
     bInteractive=True
     CollisionRadius=20.000000
     CollisionHeight=20.000000
}
