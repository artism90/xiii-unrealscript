//===============================================================================
//  fpsphone.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIbanque.utx PACKAGE=XIIIbanque

class fpsphone extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsphoneM MODELFILE=models\fpsphone.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsphoneM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsphoneM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsphoneA ANIMFILE=models\fpsphone.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsphoneA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsphoneM ANIM=fpsphoneA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsphoneM NUM=0 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsphoneM NUM=1 TEXTURE=Bphone

#EXEC ANIM NOTIFY ANIM=fpsphoneA SEQ=Fire TIME=0.385 FUNCTION=FPSFireNote1



defaultproperties
{
}
