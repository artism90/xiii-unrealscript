//===============================================================================
//  fpsarbalete.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsarbalete extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsarbaleteM MODELFILE=models\fpsarbalete.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsarbaleteM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsarbaleteA ANIMFILE=models\fpsarbalete.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsarbaleteM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsarbaleteM ANIM=fpsarbaleteA

#EXEC ANIM DIGEST ANIM=fpsarbaleteA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsarbaleteM NUM=2 TEXTURE=arbalete
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsarbaleteM NUM=1 TEXTURE=arbalete
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsarbaleteM NUM=0 TEXTURE=fps



defaultproperties
{
}
