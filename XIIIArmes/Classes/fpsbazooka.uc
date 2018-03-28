//===============================================================================
//  fpsbazooka.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsbazooka extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsbazookaM MODELFILE=models\fpsbazooka.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbazookaM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsbazookaA ANIMFILE=models\fpsbazooka.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsbazookaM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsbazookaM ANIM=fpsbazookaA

#EXEC ANIM DIGEST ANIM=fpsbazookaA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbazookaM NUM=2 TEXTURE=bazooka
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbazookaM NUM=1 TEXTURE=bazooka
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbazookaM NUM=0 TEXTURE=fps
#EXEC ANIM NOTIFY ANIM=fpsbazookaA SEQ=ReLoad TIME=0.098 FUNCTION=FPSRelNote1
#EXEC ANIM NOTIFY ANIM=fpsbazookaA SEQ=ReLoad TIME=0.625 FUNCTION=FPSRelNote2
#EXEC ANIM NOTIFY ANIM=fpsbazookaA SEQ=ReLoad TIME=0.694 FUNCTION=FPSRelNote3
#EXEC ANIM NOTIFY ANIM=fpsbazookaA SEQ=FireAlt TIME=0.300 FUNCTION=FPSFireAltNote1
#EXEC ANIM NOTIFY ANIM=fpsbazookaA SEQ=FireAlt TIME=0.600 FUNCTION=FPSFireAltNote2
#EXEC ANIM NOTIFY ANIM=fpsbazookaA SEQ=WaitAct TIME=0.148 FUNCTION=FPSFireWaitActNote1
#EXEC ANIM NOTIFY ANIM=fpsbazookaA SEQ=WaitActVide TIME=0.148 FUNCTION=FPSFireWaitActNote1



defaultproperties
{
}
