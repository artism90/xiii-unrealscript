//===============================================================================
//  fpspasse.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets

class fpspasse extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=fpspasseM MODELFILE=models\fpspasse.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpspasseM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpspasseM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpspasseA ANIMFILE=models\fpspasse.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpspasseA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpspasseM ANIM=fpspasseA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpspasseM NUM=0 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpspasseM NUM=1 TEXTURE=magnetic_card



defaultproperties
{
}
