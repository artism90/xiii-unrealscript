//===============================================================================
//  fpsbouteille.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


class fpsbouteille extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=fpsbouteilleM MODELFILE=models\fpsbouteille.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbouteilleM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsbouteilleA ANIMFILE=models\fpsbouteille.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsbouteilleM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsbouteilleM ANIM=fpsbouteilleA

#EXEC ANIM DIGEST ANIM=fpsbouteilleA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbouteilleM NUM=1 TEXTURE=bouteille
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbouteilleM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpsbouteilleA SEQ=Down TIME=0.492 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpsbouteilleA SEQ=Fire TIME=0.254 FUNCTION=FPSFireNote1



defaultproperties
{
}
