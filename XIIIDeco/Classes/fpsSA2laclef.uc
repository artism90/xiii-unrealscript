//===============================================================================
//  fpsSA2laclef.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


class fpsSA2laclef extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=fpsSA2laclefM MODELFILE=models\fpsSA2laclef.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsSA2laclefM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsSA2laclefM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsSA2laclefA ANIMFILE=models\fpsSA2laclef.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsSA2laclefA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsSA2laclefM ANIM=fpsSA2laclefA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsSA2laclefM NUM=1 TEXTURE=SAstele4
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsSA2laclefM NUM=0 TEXTURE=fps



defaultproperties
{
}
