//===============================================================================
//  fpsbouteille3.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


class fpsbouteille3 extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsbouteille3M MODELFILE=models\fpsbouteille3.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbouteille3M X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsbouteille3M X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsbouteille3A ANIMFILE=models\fpsbouteille3.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsbouteille3A USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsbouteille3M ANIM=fpsbouteille3A

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbouteille3M NUM=2 TEXTURE=bouteille3
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbouteille3M NUM=1 TEXTURE=bouteille3
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbouteille3M NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpsbouteille3A SEQ=Down TIME=0.492 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpsbouteille3A SEQ=Fire TIME=0.254 FUNCTION=FPSFireNote1



defaultproperties
{
}
