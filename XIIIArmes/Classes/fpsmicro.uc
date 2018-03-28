//===============================================================================
//  fpsmicro.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes

class fpsmicro extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsmicroM MODELFILE=models\fpsmicro.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsmicroM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM  IMPORT ANIM=fpsmicroA ANIMFILE=models\fpsmicro.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsmicroM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsmicroM ANIM=fpsmicroA

#EXEC ANIM DIGEST  ANIM=fpsmicroA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmicroM NUM=0 TEXTURE=FPS
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmicroM NUM=1 TEXTURE=micro
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmicroM NUM=2 TEXTURE=micro01



defaultproperties
{
}
