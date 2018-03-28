//===============================================================================
//  fpsbartabouret.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIbar.utx PACKAGE=XIIIbar

class fpsbartabouret extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsbartabouretM MODELFILE=models\fpsbartabouret.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbartabouretM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsbartabouretM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsbartabouretA ANIMFILE=models\fpsbartabouret.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsbartabouretA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsbartabouretM ANIM=fpsbartabouretA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbartabouretM NUM=0 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbartabouretM NUM=1 TEXTURE=bartabouret

#EXEC ANIM NOTIFY ANIM=fpsbartabouretA SEQ=Down TIME=0.492 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpsbartabouretA SEQ=Fire TIME=0.227 FUNCTION=FPSFireNote1




defaultproperties
{
}
