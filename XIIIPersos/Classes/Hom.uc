//===============================================================================
//  Hom.
//===============================================================================

class Hom extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=HomM MODELFILE=models\Hom.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=HomM X=0 Y=0 Z=80.355 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=HomM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=HomSpeA ANIMFILE=models\HomSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=HomSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=HomM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=HomTex  FILE=Textures\Hom.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=HomM NUM=0 TEXTURE=HomTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=HomTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
