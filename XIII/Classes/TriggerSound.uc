//-----------------------------------------------------------
//
//-----------------------------------------------------------
class TriggerSound extends Triggers;

var() sound hTriggeredMusic;
var() sound hTriggeredSound;
var() bool bTriggerOnlyOnce;
var() actor SoundActor;

//_____________________________________________________________________________
function Trigger( actor Other, pawn EventInstigator )
{
    if ( hTriggeredSound != none )
	{
		if(SoundActor==none)
		{
			PlaySound( hTriggeredSound );
		}
		else
		{
			SoundActor.PlaySound( hTriggeredSound );
		}
     
	}
    if ( hTriggeredMusic != none )
      PlayMusic(hTriggeredMusic);
    if (bTriggerOnlyOnce)
      //Destroy();
	  disable('trigger');
}



defaultproperties
{
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
}
