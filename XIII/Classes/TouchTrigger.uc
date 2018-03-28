//=============================================================================
// TouchTrigger.
//=============================================================================
class TouchTrigger extends XIIITriggers;

VAR() bool bActivableParTrigger; //attend trigger pour s'activer sinon actif des le debut
VAR() bool bDesactivableParTrigger; //si trigger alors se desactive
VAR() bool bPawnActivable; //peut etre active par un pawn sinon seulement XIII
VAR bool bActif; //actif ou pas

EVENT PostBeginplay()
{
	bActif=!bActivableParTrigger;
}

EVENT Touch( Actor Other )
{
	if ( bActif && ( ( bPawnActivable && Other.IsA('XIIIPawn') ) || other.IsA('XIIIPlayerPawn') ) )
	{
		instigator = pawn(other);
		TriggerEvent( event, self, Instigator );
		disable('Touch');
	}
}

EVENT Trigger( Actor Other, Pawn EventInstigator )
{
	LOCAL int i;
	
    if (bActivableParTrigger)
    {
		bActif=true;
		for ( i=0; i<Touching.Length; i++ )
		{
			Touch( Touching[i] );
		}
		return;
    }
    if (bDesactivableParTrigger && bActif)
    {
		bActif=false;
    }
}



defaultproperties
{
}
