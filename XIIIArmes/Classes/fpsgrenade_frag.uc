//===============================================================================
//  fpsgrenade_frag.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsgrenade_frag extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsgrenade_fragM MODELFILE=models\fpsgrenade_frag.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsgrenade_fragM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsgrenade_fragA ANIMFILE=models\fpsgrenade_frag.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsgrenade_fragM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsgrenade_fragM ANIM=fpsgrenade_fragA

#EXEC ANIM DIGEST ANIM=fpsgrenade_fragA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsgrenade_fragM NUM=1 TEXTURE=grenade_frag
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsgrenade_fragM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpsgrenade_fragA SEQ=PendingFire TIME=0.459 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpsgrenade_fragA SEQ=PendingFire TIME=0.792 FUNCTION=FPSFireNote2
#EXEC ANIM NOTIFY ANIM=fpsgrenade_fragA SEQ=PendingFireAlt TIME=0.459 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpsgrenade_fragA SEQ=PendingFireAlt TIME=0.792 FUNCTION=FPSFireNote2
#EXEC ANIM NOTIFY ANIM=fpsgrenade_fragA SEQ=WaitAct TIME=0.626 FUNCTION=FPSFireWaitActNote1



defaultproperties
{
}
