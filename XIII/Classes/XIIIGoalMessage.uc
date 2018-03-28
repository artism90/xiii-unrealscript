//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIGoalMessage extends XIIILocalMessage;

/*
//_____________________________________________________________________________
//
static function texture GetIcon( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    switch (switch)
    {
      Case 0: return Texture'XIIIMenu.Mire'; break;     // Goal Given
      Case 1: return texture'XIIIMenu.Hand'; break;     // Goal completed
    }
    return Texture'XIIIMenu.Mire';
}
*/



defaultproperties
{
     Lifetime=5
     DrawColor=(B=250,G=230,R=230,A=200)
}
