//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MagnumAttach extends XIIIWeaponAttachment;



defaultproperties
{
     MuzzleClass=Class'XIII.MFSmallAttach'
     MuzzleOffset=(X=34.000000,Y=-2.000000,Z=10.500000)
     TraceClass=Class'XIII.BulletTrail'
     WeaponClass=Class'XIII.magnum'
     FiringMode="FM_1H"
     AltFiringMode="FM_44Alt"
     hFireSound=Sound'XIIIsound.Guns__MagFire.MagFire__hMagFire'
     hAltFireSound=Sound'XIIIsound.Guns__MagFire.MagFire__hMagFire'
     hReloadSound=Sound'XIIIsound.Guns__MagRel.MagRel__hMagRel'
     StaticMeshName="MeshArmesPickup.Magnum"
     DrawType=DT_StaticMesh
}
