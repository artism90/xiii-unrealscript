//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ChaiseDeco extends XIIIDecoPickup;

//_____________________________________________________________________________
// no destruction of shovels
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType);


defaultproperties
{
     InventoryType=Class'XIII.DecoChair'
     StaticMesh=StaticMesh'MeshObjetsPickup.chaiselight'
     CollisionRadius=32.000000
     CollisionHeight=40.000000
}
