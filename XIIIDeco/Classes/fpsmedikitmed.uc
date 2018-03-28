//===============================================================================
//  fpsmedikitmed.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


class fpsmedikitmed extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=fpsmedikitmedM MODELFILE=models\fpsmedikitmed.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsmedikitmedM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsmedikitmedA ANIMFILE=models\fpsmedikitmed.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsmedikitmedM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsmedikitmedM ANIM=fpsmedikitmedA

#EXEC ANIM DIGEST ANIM=fpsmedikitmedA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmedikitmedM NUM=1 TEXTURE=medikitmed
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmedikitmedM NUM=0 TEXTURE=fps



defaultproperties
{
}
