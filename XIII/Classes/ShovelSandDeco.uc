//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ShovelSandDeco extends XIIIDecoPickup;

//_____________________________________________________________________________
// no destruction of shovels
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType);



defaultproperties
{
     InventoryType=Class'XIII.DecoShovelSand'
     StaticMesh=StaticMesh'MeshArmesPickup.pellesand'
     CollisionRadius=16.000000
     CollisionHeight=60.000000
}
