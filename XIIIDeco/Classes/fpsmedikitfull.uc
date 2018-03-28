//===============================================================================
//  fpsmedikitfull.
//===============================================================================

class fpsmedikitfull extends XIIIAccessoires;

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


#EXEC MESH  MODELIMPORT MESH=fpsmedikitfullM MODELFILE=models\fpsmedikitfull.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsmedikitfullM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsmedikitfullA ANIMFILE=models\fpsmedikitfull.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsmedikitfullM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsmedikitfullM ANIM=fpsmedikitfullA

#EXEC ANIM DIGEST ANIM=fpsmedikitfullA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmedikitfullM NUM=2 TEXTURE=mediketiket
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmedikitfullM NUM=1 TEXTURE=medikitfull
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsmedikitfullM NUM=0 TEXTURE=fps



defaultproperties
{
}
