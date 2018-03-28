//-----------------------------------------------------------
//
//-----------------------------------------------------------
class M60Attach extends XIIIWeaponAttachment;



defaultproperties
{
     bSpawnShells=True
     ShellEffectOffset=(X=-17.000000,Y=4.000000,Z=5.500000)
     ShellFirstPersonOffset=(X=7.000000,Y=3.000000,Z=1.000000)
     ShellSFXEmitter=Class'XIII.LargeShells'
     MuzzleClass=Class'XIII.MFM60Attach'
     MuzzleOffset=(X=84.000000,Y=-3.000000,Z=11.000000)
     TraceClass=Class'XIII.BulletTrail'
     TraceFrequency=0.400000
     WeaponClass=Class'XIII.m60'
     FiringMode="FM_2HHeavy"
     hFireSound=Sound'XIIIsound.Guns__M60Fire.M60Fire__hM60Fire'
     hAltFireSound=Sound'XIIIsound.Interface.SwitchFireType1'
     hReloadSound=Sound'XIIIsound.Guns__M60Rel.M60Rel__hM60Rel'
     StaticMeshName="MeshArmesPickup.M60"
     DrawType=DT_StaticMesh
}
