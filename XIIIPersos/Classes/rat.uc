//===============================================================================
//  rat.
//===============================================================================

class rat extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=ratM MODELFILE=models\rat.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=ratM X=0 Y=0 Z=6.641 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=ratM X=0.5 Y=0.5 Z=0.5

#EXEC ANIM IMPORT ANIM=ratA ANIMFILE=models\rat.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=ratA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=ratM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=RatTex  FILE=Textures\Rat.tga MIPS=Off GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=ratM NUM=0 TEXTURE=RatTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=RatTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
