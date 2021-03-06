//===============================================================================
//  McCall.
//===============================================================================

class McCall extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=McCallM MODELFILE=models\McCall.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=McCallM X=0 Y=0 Z=79.988 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=McCallM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=MCCALLspeA ANIMFILE=models\MCCALLspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=MCCALLspeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=McCallSpeA ANIMFILE=models\McCallSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=McCallSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=McCallM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=McCallTex  FILE=Textures\McCall.tga  GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=McCallM NUM=0 TEXTURE=McCallTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=McCallTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
