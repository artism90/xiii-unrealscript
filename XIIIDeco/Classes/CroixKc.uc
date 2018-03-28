//===============================================================================
//  croixKC.
//===============================================================================

#exec OBJ LOAD FILE=XIIIsanc01.utx PACKAGE=XIIIsanc01


class croixKC extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=croixKCM MODELFILE=models\croixKC.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=croixKCM X=0 Y=0 Z=0 YAW=0 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=croixKCM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=croixKCA ANIMFILE=models\croixKC.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=croixKCA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=croixKCM ANIM=croixKCA

#EXEC MESHMAP SETTEXTURE MESHMAP=croixKCM NUM=2 TEXTURE=SAfont02
#EXEC MESHMAP SETTEXTURE MESHMAP=croixKCM NUM=1 TEXTURE=SAfont01
#EXEC MESHMAP SETTEXTURE MESHMAP=croixKCM NUM=0 TEXTURE=SAcolonne



defaultproperties
{
}
