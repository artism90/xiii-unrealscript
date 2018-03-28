//===============================================================================
//  fpscendrier.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpscendrier extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpscendrierM MODELFILE=models\fpscendrier.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpscendrierM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpscendrierM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpscendrierA ANIMFILE=models\fpscendrier.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpscendrierA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpscendrierM ANIM=fpscendrierA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpscendrierM NUM=1 TEXTURE=cendrier
#EXEC MESHMAP SETTEXTURE MESHMAP=fpscendrierM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpscendrierA SEQ=Fire TIME=0.360 FUNCTION=FPSFireNote1



defaultproperties
{
}
