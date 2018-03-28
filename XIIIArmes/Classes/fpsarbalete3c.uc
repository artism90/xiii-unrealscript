//===============================================================================
//  fpsarbalete3c.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsarbalete3c extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsarbalete3cM MODELFILE=models\fpsarbalete3c.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsarbalete3cM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsarbalete3cA ANIMFILE=models\fpsarbalete3c.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsarbalete3cM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsarbalete3cM ANIM=fpsarbalete3cA

#EXEC ANIM DIGEST ANIM=fpsarbalete3cA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsarbalete3cM NUM=2 TEXTURE=arbalete
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsarbalete3cM NUM=1 TEXTURE=arbalete
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsarbalete3cM NUM=0 TEXTURE=fps
#EXEC ANIM NOTIFY ANIM=fpsarbalete3cA SEQ=ReLoad TIME=0.358 FUNCTION=FPSRelNote1



defaultproperties
{
}
