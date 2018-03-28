//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ShovelSnowDeco extends XIIIDecoPickup;

//_____________________________________________________________________________
// no destruction of shovels
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType);



defaultproperties
{
     InventoryType=Class'XIII.DecoShovelSnow'
     StaticMesh=StaticMesh'MeshArmesPickup.pellesnow'
     CollisionRadius=16.000000
     CollisionHeight=60.000000
}
