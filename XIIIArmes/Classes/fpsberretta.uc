//===============================================================================
//  fpsberretta.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsberretta extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsberrettaM MODELFILE=models\fpsberretta.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsberrettaM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsberrettaM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsberrettaA ANIMFILE=models\fpsberretta.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsberrettaA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsberrettaM ANIM=fpsberrettaA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsberrettaM NUM=1 TEXTURE=berretta
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsberrettaM NUM=0 TEXTURE=fps
#EXEC ANIM NOTIFY ANIM=fpsberrettaA SEQ=WaitActVide TIME=0.644 FUNCTION=FPSFireWaitActNote1
#EXEC ANIM NOTIFY ANIM=fpsberrettaA SEQ=WaitAct TIME=0.745 FUNCTION=FPSFireWaitActNote1



defaultproperties
{
}
