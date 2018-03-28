//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FusilSnipeAttach extends XIIIWeaponAttachment;



defaultproperties
{
     bMuzzleRandRotation=False
     MuzzleClass=Class'XIII.MFMediumAttach'
     MuzzleOffset=(X=85.000000,Y=-4.000000,Z=6.000000)
     TraceClass=Class'XIII.BulletTrail'
     TraceFrequency=0.660000
     WeaponClass=Class'XIII.FusilSnipe'
     FiringMode="FM_Snipe"
     hFireSound=Sound'XIIIsound.Guns__SnipFire.SnipFire__hSnipFire'
     hReloadSound=Sound'XIIIsound.Guns__SnipRel.SnipRel__hSnipRel'
     StaticMeshName="MeshArmesPickup.Sniper"
     DrawType=DT_StaticMesh
}
