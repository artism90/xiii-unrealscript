//-----------------------------------------------------------
//
//-----------------------------------------------------------
class WBallDecoPick extends XIIIDecoPickup;

//_____________________________________________________________________________
// no destruction of shovels
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType);



defaultproperties
{
     InventoryType=Class'XIII.DecoWBall'
     bUnlit=True
     StaticMesh=StaticMesh'StatiPalace.bouleblanche'
     CollisionRadius=16.000000
     CollisionHeight=16.000000
}
