//===============================================================================
//  fpsflashbang.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsflashbang extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsflashbangM MODELFILE=models\fpsflashbang.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsflashbangM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsflashbangM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsflashbangA ANIMFILE=models\fpsflashbang.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsflashbangA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsflashbangM ANIM=fpsflashbangA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsflashbangM NUM=1 TEXTURE=grenade_explo
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsflashbangM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpsflashbangA SEQ=PendingFire TIME=0.459 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpsflashbangA SEQ=PendingFire TIME=0.792 FUNCTION=FPSFireNote2
#EXEC ANIM NOTIFY ANIM=fpsflashbangA SEQ=Fire TIME=0.016 FUNCTION=FPSFireNote0



defaultproperties
{
}
