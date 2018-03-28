//===============================================================================
//  fpsphotokim.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


class fpsphotokim extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=fpsphotokimM MODELFILE=models\fpsphotokim.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsphotokimM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsphotokimA ANIMFILE=models\fpsphotokim.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsphotokimM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsphotokimM ANIM=fpsphotokimA

#EXEC ANIM DIGEST ANIM=fpsphotokimA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsphotokimM NUM=1 TEXTURE=photokim
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsphotokimM NUM=0 TEXTURE=fps



defaultproperties
{
}
