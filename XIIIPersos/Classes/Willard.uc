//===============================================================================
//  Willard.
//===============================================================================

class Willard extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=WillardM MODELFILE=models\Willard.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=WillardM X=0 Y=0 Z=79.762 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=WillardM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=willardspeA ANIMFILE=models\willardspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=willardspeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=WillardSpeA ANIMFILE=models\WillardSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=WillardSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=WillardM ANIM=JonesMajA

#EXEC TEXTURE IMPORT NAME=WillardTex  FILE=Textures\Willard.tga  GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=WillardM NUM=0 TEXTURE=WillardTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=WillardTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
