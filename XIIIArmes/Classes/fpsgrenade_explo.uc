//===============================================================================
//  fpsgrenade_explo.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes

class fpsgrenade_explo extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsgrenade_exploM MODELFILE=models\fpsgrenade_explo.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsgrenade_exploM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsgrenade_exploM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsgrenade_exploA ANIMFILE=models\fpsgrenade_explo.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsgrenade_exploA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsgrenade_exploM ANIM=fpsgrenade_exploA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsgrenade_exploM NUM=0 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsgrenade_exploM NUM=1 TEXTURE=grenade_explo
#EXEC ANIM NOTIFY ANIM=fpsgrenade_exploA SEQ=PendingFire TIME=0.459 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpsgrenade_exploA SEQ=PendingFire TIME=0.792 FUNCTION=FPSFireNote2
#EXEC ANIM NOTIFY ANIM=fpsgrenade_exploA SEQ=Fire TIME=0.016 FUNCTION=FPSFireNote0
#EXEC ANIM NOTIFY ANIM=fpsgrenade_exploA SEQ=Firevide TIME=0.040 FUNCTION=FPSFireNote0
#EXEC ANIM NOTIFY ANIM=fpsgrenade_exploA SEQ=PendingFireAlt TIME=0.459 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpsgrenade_exploA SEQ=PendingFireAlt TIME=0.792 FUNCTION=FPSFireNote2
#EXEC ANIM NOTIFY ANIM=fpsgrenade_exploA SEQ=WaitAct TIME=0.646 FUNCTION=FPSFireWaitActNote1



defaultproperties
{
}
