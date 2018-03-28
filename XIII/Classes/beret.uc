//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Beret extends Inventory;

var name BoneToAttach;

//_____________________________________________________________________________
function GiveTo( pawn Other )
{
    if ( Other.IsPlayerPawn() )
    {
      Destroy();
      return;
    }
    Super.GiveTo(other);
    AttachToPawn(Other);
}

//_____________________________________________________________________________
function AttachToPawn(Pawn P)
{
  	if ( ThirdPersonActor == None )
  	{
  		ThirdPersonActor = Spawn(AttachmentClass,Owner);
  		InventoryAttachment(ThirdPersonActor).InitFor(self);
  	}
  	P.AttachToBone(ThirdPersonActor,BoneToAttach);
  	ThirdPersonActor.SetRelativeLocation(ThirdPersonRelativeLocation);
  	ThirdPersonActor.SetRelativeRotation(ThirdPersonRelativeRotation);
}

//_____________________________________________________________________________
// My owner has been killed, maybe make me go off
function NotifyOwnerKilled(controller Killer)
{
    local BeretFlying BF;

    BF = Spawn(class'BeretFlying',,,ThirdPersonActor.Location, ThirdPersonActor.Rotation);
    BF.CalcVelocity( 1000.0*Normal(Killer.Pawn.Location - Owner.Location) );
    BF.StaticMesh = AttachmentClass.default.StaticMesh;
    DetachFromPawn(Pawn(Owner));
}



defaultproperties
{
     BoneToAttach="X Head"
     ThirdPersonRelativeLocation=(X=9.700000,Y=-1.500000,Z=-1.050000)
     ThirdPersonRelativeRotation=(Pitch=-16384,Yaw=1550)
     AttachmentClass=Class'XIII.BeretAttachment'
}
