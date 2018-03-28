//===============================================================================
//  fpsbombemagnet.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsbombemagnet extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsbombemagnetM MODELFILE=models\fpsbombemagnet.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbombemagnetM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsbombemagnetM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsbombemagnetA ANIMFILE=models\fpsbombemagnet.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsbombemagnetA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsbombemagnetM ANIM=fpsbombemagnetA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbombemagnetM NUM=1 TEXTURE=bombemagnet
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbombemagnetM NUM=0 TEXTURE=fps



defaultproperties
{
}
