//===============================================================================
//  Fps.
//===============================================================================


#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes

class fps extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsM MODELFILE=models\fps.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM  IMPORT ANIM=fpsA ANIMFILE=models\fps.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsM ANIM=fpsA

#EXEC ANIM DIGEST  ANIM=fpsA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsM NUM=0 TEXTURE=fps



defaultproperties
{
}
