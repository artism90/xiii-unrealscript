//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BerettaAttach extends XIIIWeaponAttachment;



defaultproperties
{
     bSpawnShells=True
     ShellEffectOffset=(Y=1.000000,Z=10.000000)
     ShellFirstPersonOffset=(X=7.000000,Y=3.500000,Z=1.500000)
     fShellDelay=0.100000
     MuzzleClass=Class'XIII.MFSmallAttach'
     MuzzleOffset=(X=24.000000,Y=-2.000000,Z=9.300000)
     TraceClass=Class'XIII.BulletTrail'
     WeaponClass=Class'XIII.Beretta'
     FiringMode="FM_1H"
     hFireSound=Sound'XIIIsound.Guns__9mmFire.9mmFire__h9mmFire'
     hReloadSound=Sound'XIIIsound.Guns__9mmRel.9mmRel__h9mmRel'
     StaticMeshName="MeshArmesPickup.Berretta"
     DrawType=DT_StaticMesh
}
