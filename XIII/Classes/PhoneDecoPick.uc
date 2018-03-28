//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PhoneDecoPick extends XIIIDecoPickup;

//_____________________________________________________________________________
// no destruction of shovels
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType);



defaultproperties
{
     InventoryType=Class'XIII.DecoPhone'
     StaticMesh=StaticMesh'Staticbanque.Bphone'
     CollisionRadius=32.000000
     CollisionHeight=20.000000
}
