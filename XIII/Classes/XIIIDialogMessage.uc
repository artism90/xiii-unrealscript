//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIDialogMessage extends XIIILocalMessage;

#exec OBJ LOAD FILE=XIIICine.utx PACKAGE=XIIICine

var localized string sEnoughAmmo, sCantClimb;

//_____________________________________________________________________________
static function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    switch (Switch)
    {
      case 4: // too much ammo
        return default.sEnoughAmmo;
        break;
      case 5: // holding corpse & trying to climb ladder.
        return default.sCantClimb;
    }
    return default.class$" ERR::RECEIVED GetString with wrong or undefined Params";
}

/*
//_____________________________________________________________________________
// ::TODO:: Should return the icon for the character speaking
static function texture GetIcon( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
    switch (switch)
    {
        Case 0: return texture'XIIICine.Icon_inconnu'; break;
        Case 1: return texture'XIIICine.Icon_HF'; break;
    }
    return texture'XIIICine.Icon_inconnu';
}
*/


defaultproperties
{
     sEnoughAmmo="I can't hold more ammo"
     sCantClimb="I must drop this guy to climb"
     Lifetime=5
     DrawColor=(B=10,G=10,R=10)
}
