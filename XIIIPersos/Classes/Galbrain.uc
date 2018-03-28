//===============================================================================
//  Galbrain.
//===============================================================================

class Galbrain extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=GalbrainM MODELFILE=models\Galbrain.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=GalbrainM X=0 Y=0 Z=79.245 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=GalbrainM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=GALBRAINspeA ANIMFILE=models\GALBRAINspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=GALBRAINspeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=GalbrainM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=GalbrainTex  FILE=Textures\Galbrain.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=GalbrainM NUM=0 TEXTURE=GalbrainTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=GalbrainTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
