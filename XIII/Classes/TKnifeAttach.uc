//-----------------------------------------------------------
//
//-----------------------------------------------------------
class TKnifeAttach extends XIIIWeaponAttachment;

//    RelativeRotation=(Roll=32768)
//    DrawType=DT_Mesh
//    Mesh=Mesh'XIIIArmes.CoutoLancM'


defaultproperties
{
     FiringMode="FM_Throw"
     hFireSound=Sound'XIIIsound.Guns__JetFire.JetFire__hJetFire'
     hAltFireSound=Sound'XIIIsound.Guns__JetFireAlt.JetFireAlt__hJetFireAlt'
     StaticMeshName="MeshArmesPickup.CoutoLanc"
     DrawType=DT_StaticMesh
}
