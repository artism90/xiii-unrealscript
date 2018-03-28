//===============================================================================
//  fpsTLfusible.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIItelepherique.utx PACKAGE=XIIItelepherique


class fpsTLfusible extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=fpsTLfusibleM MODELFILE=models\fpsTLfusible.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsTLfusibleM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsTLfusibleM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsTLfusibleA ANIMFILE=models\fpsTLfusible.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsTLfusibleA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsTLfusibleM ANIM=fpsTLfusibleA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsTLfusibleM NUM=1 TEXTURE=TLfusible
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsTLfusibleM NUM=0 TEXTURE=fps



defaultproperties
{
}
