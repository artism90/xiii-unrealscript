//===============================================================================
//  fpscanne.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIPalace.utx PACKAGE=XIIIPalace


class fpscanne extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpscanneM MODELFILE=models\fpscanne.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpscanneM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpscanneM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpscanneA ANIMFILE=models\fpscanne.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpscanneA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpscanneM ANIM=fpscanneA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpscanneM NUM=3 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpscanneM NUM=2 TEXTURE=Pcanbillar
#EXEC MESHMAP SETTEXTURE MESHMAP=fpscanneM NUM=1 TEXTURE=Pcanbillar
#EXEC MESHMAP SETTEXTURE MESHMAP=fpscanneM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpscanneA SEQ=Down TIME=0.492 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpscanneA SEQ=Fire TIME=0.240 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpscanneA SEQ=Fire TIME=0.415 FUNCTION=FPSFireNote2




defaultproperties
{
}
