//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GiletMk2Pick extends XIIIArmorPickup;

//    DrawType=DT_Mesh
//    Mesh=VertMesh'XIIIArmes.GiletHeavyM'


defaultproperties
{
     ProtectionLevel=100
     MaxDesireability=1.000000
     InventoryType=Class'XIII.GiletMk1'
     RespawnTime=20.000000
     PickupMessage="Heavy Vest"
     PickupSound=Sound'XIIIsound.Items.GiletPick1'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'MeshArmesPickup.giletheavy'
     CollisionHeight=31.000000
     AmbientGlow=64
}
