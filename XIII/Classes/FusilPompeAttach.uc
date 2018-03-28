//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FusilPompeAttach extends XIIIWeaponAttachment;


defaultproperties
{
     bMuzzleRandRotation=False
     ShellEffectOffset=(Y=5.000000,Z=10.000000)
     ShellFirstPersonOffset=(X=7.000000,Y=3.000000,Z=1.000000)
     fShellDelay=1.000000
     MuzzleClass=Class'XIII.MFShotGun'
     MuzzleOffset=(X=77.000000,Y=-4.000000,Z=2.500000)
     MuzzleRotationOffset=(Pitch=7000)
     TraceClass=Class'XIII.ShotGunBTrail'
     TraceFrequency=1.000000
     WeaponClass=Class'XIII.FusilPompe'
     WeaponThirdPersonRelativeRotation=(Pitch=7000)
     ClientImpactNb=5
     AltFiringMode="FM_ShotGunAlt"
     hFireSound=Sound'XIIIsound.Guns__ShotFire.ShotFire__hShotFire'
     hAltFireSound=Sound'XIIIsound.Guns__ShotFireAlt.ShotFireAlt__hShotFireAlt'
     hReloadSound=Sound'XIIIsound.Guns__ShotRel.ShotRel__hShotRel'
     StaticMeshName="MeshArmesPickup.Pompe"
     DrawType=DT_StaticMesh
}
