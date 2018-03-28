//===============================================================================
//  fpsOtage.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes

class fpsOtage extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsOtageM MODELFILE=models\fpsOtage.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsOtageM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsOtageM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsOtageA ANIMFILE=models\fpsOtage.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsOtageA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=FpsOtageA ANIMFILE=models\FpsOtage.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=FpsOtageA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsOtageM ANIM=fpsOtageA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsOtageM NUM=0 TEXTURE=fps



defaultproperties
{
}
