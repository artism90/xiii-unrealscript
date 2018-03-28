//===============================================================================
//  Standwell.
//===============================================================================

class Standwell extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=StandwellM MODELFILE=models\Standwell.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=StandwellM X=0 Y=0 Z=81.695 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=StandwellM X=1.00 Y=1.00 Z=1.00
#EXEC ANIM IMPORT ANIM=STANDWELLspeA ANIMFILE=models\STANDWELLspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=STANDWELLspeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=StandwellSpeA ANIMFILE=models\StandwellSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=StandwellSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=StandwellM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=StandwellTex  FILE=Textures\Standwell.tga  GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=StandwellM NUM=0 TEXTURE=StandwellTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=StandwellTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
