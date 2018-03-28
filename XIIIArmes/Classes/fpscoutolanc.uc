//===============================================================================
//  fpscoutolanc.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpscoutolanc extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpscoutolancM MODELFILE=models\fpscoutolanc.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpscoutolancM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0
#EXEC ANIM IMPORT ANIM=fpscoutolancA ANIMFILE=models\fpscoutolanc.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC MESHMAP SCALE MESHMAP=fpscoutolancM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpscoutolancM ANIM=fpscoutolancA
#EXEC ANIM DIGEST ANIM=fpscoutolancA USERAWINFO VERBOSE
#EXEC ANIM NOTIFY ANIM=fpscoutolancA SEQ=Fire TIME=0.050 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpscoutolancA SEQ=FireAlt TIME=0.300 FUNCTION=FPSFireAltNote1
#EXEC ANIM NOTIFY ANIM=fpscoutolancA SEQ=FireAlt TIME=0.800 FUNCTION=FPSFireAltNote2
#EXEC ANIM NOTIFY ANIM=fpscoutolancA SEQ=WaitAct TIME=0.200 FUNCTION=FPSFireWaitActNote1


#EXEC MESHMAP SETTEXTURE MESHMAP=fpscoutolancM NUM=1 TEXTURE=coutolanc
#EXEC MESHMAP SETTEXTURE MESHMAP=fpscoutolancM NUM=0 TEXTURE=fps


defaultproperties
{
}
