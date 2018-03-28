//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Photo extends XIIIItems;

var Texture PhotoMat;
var float EventDist;

//_____________________________________________________________________________
// ELR CauseEvent
Simulated function UseMe()
{
    local Actor A;
    local vector X, Y, Z;
    local float dist;
    local vector dir;

    if ( caps(Event) != "NONE" )
    {
      GetAxes(pawn(owner).GetViewRotation(),X,Y,Z);
      ForEach DynamicActors( class 'Actor', A, event )
        if (normal(X) dot normal(A.Location - Owner.Location) >= 0.7)
        {
          log("triggering "$A$" w/ event "$event);

          dir = A.Location - Owner.Location;
          dist = VSize(dir);
          if ( dist<EventDist )
            A.Trigger(self, Pawn(Owner));
        }
    }
}
//_____________________________________________________________________________
// ELR called in Beginstate of Downweapon
simulated function EndUse()
{
//    bDrawn=false;
}

//_____________________________________________________________________________
simulated function PlayIdle()
{
//    Log(self@"PlayIdle");
    PlayAnim('Wait', 1.0);
}



defaultproperties
{
     EventDist=200.000000
     MeshName="XIIIDeco.FPSPhotoKimM"
     IconNumber=27
     sItemName="Photograph"
     bCanHaveMultipleCopies=True
     bAutoActivate=True
     bActivatable=True
     ExpireMessage="Photography was used."
     InventoryGroup=6
     bDisplayableInv=True
     PickupClass=Class'XIII.PhotoPick'
     Charge=1
     PlayerViewOffset=(X=8.600000,Y=6.000000,Z=-5.800000)
     BobDamping=0.975000
     ItemName="PHOTOGRAPHY"
     Rotation=(Roll=-15536)
}
