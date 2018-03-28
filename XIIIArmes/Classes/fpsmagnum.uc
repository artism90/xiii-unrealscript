//===============================================================================
//  fpsmagnum.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsmagnum extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsmagnumM MODELFILE=models\fpsmagnum.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsmagnumM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsmagnumM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsmagnumA ANIMFILE=models\fpsmagnum.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsmagnumA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsmagnumM ANIM=fpsmagnumA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmagnumM NUM=1 TEXTURE=magnum
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmagnumM NUM=0 TEXTURE=fps
#EXEC ANIM NOTIFY ANIM=fpsmagnumA SEQ=reload TIME=0.173 FUNCTION=FPSRelNote2
#EXEC ANIM NOTIFY ANIM=fpsmagnumA SEQ=reload TIME=0.862 FUNCTION=FPSRelNote3
#EXEC ANIM NOTIFY ANIM=fpsmagnumA SEQ=WaitAct TIME=0.141 FUNCTION=FPSFireWaitActNote1



defaultproperties
{
}
