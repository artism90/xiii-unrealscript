//=============================================================================
// DamageVolume.
//=============================================================================
class DamageVolume extends Volume;

VAR class<XIIIDamageType> DamageType;
VAR int DamagePerSec;
VAR bool LevelModification;

EVENT Timer( )
{
	LOCAL int i;

	for ( i=0; i<Touching.Length; i++ )
	{
		if ( !LevelModification && Touching[i].IsA( 'XIIIPlayerPawn' ) )
			Touching[i].TakeDamage( DamagePerSec*1.5/((1+Level.Game.Difficulty)*0.15+Level.AdjustDifficulty/100), none, Touching[i].Location, vect(0,0,0), DamageType );
		else
			Touching[i].TakeDamage( DamagePerSec, none, Touching[i].Location, vect(0,0,0), DamageType );
	}
}	

STATE() STA_Lets_Burn
{
	EVENT BeginState( )
	{
		SetTimer( 1.0, true );
	}
}

STATE() STA_TriggerTurnOn
{
	EVENT Trigger( Actor Other, Pawn EventInstigator )
	{
		SetTimer( 1.0, true );
		Disable( 'Trigger');
	}
}


defaultproperties
{
     DamageType=Class'XIII.DTFire'
     DamagePerSec=2
     bStatic=False
     InitialState="STA_Lets_Burn"
}
