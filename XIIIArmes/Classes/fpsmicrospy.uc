//===============================================================================
//  fpsmicrospy.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes

class fpsmicrospy extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsmicrospyM MODELFILE=models\fpsmicrospy.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsmicrospyM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsmicrospyM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsmicrospyA ANIMFILE=models\fpsmicrospy.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsmicrospyA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsmicrospyM ANIM=fpsmicrospyA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmicrospyM NUM=0 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmicrospyM NUM=1 TEXTURE=microspy



defaultproperties
{
}
