//===============================================================================
//  fpsbouteille2.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


class fpsbouteille2 extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsbouteille2M MODELFILE=models\fpsbouteille2.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbouteille2M X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsbouteille2M X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsbouteille2A ANIMFILE=models\fpsbouteille2.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsbouteille2A USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsbouteille2M ANIM=fpsbouteille2A

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbouteille2M NUM=2 TEXTURE=bouteille2
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbouteille2M NUM=1 TEXTURE=bouteille2
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbouteille2M NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpsbouteille2A SEQ=Down TIME=0.492 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpsbouteille2A SEQ=Fire TIME=0.254 FUNCTION=FPSFireNote1



defaultproperties
{
}
