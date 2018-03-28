//===============================================================================
//  fpsbalaiProck.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIPrison.utx PACKAGE=XIIIPrison

class fpsbalaiProck extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsbalaiProckM MODELFILE=models\fpsbalaiProck.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbalaiProckM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsbalaiProckM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsbalaiProckA ANIMFILE=models\fpsbalaiProck.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsbalaiProckA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsbalaiProckM ANIM=fpsbalaiProckA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbalaiProckM NUM=0 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbalaiProckM NUM=1 TEXTURE=prbois
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbalaiProckM NUM=2 TEXTURE=prbrosse

#EXEC ANIM NOTIFY ANIM=fpsbalaiProckA SEQ=Down TIME=0.492 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpsbalaiProckA SEQ=Fire TIME=0.284 FUNCTION=FPSFireNote1




defaultproperties
{
}
