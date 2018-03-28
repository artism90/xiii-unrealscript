//===============================================================================
//  Corde.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


class Corde extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=CordeM MODELFILE=models\Corde.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=CordeM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=CordeM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=CordeA ANIMFILE=models\Corde.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=CordeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=CordeM ANIM=CordeA

#EXEC MESHMAP SETTEXTURE MESHMAP=CordeM NUM=0 TEXTURE=grappincorde



defaultproperties
{
}
