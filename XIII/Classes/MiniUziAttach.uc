//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MiniUziAttach extends XIIIWeaponAttachment;

//    DrawType=DT_Mesh
//    Mesh=Mesh'XIIIArmes.UziM'
//    MuzzleRotationOffset=(Yaw=-16384)


defaultproperties
{
     bSpawnShells=True
     ShellEffectOffset=(X=-5.000000,Y=1.000000,Z=10.000000)
     ShellFirstPersonOffset=(X=7.000000,Y=3.000000,Z=1.000000)
     ShellSFXEmitter=Class'XIII.SmallShells'
     MuzzleClass=Class'XIII.MFLargeStarAttach'
     MuzzleOffset=(X=26.000000,Y=-5.000000,Z=9.500000)
     TraceClass=Class'XIII.BulletTrail'
     TraceFrequency=0.150000
     WeaponClass=Class'XIII.MiniUzi'
     FiringMode="FM_1H"
     hFireSound=Sound'XIIIsound.Guns__UziFire.UziFire__hUziFire'
     hReloadSound=Sound'XIIIsound.Guns__UziRel.UziRel__hUziRel'
     StaticMeshName="MeshArmesPickup.Uzi"
     DrawType=DT_StaticMesh
}
