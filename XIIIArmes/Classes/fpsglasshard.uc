//===============================================================================
//  fpsglasshard.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsglasshard extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsglasshardM MODELFILE=models\fpsglasshard.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsglasshardM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsglasshardM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsglasshardA ANIMFILE=models\fpsglasshard.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsglasshardA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsglasshardM ANIM=fpsglasshardA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsglasshardM NUM=1 TEXTURE=hardglass
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsglasshardM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpsglasshardA SEQ=Down TIME=0.250 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpsglasshardA SEQ=Down TIME=0.950 FUNCTION=FPSDownNote2
#EXEC ANIM NOTIFY ANIM=fpsglasshardA SEQ=Fire TIME=0.324 FUNCTION=FPSFireNote1



defaultproperties
{
}
