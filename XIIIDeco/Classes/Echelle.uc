//===============================================================================
//  Echelle.
//===============================================================================

#exec OBJ LOAD FILE=XIIIVertexshaders.utx PACKAGE=XIIIVertexshaders


class Echelle extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=EchelleM MODELFILE=models\Echelle.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=EchelleM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=EchelleM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=EchelleA ANIMFILE=models\Echelle.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=EchelleA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=EchelleM ANIM=EchelleA

#EXEC MESHMAP SETTEXTURE MESHMAP=EchelleM NUM=0 TEXTURE=echelleM_2sides



defaultproperties
{
}
