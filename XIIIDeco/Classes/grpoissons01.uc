//=============================================================================
// poissons01.
//=============================================================================

class grpoissons01 extends XIIIAccessoires;
#exec OBJ LOAD FILE=XIIIMeshobjets.utx PACKAGE=XIIIMeshobjets

#exec MESH IMPORT MESH=poissons01M ANIVFILE=MODELS\poissons01_a.3d DATAFILE=MODELS\poissons01_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=poissons01M X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=poissons01M SEQ=All STARTFRAME=0 NUMFRAMES=120
#exec MESH SEQUENCE MESH=poissons01M SEQ=nage STARTFRAME=0 NUMFRAMES=120


#exec MESHMAP NEW   MESHMAP=poissons01M MESH=poissons01
#exec MESHMAP SCALE MESHMAP=poissons01M X=0.244 Y=0.244 Z=0.488

#exec MESHMAP SETTEXTURE MESHMAP=poissons01M NUM=1 TEXTURE=aqfriture3M



defaultproperties
{
}
