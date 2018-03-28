//=============================================================================
// poissons.
//=============================================================================

class grpoissons extends XIIIAccessoires;
#exec OBJ LOAD FILE=XIIIMeshobjets.utx PACKAGE=XIIIMeshobjets

#exec MESH IMPORT MESH=poissonsM ANIVFILE=MODELS\poissons_a.3d DATAFILE=MODELS\poissons_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=poissonsM X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=poissonsM SEQ=All STARTFRAME=0 NUMFRAMES=120
#exec MESH SEQUENCE MESH=poissonsM SEQ=nage STARTFRAME=0 NUMFRAMES=120


#exec MESHMAP NEW   MESHMAP=poissonsM MESH=poissons
#exec MESHMAP SCALE MESHMAP=poissonsM X=0.244 Y=0.244 Z=0.488

#exec MESHMAP SETTEXTURE MESHMAP=poissonsM NUM=1 TEXTURE=aqfriture4M



defaultproperties
{
}
