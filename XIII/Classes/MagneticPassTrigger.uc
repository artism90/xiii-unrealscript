//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MagneticPassTrigger extends XIIITriggers;

var() name  OutEvent;   // Event to cause
var() float OutDelay;   // Delay before event
var texture Icon;
var() texture NeverUsedIcon;
var() texture UsedIcon;
//var(DoorLock) XIIIPorte LinkedDoor;

//_____________________________________________________________________________
function PostBeginPlay()
{
    Super.PostBeginPlay();
    Icon = NeverUsedIcon;
}

//_____________________________________________________________________________
// Magnetic Pass Used
function Trigger( actor Other, pawn EventInstigator )
{
    // test if interaction exists
	if ( ( XIIIGameInfo(Level.Game).MapInfo.XIIIController.MyInteraction.TargetActor != none ) && ( XIIIGameInfo(Level.Game).MapInfo.XIIIController.MyInteraction.TargetActor == self ) )
	{
		Instigator = EventInstigator;
		Icon = UsedIcon;
		gotostate('Dispatch');
	}
}

//_____________________________________________________________________________
// Dispatch events.
state() Dispatch
{
    ignores trigger;
Begin:
  if( (OutEvent != '') && (OutEvent != 'None') )
  {
    Sleep( OutDelay );
    TriggerEvent(OutEvent,self,Instigator);
  }
  GotoState('');
}



defaultproperties
{
     NeverUsedIcon=Texture'XIIIMenu.HUD.Hand_ClosedDoor'
     UsedIcon=Texture'XIIIMenu.HUD.Hand_SearchBody'
     bCanBeLocked=True
     bInteractive=True
}
