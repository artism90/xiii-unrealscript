//===============================================================================
//  fpsCadavre.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes

class fpsCadavre extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsCadavreM MODELFILE=models\fpsCadavre.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsCadavreM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsCadavreM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=FpsCadavreA ANIMFILE=models\FpsCadavre.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=FpsCadavreA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsCadavreM ANIM=fpsCadavreA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsCadavreM NUM=0 TEXTURE=fps



defaultproperties
{
}
