//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BroomDecoPick extends XIIIDecoPickup;

//_____________________________________________________________________________
// no destruction of shovels
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType);



defaultproperties
{
     InventoryType=Class'XIII.DecoBroom'
     StaticMesh=StaticMesh'StatiBarFight.balai'
     CollisionRadius=25.000000
     CollisionHeight=70.000000
}
