//===============================================================================
//  fpschaiselight.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets

class fpschaiselight extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=fpschaiselightM MODELFILE=models\fpschaiselight.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpschaiselightM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpschaiselightM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpschaiselightA ANIMFILE=models\fpschaiselight.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpschaiselightA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpschaiselightM ANIM=fpschaiselightA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpschaiselightM NUM=0 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpschaiselightM NUM=1 TEXTURE=chaiselight

#EXEC ANIM NOTIFY ANIM=fpschaiselightA SEQ=Down TIME=0.492 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpschaiselightA SEQ=Fire TIME=0.211 FUNCTION=FPSFireNote1



defaultproperties
{
}
