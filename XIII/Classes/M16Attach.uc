//-----------------------------------------------------------
//
//-----------------------------------------------------------
class M16Attach extends XIIIWeaponAttachment;



defaultproperties
{
     bSpawnShells=True
     bMuzzleRandRotation=False
     ShellEffectOffset=(X=-10.000000,Y=1.000000,Z=5.000000)
     ShellFirstPersonOffset=(X=7.000000,Y=3.000000,Z=1.000000)
     MuzzleClass=Class'XIII.MFM16Attach'
     MuzzleOffset=(X=71.500000,Y=-4.000000,Z=4.350000)
     MuzzleRotationOffset=(Pitch=7000)
     TraceClass=Class'XIII.BulletTrail'
     TraceFrequency=0.200000
     WeaponClass=Class'XIII.m16'
     WeaponThirdPersonRelativeRotation=(Pitch=7000)
     FiringMode="FM_M16"
     AltFiringMode="FM_ARAlt"
     hFireSound=Sound'XIIIsound.Guns__M16Fire.M16Fire__hM16Fire'
     hAltFireSound=Sound'XIIIsound.Guns__M16Fire.M16Fire__hM16GrenadeFire'
     hReloadSound=Sound'XIIIsound.Guns__M16Rel.M16Rel__hM16Rel'
     StaticMeshName="MeshArmesPickup.M16"
     DrawType=DT_StaticMesh
}
