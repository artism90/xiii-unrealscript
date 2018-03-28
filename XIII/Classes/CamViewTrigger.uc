//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CamViewTrigger extends XIIITriggers;

var() actor ObjectTofollow;
var() float FOVToUse;
var bool bTouched, bLookedAt, bOn;
var bool bHighDetail;

//____________________________________________________________________
event PostBeginPlay()
{
    Super.PostBeginPlay();
    bHighDetail = ( (Level.Game != none) && (Level.Game.DetailLevel > 1) );
}

//____________________________________________________________________
function PlayerTrigger( actor Other, pawn EventInstigator )
{
    if ( !bHighDetail )
      XIIIPlayerController(Other).SetCamView(ObjectTofollow, FOVToUse);
}

//_____________________________________________________________________________
function UnLookedAt(actor other)
{
    if ( !bHighDetail )
      return;

    if ( bOn )
    {
      Pawn(other).StopSound(XIIIPlayerController(Pawn(Other).controller).hCamViewInUseSound);
      Pawn(other).Playsound(XIIIPlayerController(Pawn(Other).controller).hCamViewBeginUseSound);
      bOn = false;
    }

    XIIIPlayerController(Pawn(Other).controller).CamViewMode = 0;
    bLookedAt = false;
}

//_____________________________________________________________________________
function LookedAt(actor other)
{
    if ( !bHighDetail )
      return;
    if ( bTouched )
      Go(other);
    bLookedAt = True;
}

//_____________________________________________________________________________
event Touch(Actor other)
{
    if ( !bHighDetail )
      return;
    if ( bLookedAt )
      Go(other);
    bTouched = true;
}

//_____________________________________________________________________________
function Go(actor other)
{
    if ( !bHighDetail )
      return;
    if ( !bOn )
    {
      Pawn(Other).Playsound(XIIIPlayerController(Pawn(Other).controller).hCamViewBeginUseSound);
      Pawn(Other).Playsound(XIIIPlayerController(Pawn(Other).controller).hCamViewInUseSound);
      bOn = true;
    }
    XIIIPlayerController(Pawn(Other).controller).CamViewMode = 1;
    XIIIPlayerController(Pawn(Other).controller).SetCamViewPortal(objectToFollow, FOVToUse);
}

//_____________________________________________________________________________
event Untouch(Actor other)
{
    if ( !bHighDetail )
      return;

    if ( bOn )
    {
      Pawn(other).StopSound(XIIIPlayerController(Pawn(Other).controller).hCamViewInUseSound);
      Pawn(other).Playsound(XIIIPlayerController(Pawn(Other).controller).hCamViewBeginUseSound);
      bOn = false;
    }

    XIIIPlayerController(Pawn(Other).controller).CamViewMode = 0;
    bTouched=false;
    bLookedAt=false;
}


defaultproperties
{
     bCanBeLocked=True
     bInteractive=True
}
