//===============================================================================
//  fpskalash.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpskalash extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpskalashM MODELFILE=models\fpskalash.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpskalashM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpskalashA ANIMFILE=models\fpskalash.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpskalashM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpskalashM ANIM=fpskalashA

#EXEC ANIM DIGEST ANIM=fpskalashA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpskalashM NUM=1 TEXTURE=kalash
#EXEC MESHMAP SETTEXTURE MESHMAP=fpskalashM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpskalashA SEQ=reload TIME=0.347 FUNCTION=FPSRelNote1
#EXEC ANIM NOTIFY ANIM=fpskalashA SEQ=reload TIME=0.693 FUNCTION=FPSRelNote2
#EXEC ANIM NOTIFY ANIM=fpskalashA SEQ=WaitAct TIME=0.161 FUNCTION=FPSFireWaitActNote1



defaultproperties
{
}
