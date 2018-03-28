//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DartDecoPick extends XIIIDecoPickup;

//_____________________________________________________________________________
// no destruction of Darts
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType);



defaultproperties
{
     InventoryType=Class'XIII.DecoDart'
     PickupSound=Sound'XIIIsound.Items__DartPick.DartPick__hGlassPick'
     StaticMesh=StaticMesh'MeshArmesPickup.barflechette'
     CollisionRadius=32.000000
     CollisionHeight=16.000000
}
