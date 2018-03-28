//===============================================================================
//  fpsm60.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes

class fpsm60 extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsm60M MODELFILE=models\fpsm60.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsm60M X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsm60M X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsm60A ANIMFILE=models\fpsm60.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsm60A USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsm60M ANIM=fpsm60A

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsm60M NUM=0 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsm60M NUM=1 TEXTURE=m60



defaultproperties
{
}
