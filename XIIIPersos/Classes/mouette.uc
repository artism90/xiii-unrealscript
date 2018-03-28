//===============================================================================
//  mouette.
//===============================================================================

class mouette extends TousLesPersos;

#exec MESH  MODELIMPORT MESH=mouetteM MODELFILE=models\mouette.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=mouetteM X=0 Y=0 Z=14.610 YAW=192 PITCH=0 ROLL=0

#exec ANIM  IMPORT ANIM=mouetteA ANIMFILE=models\mouette.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#exec MESHMAP SCALE MESHMAP=mouetteM X=1.00 Y=1.00 Z=1.00
#exec MESH    DEFAULTANIM MESH=mouetteM ANIM=mouetteA

#exec ANIM DIGEST  ANIM=mouetteA USERAWINFO VERBOSE

#EXEC TEXTURE IMPORT NAME=mouetTex  FILE=Textures\Mouet.tga MIPS=Off GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=mouetteM NUM=0 TEXTURE=mouetTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=mouetTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
