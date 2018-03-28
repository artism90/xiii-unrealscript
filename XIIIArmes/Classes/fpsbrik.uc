//===============================================================================
//  fpsbrik.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsbrik extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsbrikM MODELFILE=models\fpsbrik.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbrikM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsbrikM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsbrikA ANIMFILE=models\fpsbrik.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsbrikA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsbrikM ANIM=fpsbrikA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbrikM NUM=1 TEXTURE=brik
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbrikM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpsbrikA SEQ=Fire TIME=0.280 FUNCTION=FPSFireNote1



defaultproperties
{
}
