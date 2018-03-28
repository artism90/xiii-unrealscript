//===============================================================================
//  fpsclef.
//===============================================================================

class fpsclef extends XIIIAccessoires;

#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


#EXEC MESH  MODELIMPORT MESH=fpsclefM MODELFILE=models\fpsclef.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsclefM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsclefA ANIMFILE=models\fpsclef.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsclefM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsclefM ANIM=fpsclefA

#EXEC ANIM DIGEST ANIM=fpsclefA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsclefM NUM=1 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsclefM NUM=0 TEXTURE=clef



defaultproperties
{
}
