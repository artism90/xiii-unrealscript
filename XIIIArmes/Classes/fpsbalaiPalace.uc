//===============================================================================
//  fpsbalaiPalace.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIPalace.utx PACKAGE=XIIIPalace

class fpsbalaiPalace extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsbalaiPalaceM MODELFILE=models\fpsbalaiPalace.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbalaiPalaceM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsbalaiPalaceM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsbalaiPalaceA ANIMFILE=models\fpsbalaiPalace.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsbalaiPalaceA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsbalaiPalaceM ANIM=fpsbalaiPalaceA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbalaiPalaceM NUM=0 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbalaiPalaceM NUM=1 TEXTURE=Pbalais
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbalaiPalaceM NUM=2 TEXTURE=Pbalais

#EXEC ANIM NOTIFY ANIM=fpsbalaiPalaceA SEQ=Down TIME=0.492 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpsbalaiPalaceA SEQ=Fire TIME=0.0120 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpsbalaiPalaceA SEQ=Fire TIME=0.0300 FUNCTION=FPSFireNote2
#EXEC ANIM NOTIFY ANIM=fpsbalaiPalaceA SEQ=Select TIME=0.230 FUNCTION=FPSSelWPNote1




defaultproperties
{
}
