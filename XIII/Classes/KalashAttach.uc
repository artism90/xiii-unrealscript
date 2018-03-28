//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KalashAttach extends XIIIWeaponAttachment;



defaultproperties
{
     bSpawnShells=True
     bMuzzleRandRotation=False
     ShellEffectOffset=(X=-5.000000,Y=1.000000,Z=10.000000)
     ShellFirstPersonOffset=(X=7.000000,Y=3.000000,Z=1.000000)
     fShellDelay=0.100000
     MuzzleClass=Class'XIII.MFKalashAttach'
     MuzzleOffset=(X=60.000000,Y=-4.000000,Z=3.700000)
     MuzzleRotationOffset=(Pitch=7000)
     TraceClass=Class'XIII.BulletTrail'
     TraceFrequency=0.150000
     WeaponClass=Class'XIII.kalash'
     WeaponThirdPersonRelativeRotation=(Pitch=7000)
     FiringMode="FM_M16"
     hFireSound=Sound'XIIIsound.Guns__KalFire.KalFire__hKalFire'
     hAltFireSound=Sound'XIIIsound.Interface.SwitchFireType1'
     hReloadSound=Sound'XIIIsound.Guns__KalRel.KalRel__hKalRel'
     StaticMeshName="MeshArmesPickup.Kalach"
     DrawType=DT_StaticMesh
}
