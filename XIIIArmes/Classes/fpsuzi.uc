//===============================================================================
//  fpsuzi.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsuzi extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsuziM MODELFILE=models\fpsuzi.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsuziM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsuziA ANIMFILE=models\fpsuzi.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsuziM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsuziM ANIM=fpsuziA

#EXEC ANIM DIGEST ANIM=fpsuziA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsuziM NUM=1 TEXTURE=uzi
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsuziM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpsuziA SEQ=reload TIME=0.198 FUNCTION=FPSRelNote1
#EXEC ANIM NOTIFY ANIM=fpsuziA SEQ=reload TIME=0.580 FUNCTION=FPSRelNote2
#EXEC ANIM NOTIFY ANIM=fpsuziA SEQ=WaitAct TIME=0.632 FUNCTION=FPSFireWaitActNote1



defaultproperties
{
}
