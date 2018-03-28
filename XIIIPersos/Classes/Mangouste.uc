//===============================================================================
//  Mangouste.
//===============================================================================

class Mangouste extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=MangousteM MODELFILE=models\Mangouste.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=MangousteM X=0 Y=0 Z=80.355 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=MangousteM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=MANGOUSTEspeA ANIMFILE=models\MANGOUSTEspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=MANGOUSTEspeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=MangousteSpeA ANIMFILE=models\MangousteSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=MangousteSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=MangousteM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=MangousteTex  FILE=Textures\Mangouste.tga  GROUP=Skins


#EXEC MESHMAP SETTEXTURE MESHMAP=MangousteM NUM=0 TEXTURE=MangousteTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=MangousteTex SOUND=ImpCdvr__hPlayImpCdvr

#EXEC ANIM NOTIFY ANIM=MangousteSpeA SEQ=MortTitube TIME=0.100 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=MangousteSpeA SEQ=MortTitube TIME=0.389 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=MangousteSpeA SEQ=MortTitube TIME=0.522 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=MangousteSpeA SEQ=MortTitube TIME=0.767 FUNCTION=PlayFootStep


defaultproperties
{
}
