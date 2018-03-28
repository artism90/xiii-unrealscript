//===============================================================================
//  fpspicklock.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


class fpspicklock extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=fpspicklockM MODELFILE=models\fpspicklock.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpspicklockM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpspicklockA ANIMFILE=models\fpspicklock.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpspicklockM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpspicklockM ANIM=fpspicklockA

#EXEC ANIM DIGEST ANIM=fpspicklockA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpspicklockM NUM=1 TEXTURE=grappin
#EXEC MESHMAP SETTEXTURE MESHMAP=fpspicklockM NUM=0 TEXTURE=fps
#EXEC ANIM NOTIFY ANIM=fpspicklockA SEQ=Select TIME=0.401 FUNCTION=FPSFireNote1



defaultproperties
{
}
