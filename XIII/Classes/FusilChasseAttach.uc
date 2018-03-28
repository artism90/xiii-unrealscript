//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FusilChasseAttach extends XIIIWeaponAttachment;

//    RelativeRotation=(Roll=32768)
//    DrawType=DT_Mesh
//    Mesh=Mesh'XIIIArmes.FChasseM'


defaultproperties
{
     bMuzzleRandRotation=False
     MuzzleClass=Class'XIII.MFLargeAttach'
     MuzzleOffset=(X=85.000000,Y=-4.000000,Z=1.800000)
     MuzzleRotationOffset=(Pitch=7000)
     TraceClass=Class'XIII.ShotGunBTrail'
     TraceFrequency=1.000000
     WeaponClass=Class'XIII.FusilChasse'
     WeaponThirdPersonRelativeRotation=(Pitch=7000)
     ClientImpactNb=5
     AltFiringMode="FM_ShotGunAlt"
     hFireSound=Sound'XIIIsound.Guns__GunFire.GunFire__hGunFire'
     hAltFireSound=Sound'XIIIsound.Guns__ShotFireAlt.ShotFireAlt__hShotFireAlt'
     hReloadSound=Sound'XIIIsound.Guns__GunRel.GunRel__hGunRel'
     StaticMeshName="MeshArmesPickup.FChasse"
     DrawType=DT_StaticMesh
}
